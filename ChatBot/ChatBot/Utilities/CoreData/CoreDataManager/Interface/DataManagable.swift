//
//  DataManagable.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import CoreData

protocol DataManagable {
    var context: NSManagedObjectContext { get }
    func saveContext() throws
}
