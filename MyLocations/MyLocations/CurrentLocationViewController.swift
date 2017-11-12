//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Martin Rist on 12/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {

    // MARK:- Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    
    // MARK:- Actions
    
    @IBAction func getLocation() {
        // do nothing yet
    }
    
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

