//
//  FeedStore.swift
//  SuperFeed
//
//  Created by yossa on 17/1/2566 BE.
//

import Foundation

// MARK: - FeedStore

public protocol FeedStore {
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void

  func deleteCachedFeed(completion: @escaping DeletionCompletion)
  func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}
