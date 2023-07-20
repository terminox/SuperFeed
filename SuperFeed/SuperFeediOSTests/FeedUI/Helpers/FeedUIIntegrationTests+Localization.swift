//
//  FeedUIIntegrationTests+Localization.swift
//  SuperFeediOSTests
//
//  Created by yossa on 29/6/2566 BE.
//

import Foundation
import XCTest
import SuperFeed

extension FeedUIIntegrationTests {
  func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
    let table = "Feed"
    let bundle = Bundle(for: FeedPresenter.self)
    let value = bundle.localizedString(forKey: key, value: nil, table: table)
    
    if value == key {
      XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
    }
    
    return value
  }
}
