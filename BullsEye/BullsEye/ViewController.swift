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
    @IBOutlet weak var targetLabel: UILabel!

    var currentValue = 0
    var targetValue = 0 {
        didSet {
            targetLabel.text = String(targetValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startNewRound() {
        targetValue = 1 + Int(arc4random_uniform(100))
        currentValue = 50
        slider.value = Float(currentValue)

    }

    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    @IBAction func showAlert() {
        
        let difference = abs(currentValue - targetValue)
        let points = 100 - difference
        
        let message = "You scored \(points) points"
        let alert = UIAlertController(title: "Results", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in self.startNewRound() }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

}

