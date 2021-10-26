//
//  CoreDataManager.swift
//  ToteWallet
//
//  Created by Charbel Youssef on 9/30/20.
//  Copyright © 2020 Charbel Youssef. All rights reserved.
//

// MARK: - Singleton

import CoreData
import UIKit

final class CoreDataManager {
    
    private init() {
    }
    
    // MARK: Shared Instance
    
    static let shared = CoreDataManager()
    
    // MARK: - Core Data stack
    
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "ToteWallet")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
    
    // MARK: Core Data Managing Methods
    static func getAllObjects(entity: String, predicate: NSPredicate?, sortDescriptors:[NSSortDescriptor]? = nil) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        do {
            let result = try CoreDataManager.shared.context.fetch(fetchRequest)
            return result
        } catch let error {
            ALog.d(object: error.localizedDescription)
            return []
        }
    }
    
    static func clearSavedObjects(entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try CoreDataManager.shared.context.execute(deleteRequest)
            CoreDataManager.shared.saveContext()
        } catch let error {
            ALog.d(object: error.localizedDescription)
        }
    }
    
    static func deleteAllData() {
        if let entities = CoreDataManager.shared.context.persistentStoreCoordinator?.managedObjectModel.entities {
            for entity in entities {
                guard let entityName = entity.name else { continue }
                clearSavedObjects(entity: entityName)
            }
        }
    }
    
    // MARK: Core Data Saving support
    
    func saveContext () {
        saveContext(self.context)
    }
    
    func saveContext (_ context: NSManagedObjectContext) {
        context.mergePolicy = NSMergePolicy.overwrite
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
