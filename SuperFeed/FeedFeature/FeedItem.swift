//
//  FeedItem.swift
//  SuperFeed
//
//  Created by yossa on 4/10/2565 BE.
//

import Foundation

public struct FeedItem: Equatable {
  public init(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) {
    self.id = id
    self.description = description
    self.location = location
    self.imageURL = imageURL
  }
  
  public let id: UUID
  public let description: String?
  public let location: String?
  public let imageURL: URL
}
