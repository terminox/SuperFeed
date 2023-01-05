//
//  CacheFeedUseCaseTests.swift
//  SuperFeedTests
//
//  Created by yossa on 5/1/2566 BE.
//

import XCTest

// MARK: - LocalFeedLoader

class LocalFeedLoader {

  // MARK: Lifecycle

  init(store: FeedStore) {
    self.store = store
  }

  // MARK: Internal

  func save(_: [FeedItem]) {
    store.deleteCachedFeed()
  }

  // MARK: Private

  private let store: FeedStore
}

// MARK: - FeedStore

class FeedStore {
  var deleteCachedFeedCallCount = 0

  func deleteCachedFeed() {
    deleteCachedFeedCallCount += 1
  }
}

// MARK: - CacheFeedUseCaseTests

class CacheFeedUseCaseTests: XCTestCase {

  // MARK: Internal

  func test_init_doesNotDeleteCacheUponCreation() {
    let (_, store) = makeSUT()
    XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
  }

  func test_save_requestCacheDeletion() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()

    sut.save(items)
    XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
  }

  // MARK: Private
  
  private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore) {
    let store = FeedStore()
    let sut = LocalFeedLoader(store: store)
    return (sut, store)
  }

  private func uniqueItem() -> FeedItem {
    FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
  }

  private func anyURL() -> URL {
    URL(string: "http://any-url.com")!
  }
}
