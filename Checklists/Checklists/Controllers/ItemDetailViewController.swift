//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Martin Rist on 11/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishAdding item: ChecklistItem)
  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {

  // MARK: - Segue Identifiers

  enum Segue: String {
    case addItem
    case editItem
  }


  // MARK: - Properties

  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  var dueDate = Date()
  var datePickerVisible = false


  // MARK: - Outlets

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var dueDateLabel: UILabel!
  @IBOutlet weak var datePickerCell: UITableViewCell!
  @IBOutlet weak var datePicker: UIDatePicker!


  // MARK: - Actions
  
  @IBAction func cancel(_ sender: Any) {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done(_ sender: Any) {

    if let item = itemToEdit {

      // Copy view data back into model
      item.text = textField.text!
      item.shouldRemind = shouldRemindSwitch.isOn
      item.dueDate = dueDate
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishEditing: item)
    } else {

      // Create new model object
      let item = ChecklistItem(text: textField.text!)
      item.shouldRemind = shouldRemindSwitch.isOn
      item.dueDate = dueDate
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
  }

  @IBAction func dateChanged(_ datePicker: UIDatePicker) {
    dueDate = datePicker.date
    updateDueDateLabel()
  }

  @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
    textField.resignFirstResponder()

    if switchControl.isOn {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        // do nothing
      }
    }
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    navigationItem.largeTitleDisplayMode = .never

    if let item = itemToEdit {

      // Set up view state for editing
      title = "Edit item"
      doneBarButton.isEnabled = true

      // Copy initial model data into view
      textField.text = item.text
      shouldRemindSwitch.isOn = item.shouldRemind
      dueDate = item.dueDate

    } else {
      // Set up view state for new item
      title = "Add item"
      shouldRemindSwitch.isOn = false
    }

    updateDueDateLabel()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
}


// MARK: - UITableViewDataSource

extension ItemDetailViewController {

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    if section == 1 && datePickerVisible {
      return 3
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 && indexPath.row == 2 {
      return datePickerCell
    } else {
      return super.tableView(tableView, cellForRowAt: indexPath)
    }
  }

  override func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 2 {
      return 217
    } else {
      return super.tableView(tableView, heightForRowAt: indexPath)
    }
  }
}


// MARK: - UITableViewDelegate

extension ItemDetailViewController {

  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 1 && indexPath.row == 1 {
      return indexPath
    } else {
      return nil
    }
  }

  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    textField.resignFirstResponder()
    if indexPath.section == 1 && indexPath.row == 1 {
      datePickerVisible ? hideDatePicker() : showDatePicker()
    }
  }

  override func tableView(_ tableView: UITableView,
                          indentationLevelForRowAt indexPath: IndexPath) -> Int {
    var newIndexPath = indexPath
    if indexPath.section == 1 && indexPath.row == 2 {
      newIndexPath = IndexPath(row: 0, section: indexPath.section)
    }
    return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)

  }

}

// MARK: - UI Helper Methods
extension ItemDetailViewController {

  func updateDueDateLabel() {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    dueDateLabel.text = formatter.string(from: dueDate)
  }

  func showDatePicker() {
    datePickerVisible = true
    let indexPathDatePicker = IndexPath(row: 2, section: 1)
    tableView.insertRows(at: [indexPathDatePicker], with: .fade)
    datePicker.setDate(dueDate, animated: false)
    dueDateLabel.textColor = dueDateLabel.tintColor
  }

  func hideDatePicker() {
    if datePickerVisible {
      datePickerVisible = false
      let indexPathDatePicker = IndexPath(row: 2, section: 1)
      tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
      dueDateLabel.textColor = .black
    }
  }
}


// MARK: - UITextFieldDelegate

extension ItemDetailViewController: UITextFieldDelegate {

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

  func textFieldDidBeginEditing(_ textField: UITextField) {
    hideDatePicker()
  }

}
