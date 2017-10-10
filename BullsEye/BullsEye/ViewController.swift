//
//  ViewController.swift
//  BullsEye
//
//  Created by Martin Rist on 10/10/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAlert() {
        let alert = UIAlertController(title: "Hello World!", message: "This is my first app", preferredStyle: .alert)
        let awesomeAction = UIAlertAction(title: "Awesome", style: .default, handler: nil)
        alert.addAction(awesomeAction)
        let notAwesomeAction = UIAlertAction(title: "NotAwesome", style: .destructive, handler: nil)
        alert.addAction(notAwesomeAction)
        
        let thirdAction = UIAlertAction(title: "Number 3", style: .default, handler: nil)
        alert.addAction(thirdAction)
        
        
        present(alert, animated: true, completion: nil)
        
    }

}

