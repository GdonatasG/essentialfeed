//
//  FeedImagePresenter.swift
//  EssentialFeed2
//
//  Created by Donatas Žitkus on 21/06/2025.
//

import Foundation

public struct FeedImageViewModelStruct<Image: Hashable>: Hashable {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

public protocol FeedImageView {
    associatedtype Image: Hashable
    
    func display(_ model: FeedImageViewModelStruct<Image>)
}

public class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
}
