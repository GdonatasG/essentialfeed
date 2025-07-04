//
//  FeedPresentationTestHelpers.swift
//  EssentialFeed2PresentationTests
//
//  Created by Donatas Žitkus on 04/07/2025.
//

import Foundation
import EssentialFeed2

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "a", url: anyURL())
}

func uniqueImageFeed() -> [FeedImage] {
    return [uniqueImage(), uniqueImage()]
}
