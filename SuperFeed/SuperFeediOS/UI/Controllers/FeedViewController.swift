//
//  FeedViewController.swift
//  SuperFeediOS
//
//  Created by yossa on 18/5/2566 BE.
//

import UIKit
import SuperFeed

protocol FeedViewControllerDelegate {
  func didRequestFeedRefresh()
}

public protocol FeedImageDataLoaderTask {
  func cancel()
}

public protocol FeedImageDataLoader {
  typealias Result = Swift.Result<Data, Error>
  func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching, FeedLoadingView {
  
  var delegate: FeedViewControllerDelegate?
  
  var tableModel: [FeedImageCellController] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    refresh()
  }
  
  func display(_ viewModel: FeedLoadingViewModel) {
    if viewModel.isLoading {
      refreshControl?.beginRefreshing()
    } else {
      refreshControl?.endRefreshing()
    }
  }
  
  @IBAction
  private func refresh() {
    delegate?.didRequestFeedRefresh()
  }

  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableModel.count
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cellController(forRowAt: indexPath).view(in: tableView)
  }
  
  public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cellController(forRowAt: indexPath).preload()
  }
  
  public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cancelCellControllerLoad(forRowAt: indexPath)
  }
  
  public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach { indexPath in
      cellController(forRowAt: indexPath).preload()
    }
  }
  
  public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach(cancelCellControllerLoad(forRowAt:))
  }
  
  private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
    tableModel[indexPath.row]
  }
  
  private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
    cellController(forRowAt: indexPath).cancelLoad()
  }
}
