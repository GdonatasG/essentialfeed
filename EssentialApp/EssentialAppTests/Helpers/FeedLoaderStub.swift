//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Donatas Žitkus on 26/06/2025.
//

import EssentialFeed2

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
