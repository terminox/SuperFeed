//
//  FeedImageDataLoaderTask.swift
//  SuperFeed
//
//  Created by yossa on 21/7/2566 BE.
//

import Foundation

public protocol FeedImageDataLoaderTask {
  func cancel()
}

public protocol FeedImageDataLoader {
  typealias Result = Swift.Result<Data, Error>
  func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
