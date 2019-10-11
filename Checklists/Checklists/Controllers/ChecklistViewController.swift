//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Martin Rist on 11/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

  // MARK: - Properties

  var checklist: Checklist!


  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = checklist.name
    navigationItem.leftBarButtonItem = editButtonItem
    tableView.allowsMultipleSelectionDuringEditing = true
  }

}


// MARK: - Actions

extension ChecklistViewController {

  @IBAction func deleteItems(_ sender: Any) {

    if let selectedRows = tableView.indexPathsForSelectedRows {
      let itemsToRemove = selectedRows.map { checklist.items[$0.row] }
      checklist.remove(itemsToRemove)

      tableView.beginUpdates()
      tableView.deleteRows(at: selectedRows, with: .automatic)
      tableView.endUpdates()
    }

  }

}


// MARK: - Editing Mode

extension ChecklistViewController {

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(tableView.isEditing, animated: true)
  }
}


// MARK: - Navigation

extension ChecklistViewController {

  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    guard let identifier = ItemDetailViewController.Segue(rawValue: identifier) else { return false }
    switch identifier {
    case .addItem:
      return true
    case .editItem:
      return !self.isEditing
    }
  }

  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {

    guard let identString = segue.identifier,
      let identifier = ItemDetailViewController.Segue(rawValue: identString) else { return }

    switch identifier {
    case .addItem:
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self

    case .editItem:
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
      if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = checklist.items[indexPath.row]
      }
    }

  }
}


// MARK: - UITableViewDataSource

extension ChecklistViewController {

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return checklist.items.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

    // Fetch model data
    let item = checklist.items[indexPath.row]

    // Configure view cell with data from model
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)

    return cell
  }

  private func configureText(for cell: UITableViewCell,
                             with item: ChecklistItem) {
    if let cell = cell as? ChecklistTableViewCell {
      cell.checklistItemTextLabel.text = item.text
    }
  }

  private func configureCheckmark(for cell: UITableViewCell,
                                  with item: ChecklistItem) {
    if let cell = cell as? ChecklistTableViewCell {
      cell.checkmarkLabel.text = item.checked ? "√" : ""
    }

  }

  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
    checklist.items.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }

  override func tableView(_ tableView: UITableView,
                          moveRowAt sourceIndexPath: IndexPath,
                          to destinationIndexPath: IndexPath) {
    checklist.move(item: checklist.items[sourceIndexPath.row],
                   to: destinationIndexPath.row)
    tableView.reloadData()
  }

}


// MARK: - UITableViewDelegate

extension ChecklistViewController {

  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {

    guard !isEditing else { return }
    
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = checklist.items[indexPath.row]
      item.checked.toggle()
      checklist.items[indexPath.row] = item
      configureCheckmark(for: cell, with: item)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}


// MARK: - ItemDetailViewControllerDelegate

extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }

  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishAdding item: ChecklistItem) {
    let newRowIndex = checklist.items.count
    checklist.items.append(item)
    let indexPath = IndexPath(item: newRowIndex, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)

    navigationController?.popViewController(animated: true)
  }

  func itemDetailViewController(_ controller: ItemDetailViewController,
                                didFinishEditing item: ChecklistItem) {

    if let index = checklist.items.firstIndex(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }

    navigationController?.popViewController(animated: true)
  }

}
