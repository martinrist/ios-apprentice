//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 11/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import Foundation
import UIKit

class LandscapeViewController: UIViewController {

    // MARK:- Properties
    var search: Search!

    private var firstTime = true
    private var downloads = [URLSessionDownloadTask]()

    // MARK:- Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!


    // MARK:- Actions

    @IBAction func pageChanged(_ sender: UIPageControl) {

        UIView.animate(withDuration: 0.3, delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.scrollView.contentOffset = CGPoint(
                            x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage),
                            y: 0)
        },
                       completion: nil)
    }


    // MARK:- Controller lifecycle

    deinit {
        print("deinit \(self)")
        for task in downloads {
            task.cancel()
        }
    }

    
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

        pageControl.numberOfPages = 0
    }


    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if case .results(let list) = search.state {
                let detailViewController = segue.destination as! DetailViewController
                let searchResult = list[(sender as! UIButton).tag - 2000]
                detailViewController.searchResult = searchResult
            }
        }
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

            switch search.state {
            case .notSearchedYet:
                break
            case .loading:
                showSpinner()
            case .noResults:
                showNothingFoundLabel()
            case .results(let list):
                tileButtons(list)
            }
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
            let button = UIButton(type: .custom)
            button.setBackgroundImage(UIImage(named: "LandscapeButton"),
                                      for: .normal)
            downloadImage(for: result, andPlaceOn: button)
            button.frame = CGRect(x: x + paddingHorz,
                                  y: marginY + CGFloat(row)*itemHeight + paddingVert,
                                  width: buttonWidth,
                                  height: buttonHeight)
            button.tag = 2000 + index
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
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

        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
    }

    @objc func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowDetail", sender: sender)
    }

    private func downloadImage(for searchResult: SearchResult,
                               andPlaceOn button: UIButton) {
        if let url = URL(string: searchResult.imageSmall) {
            let task = URLSession.shared.downloadTask(with: url) {
                url, response, error in
                if error == nil, let url = url,
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                            button.setImage(image, for: .normal)

                    }
                }
            }
            task.resume()
            downloads.append(task)
        }
    }



    // MARK:- Spinner

    func searchResultsReceived() {
        hideSpinner()

        switch search.state {
        case .notSearchedYet, .loading:
            break
        case .noResults:
            showNothingFoundLabel()
        case .results(let list):
            tileButtons(list)
        }
    }

    private func showSpinner() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.center = CGPoint(x: scrollView.bounds.midX + 0.5,
                                 y: scrollView.bounds.midY + 0.5)
        spinner.tag = 1000
        view.addSubview(spinner)
        spinner.startAnimating()
    }

    private func hideSpinner() {
        view.viewWithTag(1000)?.removeFromSuperview()
    }

    private func showNothingFoundLabel() {
        let label = UILabel(frame: CGRect.zero)
        label.text = NSLocalizedString("Nothing Found", comment: "Nothing Found label")
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear

        label.sizeToFit()

        var rect = label.frame
        // Make even to avoid fuzzing
        rect.size.width = ceil(rect.size.width / 2) * 2
        rect.size.height = ceil(rect.size.height / 2) * 2
        label.frame = rect

        label.center = CGPoint(x: scrollView.bounds.midX,
                               y: scrollView.bounds.midY)
        view.addSubview(label)

    }

}


// MARK: UIScrollViewDelegate extension

extension LandscapeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let page = Int((scrollView.contentOffset.x + width / 2) / width)
        pageControl.currentPage = page
    }
}

