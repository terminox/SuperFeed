//
//  FeedViewModel.swift
//  SuperFeediOS
//
//  Created by yossa on 4/6/2566 BE.
//

import Foundation
import SuperFeed

final class FeedViewModel {
  
  typealias Observer<T> = (T) -> Void
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }

  private let feedLoader: FeedLoader
  
  var onLoadingStateChange: Observer<Bool>?
  var onFeedLoad: Observer<[FeedImage]>?
  
  func loadFeed() {
    onLoadingStateChange?(true)
    
    feedLoader.load { [weak self] result in
      if case .success(let feed) = result {
        self?.onFeedLoad?(feed)
      }
      
      self?.onLoadingStateChange?(false)
    }
  }
}
