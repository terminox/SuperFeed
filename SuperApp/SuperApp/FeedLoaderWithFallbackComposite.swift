//
//  FeedLoaderWithFallbackComposite.swift
//  SuperApp
//
//  Created by yossa on 1/8/2566 BE.
//

import SuperFeed

public class FeedLoaderWithFallbackComposite: FeedLoader {

  // MARK: Lifecycle

  public init(primary: FeedLoader, fallback: FeedLoader) {
    self.primary = primary
    self.fallback = fallback
  }

  // MARK: Internal

  public func load(completion: @escaping (FeedLoader.Result) -> Void) {
    primary.load { [weak self] result in
      switch result {
      case .success:
        completion(result)
      case .failure:
        self?.fallback.load(completion: completion)
      }
    }
  }

  // MARK: Private

  private let primary: FeedLoader
  private let fallback: FeedLoader
}
