//
//  CoreDataManager.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container: NSPersistentContainer
    
    private init() {
        self.container = {
            let container = NSPersistentContainer(name: "DataModel")
            container.loadPersistentStores { _, error in
                if let error = error as? NSError {
                    fatalError("container load Error: \(error.userInfo)")
                }
            }
            return container
        }()
    }
}

extension CoreDataManager: DataManagable {
    var context: NSManagedObjectContext { container.viewContext }
    
    func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
