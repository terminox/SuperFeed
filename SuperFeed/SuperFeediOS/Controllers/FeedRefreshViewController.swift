//
//  FeedRefreshViewController.swift
//  SuperFeediOS
//
//  Created by yossa on 25/5/2566 BE.
//

import UIKit
import SuperFeed

final class FeedRefreshViewController: NSObject {
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }
  
  private(set) lazy var view: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    return refreshControl
  }()
  
  private let feedLoader: FeedLoader
  
  var onRefresh: (([FeedImage]) -> Void)?
  
  @objc
  func refresh() {
    view.beginRefreshing()
    
    feedLoader.load { [weak self] result in
      switch result {
      case .success(let models):
        self?.onRefresh?(models)
      case .failure(_):
        break
      }
      
      self?.view.endRefreshing()
    }
  }
}
