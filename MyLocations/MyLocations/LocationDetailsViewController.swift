//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Martin Rist on 13/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()


class LocationDetailsViewController: UITableViewController {

    // MARK:- Properties

    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                placemark = location.placemark
            }
        }
    }

    var descriptionText = ""
    var categoryName = "No Category"
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var date = Date()
    var image: UIImage?
    var observer: Any!
    var managedObjectContext: NSManagedObjectContext!


    // MARK:- Outlets

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!


    // MARK:- Actions

    @IBAction func done() {
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)

        let location: Location
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
            location.photoID = nil
        }

        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark

        // Save image
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = UIImageJPEGRepresentation(image, 0.5) {
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }


        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            fatalCoreDataError(error)
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

        if let location = locationToEdit {
            title = "Edit Location"
            if location.hasPhoto {
                if let theImage = location.photoImage {
                    show(image: theImage)
                }
            }
        }

        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName

        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)

        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No Address Found"
        }

        dateLabel.text = format(date: date)

        // Hide the keyboard
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecogniser.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecogniser)

        listenForBackgroundNotification()
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


    deinit {
        print("*** deinit \(self)")
        NotificationCenter.default.removeObserver(observer)
    }


    // MARK:- TableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 88

        case (1, _):
            return imageView.isHidden ? 44 : 280

        case (2, 2):
            addressLabel.frame.size = CGSize(width: view.bounds.size.width - 120, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 16
            return addressLabel.frame.size.height + 20

        default:
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
        } else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
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

        var line = ""
        line.add(text: placemark.subThoroughfare)
        line.add(text: placemark.thoroughfare, separatedBy: " ")
        line.add(text: placemark.locality, separatedBy: ", ")
        line.add(text: placemark.administrativeArea, separatedBy: ", ")
        line.add(text: placemark.postalCode, separatedBy: " ")
        line.add(text: placemark.country, separatedBy: ", ")
        return line
    }

    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        imageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
        addPhotoLabel.isHidden = true
    }
}


extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }

    func showPhotoMenu() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take Photo",
                                     style: .default,
                                     handler: { _ in
                                        self.takePhotoWithCamera()
                                        })
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose from Library",
                                       style: .default,
                                       handler: { _ in
                                        self.choosePhotoFromLibrary()
                                        })
        alert.addAction(actLibrary)

        present(alert, animated: true, completion: nil)
    }

    func takePhotoWithCamera() {
        let imagePicker = MyImagePickerController()
        imagePicker.view.tintColor = view.tintColor
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func choosePhotoFromLibrary() {
        let imagePicker = MyImagePickerController()
        imagePicker.view.tintColor = view.tintColor
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


    // MARK:- Background notification
    func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] _ in

                                                if let weakSelf = self {
                                                    if weakSelf.presentedViewController != nil {
                                                        weakSelf.dismiss(animated: true, completion: nil)
                                                    }
                                                    weakSelf.descriptionTextView.resignFirstResponder()
                                                }
        }
    }
}
