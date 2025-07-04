//
//  FeedPresentationTestHelpers.swift
//  EssentialFeed2PresentationTests
//
//  Created by Donatas Žitkus on 04/07/2025.
//

import Foundation
import EssentialFeed2
import EssentialFeed2Cache

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "a", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    
    return (models, local)
}
