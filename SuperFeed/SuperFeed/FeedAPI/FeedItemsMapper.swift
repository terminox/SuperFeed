//
//  FeedItemsMapper.swift
//  SuperFeed
//
//  Created by yossa on 22/11/2565 BE.
//

import Foundation

internal class FeedItemsMapper {
  private struct Root: Decodable {
    let items: [RemoteFeedItem]
  }
  
  internal static var OK_200: Int { 200 }
  
  internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
    guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      throw RemoteFeedLoader.Error.invalidData
    }
    
    return root.items
  }
}
