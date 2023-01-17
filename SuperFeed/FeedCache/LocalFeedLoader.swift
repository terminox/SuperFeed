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

  // MARK: Public

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

  // MARK: Private

  private let store: FeedStore
  private let currentDate: () -> Date
  
  private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
    store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] error in
      guard self != nil else { return }
      completion(error)
    }
  }
}

private extension Array where Element == FeedImage {
  func toLocal() -> [LocalFeedImage] {
    return map {
      LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
    }
  }
}
