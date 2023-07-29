//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//  SuperFeedTests
//
//  Created by yossa on 1/2/2566 BE.
//

import SuperFeed
import XCTest

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
  func assertThatInsertDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
    let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
    
    XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
  }
  
  func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
    insert((uniqueImageFeed().local, Date()), to: sut)
    
    expect(sut, toRetrieve: .success(.none), file: file, line: line)
  }
}
