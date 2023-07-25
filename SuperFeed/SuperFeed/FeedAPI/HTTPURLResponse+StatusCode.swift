//
//  HTTPURLResponse+StatusCode.swift
//  SuperFeed
//
//  Created by yossa on 25/7/2566 BE.
//

import Foundation

extension HTTPURLResponse {

  var isOK: Bool {
    statusCode == HTTPURLResponse.OK_200
  }

  private static var OK_200: Int { 200 }
}
