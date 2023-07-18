//
//  MainQueueDispatchDecorator.swift
//  SuperFeediOS
//
//  Created by yossa on 30/6/2566 BE.
//

import Foundation
import SuperFeed

final class MainQueueDispatchDecorator<T> {
  
  private let decoratee: T
  
  init(decoratee: T) {
    self.decoratee = decoratee
  }
  
  func dispatch(completion: @escaping () -> Void) {
    guard Thread.isMainThread else {
      return DispatchQueue.main.async(execute: completion)
    }
    
    completion()
  }
}

extension MainQueueDispatchDecorator: FeedLoader where T == FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void) {
    decoratee.load { [weak self] result in
      self?.dispatch {
        completion(result)
      }
    }
  }
}

extension MainQueueDispatchDecorator: FeedImageDataLoader where T == FeedImageDataLoader {
  func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
    decoratee.loadImageData(from: url) { [weak self] result in
      self?.dispatch {
        completion(result)
      }
    }
  }
}
