//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Martin Rist on 22/10/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false

    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }

    func toggleChecked() {
        checked = !checked
    }
}
