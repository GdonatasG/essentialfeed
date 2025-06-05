//
//  FeedImageViewModel+PrototypeData.swift
//  Prototype
//
//  Created by Donatas Zitkus on 05/06/2025.
//

import Foundation

extension FeedImageViewModel {
    static var prototypeFeed: [FeedImageViewModel] {
        return [
            FeedImageViewModel(description: "A", location: "New York", imageName: "image-1"),
            FeedImageViewModel(description: nil, location: "London", imageName: "image-2"),
            FeedImageViewModel(description: "Lorem ipsum dolor sit amet.", location: nil, imageName: "image-1"),
            FeedImageViewModel(description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem.", location: "Berlin", imageName: "image-4"),
            FeedImageViewModel(description: "Nemo enim ipsam voluptatem.", location: "Tokyo", imageName: "image-3"),
            FeedImageViewModel(description: nil, location: nil, imageName: "image-2"),
            FeedImageViewModel(description: "Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae.", location: "San Francisco", imageName: "image-4"),
            FeedImageViewModel(description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", location: nil, imageName: "image-2"),
            FeedImageViewModel(description: "Ut enim ad minima veniam.", location: "Sydney", imageName: "image-1"),
            FeedImageViewModel(description: "Et harum quidem rerum facilis est et expedita distinctio.", location: nil, imageName: "image-3")
        ]
    }
}
