//
//  FeedUIComposer.swift
//  SuperFeediOS
//
//  Created by yossa on 4/6/2566 BE.
//

import Foundation
import SuperFeed

public final class FeedUIComposer {
  
  private init() {}
  
  public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
    let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
    let feedController = FeedViewController(refreshController: refreshController)
    refreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
    return feedController
  }
  
  private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
    return { [weak controller] feed in
      controller?.tableModel = feed.map {
        FeedImageCellController(model: $0, imageLoader: loader)
      }
    }
  }
}
