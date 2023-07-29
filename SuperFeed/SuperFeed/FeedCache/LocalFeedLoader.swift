//
//  LocalFeedLoader.swift
//  SuperFeed
//
//  Created by yossa on 17/1/2566 BE.
//

import Foundation

// MARK: - LocalFeedLoader

public final class LocalFeedLoader {

  // MARK: Lifecycle

  public init(store: FeedStore, currentDate: @escaping () -> Date) {
    self.store = store
    self.currentDate = currentDate
  }

  // MARK: Private

  private let store: FeedStore
  private let currentDate: () -> Date
}

extension LocalFeedLoader {

  // MARK: Public

  public typealias SaveResult = Result<Void, Error>

  public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
    store.deleteCachedFeed { [weak self] deletionResult in
      guard let self = self else { return }

      switch deletionResult {
      case .success:
        self.cache(feed, with: completion)

      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  // MARK: Private

  private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
    store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] insertionResult in
      guard self != nil else { return }

      completion(insertionResult)
    }
  }
}

// MARK: FeedLoader

extension LocalFeedLoader: FeedLoader {
  public typealias LoadResult = FeedLoader.Result

  public func load(completion: @escaping (LoadResult) -> Void) {
    store.retrieve { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .failure(let error):
        completion(.failure(error))

      case .success(.some(let cache)) where FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
        completion(.success(cache.feed.toModels()))

      case .success:
        completion(.success([]))
      }
    }
  }
}

extension LocalFeedLoader {
  public typealias ValidationResult = Result<Void, Error>

  public func validateCache(completion: @escaping (ValidationResult) -> Void) {
    store.retrieve { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .failure:
        self.store.deleteCachedFeed(completion: completion)

      case .success(.some(let cache)) where !FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
        self.store.deleteCachedFeed(completion: completion)

      case .success:
        completion(.success(()))
      }
    }
  }
}

extension Array where Element == FeedImage {
  fileprivate func toLocal() -> [LocalFeedImage] {
    map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
  }
}

extension Array where Element == LocalFeedImage {
  fileprivate func toModels() -> [FeedImage] {
    map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
  }
}
