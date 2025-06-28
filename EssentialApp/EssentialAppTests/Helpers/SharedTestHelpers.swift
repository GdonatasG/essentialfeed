//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Donatas Žitkus on 26/06/2025.
//

import EssentialFeed2

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any description", location: "any location", url: URL(string: "http://any-url.com")!)]
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
