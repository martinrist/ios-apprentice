//
//  Checklist.swift
//  Checklists
//
//  Created by Martin Rist on 19/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import Foundation

class Checklist: NSObject, Codable {

  // MARK: - Properties

  var name: String
  var items = [ChecklistItem]()
  var iconName = "No Icon"


  // MARK: - Lifecycle

  init(name: String, iconName: String = "No Icon") {
    self.name = name
    self.iconName = iconName
  }


  // MARK: - Business Logic

  func countUncheckedItems() -> Int {
    items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1)}
  }

  func move(item: ChecklistItem, to index: Int) {
    guard let currentIndex = items.firstIndex(of: item) else {
      // We can't move an item that isn't already in the list
      return
    }

    items.remove(at: currentIndex)
    items.insert(item, at: index)
  }

  func remove(_ itemsToRemove: [ChecklistItem]) {
    for item in itemsToRemove {
      if let index = items.firstIndex(of: item) {
        items.remove(at: index)
      }
    }
  }
}
