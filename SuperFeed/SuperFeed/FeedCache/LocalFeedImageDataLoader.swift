//
//  LocalFeedImageDataLoader.swift
//  SuperFeed
//
//  Created by yossa on 29/7/2566 BE.
//

import Foundation

// MARK: - LocalFeedImageDataLoader

public final class LocalFeedImageDataLoader {

  // MARK: Lifecycle

  public init(store: FeedImageDataStore) {
    self.store = store
  }

  // MARK: Private

  private let store: FeedImageDataStore
}

extension LocalFeedImageDataLoader {
  public typealias SaveResult = Result<Void, Error>

  public enum SaveError: Error {
    case failed
  }


  public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
    store.insert(data, for: url) { [weak self] result in
      guard self != nil else { return }
      completion(result.mapError { _ in SaveError.failed })
    }
  }
}

// MARK: FeedImageDataLoader

extension LocalFeedImageDataLoader: FeedImageDataLoader {

  // MARK: Public

  public typealias LoadResult = FeedImageDataLoader.Result

  public enum LoadError: Error {
    case failed
    case notFound
  }


  public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
    let task = LoadImageDataTask(completion)
    store.retrieve(dataForURL: url) { [weak self] result in
      guard self != nil else { return }
      task.complete(
        with: result
          .mapError { _ in LoadError.failed }
          .flatMap { data in
            data.map { .success($0) } ?? .failure(LoadError.notFound)
          })
    }
    return task
  }

  // MARK: Private

  private final class LoadImageDataTask: FeedImageDataLoaderTask {

    // MARK: Lifecycle

    init(_ completion: ((FeedImageDataLoader.Result) -> Void)? = nil) {
      self.completion = completion
    }

    // MARK: Internal

    func complete(with result: FeedImageDataLoader.Result) {
      completion?(result)
    }

    func cancel() {
      preventFurtherCompletions()
    }

    // MARK: Private

    private var completion: ((FeedImageDataLoader.Result) -> Void)?

    private func preventFurtherCompletions() {
      completion = nil
    }
  }
}
