//
//  WeakReferenceVirtualProxy.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 19/06/2025.
//

import Foundation
import EssentialFeed2
import EssentialFeed2Presentation

final class WeakReferenceVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakReferenceVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakReferenceVirtualProxy: FeedImageView where T: FeedImageView {
    typealias Image = T.Image
    
    func display(_ model: FeedImageViewModel<T.Image>) {
        object?.display(model)
    }
}
