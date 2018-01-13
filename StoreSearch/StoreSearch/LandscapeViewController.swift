//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 11/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

    // MARK:- Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!


    // MARK:- View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove constraints from main view
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true

        // Remove constraints for page control
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true

        // Remove constraints for scroll view
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true

        scrollView.backgroundColor = UIColor(patternImage:
            UIImage(named: "LandscapeBackground")!)
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = view.bounds

        pageControl.frame = CGRect(x: 0,
                                   y: view.frame.size.height - pageControl.frame.size.height,
                                   width: view.frame.size.width,
                                   height: pageControl.frame.size.height)
    }

}
