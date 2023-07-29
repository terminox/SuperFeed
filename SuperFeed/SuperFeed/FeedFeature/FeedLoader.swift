//
//  FeedLoader.swift
//  SuperFeed
//
//  Created by yossa on 4/10/2565 BE.
//

import Foundation

public protocol FeedLoader {
  typealias Result = Swift.Result<[FeedImage], Error>
  
  func load(completion: @escaping (Result) -> Void)
}
