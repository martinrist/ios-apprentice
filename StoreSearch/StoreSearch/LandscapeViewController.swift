//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 11/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

    // MARK:- Properties
    var searchResults = [SearchResult]()

    private var firstTime = true

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
    }


    // MARK:- Layout

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = view.bounds

        pageControl.frame = CGRect(x: 0,
                                   y: view.frame.size.height - pageControl.frame.size.height,
                                   width: view.frame.size.width,
                                   height: pageControl.frame.size.height)

        if firstTime {
            firstTime = false
            tileButtons(searchResults)
        }
    }

    private func tileButtons(_ searchResults: [SearchResult]) {
        var columnsPerPage = 5
        var rowsPerPage = 3
        var itemWidth: CGFloat = 96
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 0
        var marginY: CGFloat = 20

        let viewWidth = scrollView.bounds.size.width

        switch viewWidth {
        case 568:
            columnsPerPage = 6
            itemWidth = 94
            marginX = 2

        case 667:
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29

        case 736:
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92

        default:
            break
        }

        // Button size
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth) / 2
        let paddingVert = (itemHeight - buttonHeight) / 2

        // Add the buttons
        var row = 0
        var column = 0
        var x = marginX
        for (index, result) in searchResults.enumerated() {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor.white
            button.setTitle("\(index)", for: .normal)
            button.frame = CGRect(x: x + paddingHorz,
                                  y: marginY + CGFloat(row)*itemHeight + paddingVert,
                                  width: buttonWidth,
                                  height: buttonHeight)
            scrollView.addSubview(button)

            row += 1
            if row == rowsPerPage {
                row = 0; x += itemWidth; column += 1

                if column == columnsPerPage {
                    column = 0; x += marginX * 2
                }
            }
        }

        // Set scroll view content size
        let buttonsPerPage = columnsPerPage * rowsPerPage

        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        scrollView.contentSize = CGSize(width: CGFloat(numPages) * viewWidth,
                                        height: scrollView.bounds.size.height)

        print("Number of pages: \(numPages)")
    }
}
