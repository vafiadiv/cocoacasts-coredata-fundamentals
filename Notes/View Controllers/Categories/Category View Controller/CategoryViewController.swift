//
//  CategoryViewController.swift
//  Notes
//
//  Created by Bart Jacobs on 06/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var nameTextField: UITextField!

    // MARK: -

    var category: Category?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Category"

        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Update Category
        if let name = nameTextField.text, !name.isEmpty {
            category?.name = name
        }
    }

    // MARK: - View Methods

    private func setupView() {
        setupNameTextField()
    }

    // MARK: -

    private func setupNameTextField() {
        // Configure Name Text Field
        nameTextField.text = category?.name
    }

}

