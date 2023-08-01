//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  SuperAppTests
//
//  Created by yossa on 2/8/2566 BE.
//

import SuperFeed
import XCTest

// MARK: - FeedImageDataLoaderWithFallbackCompositeTests

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

  // MARK: Internal
  
  func test_loadImageData_doesNotLoadOnCreation() {
    let (_, primaryLoader, fallbackLoader) = makeSUT()
    
    XCTAssertTrue(primaryLoader.urls.isEmpty)
    XCTAssertTrue(fallbackLoader.urls.isEmpty)
  }

  func test_loadImageData_loadsFromPrimaryLoaderFirst() {
    let url = anyURL()
    let (sut, primaryLoader, fallbackLoader) = makeSUT()
    
    _ = sut.loadImageData(from: url) { _ in }

    XCTAssertEqual(primaryLoader.urls, [url])
    XCTAssertTrue(fallbackLoader.urls.isEmpty)
  }

  func test_loadImageData_loadsFromFallbackLoaderOnPrimaryFailure() {
    let url = anyURL()
    let (sut, primaryLoader, fallbackLoader) = makeSUT()
    
    _ = sut.loadImageData(from: url) { _ in }
    primaryLoader.complete(with: anyNSError())

    XCTAssertEqual(primaryLoader.urls, [url])
    XCTAssertEqual(fallbackLoader.urls, [url])
  }
  
  func test_cancelLoadImageData_cancelPrimaryTask() {
    let url = anyURL()
    let (sut, primaryLoader, fallbackLoader) = makeSUT()
    
    let task = sut.loadImageData(from: url) { _ in }
    task.cancel()

    XCTAssertEqual(primaryLoader.cancelledURLs, [url])
    XCTAssertTrue(fallbackLoader.cancelledURLs.isEmpty)
  }
  
  func test_cancelLoadImageData_cancelFallbackTaskAfterPrimaryFailure() {
    let url = anyURL()
    let (sut, primaryLoader, fallbackLoader) = makeSUT()
    
    let task = sut.loadImageData(from: url) { _ in }
    primaryLoader.complete(with: anyNSError())
    task.cancel()

    XCTAssertTrue(primaryLoader.cancelledURLs.isEmpty)
    XCTAssertEqual(fallbackLoader.cancelledURLs, [url])
  }
  
  func test_loadImageData_deliversPrimaryDataOnPrimarySuccess() {
    let primaryData = anyData()
    let url = anyURL()
    let (sut, primaryLoader, _) = makeSUT()

    let exp = expectation(description: "wait for image loading")
    _ = sut.loadImageData(from: url) { result in
      switch result {
      case .success(let data):
        XCTAssertEqual(data, primaryData)
      case .failure(let error):
        XCTFail("Expected \(primaryData), got \(error) instead")
      }
      
      exp.fulfill()
    }
    
    primaryLoader.complete(with: primaryData)
    
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_loadImageData_deliversFallbackDataOnPrimaryFailure() {
    let fallbackData = anyData()
    let url = anyURL()
    let (sut, primaryLoader, fallbackLoader) = makeSUT()

    let exp = expectation(description: "wait for image loading")
    _ = sut.loadImageData(from: url) { result in
      switch result {
      case .success(let data):
        XCTAssertEqual(data, fallbackData)
      case .failure(let error):
        XCTFail("Expected \(fallbackData), got \(error) instead")
      }
      
      exp.fulfill()
    }
    
    primaryLoader.complete(with: anyNSError())
    fallbackLoader.complete(with: fallbackData)
    
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_loadImageData_deliversErrorDataOnBothLoadersFailure() {
    let error = anyNSError()
    let url = anyURL()
    let (sut, primaryLoader, fallbackLoader) = makeSUT()

    let exp = expectation(description: "wait for image loading")
    _ = sut.loadImageData(from: url) { result in
      switch result {
      case .success(let data):
        XCTFail("Expected an error, got \(data) instead")
      case .failure:
        break
      }
      
      exp.fulfill()
    }
    
    primaryLoader.complete(with: error)
    fallbackLoader.complete(with: error)
    
    wait(for: [exp], timeout: 1.0)
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

    func complete(with data: Data, at index: Int = 0) {
      messages[index].completion(.success(data))
    }
    
    func complete(with error: Error, at index: Int = 0) {
      messages[index].completion(.failure(error))
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

  private func makeSUT(
    file: StaticString = #file,
    line: UInt = #line) -> (sut: FeedImageDataLoaderWithFallbackComposite, primaryLoader: LoaderSpy, fallbackLoader: LoaderSpy) {
    let primaryLoader = LoaderSpy()
    let fallbackLoader = LoaderSpy()
    let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    trackForMemoryLeaks(primaryLoader, file: file, line: line)
    trackForMemoryLeaks(fallbackLoader, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, primaryLoader, fallbackLoader)
  }

  private func anyURL() -> URL {
    URL(string: "https://any-url.com")!
  }

  private func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
  }
  
  func anyData() -> Data {
    return Data("any data".utf8)
  }

  private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
    addTeardownBlock { [weak instance] in
      XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
    }
  }
}

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
