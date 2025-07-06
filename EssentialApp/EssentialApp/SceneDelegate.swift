//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Donatas Žitkus on 24/06/2025.
//

import UIKit
import CoreData
import Combine
import EssentialFeed2
import EssentialFeed2Cache
import EssentialFeed2CacheInfrastructure
import EssentialFeed2API
import EssentialFeed2APIInfrastructure

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")
    private lazy var localStore = CoreDataFeedStore(storeURL: localStoreURL, bundle: Bundle(for: CoreDataFeedStore.self))
    private lazy var localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
    private lazy var remoteClient = makeRemoteClient()
    private lazy var remoteURL = URL(string: "https://my.api.mockaroo.com/feed?key=f0d1fca0")!
    private lazy var remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
        )
        window?.rootViewController = UINavigationController(rootViewController: feedViewController)
        window?.makeKeyAndVisible()
    }
    
    func makeRemoteClient() -> HTTPClient {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache()
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher {
        return remoteFeedLoader
            .loadPublisher()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: {
                remoteImageLoader
                    .loadImageDataPublisher(from: url)
                    .caching(to: localImageLoader, using: url)
            })
    }
}

