//
//  CoreDataFeedStoreTests.swift
//  SuperFeedTests
//
//  Created by yossa on 1/2/2566 BE.
//

import SuperFeed
import XCTest

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {

  // MARK: Internal

  func test_retrieve_deliversEmptyOnEmptyCache() {
    let sut = makeSUT()
    assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
  }

  func test_retrieve_hasNoSideEffectsOnEmptyCache() {
    let sut = makeSUT()
    assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
  }

  func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
    let sut = makeSUT()
    assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
  }

  func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
    let sut = makeSUT()
    assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
  }

  func test_insert_overridesPreviouslyInsertedCacheValues() {
    let sut = makeSUT()
    assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
  }

  func test_delete_hasNoSideEffectsOnEmptyCache() {
    let sut = makeSUT()
    assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
  }

  func test_delete_emptiesPreviouslyInsertedCache() {
    let sut = makeSUT()
    assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
  }

  func test_storeSideEffects_runSerially() {
    let sut = makeSUT()
    assertThatSideEffectsRunSerially(on: sut)
  }

  // MARK: Private

  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
    let storeBundle = Bundle(for: CoreDataFeedStore.self)
    let storeURL = URL(fileURLWithPath: "/dev/null")
    let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
}
