//
//  ViewController.swift
//  BullsEye
//
//  Created by Martin Rist on 10/10/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    var currentValue = 0
    var targetValue = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue = lroundf(slider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    @IBAction func showAlert() {
        let message = "The value of the slider is: \(currentValue)"
        let alert = UIAlertController(title: "Hello World!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)

    }

}

