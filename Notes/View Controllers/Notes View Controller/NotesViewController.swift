//
//  ViewController.swift
//  Notes
//
//  Created by Bart Jacobs on 05/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {

    // MARK: - Segues

    private enum Segue {

        static let AddNote = "AddNote"
        static let Note = "Note"

    }

    // MARK: - Properties

    @IBOutlet var notesView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: coreDataManager.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    private var notes: [Note]? {
        didSet {
            updateView()
        }
    }
    
    private var hasNotes: Bool {
        guard let fetchedNotes = fetchedResultsController.fetchedObjects else { return false }
        return fetchedNotes.count > 0
    }

    // MARK: -

    private var coreDataManager = CoreDataManager(modelName: "Notes")

    // MARK: -

    private let estimatedRowHeight = CGFloat(44.0)

    // MARK: -

    private lazy var updatedAtDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notes"

        setupView()
        fetchNotes()
        updateView()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case Segue.AddNote:
            guard let destination = segue.destination as? AddNoteViewController else {
                return
            }
            // Configure Destination
            destination.managedObjectContext = coreDataManager.managedObjectContext
        case Segue.Note:
            guard let destination = segue.destination as? NoteViewController else {
                return
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let note = fetchedResultsController.object(at: indexPath)
            destination.note = note
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }

    // MARK: - View Methods

    private func setupView() {
        setupMessageLabel()
        setupTableView()
    }

    private func updateView() {
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }

    // MARK: -

    private func setupMessageLabel() {
        messageLabel.text = "You don't have any notes yet."
    }

    // MARK: -

    private func setupTableView() {
        tableView.isHidden = true
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func fetchNotes() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch: \(error)")
        }
    }
}

extension NotesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        
        let note = fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unexpected Index Path")
        }

        cell.titleLabel.text = note.title
        cell.contentsLabel.text = note.contents
        cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let note = fetchedResultsController.object(at: indexPath)
        
        coreDataManager.managedObjectContext.delete(note)
    }

}

extension NotesViewController: NSFetchedResultsControllerDelegate {
    
}
