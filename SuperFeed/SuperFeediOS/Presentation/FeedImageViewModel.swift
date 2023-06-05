//
//  FeedImageViewModel.swift
//  SuperFeediOS
//
//  Created by yossa on 6/6/2566 BE.
//

struct FeedImageViewModel<Image> {
  let description: String?
  let location: String?
  let image: Image?
  let isLoading: Bool
  let shouldRetry: Bool
  
  var hasLocation: Bool {
    return location != nil
  }
}
