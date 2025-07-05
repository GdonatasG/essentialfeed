//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Donatas Žitkus on 24/06/2025.
//

import UIKit
import CoreData
import EssentialFeed2
import EssentialFeed2Cache
import EssentialFeed2CacheInfrastructure
import EssentialFeed2API
import EssentialFeed2APIInfrastructure
import EssentialFeed2iOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let localStoreURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")
    private lazy var localStore = CoreDataFeedStore(storeURL: localStoreURL, bundle: Bundle(for: CoreDataFeedStore.self))
    private lazy var localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let remoteURL = URL(string: "https://my.api.mockaroo.com/feed?key=f0d1fca0")!
        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: FeedLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localFeedLoader),
                fallback: localFeedLoader
            ),
            imageLoader: FeedImageDataLoaderWithFallbackComposite(
                primary: FeedImageDataLoaderCacheDecorator(decoratee: remoteImageLoader, cache: localImageLoader),
                fallback: localImageLoader
            )
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
}

