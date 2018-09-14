//
//  ViewController.swift
//  Notes
//
//  Created by Valentin Vafiadi on 15/09/2018.
//  Copyright © 2018 VFD Design. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let coreDataManager = CoreDataManager(modelName: "Notes")

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
    }
}

