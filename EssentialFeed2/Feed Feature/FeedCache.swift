//
//  FeedCache.swift
//  EssentialFeed2
//
//  Created by Donatas Žitkus on 27/06/2025.
//

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
