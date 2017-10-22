//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by Martin Rist on 22/10/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }

    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }

}
