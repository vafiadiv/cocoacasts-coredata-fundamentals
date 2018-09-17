//
//  ViewController.swift
//  Notes
//
//  Created by Valentin Vafiadi on 15/09/2018.
//  Copyright © 2018 VFD Design. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    private let coreDataManager = CoreDataManager(modelName: "Notes")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
            print(entityDescription.name ?? "No Name")
            
            let note = NSManagedObject(entity: entityDescription, insertInto: coreDataManager.managedObjectContext)
            note.setValue("My first note", forKey: "title")
            note.setValue(Date(), forKey: "createdAt")
            note.setValue(Date(), forKey: "updatedAt")
            print(note)
            
            do {
                try coreDataManager.managedObjectContext.save()
            } catch {
                print("Error saving managed object context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
}

