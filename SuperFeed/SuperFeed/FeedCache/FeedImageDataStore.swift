//
//  FeedImageDataStore.swift
//  SuperFeed
//
//  Created by yossa on 29/7/2566 BE.
//

import Foundation

public protocol FeedImageDataStore {
  typealias RetrievalResult = Swift.Result<Data?, Error>
  typealias InsertionResult = Swift.Result<Void, Error>
  
  func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
  func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}
