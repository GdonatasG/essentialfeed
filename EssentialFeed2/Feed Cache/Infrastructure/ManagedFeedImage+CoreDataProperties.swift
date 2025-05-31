//
//  ManagedFeedImage+CoreDataProperties.swift
//  EssentialFeed2
//
//  Created by Donatas Zitkus on 31/05/2025.
//
//

import Foundation
import CoreData


extension ManagedFeedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedFeedImage> {
        return NSFetchRequest<ManagedFeedImage>(entityName: "ManagedFeedImage")
    }

    @NSManaged public var id: UUID
    @NSManaged public var imageDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var url: URL

}

extension ManagedFeedImage : Identifiable {

}
