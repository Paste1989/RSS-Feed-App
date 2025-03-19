//
//  CoreDataService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 18.03.2025..
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func saveContext()
    func createEntity<T: NSManagedObject>(ofType entityType: T.Type) -> T
    func fetchEntities<T: NSManagedObject>(ofType entityType: T.Type) -> [T]
    func getEntity(for model: RSSChannelModel) async -> RSSChannelEntity?
    func getEntity(for model: RSSFeedItemModel) async -> RSSFeedEntity?
}

class CoreDataService: CoreDataServiceProtocol {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RSS_Feed_App")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func createEntity<T: NSManagedObject>(ofType entityType: T.Type) -> T {
        return T(context: context)
    }
    
    func fetchEntities<T: NSManagedObject>(ofType entityType: T.Type) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func deleteEntity(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
    
    func getEntity(for model: RSSFeedItemModel) async -> RSSFeedEntity? {
        let fetchRequest: NSFetchRequest<RSSFeedEntity> = RSSFeedEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.first
        } catch {
            print("Error fetching RSSFeedEntity: \(error)")
            return nil
        }
    }
    
    func getEntity(for model: RSSChannelModel) async -> RSSChannelEntity? {
        let fetchRequest: NSFetchRequest<RSSChannelEntity> = RSSChannelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.first
        } catch {
            print("Error fetching RSSFeedEntity: \(error)")
            return nil
        }
    }
}



