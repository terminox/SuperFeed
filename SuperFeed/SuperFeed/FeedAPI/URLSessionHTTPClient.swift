//
//  URLSessionHTTPClient.swift
//  SuperFeed
//
//  Created by yossa on 2/12/2565 BE.
//

import Foundation

// MARK: - URLSessionHTTPClient

public final class URLSessionHTTPClient: HTTPClient {
  
  // MARK: Lifecycle
  
  public init(session: URLSession) {
    self.session = session
  }
  
  // MARK: Internal
  
  private struct UnexpectedValuesRepresentation: Error {}
  
  private struct URLSessionTaskWrapper: HTTPClientTask {
    let wrapped: URLSessionTask
    
    func cancel() {
      wrapped.cancel()
    }
  }
  
  public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
    let task = session.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
      } else if let data = data, let response = response as? HTTPURLResponse {
        completion(.success((data, response)))
      } else {
        completion(.failure(UnexpectedValuesRepresentation()))
      }
    }
    
    task.resume()
    return URLSessionTaskWrapper(wrapped: task)
  }
  
  // MARK: Private
  
  private let session: URLSession
}
