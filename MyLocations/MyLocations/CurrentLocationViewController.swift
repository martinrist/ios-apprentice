//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Martin Rist on 12/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController,
                                     CLLocationManagerDelegate {

    // MARK:- Properties
    let locationManager = CLLocationManager()


    // MARK:- Outlets
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    
    // MARK:- Actions
    
    @IBAction func getLocation() {

        let authStatus = CLLocationManager.authorizationStatus()

        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }

        if authStatus == .denied {
            showLocationServicesDeniedAlert()
            return
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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


    // MARK:- CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocation \(newLocation)")
    }


    // MARK:- Miscellaneous Functions


}

