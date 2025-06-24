//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Donatas Žitkus on 24/06/2025.
//

import UIKit
import EssentialFeed2
import EssentialFeed2iOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://my.api.mockaroo.com/feed?key=f0d1fca0")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let feedLoader = RemoteFeedLoader(url: url, client: client)
        let imageLoader = RemoteFeedImageDataLoader(client: client)
        
        let feedViewController = FeedUIComposer.feedComposedWith(feedLoader: feedLoader, imageLoader: imageLoader)
        
        window?.rootViewController = feedViewController
    }


}

