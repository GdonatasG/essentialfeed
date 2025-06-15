//
//  FeedPresenter.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 14/06/2025.
//

import Foundation
import EssentialFeed2

protocol FeedView {
    func display(feed: [FeedImage])
}

protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    
    private var feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?

    public func loadFeed() {
        self.loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            guard let self = self else { return }
            if let feed = try? result.get() {
                self.feedView?.display(feed: feed)
            }
            self.loadingView?.display(isLoading: false)
        }
    }
}
