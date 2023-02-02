//
//  CodableFeedStoreTests.swift
//  SuperFeedTests
//
//  Created by yossa on 31/1/2566 BE.
//

import SuperFeed
import XCTest

// MARK: - CodableFeedStoreTests

class CodableFeedStoreTests: XCTestCase, FailableFeedStoreSpecs {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    setupEmptyStoreState()
  }

  override func tearDown() {
    super.tearDown()
    undoStoreSideEffects()
  }

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

  func test_retrieve_deliversFailureOnRetrievalError() {
    let storeURL = testSpecificStoreURL()
    let sut = makeSUT(storeURL: storeURL)

    try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)

    assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
  }

  func test_retrieve_hasNoSideEffectsOnFailure() {
    let storeURL = testSpecificStoreURL()
    let sut = makeSUT(storeURL: storeURL)

    try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)

    assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
  }

  func test_insert_overridesPreviouslyInsertedCacheValues() {
    let sut = makeSUT()
    assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
  }

  func test_insert_deliversErrorOnInsertionError() {
    let invalidStoreURL = URL(string: "invalid://store-url")!
    let sut = makeSUT(storeURL: invalidStoreURL)
    assertThatInsertDeliversErrorOnInsertionError(on: sut)
  }

  func test_insert_hasNoSideEffectsOnInsertionError() {
    let invalidStoreURL = URL(string: "invalid://store-url")!
    let sut = makeSUT(storeURL: invalidStoreURL)
    assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
  }

  func test_delete_hasNoSideEffectsOnEmptyCache() {
    let sut = makeSUT()
    assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
  }

  func test_delete_emptiesPreviouslyInsertedCache() {
    let sut = makeSUT()
    assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
  }

  func test_delete_deliversErrorOnDeletionError() {
    let noDeletePermissionURL = FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    let sut = makeSUT(storeURL: noDeletePermissionURL)
    assertThatDeleteDeliversErrorOnDeletionError(on: sut)
  }

  func test_delete_hasNoSideEffectsOnDeletionError() {
    let noDeletePermissionURL = FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    let sut = makeSUT(storeURL: noDeletePermissionURL)
    assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
  }

  func test_storeSideEffects_runSerially() {
    let sut = makeSUT()
    assertThatSideEffectsRunSerially(on: sut)
  }

  // MARK: Private

  private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
    let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }

  private func setupEmptyStoreState() {
    deleteStoreArtifacts()
  }

  private func undoStoreSideEffects() {
    deleteStoreArtifacts()
  }

  private func deleteStoreArtifacts() {
    try? FileManager.default.removeItem(at: testSpecificStoreURL())
  }

  private func testSpecificStoreURL() -> URL {
    cachesDirectory().appendingPathComponent("\(type(of: self)).store")
  }

  private func cachesDirectory() -> URL {
    FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  }
}
