//
//  XCTestCase+FailableDeleteFeedStoreSpecs.swift
//  SuperFeedTests
//
//  Created by yossa on 1/2/2566 BE.
//

import SuperFeed
import XCTest

extension FailableDeleteFeedStoreSpecs where Self: XCTestCase {
  func assertThatDeleteDeliversErrorOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
    let deletionError = deleteCache(from: sut)
    
    XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
  }
  
  func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
    deleteCache(from: sut)
    
    expect(sut, toRetrieve: .success(.none), file: file, line: line)
  }
}
