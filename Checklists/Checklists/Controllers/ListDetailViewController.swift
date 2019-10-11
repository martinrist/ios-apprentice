//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Martin Rist on 19/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import Foundation
import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist)
}


class ListDetailViewController: UITableViewController {

  // MARK: Segue Identifiers

  enum Segue: String {
    case pickIcon
  }


  // MARK: - Properties

  weak var delegate: ListDetailViewControllerDelegate?

  var checklistToEdit: Checklist?
  var iconName = "Folder"


  // MARK: - Outlets

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var iconImage: UIImageView!


  // MARK: - Actions

  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }

  @IBAction func done() {
    if let checklist = checklistToEdit {
      // If we're editing, copy the view data back into the model
      checklist.name = textField.text!
      checklist.iconName = iconName
      delegate?.listDetailViewController(self, didFinishEditing: checklist)
    } else {
      // If not editing, create a new model object
      let checklist = Checklist(name: textField.text!,
                                iconName: iconName)
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }


  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.largeTitleDisplayMode = .never

    // If we're editing, configure the title and copy the model data into the view
    if let checklist = checklistToEdit {

      // Set up view state
      title = "Edit Checklist"
      doneBarButton.isEnabled = true

      // Copy model data into view
      textField.text = checklist.name
      iconName = checklist.iconName
    }

    iconImage.image = UIImage(named: iconName)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }


  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    guard let identString = segue.identifier,
      let identifier = Segue(rawValue: identString) else { return }

    switch identifier {
    case .pickIcon:
      let controller = segue.destination as! IconPickerViewController
      controller.delegate = self
    }
  }
}


// MARK: - UITableViewDelegate

extension ListDetailViewController {

  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    // Returning `nil` for section 0 prevents selecting the row instead of the text field inside it
    return indexPath.section == 1 ? indexPath : nil
  }
}


// MARK: - UITextFieldDelegate

extension ListDetailViewController: UITextFieldDelegate {

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {

    // Work out what the 'new' text would be
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)

    // Disable the 'done' button if the new text is empty
    doneBarButton.isEnabled = !newText.isEmpty

    return true
  }
}


// MARK: - IconPickerViewControllerDelegate

extension ListDetailViewController: IconPickerViewControllerDelegate {
  func iconPicker(_ picker: IconPickerViewController,
                  didPick iconName: String) {
    self.iconName = iconName
    iconImage.image = UIImage(named: iconName)
    navigationController?.popViewController(animated: true)
  }
}
