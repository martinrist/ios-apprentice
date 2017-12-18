//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Martin Rist on 18/12/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return nil
    }
}
