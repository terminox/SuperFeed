//
//  FeedLoader.swift
//  SuperFeed
//
//  Created by yossa on 4/10/2565 BE.
//

import Foundation

public enum LoadFeedResult {
  case success([FeedItem])
  case failure(Error)
}

public protocol FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void)
}
