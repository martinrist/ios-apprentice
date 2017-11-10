//
//  Checklist.swift
//  Checklists
//
//  Created by Martin Rist on 07/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {

    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"

    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }

    func countUncheckedItems() -> Int {
        return items.filter({ !$0.checked }).count
    }

    func sortItems() {
        items.sort(by: { item1, item2 in
            return item1.dueDate.compare(item2.dueDate) == .orderedAscending
        })
    }
}
