//
//  FeedViewController.swift
//  SuperFeediOS
//
//  Created by yossa on 18/5/2566 BE.
//

import UIKit
import SuperFeed

public protocol FeedImageDataLoaderTask {
  func cancel()
}

public protocol FeedImageDataLoader {
  typealias Result = Swift.Result<Data, Error>
  func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
  
  private var refreshController: FeedRefreshViewController?
  private var imageLoader: FeedImageDataLoader?
  private var tableModel: [FeedImage] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  private var tasks: [IndexPath: FeedImageDataLoaderTask] = [:]
  
  public convenience init(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) {
    self.init()
    self.refreshController = FeedRefreshViewController(feedLoader: feedLoader)
    self.imageLoader = imageLoader
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl = refreshController?.view
    refreshController?.onRefresh = { [weak self] feed in
      self?.tableModel = feed
    }
    
    tableView.prefetchDataSource = self
    
    refreshController?.refresh()
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
    cell.feedImageView.image = nil
    cell.feedImageRetryButton.isHidden = true
    cell.feedImageContainer.startShimmering()
    
    let loadImage = { [weak self, weak cell] in
      guard let self = self else { return }
      
      self.tasks[indexPath] = self.imageLoader?.loadImageData(from: cellModel.url) { [weak cell] result in
        if case .success(let data) = result {
          let image = UIImage(data: data)
          cell?.feedImageView.image = image
          cell?.feedImageRetryButton.isHidden = (image != nil)
        } else {
          cell?.feedImageView.image = nil
          cell?.feedImageRetryButton.isHidden = false
        }
        
        cell?.feedImageContainer.stopShimmering()
      }
    }
    
    cell.onRetry = loadImage
    loadImage()
    
    return cell
  }
  
  public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let cellModel = tableModel[indexPath.row]
    tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.url) { _ in }
  }
  
  public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let cellModel = tableModel[indexPath.row]
    tasks[indexPath]?.cancel()
    tasks[indexPath] = nil
  }
  
  public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach { indexPath in
      let cellModel = tableModel[indexPath.row]
      tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.url) { _ in }
    }
  }
  
  public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach { indexPath in
      tasks[indexPath]?.cancel()
      tasks[indexPath] = nil
    }
  }
}
