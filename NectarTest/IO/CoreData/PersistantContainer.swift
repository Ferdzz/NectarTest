//
//  PersistantContainer.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
