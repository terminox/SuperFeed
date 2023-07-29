//
//  CoreDataFeedStore.swift
//  SuperFeed
//
//  Created by yossa on 1/2/2566 BE.
//

import CoreData

public final class CoreDataFeedStore {

  // MARK: Lifecycle

  public init(storeURL: URL) throws {
    guard let model = CoreDataFeedStore.model else {
      throw StoreError.modelNotFound
    }

    do {
      container = try NSPersistentContainer.load(name: CoreDataFeedStore.modelName, model: model, url: storeURL)
      context = container.newBackgroundContext()
    } catch {
      throw StoreError.failedToLoadPersistenContainer(error)
    }
  }
  
  deinit {
    cleanUpReferencesToPersistentStores()
  }
  
  // MARK: Internal

  enum StoreError: Error {
    case modelNotFound
    case failedToLoadPersistenContainer(Error)
  }

  func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
    let context = context
    context.perform {
      action(context)
    }
  }

  // MARK: Private

  private static let modelName = "FeedStore"
  private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))

  private let container: NSPersistentContainer
  private let context: NSManagedObjectContext
  
  private func cleanUpReferencesToPersistentStores() {
    context.performAndWait {
      if let coordinator = self.context.persistentStoreCoordinator {
        try? coordinator.persistentStores.forEach(coordinator.remove(_:))
      }
    }
  }
}
