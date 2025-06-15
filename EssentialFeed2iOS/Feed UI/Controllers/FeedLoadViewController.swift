//
//  FeedLoadViewController.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 13/06/2025.
//

import UIKit

final class FeedLoadViewController: NSObject, FeedLoadingView {
    public let mainLoadingIndicator = UIActivityIndicatorView(style: .large)
    private(set) lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let loadFeed: () -> Void
    
    private enum TriggeredLoadType {
        case load
        case refresh
    }
    
    private var triggeredLoadType: TriggeredLoadType? = nil
    
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        let isLoading = viewModel.isLoading

        if let loadType = triggeredLoadType {
            switch loadType {
            case .load: toggleMainLoadingIndicator(isLoading)
            case .refresh: toggleRefreshControl(isLoading)
            }
        }
    }
    
    public func load() {
        triggeredLoadType = .load
        loadFeed()
    }
    
    @objc private func refresh() {
        triggeredLoadType = .refresh
        loadFeed()
    }
    
    private func toggleMainLoadingIndicator(_ isLoading: Bool) {
        if isLoading {
            mainLoadingIndicator.startAnimating()
        } else {
            mainLoadingIndicator.stopAnimating()
        }
    }
    
    private func toggleRefreshControl(_ isLoading: Bool) {
        if isLoading {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
    }
}
