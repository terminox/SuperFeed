//
//  FeedImageViewModel.swift
//  SuperFeediOS
//
//  Created by yossa on 6/6/2566 BE.
//

public struct FeedImageViewModel<Image> {
  public let description: String?
  public let location: String?
  public let image: Image?
  public let isLoading: Bool
  public let shouldRetry: Bool
  
  public var hasLocation: Bool {
    return location != nil
  }
}
