//
//  FeedViewController.swift
//  Prototype
//
//  Created by yossa on 17/5/2566 BE.
//

import UIKit

final class FeedViewController: UITableViewController {
  
  private var feed = FeedImageViewModel.prototypeFeed
  
  @IBAction func refresh() {
    refreshControl?.beginRefreshing()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      if self.feed.isEmpty {
        self.feed = FeedImageViewModel.prototypeFeed
        self.tableView.reloadData()
      }
      
      self.refreshControl?.endRefreshing()
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    feed.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
    let model = feed[indexPath.row]
    cell.configure(with: model)
    return cell
  }
}

extension FeedImageCell {
  func configure(with model: FeedImageViewModel) {
    locationLabel.text = model.location
    locationContainer.isHidden = model.location == nil
    
    descriptionLabel.text = model.description
    descriptionLabel.isHidden = model.description == nil
    
    let image = UIImage(named: model.imageName)
    fadeIn(image)
  }
}

struct FeedImageViewModel {
  let description: String?
  let location: String?
  let imageName: String
}
