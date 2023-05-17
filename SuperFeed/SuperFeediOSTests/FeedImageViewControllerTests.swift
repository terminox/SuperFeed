//
//  FeedImageViewControllerTests.swift
//  SuperFeediOSTests
//
//  Created by yossa on 17/5/2566 BE.
//

import XCTest

final class FeedViewController {
  init(loader: FeedImageViewControllerTests.LoaderSpy) {
    
  }
}

final class FeedImageViewControllerTests: XCTestCase {
  
  func test_init_doesNotLoadFeed() {
    let loader = LoaderSpy()
    _ = FeedViewController(loader: loader)
    XCTAssertEqual(loader.loadCallCount, 0)
  }
  
  class LoaderSpy {
    private(set) var loadCallCount: Int = 0
  }
}
