//
//  FeedItemsMapper.swift
//  SuperFeed
//
//  Created by yossa on 22/11/2565 BE.
//

import Foundation

internal class FeedItemsMapper {
  private struct Root: Decodable {
    let items: [Item]
    
    var feed: [FeedItem] {
      items.map(\.item)
    }
  }
  
  private struct Item: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    var item: FeedItem {
      return FeedItem(id: id, description: description, location: location, imageURL: image)
    }
  }
  
  internal static var OK_200: Int { 200 }
  
  internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
    guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      return .failure(RemoteFeedLoader.Error.invalidData)
    }
    
    return .success(root.feed)
  }
}
