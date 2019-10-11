//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Martin Rist on 23/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Delegate Protocol

protocol IconPickerViewControllerDelegate: class {
  func iconPicker(_ picker: IconPickerViewController,
                  didPick iconName: String)
}



class IconPickerViewController: UITableViewController {

  // MARK: - Constants

  let icons = [ "No Icon", "Appointments", "Birthdays",
                "Chores", "Drinks", "Folder", "Groceries",
                "Inbox", "Photos", "Trips"
    ]


  // MARK: - Properties

  weak var delegate: IconPickerViewControllerDelegate?

}


// MARK: - UITableViewDelegate

extension IconPickerViewController {

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return icons.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
    let iconName = icons[indexPath.row]
    cell.textLabel!.text = iconName
    cell.imageView!.image = UIImage(named: iconName)
    return cell
  }

  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      let iconName = icons[indexPath.row]
      delegate.iconPicker(self, didPick: iconName)
    }
  }

}
