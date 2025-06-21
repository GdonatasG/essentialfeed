//
//  FeedView.swift
//  EssentialFeed2
//
//  Created by Donatas Žitkus on 21/06/2025.
//

import Foundation

public struct FeedViewModel {
    public let feed: [FeedImage]
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}
