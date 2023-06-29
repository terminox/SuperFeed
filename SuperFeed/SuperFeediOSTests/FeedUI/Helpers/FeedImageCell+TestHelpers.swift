//
//  FeedImageCell+TestHelpers.swift
//  SuperFeediOSTests
//
//  Created by yossa on 29/6/2566 BE.
//

import UIKit
import SuperFeediOS

extension FeedImageCell {
  
  func simulateRetryAction() {
    feedImageRetryButton.simulateTap()
  }
  
  var isShowingLocation: Bool {
    !locationContainer.isHidden
  }
  
  var locationText: String? {
    locationLabel.text
  }
  
  var descriptionText: String? {
    descriptionLabel.text
  }
  
  var isShowingImageLoadingIndicator: Bool {
    feedImageContainer.isShimmering
  }
  
  var isShowingRetryAction: Bool {
    !feedImageRetryButton.isHidden
  }
  
  var renderedImage: Data? {
    feedImageView.image?.pngData()
  }
}
