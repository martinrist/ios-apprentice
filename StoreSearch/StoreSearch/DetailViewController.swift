//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 11/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK:- View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    // MARK:- Actions
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
