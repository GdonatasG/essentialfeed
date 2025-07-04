//
//  RemoteFeedItem.swift
//  EssentialFeed2API
//
//  Created by Donatas Zitkus on 23/05/2025.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
