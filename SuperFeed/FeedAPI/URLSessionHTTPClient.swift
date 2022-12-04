//
//  URLSessionHTTPClient.swift
//  SuperFeed
//
//  Created by yossa on 2/12/2565 BE.
//

import Foundation

// MARK: - URLSessionHTTPClient

public class URLSessionHTTPClient: HTTPClient {
  
  // MARK: Lifecycle
  
  public init(session: URLSession = .shared) {
    self.session = session
  }
  
  // MARK: Internal
  
  private struct UnexpectedValuesRepresentation: Error {}
  
  public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
    session.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
      } else if let data = data, let response = response as? HTTPURLResponse {
        completion(.success(data, response))
      } else {
        completion(.failure(UnexpectedValuesRepresentation()))
      }
    }.resume()
  }
  
  // MARK: Private
  
  private let session: URLSession
}
