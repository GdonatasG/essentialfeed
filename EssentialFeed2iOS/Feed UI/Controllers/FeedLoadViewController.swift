//
//  FeedLoadViewController.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 13/06/2025.
//

import UIKit

final class FeedLoadViewController: NSObject {
    public let mainLoadingIndicator = UIActivityIndicatorView(style: .large)
    private(set) lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    public func loadFeed() {
        load { [weak self] isLoading in
            if isLoading {
                self?.mainLoadingIndicator.startAnimating()
            } else {
                self?.mainLoadingIndicator.stopAnimating()
            }
        }
    }
    
    @objc private func refresh() {
        load { [weak self] isLoading in
            if isLoading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private func load(isLoadingCallback: @escaping (Bool) -> Void) {
        viewModel.onLoadingStateChange = { isLoading in
            isLoadingCallback(isLoading)
        }
        viewModel.loadFeed()
    }
}
