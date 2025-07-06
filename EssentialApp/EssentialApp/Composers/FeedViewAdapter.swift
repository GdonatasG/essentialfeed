//
//  FeedViewAdapter.swift
//  EssentialApp
//
//  Created by Donatas Žitkus on 19/06/2025.
//

import Foundation
import Combine
import UIKit
import EssentialFeed2
import EssentialFeed2Presentation
import EssentialFeed2iOS

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(controller: FeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = FeedImagePresentationAdapter<WeakReferenceVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let cellController = FeedImageCellController(delegate: adapter)
            adapter.presenter = FeedImagePresenter(view: WeakReferenceVirtualProxy<FeedImageCellController>(cellController), imageTransformer: UIImage.init)
            
            return cellController
        })
    }
}
