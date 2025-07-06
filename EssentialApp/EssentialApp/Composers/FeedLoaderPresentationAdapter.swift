//
//  FeedLoaderPresentationAdapter.swift
//  EssentialApp
//
//  Created by Donatas Žitkus on 19/06/2025.
//

import Combine
import Foundation
import EssentialFeed2
import EssentialFeed2Presentation
import EssentialFeed2iOS

final class FeedLoaderPresentationAdapter: FeedLoadViewControllerDelegate {
    private let feedLoader: () -> FeedLoader.Publisher
    private var cancellable: Cancellable?
    var presenter: FeedPresenter?
    
    init(feedLoader: @escaping () -> FeedLoader.Publisher) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedLoad() {
        presenter?.didStartLoadingFeed()
        
        cancellable = feedLoader().sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.presenter?.didFinishLoadingFeedWithError(with: error)
                }
            },
            receiveValue: { [weak self] feed in
                self?.presenter?.didFinishLoadingFeed(with: feed)
            })
    }
}
