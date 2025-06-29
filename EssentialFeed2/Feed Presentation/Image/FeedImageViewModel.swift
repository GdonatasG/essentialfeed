//
//  FeedImageViewModel.swift
//  EssentialFeed2
//
//  Created by Donatas Žitkus on 21/06/2025.
//

import Foundation

public struct FeedImageViewModel<Image: Hashable>: Hashable {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    public var hasLocation: Bool {
        return location != nil
    }
    
    public init(description: String?, location: String?, image: Image?, isLoading: Bool, shouldRetry: Bool) {
        self.description = description
        self.location = location
        self.image = image
        self.isLoading = isLoading
        self.shouldRetry = shouldRetry
    }
}
