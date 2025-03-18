//
//  CoreDataService.swift
//  RSS Feed App
//
//  Created by Saša Brezovac on 18.03.2025..
//

import Foundation
import CoreData

protocol CoredataServiceProtocol {
    func createEntity<T: NSManagedObject>(ofType type: T.Type, context: NSManagedObjectContext) -> T
    func fetchEntities<T: NSManagedObject>(ofType type: T.Type, context: NSManagedObjectContext) -> [T]
    func deleteEntity<T: NSManagedObject>(entity: T, context: NSManagedObjectContext)
}

class CoreDataService: CoredataServiceProtocol {
       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "RSS_Feed_App")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
    
        var context: NSManagedObjectContext {
            return persistentContainer.viewContext
        }

    func createEntity<T: NSManagedObject>(ofType type: T.Type, context: NSManagedObjectContext) -> T {
        return T(context: context)
    }

    func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    func fetchEntities<T: NSManagedObject>(ofType type: T.Type, context: NSManagedObjectContext) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch entities: \(error)")
            return []
        }
    }

    func deleteEntity<T: NSManagedObject>(entity: T, context: NSManagedObjectContext) {
        context.delete(entity)
        saveContext(context: context)
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
}



