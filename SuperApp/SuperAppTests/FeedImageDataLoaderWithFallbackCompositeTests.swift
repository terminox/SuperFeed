//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  SuperAppTests
//
//  Created by yossa on 2/8/2566 BE.
//

import SuperFeed
import XCTest

// MARK: - FeedImageDataLoaderWithFallbackComposite

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {

  // MARK: Lifecycle

  init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
    self.primary = primary
    self.fallback = fallback
  }

  // MARK: Internal

  func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
    let task = TaskWrapper()
    task.wrapped = primary.loadImageData(from: url) { [weak self] result in
      switch result {
      case .success(let data):
        completion(.success(data))
      case .failure:
        task.wrapped = self?.fallback.loadImageData(from: url, completion: completion)
      }
    }

    return task
  }

  // MARK: Private

  private class TaskWrapper: FeedImageDataLoaderTask {
    var wrapped: FeedImageDataLoaderTask?

    func cancel() {
      wrapped?.cancel()
    }
  }

  private let primary: FeedImageDataLoader
  private let fallback: FeedImageDataLoader
}

// MARK: - FeedImageDataLoaderWithFallbackCompositeTests

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

  // MARK: Internal

  func test_load_loadsFromPrimaryLoaderFirst() {
    let primaryLoader = LoaderSpy()
    let fallbackLoader = LoaderSpy()
    let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    let url = anyURL()
    
    _ = sut.loadImageData(from: url) { _ in }

    XCTAssertEqual(primaryLoader.urls, [url])
    XCTAssertTrue(fallbackLoader.urls.isEmpty)
  }

  func test_load_loadsFromFallbackLoaderOnPrimaryFailure() {
    let primaryLoader = LoaderSpy()
    let fallbackLoader = LoaderSpy()
    let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    let url = anyURL()
    
    _ = sut.loadImageData(from: url) { _ in }
    primaryLoader.complete(with: .failure(anyNSError()))

    XCTAssertEqual(primaryLoader.urls, [url])
    XCTAssertEqual(fallbackLoader.urls, [url])
  }

  // MARK: Private

  private class LoaderSpy: FeedImageDataLoader {

    // MARK: Internal

    private(set) var cancelledURLs: [URL] = []
    
    var urls: [URL] {
      messages.map { $0.url }
    }

    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
      messages.append((url: url, completion: completion))
      return LoaderTask { [weak self] in
        self?.cancelledURLs.append(url)
      }
    }
    
    func complete(with result: FeedImageDataLoader.Result, at index: Int = 0) {
      messages[index].completion(result)
    }

    // MARK: Private

    private struct LoaderTask: FeedImageDataLoaderTask {
      let callback: () -> Void

      func cancel() {
        callback()
      }
    }

    private var messages: [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)] = []
  }

  private func anyURL() -> URL {
    URL(string: "https://any-url.com")!
  }

  private func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
  }
}
