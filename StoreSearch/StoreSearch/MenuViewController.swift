//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 15/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewControllerSendEmail(_ controller: MenuViewController)
}

class MenuViewController: UITableViewController {

    weak var delegate: MenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            delegate?.menuViewControllerSendEmail(self)
        }
    }

}
