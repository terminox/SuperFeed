//
//  FeedRefreshViewController.swift
//  SuperFeediOS
//
//  Created by yossa on 25/5/2566 BE.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
  func didRequestFeedRefresh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {
  
  @IBOutlet private var view: UIRefreshControl?
  var delegate: FeedRefreshViewControllerDelegate?
  
  @IBAction
  func refresh() {
    delegate?.didRequestFeedRefresh()
  }
  
  func display(_ viewModel: FeedLoadingViewModel) {
    if viewModel.isLoading {
      view?.beginRefreshing()
    } else {
      view?.endRefreshing()
    }
  }
}
