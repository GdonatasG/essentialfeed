//
//  ManagedFeedImage+CoreDataProperties.swift
//  EssentialFeed2Cache
//
//  Created by Donatas Žitkus on 24/06/2025.
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
    @NSManaged public var data: Data?

}

extension ManagedFeedImage : Identifiable {

}
