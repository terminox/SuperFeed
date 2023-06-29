//
//  FeedPresenter.swift
//  SuperFeediOS
//
//  Created by yossa on 6/6/2566 BE.
//

import Foundation
import SuperFeed

protocol FeedLoadingView {
  func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView {
  func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
  
  private let feedView: FeedView
  private let loadingView: FeedLoadingView
  
  init(feedView: FeedView, loadingView: FeedLoadingView) {
    self.feedView = feedView
    self.loadingView = loadingView
  }
  
  static var title: String {
    NSLocalizedString(
      "FEED_VIEW_TITLE",
      tableName: "Feed",
      bundle: Bundle(for: FeedPresenter.self),
      comment: "Title for the feed view")
  }
  
  func didStartLoadingFeed() {
    loadingView.display(FeedLoadingViewModel(isLoading: true))
  }
  
  func didFinishLoadingFeed(with feed: [FeedImage]) {
    guard Thread.isMainThread else {
      return DispatchQueue.main.async { [weak self] in self?.didFinishLoadingFeed(with: feed) }
    }
    
    feedView.display(FeedViewModel(feed: feed))
    loadingView.display(FeedLoadingViewModel(isLoading: false))
  }
  
  func didFinishLoadingFeed(with error: Error) {
    guard Thread.isMainThread else {
      return DispatchQueue.main.async { [weak self] in self?.didFinishLoadingFeed(with: error) }
    }

    loadingView.display(FeedLoadingViewModel(isLoading: false))
  }
}
