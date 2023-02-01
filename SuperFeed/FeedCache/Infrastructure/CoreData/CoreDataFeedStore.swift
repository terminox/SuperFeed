//
//  CoreDataFeedStore.swift
//  SuperFeed
//
//  Created by yossa on 1/2/2566 BE.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {

  // MARK: Lifecycle

  public init(storeURL: URL, bundle: Bundle = .main) throws {
    container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
    context = container.newBackgroundContext()
  }

  // MARK: Public

  public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    perform { context in
      do {
        try ManagedCache.find(in: context).map(context.delete).map(context.save)
        completion(nil)
      } catch {
        completion(error)
      }
    }
  }

  public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    perform { context in
      do {
        let managedCache = try ManagedCache.newUniqueInstance(in: context)
        managedCache.timestamp = timestamp
        managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
        
        try context.save()
        completion(nil)
      } catch {
        completion(error)
      }
    }
  }

  public func retrieve(completion: @escaping RetrievalCompletion) {
    perform { context in
      do {
        if let cache = try ManagedCache.find(in: context) {
          completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
        } else {
          completion(.empty)
        }
      } catch {
        completion(.failure(error))
      }
    }
  }

  // MARK: Private

  private let container: NSPersistentContainer
  private let context: NSManagedObjectContext
  
  private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
    let context = self.context
    context.perform {
      action(context)
    }
  }
}
