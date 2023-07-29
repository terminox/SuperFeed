//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  SuperFeed
//
//  Created by yossa on 29/7/2566 BE.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
  public func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
    perform { context in
      completion(Result {
//        try ManagedFeedImage.firs
      })
    }
  }
  
  public func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
    <#code#>
  }
}
