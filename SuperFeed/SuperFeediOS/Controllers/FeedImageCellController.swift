//
//  FeedImageCellController.swift
//  SuperFeediOS
//
//  Created by yossa on 4/6/2566 BE.
//

import UIKit
import SuperFeed

final class FeedImageCellController {
  
  private var task: FeedImageDataLoaderTask?
  private let model: FeedImage
  private let imageLoader: FeedImageDataLoader
  
  init(model: FeedImage, imageLoader: FeedImageDataLoader) {
    self.model = model
    self.imageLoader = imageLoader
  }
  
  func view() -> UITableViewCell {
    let cell = FeedImageCell()
    cell.locationContainer.isHidden = (model.location == nil)
    cell.locationLabel.text = model.location
    cell.descriptionLabel.text = model.description
    cell.feedImageView.image = nil
    cell.feedImageRetryButton.isHidden = true
    cell.feedImageContainer.startShimmering()
    
    let loadImage = { [weak self, weak cell] in
      guard let self = self else { return }
      
      self.task = self.imageLoader.loadImageData(from: self.model.url) { [weak cell] result in
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

  func preload() {
    task = imageLoader.loadImageData(from: model.url) { _ in }
  }
  
  deinit {
    task?.cancel()
  }
}
