//
//  LocalFeedLoader.swift
//  SuperFeed
//
//  Created by yossa on 17/1/2566 BE.
//

import Foundation

// MARK: - LocalFeedLoader

public class LocalFeedLoader {

  // MARK: Lifecycle

  public init(store: FeedStore, currentDate: @escaping () -> Date) {
    self.store = store
    self.currentDate = currentDate
  }

  // MARK: Private

  private let store: FeedStore
  private let currentDate: () -> Date
  private let calendar = Calendar(identifier: .gregorian)

  private var maxCacheAgeInDays: Int {
    7
  }

  private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
    store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] error in
      guard self != nil else { return }
      completion(error)
    }
  }

  private func validate(_ timestamp: Date) -> Bool {
    guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
      return false
    }

    return currentDate() < maxCacheAge
  }
}

extension LocalFeedLoader {
  public typealias SaveResult = Error?

  public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
    store.deleteCachedFeed { [weak self] error in
      guard let self = self else { return }

      if let cacheDeletionError = error {
        completion(cacheDeletionError)
      } else {
        self.cache(feed, with: completion)
      }
    }
  }
}

// MARK: FeedLoader

extension LocalFeedLoader: FeedLoader {
  public typealias LoadResult = LoadFeedResult


  public func load(completion: @escaping (LoadResult) -> Void) {
    store.retrieve { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .found(let feed, let timestamp) where self.validate(timestamp):
        completion(.success(feed.toModels()))
      case .found, .empty:
        completion(.success([]))
      }
    }
  }
}

extension LocalFeedLoader {
  public func validateCache() {
    store.retrieve { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .failure:
        self.store.deleteCachedFeed { _ in }
        
      case .found(_, let timestamp) where !self.validate(timestamp):
        self.store.deleteCachedFeed { _ in }
        
      case .empty, .found:
        break
      }
    }
  }
}

extension Array where Element == FeedImage {
  fileprivate func toLocal() -> [LocalFeedImage] {
    map {
      LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
    }
  }
}

extension Array where Element == LocalFeedImage {
  fileprivate func toModels() -> [FeedImage] {
    map {
      FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
    }
  }
}
