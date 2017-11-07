//
//  Checklist.swift
//  Checklists
//
//  Created by Martin Rist on 07/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class Checklist: NSObject {

    var name = ""
    var items = [ChecklistItem]()

    init(name: String) {
        self.name = name
        super.init()
    }
}
