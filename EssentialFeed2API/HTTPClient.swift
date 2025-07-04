//
//  HTTPClient.swift
//  EssentialFeed2API
//
//  Created by Donatas Zitkus on 12/05/2025.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
