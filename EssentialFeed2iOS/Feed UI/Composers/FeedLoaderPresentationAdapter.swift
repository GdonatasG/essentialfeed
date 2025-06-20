//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 19/06/2025.
//

import Foundation
import EssentialFeed2

final class FeedLoaderPresentationAdapter: FeedLoadViewControllerDelegate {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedLoad() {
        presenter?.didStartLoadingFeed()
        
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeedWithError(with: error)
            }
        }
    }
}
