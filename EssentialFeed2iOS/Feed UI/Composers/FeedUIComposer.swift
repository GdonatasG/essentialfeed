//
//  FeedUIComposer.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 14/06/2025.
//

import Foundation
import UIKit
import EssentialFeed2

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let loadController = FeedLoadViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(loadController: loadController)
        loadController.onFeedLoaded = { [weak feedController] feed in
            feedController?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: imageLoader)
            }
        }
        return feedController
    }
}
