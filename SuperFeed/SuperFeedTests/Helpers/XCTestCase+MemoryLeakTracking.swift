//
//  XCTestCase+MemoryLeakTracking.swift
//  SuperFeedTests
//
//  Created by yossa on 2/12/2565 BE.
//

import XCTest

extension XCTestCase {
  func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
    addTeardownBlock { [weak instance] in
      XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
    }
  }
}
