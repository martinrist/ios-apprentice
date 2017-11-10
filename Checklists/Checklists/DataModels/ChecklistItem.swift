//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Martin Rist on 22/10/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import Foundation
import UserNotifications

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

    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()

            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute],
                                                     from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(identifier: "\(itemID)",
                content: content, trigger: trigger)
            let centre = UNUserNotificationCenter.current()
            centre.add(request)
        }
    }

    func removeNotification() {
        let centre = UNUserNotificationCenter.current()
        centre.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }

    deinit {
        removeNotification()
    }
}
