//
//  SharedTestHelpers.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Zitkus on 24/05/2025.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}
