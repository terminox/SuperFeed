//
//  FeedErrorViewModel.swift
//  SuperFeediOS
//
//  Created by yossa on 19/7/2566 BE.
//

struct FeedErrorViewModel {
  let message: String?

  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: nil)
  }

  static func error(message: String) -> FeedErrorViewModel {
    return FeedErrorViewModel(message: message)
  }
}
