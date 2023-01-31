//
//  FeedCachePolicy.swift
//  SuperFeed
//
//  Created by yossa on 31/1/2566 BE.
//

import Foundation

internal final class FeedCachePolicy {

  // MARK: Lifecycle

  private init() {}

  // MARK: Internal

  internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
    guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
      return false
    }

    return date < maxCacheAge
  }

  // MARK: Private

  private static let calendar = Calendar(identifier: .gregorian)

  private static var maxCacheAgeInDays: Int {
    7
  }
}
