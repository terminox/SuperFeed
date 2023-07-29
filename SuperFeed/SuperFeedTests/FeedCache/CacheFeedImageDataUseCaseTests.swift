//
//  CacheFeedImageDataUseCaseTests.swift
//  SuperFeedTests
//
//  Created by yossa on 30/7/2566 BE.
//

import SuperFeed
import XCTest

class CacheFeedImageDataUseCaseTests: XCTestCase {

  // MARK: Internal

  func test_init_doesNotMessageStoreUponCreation() {
    let (_, store) = makeSUT()

    XCTAssertTrue(store.receivedMessages.isEmpty)
  }

  // MARK: Private

  private func makeSUT(
    file: StaticString = #file,
    line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
    let store = FeedImageDataStoreSpy()
    let sut = LocalFeedImageDataLoader(store: store)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }

  private func failed() -> LocalFeedImageDataLoader.SaveResult {
    .failure(LocalFeedImageDataLoader.SaveError.failed)
  }

  private func expect(
    _ sut: LocalFeedImageDataLoader,
    toCompleteWith expectedResult: LocalFeedImageDataLoader.SaveResult,
    when action: () -> Void,
    file: StaticString = #file,
    line: UInt = #line) {
    let exp = expectation(description: "Wait for load completion")

    sut.save(anyData(), for: anyURL()) { receivedResult in
      switch (receivedResult, expectedResult) {
      case (.success, .success):
        break

      case (
        .failure(let receivedError as LocalFeedImageDataLoader.SaveError),
        .failure(let expectedError as LocalFeedImageDataLoader.SaveError)):
        XCTAssertEqual(receivedError, expectedError, file: file, line: line)

      default:
        XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
      }

      exp.fulfill()
    }

    action()
    wait(for: [exp], timeout: 1.0)
  }
}
