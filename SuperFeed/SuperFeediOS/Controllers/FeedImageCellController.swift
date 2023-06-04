//
//  FeedImageCellController.swift
//  SuperFeediOS
//
//  Created by yossa on 4/6/2566 BE.
//

import UIKit

final class FeedImageCellController {
  
  private let viewModel: FeedImageViewModel<UIImage>
  
  init(viewModel: FeedImageViewModel<UIImage>) {
    self.viewModel = viewModel
  }
  
  func view() -> UITableViewCell {
    let cell = binded(FeedImageCell())
    viewModel.loadImageData()
    return cell
  }

  func preload() {
    viewModel.loadImageData()
  }
  
  func cancelLoad() {
    viewModel.cancelImageDataLoad()
  }
  
  private func binded(_ cell: FeedImageCell) -> FeedImageCell {
    let cell = FeedImageCell()
    cell.locationContainer.isHidden = !viewModel.hasLocation
    cell.locationLabel.text = viewModel.location
    cell.descriptionLabel.text = viewModel.description
    cell.onRetry = viewModel.loadImageData
    
    viewModel.onImageLoad = { [weak cell] image in
      cell?.feedImageView.image = image
    }
    
    viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
      cell?.feedImageContainer.isShimmering = isLoading
    }
    
    viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
      cell?.feedImageRetryButton.isHidden = !shouldRetry
    }
    
    return cell
  }
}
