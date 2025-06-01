//
//  CoreDataFeedStore.swift
//  EssentialFeed2
//
//  Created by Donatas Zitkus on 31/05/2025.
//

import Foundation
import CoreData

public class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) {
        guard let modelURL = bundle.url(forResource: "FeedStore", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to find Core Data model (FeedStore.momd) in bundle \(bundle)")
        }
        container = NSPersistentContainer(name: "FeedStore", managedObjectModel: model)
        let description = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                if let cache = try ManagedCache.find(in: context) {
                    completion(.success(.some(CachedFeed(feed: cache.localFeed, timestamp: cache.timestamp))))
                } else {
                    completion(.success(.none))
                }
            } catch {
                completion(.failure(error))
            }
            
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
}

private extension ManagedCache {
    var localFeed: [LocalFeedImage] {
            let feedImages = feed.array as? [ManagedFeedImage] ?? []
            return feedImages.map { $0.local }
        }
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
            let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
            request.returnsObjectsAsFaults = false
            request.fetchLimit = 1
            
            let results = try context.fetch(request)
            return results.first
        }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
            let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
            request.returnsObjectsAsFaults = false

            let existingCaches = try context.fetch(request)
            for cache in existingCaches {
                context.delete(cache)
            }

            let newCache = ManagedCache(context: context)
            return newCache
        }
}

private extension ManagedFeedImage {
    var local: LocalFeedImage {
           return LocalFeedImage(
               id: id,
               description: imageDescription,
               location: location,
               url: url
           )
       }
    
    static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        let managedImages = feed.map { local in
            let managed = ManagedFeedImage(context: context)
            managed.id = local.id
            managed.imageDescription = local.description
            managed.location = local.location
            managed.url = local.url
            return managed
        }
        return NSOrderedSet(array: managedImages)
    }
}

