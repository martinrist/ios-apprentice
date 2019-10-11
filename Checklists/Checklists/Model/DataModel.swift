//
//  DataModel.swift
//  Checklists
//
//  Created by Martin Rist on 20/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import Foundation

class DataModel {

  // MARK: - Properties

  var lists = [Checklist]()


  // MARK: Computed Properties

  var indexOfSelectedChecklist: Int {
    get {
      return UserDefaults.standard.integer(forKey: "ChecklistIndex")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
      UserDefaults.standard.synchronize()
    }
  }


  // MARK: - Lifecycle

  init() {
    loadChecklists()
    registerDefaults()
  }
}


// MARK: - Persistence

extension DataModel {

  func saveChecklists() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(lists)
      try data.write(to: dataFilePath(),
                     options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding item array: \(error)")
    }
  }

  func loadChecklists() {
    if let data = try? Data(contentsOf: dataFilePath()) {
      let decoder = PropertyListDecoder()
      do {
        lists = try decoder.decode([Checklist].self,
                                   from: data)
        sortChecklists()
      } catch {
        print("Error decoding item array: \(error)")
      }
    }
  }

  private func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)
    return paths[0]
  }

  private func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Checklists.plist")
  }
}


// MARK: - User Defaults

extension DataModel {

  private func registerDefaults() {
    let dictionary = [ "ChecklistIndex": -1]
    UserDefaults.standard.register(defaults: dictionary)
  }
}


// MARK: - Business Logic

extension DataModel {

  func sortChecklists() {
    lists.sort(by: { checklist1, checklist2 in
      checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
    })
  }

  class func nextChecklistItemID() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "ChecklistItemID")
    userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
    userDefaults.synchronize()
    return itemID
  }
}
