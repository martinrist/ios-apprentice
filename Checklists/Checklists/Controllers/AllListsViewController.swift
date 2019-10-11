//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Martin Rist on 19/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {


  // MARK: - Segue Identifiers

  enum Segue: String {
    case showChecklist
    case addChecklist
  }


  // MARK: - Properties

  var dataModel: DataModel!


  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.delegate = self

    // Restore the previously-selected checklist
    let index = dataModel.indexOfSelectedChecklist
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegue(withIdentifier: Segue.showChecklist.rawValue,
                   sender: checklist)
    }
  }


  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue,
                        sender: Any?) {
    guard let identString = segue.identifier,
      let identifier = Segue(rawValue: identString) else { return }

    switch identifier {
    case .showChecklist:
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = (sender as! Checklist)
    case .addChecklist:
      let controller = segue.destination as! ListDetailViewController
      controller.delegate = self
    }
  }

}


// MARK: - UITableViewDataSource

extension AllListsViewController {

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return dataModel.lists.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
      let cell = makeCell(for: tableView)
      let checklist = dataModel.lists[indexPath.row]
      cell.textLabel!.text = checklist.name
      cell.accessoryType = .detailDisclosureButton

      let count = checklist.countUncheckedItems()
      if checklist.items.count == 0 {
        cell.detailTextLabel!.text = "(No items)"
      } else {
        cell.detailTextLabel!.text = count == 0 ? "All Done!" : "\(count) Remaining"
      }

      cell.imageView!.image = UIImage(named: checklist.iconName)

      return cell
  }

  private func makeCell(for tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
      return cell
    } else {
      return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    }
  }

  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
    dataModel.lists.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }

}


// MARK: - UITableViewDelegate

extension AllListsViewController {

  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    dataModel.indexOfSelectedChecklist = indexPath.row
    let checklist = dataModel.lists[indexPath.row]
    performSegue(withIdentifier: Segue.showChecklist.rawValue, sender: checklist)
  }

  override func tableView(_ tableView: UITableView,
                          accessoryButtonTappedForRowWith indexPath: IndexPath) {

    // This is an example of how to programatically instantiate a View Controller
    // instead of using Segues
    let controller = storyboard!.instantiateViewController(
      withIdentifier: String(describing: ListDetailViewController.self))
      as! ListDetailViewController

    controller.delegate = self

    let checklist = dataModel.lists[indexPath.row]
    controller.checklistToEdit = checklist

    navigationController?.pushViewController(controller, animated: true)
  }
}


// MARK: - ListDetailViewControllerDelegate

extension AllListsViewController: ListDetailViewControllerDelegate {

  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
    navigationController?.popViewController(animated: true)
  }

  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishAdding checklist: Checklist) {
    dataModel.lists.append(checklist)
    dataModel.sortChecklists()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }

  func listDetailViewController(_ controller: ListDetailViewController,
                                didFinishEditing checklist: Checklist) {
    dataModel.sortChecklists()
    tableView.reloadData()
    navigationController?.popViewController(animated: true)
  }

}


// MARK: - UINavigationControllerDelegate

extension AllListsViewController: UINavigationControllerDelegate {

  func navigationController(_ navigationController: UINavigationController,
                            willShow viewController: UIViewController,
                            animated: Bool) {
    // Was the back button tapped?
    if viewController === self {
      dataModel.indexOfSelectedChecklist = -1
    }
  }
}
