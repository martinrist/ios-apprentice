//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Martin Rist on 24/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController {

    // MARK:- Properties

    var managedObjectContext: NSManagedObjectContext!
    var locations = [Location]()



    // MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest<Location>()

        let entity = Location.entity()
        fetchRequest.entity = entity

        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
    }


    // MARK:- Table View Delegates

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell",
                                                 for: indexPath)
                        as! LocationCell

        let location = locations[indexPath.row]

        cell.configure(for: location)

        return cell
    }
}
