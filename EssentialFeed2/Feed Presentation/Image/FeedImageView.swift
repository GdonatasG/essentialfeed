//
//  FeedImageView.swift
//  EssentialFeed2
//
//  Created by Donatas Žitkus on 21/06/2025.
//

import Foundation

public protocol FeedImageView {
    associatedtype Image: Hashable
    
    func display(_ model: FeedImageViewModel<Image>)
}
