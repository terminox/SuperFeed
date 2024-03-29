//
//  SceneDelegate.swift
//  SuperApp
//
//  Created by yossa on 30/7/2566 BE.
//

import UIKit
import SuperFeed
import SuperFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
    
    let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
    let session = URLSession(configuration: .ephemeral)
    let client = URLSessionHTTPClient(session: session)
    let feedLoader = RemoteFeedLoader(url: url, client: client)
    let imageLoader = RemoteFeedImageDataLoader(client: client)
    
    let feedViewController = FeedUIComposer.feedComposedWith(feedLoader: feedLoader, imageLoader: imageLoader)
    
    window?.rootViewController = feedViewController
  }
}

