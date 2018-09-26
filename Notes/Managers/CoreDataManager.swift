//
//  CoreDataManager.swift
//  Notes
//
//  Created by Valentin Vafiadi on 15/09/2018.
//  Copyright © 2018 VFD Design. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
        setupNotificationHandling()
    }
    
    private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateManagedObjectContext
        return managedObjectContext
    }()
    
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return privateManagedObjectContext
    }()
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Cannot find data model")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Cannot load data model")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let persistentStoreURL = documentsURL.appendingPathComponent(storeName)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Cannot initialize persistent store coordinator")
        }
        return persistentStoreCoordinator
    }()
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        let notificationNames: [NSNotification.Name] = [.UIApplicationDidEnterBackground, .UIApplicationDidEnterBackground]
        for notificationName in notificationNames {
            notificationCenter.addObserver(self,
                                           selector: #selector(saveChanges),
                                           name: notificationName,
                                           object: nil)
        }
    }
    
    @objc
    private func saveChanges() {
        mainManagedObjectContext.performAndWait {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                print("Unable to save main managed object context: \(error)")
            }
        }
        
        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                print("Unable to save private managed object context: \(error)")
            }
        }
    }
}





