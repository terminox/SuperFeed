//
//  UIRefreshControl+TestHelpers.swift
//  SuperFeediOSTests
//
//  Created by yossa on 29/6/2566 BE.
//

import UIKit

extension UIRefreshControl {
  func simulatePullToRefresh() {
    allTargets.forEach { target in
      actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
        (target as NSObject).perform(Selector($0))
      }
    }
  }
}
