//
//  FeedImageCellController.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 14/06/2025.
//

import Foundation
import EssentialFeed2
import UIKit

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedImageCellController: FeedImageView {
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?
    
    public init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImage()
        return cell!
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    public func display(_ model: FeedImageViewModel<UIImage>) {
        cell?.descriptionLabel.text = model.description
        cell?.locationLabel.text = model.location
        cell?.locationContainer.isHidden = !model.hasLocation
        
        cell?.feedImageView.image = model.image
        if model.image == nil {
            cell?.feedImageView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.cell?.feedImageView.alpha = 1
            }
        }
        
        cell?.feedImageContainer.isShimmering = model.isLoading
        cell?.feedImageRetryButton.isHidden = !model.shouldRetry
        cell?.onRetry = delegate.didRequestImage
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
