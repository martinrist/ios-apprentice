//
//  MapViewController.swift
//  MyLocations
//
//  Created by Martin Rist on 04/12/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    // MARK:- Properties

    var managedObjectContext: NSManagedObjectContext!


    // MARK:- Outlets

    @IBOutlet weak var mapView: MKMapView!


    // MARK:- Actions

    @IBAction func showUser() {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }

    @IBAction func showLocations() {

    }
}

extension MapViewController: MKMapViewDelegate {
    
}
