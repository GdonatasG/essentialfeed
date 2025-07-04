//
//  FeedView.swift
//  EssentialFeed2Presentation
//
//  Created by Donatas Žitkus on 21/06/2025.
//

import Foundation
import EssentialFeed2

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}
