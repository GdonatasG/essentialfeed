//
//  FeedImagePresentationAdapter.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 19/06/2025.
//

import Foundation
import EssentialFeed2

final class FeedImagePresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    private var task: FeedImageDataLoaderTask?
    var presenter: FeedImagePresenter<View, Image>?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: FeedImageDataLoader.Result) {
        switch result {
        case let .success(data):
            presenter?.didFinishLoadingImageData(with: data, for: model)
        case let .failure(error):
            presenter?.didFinishLoadingImageData(with: error, for: model)
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
        task = nil
    }
}
