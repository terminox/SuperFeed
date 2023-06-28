//
//  UIImageView+Animations.swift
//  SuperFeediOS
//
//  Created by yossa on 29/6/2566 BE.
//

import UIKit

extension UIImageView {
  func setImageAnimated(_ newImage: UIImage?) {
    image = newImage
    
    guard newImage != nil else { return }
    
    alpha = 0
    UIView.animate(withDuration: 0.25) {
      self.alpha = 1
    }
  }
}
