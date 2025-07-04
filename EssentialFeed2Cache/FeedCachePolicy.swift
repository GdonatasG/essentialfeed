//
//  FeedCachePolicy.swift
//  EssentialFeed2Cache
//
//  Created by Donatas Zitkus on 24/05/2025.
//

import Foundation

internal final class FeedCachePolicy {
    private init() {} 
    
    private static let calendar: Calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        
        return date < maxCacheAge
    }
}
