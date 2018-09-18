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
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
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
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
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
        guard managedObjectContext.hasChanges else {
            return
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("Unable to save")
            print("\(error)")
        }
    }
}
