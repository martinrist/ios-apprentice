//
//  DataModel.swift
//  Checklists
//
//  Created by Martin Rist on 07/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()

    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }

    func registerDefaults() {
        let dictionary: [String:Any] = [ "ChecklistIndex": -1,
                           "FirstTime": true ]
        UserDefaults.standard.register(defaults: dictionary)
    }

    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }

    func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }

    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
        }
    }

    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")

        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }

}
