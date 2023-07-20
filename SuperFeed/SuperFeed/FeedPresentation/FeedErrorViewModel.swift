//
//  FeedErrorViewModel.swift
//  SuperFeed
//
//  Created by yossa on 21/7/2566 BE.
//

public struct FeedErrorViewModel {
  public let message: String?

  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: nil)
  }
  
  static func error(message: String) -> FeedErrorViewModel {
    return FeedErrorViewModel(message: message)
  }
}
