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

  public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
    store.deleteCachedFeed { [weak self] error in
      guard let self = self else { return }
      
      if let cacheDeletionError = error {
        completion(cacheDeletionError)
      } else {
        self.cache(items, with: completion)
      }
    }
  }

  // MARK: Private

  private let store: FeedStore
  private let currentDate: () -> Date
  
  private func cache(_ items: [FeedItem], with completion: @escaping (SaveResult) -> Void) {
    store.insert(items, timestamp: currentDate()) { [weak self] error in
      guard self != nil else { return }
      completion(error)
    }
  }
}
