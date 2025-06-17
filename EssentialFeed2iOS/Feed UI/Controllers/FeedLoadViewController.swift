//
//  FeedLoadViewController.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 13/06/2025.
//

import UIKit

protocol FeedLoadViewControllerDelegate {
    func didRequestFeedLoad()
}

final class FeedLoadViewController: NSObject, FeedLoadingView {
    public let mainLoadingIndicator = UIActivityIndicatorView(style: .large)
    @IBOutlet private var refreshControl: UIRefreshControl?
    
    var delegate: FeedLoadViewControllerDelegate?
    
    private enum TriggeredLoadType {
        case load
        case refresh
    }
    
    private var triggeredLoadType: TriggeredLoadType? = nil
    
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
        delegate?.didRequestFeedLoad()
    }
    
    @IBAction func refresh() {
        triggeredLoadType = .refresh
        delegate?.didRequestFeedLoad()
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
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
}
