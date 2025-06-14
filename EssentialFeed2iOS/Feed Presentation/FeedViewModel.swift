//
//  FeedViewModel.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 14/06/2025.
//

import Foundation
import EssentialFeed2

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    
    private var feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoaded: Observer<[FeedImage]>?
    
    public func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            guard let self = self else { return }
            if let feed = try? result.get() {
                self.onFeedLoaded?(feed)
            }
            onLoadingStateChange?(false)
        }
    }
}
