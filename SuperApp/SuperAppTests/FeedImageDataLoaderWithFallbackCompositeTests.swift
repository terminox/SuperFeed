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
    task = primary.loadImageData(from: url) { [weak self] result in
      switch result {
      case .success(let data):
        completion(.success(data))
      case .failure:
        self?.task = self?.fallback.loadImageData(from: url, completion: completion)
      }
    }
    
    return task!
  }

  // MARK: Private

  private let primary: FeedImageDataLoader
  private let fallback: FeedImageDataLoader
  
  private var task: FeedImageDataLoaderTask?
}

// MARK: - FeedImageDataLoaderWithFallbackCompositeTests

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

  // MARK: Internal

  func test_load_deliversPrimaryImageOnPrimarySuccess() {
    let primaryData = UIImage.make(withColor: .red).pngData()!
    let primaryLoader = FeedImageDataLoaderStub(result: .success(primaryData))

    let fallbackData = UIImage.make(withColor: .blue).pngData()!
    let fallbackLoader = FeedImageDataLoaderStub(result: .success(fallbackData))
    let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)

    let exp = expectation(description: "wait for image loading")
    _ = sut.loadImageData(from: anyURL()) { result in
      switch result {
      case .success(let data):
        XCTAssertEqual(data, primaryData)

      case .failure:
        XCTFail("Expected data, got \(result) instead")
      }

      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
  }
  
  func test_load_deliversFallbackImageOnPrimaryFailure() {
    let primaryLoader = FeedImageDataLoaderStub(result: .failure(anyNSError()))

    let fallbackData = UIImage.make(withColor: .blue).pngData()!
    let fallbackLoader = FeedImageDataLoaderStub(result: .success(fallbackData))
    let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)

    let exp = expectation(description: "wait for image loading")
    _ = sut.loadImageData(from: anyURL()) { result in
      switch result {
      case .success(let data):
        XCTAssertEqual(data, fallbackData)

      case .failure:
        XCTFail("Expected data, got \(result) instead")
      }

      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
  }

  // MARK: Private

  private class FeedImageDataLoaderStub: FeedImageDataLoader {

    // MARK: Lifecycle

    init(result: FeedImageDataLoader.Result) {
      self.result = result
    }

    // MARK: Internal

    func loadImageData(from _: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
      completion(result)
      return FeedImageDataLoaderTaskDummy()
    }

    // MARK: Private

    private class FeedImageDataLoaderTaskDummy: FeedImageDataLoaderTask {
      func cancel() {}
    }

    private let result: FeedImageDataLoader.Result
  }

  private func anyURL() -> URL {
    URL(string: "https://any-url.com")!
  }
  
  private func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
  }
}

extension UIImage {
  fileprivate static func make(withColor color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

    let format = UIGraphicsImageRendererFormat()
    format.scale = 1

    return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
      color.setFill()
      rendererContext.fill(rect)
    }
  }
}
