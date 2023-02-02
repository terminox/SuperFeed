//
//  RemoteFeedItem.swift
//  SuperFeed
//
//  Created by yossa on 17/1/2566 BE.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
  internal let id: UUID
  internal let description: String?
  internal let location: String?
  internal let image: URL
}
