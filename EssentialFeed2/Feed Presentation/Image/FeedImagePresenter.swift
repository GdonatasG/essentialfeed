//
//  FeedImagePresenter.swift
//  EssentialFeed2
//
//  Created by Donatas Žitkus on 21/06/2025.
//

import Foundation

public class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModelStruct(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    public func didFinishLoadingImageDataSuccessfully(with data: Data, for model: FeedImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageDataUnsuccessfully(with: InvalidImageDataError(), for: model)
        }
        
        view.display(FeedImageViewModelStruct(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: false,
            shouldRetry: false))
    }
    
    public func didFinishLoadingImageDataUnsuccessfully(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModelStruct(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: false,
            shouldRetry: true))
    }
    
    private struct InvalidImageDataError: Error {}
}
