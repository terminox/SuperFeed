//
//  CacheFeedUseCaseTests.swift
//  SuperFeedTests
//
//  Created by yossa on 5/1/2566 BE.
//

import XCTest

class LocalFeedLoader {
  init(store: FeedStore) {
    
  }
}

class FeedStore {
  var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
  
  func test_init_doesNotDeleteCacheUponCreation() {
    let store = FeedStore()
    _ = LocalFeedLoader(store: store)
    XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
  }
}