//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Martin Rist on 11/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {

  // MARK: - Properties

  var text: String
  var checked = false
  var shouldRemind = false
  var dueDate = Date()
  var itemID = -1


  // MARK: - Lifecycle

  init(text: String = "") {
    self.text = text
    itemID = DataModel.nextChecklistItemID()
  }

  deinit {
    removeNotification()
  }
}


// MARK: - Notifications

extension ChecklistItem {

  func scheduleNotification() {
    removeNotification()
    if shouldRemind && dueDate > Date() {

      let content = UNMutableNotificationContent()
      content.title = "Reminder:"
      content.body = text
      content.sound = UNNotificationSound.default

      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents([.year, .month, .day, .hour, .minute],
                                               from: dueDate)
      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

      let request = UNNotificationRequest(
        identifier: "\(itemID)",
        content: content,
        trigger: trigger)

      let center = UNUserNotificationCenter.current()
      center.add(request)

      print("Scheduled: \(request) for itemID: \(itemID)")
    }
  }

  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
  }

}
