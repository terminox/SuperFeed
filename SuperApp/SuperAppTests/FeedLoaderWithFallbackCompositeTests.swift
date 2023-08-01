//
//  FeedLoaderWithFallbackCompositeTests.swift
//  SuperAppTests
//
//  Created by yossa on 1/8/2566 BE.
//

import SuperFeed
import XCTest

// MARK: - FeedLoaderWithFallbackComposite

class FeedLoaderWithFallbackComposite: FeedLoader {

  // MARK: Lifecycle

  init(primary: FeedLoader, fallback _: FeedLoader) {
    self.primary = primary
  }

  // MARK: Internal

  func load(completion: @escaping (FeedLoader.Result) -> Void) {
    primary.load(completion: completion)
  }

  // MARK: Private

  private let primary: FeedLoader
}

// MARK: - FeedLoaderWithFallbackCompositeTests

class FeedLoaderWithFallbackCompositeTests: XCTestCase {

  // MARK: Internal

  func test_load_deliversPrimaryFeedOnPrimaryFeedLoaderSuccess() {
    let primaryFeed = uniqueFeed()
    let fallbackFeed = uniqueFeed()
    let sut = makeSUT(primaryResult: .success(primaryFeed), fallbackResult: .success(fallbackFeed))

    let exp = expectation(description: "wait for load completion")
    sut.load { result in
      switch result {
      case .success(let receivedFeed):
        XCTAssertEqual(receivedFeed, primaryFeed)
      case .failure:
        XCTFail("Expected successful load feed result, got \(result) instead")
      }

      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
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

  private func uniqueFeed() -> [FeedImage] {
    [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
  }
}
