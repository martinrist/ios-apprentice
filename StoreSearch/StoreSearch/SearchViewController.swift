//
//  ViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 29/12/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- View lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

