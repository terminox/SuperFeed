//
//  FeedViewController.swift
//  Prototype
//
//  Created by yossa on 17/5/2566 BE.
//

import UIKit

final class FeedViewController: UITableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath)
  }
}

struct FeedImageViewModel {
  let description: String?
  let location: String?
  let imageName: String
}
