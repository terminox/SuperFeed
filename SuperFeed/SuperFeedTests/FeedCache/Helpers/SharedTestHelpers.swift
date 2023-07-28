//
//  SharedTestHelpers.swift
//  SuperFeedTests
//
//  Created by yossa on 31/1/2566 BE.
//

import Foundation

func anyNSError() -> NSError {
  return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
  return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
  return Data("any data".utf8)
}
