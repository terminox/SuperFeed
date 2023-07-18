//
//  FeedPresenterTests.swift
//  SuperFeedTests
//
//  Created by yossa on 19/7/2566 BE.
//

import XCTest

final class FeedPresenter {
  init(view: Any) {
    
  }
}

final class FeedPresenterTests: XCTestCase {
  
  func test_init_doesNotSendMessagesToView() {
    let view = ViewSpy()
    
    _ = FeedPresenter(view: view)
    
    XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
  }
  
  private class ViewSpy {
    let messages = [Any]()
  }
}
