//
//  CacheFeedUseCaseTests.swift
//  SuperFeedTests
//
//  Created by yossa on 5/1/2566 BE.
//

import SuperFeed
import XCTest

// MARK: - LocalFeedLoader

class LocalFeedLoader {

  // MARK: Lifecycle

  init(store: FeedStore, currentDate: @escaping () -> Date) {
    self.store = store
    self.currentDate = currentDate
  }

  // MARK: Internal

  func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
    store.deleteCachedFeed { [unowned self] error in
      if error == nil {
        self.store.insert(items, timestamp: self.currentDate(), completion: completion)
      } else {
        completion(error)
      }
    }
  }

  // MARK: Private

  private let store: FeedStore
  private let currentDate: () -> Date
}

// MARK: - FeedStore

protocol FeedStore {
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void

  func deleteCachedFeed(completion: @escaping DeletionCompletion)
  func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}

// MARK: - CacheFeedUseCaseTests

class CacheFeedUseCaseTests: XCTestCase {

  // MARK: Internal

  func test_init_doesNotMessageStoreUponCreation() {
    let (_, store) = makeSUT()

    XCTAssertEqual(store.receivedMessages, [])
  }

  func test_save_requestsCacheDeletion() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()

    sut.save(items) { _ in }

    XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
  }

  func test_save_doesNotRequestCacheInsertionOnDeletionError() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()

    sut.save(items) { _ in }
    store.completeDeletion(with: deletionError)

    XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
  }

  func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
    let timestamp = Date()
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT(currentDate: { timestamp })

    sut.save(items) { _ in }
    store.completeDeletionSuccessfully()

    XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(items, timestamp)])
  }

  func test_save_failsOnDeletionError() {
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()

    expect(sut, toCompleteWithError: deletionError, when: {
      store.completeDeletion(with: deletionError)
    })
  }

  func test_save_failsOnInsertionError() {
    let (sut, store) = makeSUT()
    let insertionError = anyNSError()

    expect(sut, toCompleteWithError: insertionError, when: {
      store.completeDeletionSuccessfully()
      store.completeInsertion(with: insertionError)
    })
  }

  func test_save_succeedsOnSuccessfulCacheInsertion() {
    let (sut, store) = makeSUT()

    expect(sut, toCompleteWithError: nil, when: {
      store.completeDeletionSuccessfully()
      store.completeInsertionSuccessfully()
    })
  }

  // MARK: Private

  private class FeedStoreSpy: FeedStore {

    // MARK: Internal

    enum ReceivedMessage: Equatable {
      case deleteCachedFeed
      case insert([FeedItem], Date)
    }


    private(set) var receivedMessages = [ReceivedMessage]()


    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
      deletionCompletions.append(completion)
      receivedMessages.append(.deleteCachedFeed)
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
      deletionCompletions[index](error)
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
      deletionCompletions[index](nil)
    }

    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
      insertionCompletions.append(completion)
      receivedMessages.append(.insert(items, timestamp))
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
      insertionCompletions[index](error)
    }

    func completeInsertionSuccessfully(at index: Int = 0) {
      insertionCompletions[index](nil)
    }

    // MARK: Private

    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
  }


  // MARK: - Helpers

  private func makeSUT(
    currentDate: @escaping () -> Date = Date.init,
    file: StaticString = #file,
    line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
    let store = FeedStoreSpy()
    let sut = LocalFeedLoader(store: store, currentDate: currentDate)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }

  private func expect(
    _ sut: LocalFeedLoader,
    toCompleteWithError expectedError: NSError?,
    when action: () -> Void,
    file: StaticString = #file,
    line: UInt = #line) {
    let exp = expectation(description: "Wait for save completion")

    var receivedError: Error?
    sut.save([uniqueItem()]) { error in
      receivedError = error
      exp.fulfill()
    }

    action()
    wait(for: [exp], timeout: 1.0)

    XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
  }

  private func uniqueItem() -> FeedItem {
    FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
  }

  private func anyURL() -> URL {
    URL(string: "http://any-url.com")!
  }

  private func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
  }

}
