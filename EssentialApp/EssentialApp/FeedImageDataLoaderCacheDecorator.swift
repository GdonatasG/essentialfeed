//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Donatas Žitkus on 28/06/2025.
//

import EssentialFeed2

public class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            if let imageData = try? result.get() {
                self?.cache.saveIgnoringResult(imageData, for: url)
            }
            completion(result)
        }
    }
}

private extension FeedImageDataCache {
    func saveIgnoringResult(_ imageData: Data, for url: URL) {
        save(imageData, for: url) { _ in }
    }
}
