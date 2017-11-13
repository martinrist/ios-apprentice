//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Martin Rist on 13/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()


class LocationDetailsViewController: UITableViewController {

    // MARK:- Properties

    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"


    // MARK:- Outlets

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!


    // MARK:- Actions

    @IBAction func done() {
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        hudView.text = "Tagged"

        afterDelay(0.6) {
            hudView.hide()
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName  = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }


    // MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.text = ""
        categoryLabel.text = categoryName

        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)

        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No Address Found"
        }

        dateLabel.text = format(date: Date())

        // Hide the keyboard
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecogniser.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecogniser)
    }

    @objc func hideKeyboard(_ gestureRecogniser: UIGestureRecognizer) {
        let point = gestureRecogniser.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        if indexPath != nil && indexPath!.section == 0
            && indexPath!.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()

    }


    // MARK:- TableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        } else if indexPath.section == 2 && indexPath.row == 2 {
                addressLabel.frame.size = CGSize(width: view.bounds.size.width - 120, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 16
            return addressLabel.frame.size.height + 20
        } else {
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        }
    }


    // MARK:- Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }


    // MARK:- Helper functions

    func string(from placemark: CLPlacemark) -> String {

        var line1 = ""
        if let s = placemark.subThoroughfare {
            line1 += s + " "
        }
        if let s = placemark.thoroughfare {
            line1 += s
        }

        var line2 = ""
        if let s = placemark.locality {
            line2 += s + " "
        }
        if let s = placemark.administrativeArea {
            line2 += s + " "
        }
        if let s = placemark.postalCode {
            line2 += s
        }

        return line1 + "\n" + line2
    }

    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

}

