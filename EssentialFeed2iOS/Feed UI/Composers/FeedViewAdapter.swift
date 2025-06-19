//
//  FeedViewAdapter.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 19/06/2025.
//

import Foundation
import EssentialFeed2
import UIKit

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImagePresentationAdapter<WeakReferenceVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let cellController = FeedImageCellController(delegate: adapter)
            adapter.presenter = FeedImagePresenter(view: WeakReferenceVirtualProxy<FeedImageCellController>(cellController), imageTransformer: UIImage.init)
            
            return cellController
        }
    }
}
