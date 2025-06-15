//
//  FeedPresenter.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 14/06/2025.
//

import Foundation
import EssentialFeed2

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    
    private var feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    var loadingView: FeedLoadingView?

    public func loadFeed() {
        self.loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader.load { [weak self] result in
            guard let self = self else { return }
            if let feed = try? result.get() {
                self.feedView?.display(FeedViewModel(feed: feed))
            }
            self.loadingView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}
