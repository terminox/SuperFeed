//
//  HTTPClient.swift
//  SuperFeed
//
//  Created by yossa on 22/11/2565 BE.
//

import Foundation

public protocol HTTPClient {
  func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
  case success(Data, HTTPURLResponse)
  case failure(Error)
}
