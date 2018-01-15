//
//  AppDelegate.swift
//  StoreSearch
//
//  Created by Martin Rist on 29/12/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    // MARK:- Application lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customiseAppearance()
        detailVC.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem
        return true
    }



    // MARK:- Helper Methods

    func customiseAppearance() {
        let barTintColor = UIColor(red: 20/255, green: 160/255,
                                   blue: 160/255, alpha: 1)
        UISearchBar.appearance().barTintColor = barTintColor

        window!.tintColor = UIColor(red: 10/255, green: 80/255,
                                    blue: 80/255, alpha: 1)
    }


    var splitVC: UISplitViewController {
        return window!.rootViewController as! UISplitViewController
    }

    var searchVC: SearchViewController {
        return splitVC.viewControllers.first as! SearchViewController
    }

    var detailNavController: UINavigationController {
        return splitVC.viewControllers.last as! UINavigationController
    }

    var detailVC: DetailViewController {
        return detailNavController.topViewController as! DetailViewController
    }

}

