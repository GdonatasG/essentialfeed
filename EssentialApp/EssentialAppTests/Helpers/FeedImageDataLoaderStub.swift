//
//  FeedImageDataLoaderStub.swift
//  EssentialAppTests
//
//  Created by Donatas Žitkus on 28/06/2025.
//

import EssentialFeed2

class FeedImageDataLoaderStub: FeedImageDataLoader {
    private let result: FeedImageDataLoader.Result
    
    init(result: FeedImageDataLoader.Result) {
        self.result = result
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        completion(result)
        return Task()
    }
    
    private class Task: FeedImageDataLoaderTask {
        func cancel() { }
    }
}
