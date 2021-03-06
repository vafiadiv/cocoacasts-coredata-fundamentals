//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Bart Jacobs on 06/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!

    var managedObjectContext: NSManagedObjectContext?
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Note"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show Keyboard
        titleTextField.becomeFirstResponder()
    }

    // MARK: - Actions

    @IBAction func save(sender: UIBarButtonItem) {
        guard let managedObjectContext = self.managedObjectContext else {
            return
        }
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(with: "Title Missing", and: "Title must not be empty")
            return
        }
        
        let note = Note(context: managedObjectContext)
        note.title = titleTextField.text
        note.contents = contentsTextView.text
        note.createdAt = Date()
        note.updatedAt = Date()
        _ = navigationController?.popViewController(animated: true)
    }

}
