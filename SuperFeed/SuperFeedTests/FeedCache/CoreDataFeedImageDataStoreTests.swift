//
//  CoreDataFeedImageDataStoreTests.swift
//  SuperFeedTests
//
//  Created by yossa on 30/7/2566 BE.
//

import SuperFeed
import XCTest

class CoreDataFeedImageDataStoreTests: XCTestCase {

  // MARK: Internal

  func test_retrieveImageData_deliversNotFoundWhenEmpty() {
    let sut = makeSUT()

    expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
  }

  // MARK: Private

  private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataFeedStore {
    let storeURL = URL(fileURLWithPath: "/dev/null")
    let sut = try! CoreDataFeedStore(storeURL: storeURL)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }

  private func notFound() -> FeedImageDataStore.RetrievalResult {
    .success(.none)
  }

  private func found(_ data: Data) -> FeedImageDataStore.RetrievalResult {
    .success(data)
  }

  private func localImage(url: URL) -> LocalFeedImage {
    LocalFeedImage(id: UUID(), description: "any", location: "any", url: url)
  }

  private func expect(
    _ sut: CoreDataFeedStore,
    toCompleteRetrievalWith expectedResult: FeedImageDataStore.RetrievalResult,
    for url: URL,
    file: StaticString = #file,
    line: UInt = #line) {
    let exp = expectation(description: "Wait for load completion")
    sut.retrieve(dataForURL: url) { receivedResult in
      switch (receivedResult, expectedResult) {
      case (.success( let receivedData), .success(let expectedData)):
        XCTAssertEqual(receivedData, expectedData, file: file, line: line)

      default:
        XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }

  private func insert(_ data: Data, for url: URL, into sut: CoreDataFeedStore, file: StaticString = #file, line: UInt = #line) {
    let exp = expectation(description: "Wait for cache insertion")
    let image = localImage(url: url)
    sut.insert([image], timestamp: Date()) { result in
      switch result {
      case .failure(let error):
        XCTFail("Failed to save \(image) with error \(error)", file: file, line: line)
        exp.fulfill()

      case .success:
        sut.insert(data, for: url) { result in
          if case Result.failure(let error) = result {
            XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
          }
          exp.fulfill()
        }
      }
    }
    wait(for: [exp], timeout: 1.0)
  }
}
