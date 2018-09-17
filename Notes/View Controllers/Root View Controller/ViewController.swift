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
        let note = Note(context: coreDataManager.managedObjectContext)
        note.title = "My second note"
        note.createdAt = Date()
        note.updatedAt = Date()

        print(note.title ?? "No title")
        do {
            try coreDataManager.managedObjectContext.save()
        } catch {
            print("Error saving managed object context")
            print("\(error), \(error.localizedDescription)")
        }
    }
}

