//
//  CoreDataFeedStore+FeedStore.swift
//  SuperFeed
//
//  Created by yossa on 29/7/2566 BE.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
  public func retrieve(completion: @escaping RetrievalCompletion) {
    perform { context in
      completion(Result {
        try ManagedCache.find(in: context)
          .map {
//            CachedFeed
          }
      })
    }
  }
  
  public func insert(_ items: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    <#code#>
  }
  
  public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
    <#code#>
  }
}
