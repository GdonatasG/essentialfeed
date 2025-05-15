//
//  HTTPClient.swift
//  EssentialFeed2
//
//  Created by Donatas Zitkus on 12/05/2025.
//

import Foundation

public protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> HTTPSessionTask
}

public protocol HTTPSessionTask {
    func resume()
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
