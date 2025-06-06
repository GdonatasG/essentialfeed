//
//  FeedLoader.swift
//  EssentialFeed2
//
//  Created by Donatas Zitkus on 09/05/2025.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
