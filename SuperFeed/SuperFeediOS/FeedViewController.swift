//
//  FeedViewController.swift
//  SuperFeediOS
//
//  Created by yossa on 18/5/2566 BE.
//

import UIKit
import SuperFeed

public protocol FeedImageDataLoader {
  func loadImageData(from url: URL)
}

final public class FeedViewController: UITableViewController {
  
  private var feedLoader: FeedLoader?
  private var imageLoader: FeedImageDataLoader?
  private var tableModel: [FeedImage] = []
  
  public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
    self.init()
    self.feedLoader = feedLoader
    self.imageLoader = imageLoader
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
    
    feedLoader?.load { [weak self] result in
      switch result {
      case .success(let models):
        self?.tableModel = models
      case .failure(_):
        break
      }
      
      self?.tableView.reloadData()
      self?.refreshControl?.endRefreshing()
    }
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableModel.count
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellModel = tableModel[indexPath.row]
    let cell = FeedImageCell()
    cell.locationContainer.isHidden = (cellModel.location == nil)
    cell.locationLabel.text = cellModel.location
    cell.descriptionLabel.text = cellModel.description
    imageLoader?.loadImageData(from: cellModel.url)
    return cell
  }
}
