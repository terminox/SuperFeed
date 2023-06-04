//
//  FeedRefreshViewController.swift
//  SuperFeediOS
//
//  Created by yossa on 25/5/2566 BE.
//

import UIKit

final class FeedRefreshViewController: NSObject {
  
  init(viewModel: FeedViewModel) {
    self.viewModel = viewModel
  }
  
  private(set) lazy var view: UIRefreshControl = binded(UIRefreshControl())
  
  private let viewModel: FeedViewModel
  
  @objc
  func refresh() {
    viewModel.loadFeed()
  }
  
  @objc
  private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
    viewModel.onChange = { [weak self] viewModel in
      if viewModel.isLoading {
        self?.view.beginRefreshing()
      } else {
        self?.view.endRefreshing()
      }
    }
    
    view.addTarget(self, action: #selector(refresh), for: .valueChanged)
    return view
  }
}
