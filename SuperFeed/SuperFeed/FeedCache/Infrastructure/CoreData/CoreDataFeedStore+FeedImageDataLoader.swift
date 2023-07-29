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
        try ManagedFeedImage.first(with: url, in: context)
          .map { $0.data = data }
          .map(context.save)
      })
    }
  }
  
  public func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
    perform { context in
      completion(Result {
        try ManagedFeedImage.first(with: url, in: context)?.data
      })
    }
  }
}
