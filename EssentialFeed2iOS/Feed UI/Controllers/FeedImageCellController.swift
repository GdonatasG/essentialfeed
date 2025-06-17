//
//  FeedImageCellController.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 14/06/2025.
//

import Foundation
import EssentialFeed2
import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedImageCell
        self.cell = cell
        delegate.didRequestImage()
        return cell
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    func display(_ model: FeedImageViewModelStruct<UIImage>) {
        cell?.descriptionLabel.text = model.description
        cell?.locationLabel.text = model.location
        cell?.locationContainer.isHidden = !model.hasLocation
        cell?.feedImageView.image = model.image
        cell?.feedImageContainer.isShimmering = model.isLoading
        cell?.feedImageRetryButton.isHidden = !model.shouldRetry
        cell?.onRetry = delegate.didRequestImage
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
