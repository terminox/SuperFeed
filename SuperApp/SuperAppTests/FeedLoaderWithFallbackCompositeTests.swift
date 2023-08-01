//
//  FeedLoaderWithFallbackCompositeTests.swift
//  SuperAppTests
//
//  Created by yossa on 1/8/2566 BE.
//

import SuperApp
import SuperFeed
import XCTest

class FeedLoaderWithFallbackCompositeTests: XCTestCase {

  // MARK: Internal

  func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
    let primaryFeed = uniqueFeed()
    let fallbackFeed = uniqueFeed()
    let sut = makeSUT(primaryResult: .success(primaryFeed), fallbackResult: .success(fallbackFeed))

    expect(sut, toCompleteWith: .success(primaryFeed))
  }
  
  func test_load_deliversFallbackFeedOnPrimaryLoaderFailure() {
    let fallbackFeed = uniqueFeed()
    let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackFeed))

    expect(sut, toCompleteWith: .success(fallbackFeed))
  }
  
  func test_load_deliversErrorOnBothPrimaryAndFallbackFailure() {
    let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))

    expect(sut, toCompleteWith: .failure(anyNSError()))
  }

  // MARK: Private

  private class LoaderStub: FeedLoader {

    // MARK: Lifecycle

    init(result: FeedLoader.Result) {
      self.result = result
    }

    // MARK: Internal

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
      completion(result)
    }

    // MARK: Private

    private let result: FeedLoader.Result
  }

  private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
    addTeardownBlock { [weak instance] in
      XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
    }
  }

  private func makeSUT(
    primaryResult: FeedLoader.Result,
    fallbackResult: FeedLoader.Result,
    file: StaticString = #file,
    line: UInt = #line)
    -> FeedLoader
  {
    let primaryLoader = LoaderStub(result: primaryResult)
    let fallbackLoader = LoaderStub(result: fallbackResult)
    let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    trackForMemoryLeaks(primaryLoader, file: file, line: line)
    trackForMemoryLeaks(fallbackLoader, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) {
    let exp = expectation(description: "wait for load completion")
    
    sut.load { receivedResult in
      switch (receivedResult, expectedResult) {
      case (.success(let receivedFeed), .success(let expectedFeed)):
        XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
      case (.failure, .failure):
        break
      default:
        XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
      }

      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
  }

  private func uniqueFeed() -> [FeedImage] {
    [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
  }
  
  private func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
  }
}
