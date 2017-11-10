//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Martin Rist on 22/10/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int

    init(text: String, checked: Bool = false) {
        self.text = text
        self.checked = checked
        self.itemID = DataModel.nextChecklistItemID()
        super.init()
    }

    func toggleChecked() {
        checked = !checked
    }
}
