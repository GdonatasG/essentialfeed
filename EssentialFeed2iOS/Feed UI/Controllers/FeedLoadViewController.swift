//
//  FeedLoadViewController.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 13/06/2025.
//

import EssentialFeed2
import UIKit

final class FeedLoadViewController: NSObject {
    public let mainLoadingIndicator = UIActivityIndicatorView(style: .large)
    private(set) lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    private var feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    public var onFeedLoaded: (([FeedImage]) -> Void)?
    
    @objc private func refresh() {
        refreshControl.beginRefreshing()
        loadFeed { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc public func load() {
        mainLoadingIndicator.startAnimating()
        loadFeed { [weak self] in
            self?.mainLoadingIndicator.stopAnimating()
        }
    }
    
    @objc private func loadFeed(completion: @escaping () -> Void) {
        feedLoader.load { [weak self] result in
            guard let self = self else { return }
            if let feed = try? result.get() {
                self.onFeedLoaded?(feed)
            }
            completion()
        }
    }
}
