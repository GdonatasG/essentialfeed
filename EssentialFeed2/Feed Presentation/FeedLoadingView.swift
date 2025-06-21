//
//  FeedLoadingView.swift
//  EssentialFeed2
//
//  Created by Donatas Žitkus on 21/06/2025.
//

import Foundation

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}
