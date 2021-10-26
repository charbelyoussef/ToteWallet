//
//  OBSCoreData.swift
//  EyeQLab
//
//  Created by Nadim Henoud on 5/20/19.
//  Copyright © 2019 OBSoft. All rights reserved.
//

import Foundation
import CoreData

class OBSCoreDataManager {
    private let modelName:String
    static private var instances:[String:OBSCoreDataManager]=[:]
    
    static func instance(name: String) -> OBSCoreDataManager {
        guard let _instance = instances[name] else {
            instances[name] = OBSCoreDataManager(modelName: name)
            return instances[name]!
        }
        return _instance
    }
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
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
