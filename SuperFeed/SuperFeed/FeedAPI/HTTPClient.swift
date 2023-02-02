//
//  HTTPClient.swift
//  SuperFeed
//
//  Created by yossa on 22/11/2565 BE.
//

import Foundation

public protocol HTTPClient {
  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
  case success(Data, HTTPURLResponse)
  case failure(Error)
}
