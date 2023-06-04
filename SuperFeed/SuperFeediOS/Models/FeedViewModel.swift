//
//  FeedViewModel.swift
//  SuperFeediOS
//
//  Created by yossa on 4/6/2566 BE.
//

import Foundation
import SuperFeed

final class FeedViewModel {
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }

  private let feedLoader: FeedLoader
  
  var onChange: ((FeedViewModel) -> Void)?
  var onFeedLoad: (([FeedImage]) -> Void)?
  
  var isLoading: Bool = false {
    didSet {
      onChange?(self)
    }
  }
  
  func loadFeed() {
    isLoading = true
    
    feedLoader.load { [weak self] result in
      if case .success(let feed) = result {
        self?.onFeedLoad?(feed)
      }
      
      self?.isLoading = false
    }
  }
}
