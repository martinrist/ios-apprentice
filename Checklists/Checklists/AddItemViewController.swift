//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by Martin Rist on 22/10/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemTableViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemTableViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    weak var delegate: AddItemViewControllerDelegate?

    var itemToEdit: ChecklistItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
        }
    }

    @IBAction func cancel() {
        delegate?.addItemTableViewControllerDidCancel(self)
    }

    @IBAction func done() {
        let newItem = ChecklistItem(text: textField.text!, checked: false)
        delegate?.addItemTableViewController(self, didFinishAdding: newItem)
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }

}
