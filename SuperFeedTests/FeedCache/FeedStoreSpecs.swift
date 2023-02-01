//
//  FeedStoreSpecs.swift
//  SuperFeedTests
//
//  Created by yossa on 1/2/2566 BE.
//

import Foundation

// MARK: - FeedStoreSpecs

protocol FeedStoreSpecs {
  func test_retrieve_deliversEmptyOnEmptyCache()
  func test_retrieve_hasNoSideEffectsOnEmptyCache()
  func test_retrieve_deliversFoundValuesOnNonEmptyCache()
  func test_retrieve_hasNoSideEffectsOnNonEmptyCache()

  func test_insert_overridesPreviouslyInsertedCacheValues()

  func test_delete_hasNoSideEffectsOnEmptyCache()
  func test_delete_emptiesPreviouslyInsertedCache()

  func test_storeSideEffects_runSerially()
}

// MARK: - FailableRetriveFeedStoreSpecs

protocol FailableRetreiveFeedStoreSpecs: FeedStoreSpecs {
  func test_retrieve_deliversFailureOnRetrievalError()
  func test_retrieve_hasNoSideEffectsOnFailure()
}

// MARK: - FailableInsertFeedStoreSpecs

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
  func test_insert_deliversErrorOnInsertionError()
  func test_insert_hasNoSideEffectsOnInsertionError()
}

// MARK: - FailableDeleteFeedStoreSpecs

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
  func test_delete_deliversErrorOnDeletionError()
  func test_delete_hasNoSideEffectsOnDeletionError()
}

// MARK: - FailableFeedStoreSpecs

typealias FailableFeedStoreSpecs = FailableRetreiveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
