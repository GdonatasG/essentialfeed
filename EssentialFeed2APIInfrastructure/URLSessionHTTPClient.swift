//
//  URLSessionHTTPClient.swift
//  EssentialFeed2APIInfrastructure
//
//  Created by Donatas Zitkus on 16/05/2025.
//

import Foundation
import EssentialFeed2API

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentationError: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionDataTask

        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentationError()
                }
            })
        }
        task.resume()
        
        return URLSessionTaskWrapper(wrapped: task)
    }
}
