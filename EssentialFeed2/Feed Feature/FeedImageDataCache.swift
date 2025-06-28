//
//  FeedImageDataCache.swift
//  EssentialFeed2
//
//  Created by Donatas Žitkus on 28/06/2025.
//

import Foundation

public protocol FeedImageDataCache {
    typealias SaveResult = Swift.Result<Void, Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
