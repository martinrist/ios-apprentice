//
//  AppDelegate.swift
//  Checklists
//
//  Created by Martin Rist on 11/09/2019.
//  Copyright © 2019 Martin Rist. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Properties

  var window: UIWindow?
  let dataModel = DataModel()


  // MARK: - Lifecycle

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil)
    -> Bool {

      let navigationController = window!.rootViewController as! UINavigationController
      let controller = navigationController.viewControllers[0] as! AllListsViewController
      controller.dataModel = dataModel
      return true
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    saveData()
  }

  func applicationWillTerminate(_ application: UIApplication) {
    saveData()
  }


  // MARK: - Persistence

  private func saveData() {
    dataModel.saveChecklists()
  }

}


// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
    -> Void) {

    print("Received local notification: \(notification)")
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    print("Received local notification response: \(response)")
    completionHandler()
  }
}
