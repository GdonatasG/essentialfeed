//
//  FeedUIComposer.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 14/06/2025.
//

import Foundation
import UIKit
import EssentialFeed2
import EssentialFeed2iOS

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        
        let loadPresentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let loadController = feedController.loadController!
        loadController.delegate = loadPresentationAdapter
        
        let presenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedController, imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)), loadingView: WeakReferenceVirtualProxy(loadController))
        loadPresentationAdapter.presenter = presenter
        
        return feedController
    }
    
    private static func makeFeedViewController(title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.title = FeedPresenter.title
        return feedController
    }
}
