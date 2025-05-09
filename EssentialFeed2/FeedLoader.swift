//
//  FeedLoader.swift
//  EssentialFeed2
//
//  Created by Donatas Zitkus on 09/05/2025.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
