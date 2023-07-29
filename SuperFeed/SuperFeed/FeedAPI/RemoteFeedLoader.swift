//
//  RemoteFeedLoader.swift
//  SuperFeed
//
//  Created by yossa on 5/10/2565 BE.
//

import Foundation

// MARK: - RemoteFeedLoader

public final class RemoteFeedLoader: FeedLoader {

  // MARK: Lifecycle

  public init(url: URL, client: HTTPClient) {
    self.url = url
    self.client = client
  }

  // MARK: Public

  public enum Error: Swift.Error {
    case connectivity
    case invalidData
  }

  public typealias Result = FeedLoader.Result


  public func load(completion: @escaping (Result) -> Void) {
    client.get(from: url) { [weak self] result in
      guard self != nil else { return }

      switch result {
      case .success((let data, let response)):
        completion(RemoteFeedLoader.map(data, from: response))

      case .failure:
        completion(.failure(Error.connectivity))
      }
    }
  }

  // MARK: Private

  private let url: URL
  private let client: HTTPClient

  private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
    do {
      let items = try FeedItemsMapper.map(data, from: response)
      return .success(items.toModels())
    } catch {
      return .failure(error)
    }
  }
}

extension Array where Element == RemoteFeedItem {
  fileprivate func toModels() -> [FeedImage] {
    map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
  }
}
