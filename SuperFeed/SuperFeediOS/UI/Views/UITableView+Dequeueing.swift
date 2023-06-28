//
//  UITableView+Dequeueing.swift
//  SuperFeediOS
//
//  Created by yossa on 29/6/2566 BE.
//

import UIKit

extension UITableView {
  func dequeueReusableCell<T: UITableViewCell>() -> T {
    let identifier = String(describing: T.self)
    return dequeueReusableCell(withIdentifier: identifier) as! T
  }
}
