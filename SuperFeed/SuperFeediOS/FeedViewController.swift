//
//  FeedViewController.swift
//  SuperFeediOS
//
//  Created by yossa on 18/5/2566 BE.
//

import UIKit
import SuperFeed

final public class FeedViewController: UITableViewController {
  
  private var loader: FeedLoader?
  
  public convenience init(loader: FeedLoader) {
    self.init()
    self.loader = loader
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
    
    load()
  }
  
  @objc
  private func load() {
    refreshControl?.beginRefreshing()
    
    loader?.load { [weak self] _ in
      self?.refreshControl?.endRefreshing()
    }
  }
}
