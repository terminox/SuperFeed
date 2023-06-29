//
//  UIButton+TestHelpers.swift
//  SuperFeediOSTests
//
//  Created by yossa on 29/6/2566 BE.
//

import UIKit

extension UIButton {
  func simulateTap() {
    allTargets.forEach { target in
      actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
        (target as NSObject).perform(Selector($0))
      }
    }
  }
}
