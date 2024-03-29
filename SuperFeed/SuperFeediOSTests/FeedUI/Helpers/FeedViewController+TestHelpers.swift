//
//  FeedViewController+TestHelpers.swift
//  SuperFeediOSTests
//
//  Created by yossa on 29/6/2566 BE.
//

import UIKit
import SuperFeediOS

extension FeedViewController {
  func simulateUserInitiatedFeedReload() {
    refreshControl?.simulatePullToRefresh()
  }
  
  @discardableResult
  func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
    feedImageView(at: index) as? FeedImageCell
  }
  
  @discardableResult
  func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
    let view = simulateFeedImageViewVisible(at: row)
    let delegate = tableView.delegate
    let index = IndexPath(row: row, section: feedImagesSection)
    delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    return view
  }
  
  func simulateFeedImageViewNearVisible(at row: Int) {
    let dataSource = tableView.prefetchDataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    dataSource?.tableView(tableView, prefetchRowsAt: [index])
  }
  
  func simulateFeedImageViewNotNearVisible(at row: Int) {
    simulateFeedImageViewNearVisible(at: row)
    
    let ds = tableView.prefetchDataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
  }
  
  var isShowingLoadingIndicator: Bool {
    refreshControl?.isRefreshing == true
  }
  
  func numberOfRenderedFeedImageViews() -> Int {
    tableView.numberOfRows(inSection: feedImagesSection)
  }
  
  func feedImageView(at row: Int) -> UITableViewCell? {
    let dataSource = tableView.dataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    return dataSource?.tableView(tableView, cellForRowAt: index)
  }
  
  private var feedImagesSection: Int {
    0
  }
}

