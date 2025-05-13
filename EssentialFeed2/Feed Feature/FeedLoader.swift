//
//  FeedLoader.swift
//  EssentialFeed2
//
//  Created by Donatas Zitkus on 09/05/2025.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
