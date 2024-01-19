//
//  CoreDataRepository.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import CoreData

extension Repository {
    final class CoreDataRepository {
        private let persistentContainer: NSPersistentContainer
        var context: NSManagedObjectContext { persistentContainer.viewContext }
        
        init(containerName: String) {
            self.persistentContainer = {
                let container = NSPersistentContainer(name: containerName)
                container.loadPersistentStores { storeDiscription, error in
                    if let error = error as? NSError {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                }
                return container
            }()
        }
        
        func saveContext() throws {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                try context.save()
            }
        }
    }
}
