//
//  ViewController.swift
//  StoreSearch
//
//  Created by Martin Rist on 29/12/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK:- Constants

    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }


    // MARK:- Instance Variables

    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?

    var landscapeVC: LandscapeViewController?
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }


    // MARK:- Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!


    // MARK:- Actions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        performSearch()
    }


    // MARK:- View lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)

        let resultCellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(resultCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        let nothingFoundCellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(nothingFoundCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        let loadingCellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.register(loadingCellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)

        tableView.rowHeight = 80

        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK:- Landscape

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        switch newCollection.verticalSizeClass {
        case .compact:
            showLandscape(with: coordinator)
        case .regular, .unspecified:
            hideLandscape(with: coordinator)
        }
    }


    func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {

        guard landscapeVC == nil else { return }

        landscapeVC = storyboard!.instantiateViewController(withIdentifier: "LandscapeViewController")
                            as? LandscapeViewController
        if let controller = landscapeVC {
            controller.searchResults = searchResults
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            view.addSubview(controller.view)
            addChildViewController(controller)

            coordinator.animate(alongsideTransition: { _ in
                controller.view.alpha = 1
                self.searchBar.resignFirstResponder()
                if self.presentedViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }, completion: { _ in
                controller.didMove(toParentViewController: self)
            })
        }

    }


    func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {

        if let controller = landscapeVC {
            controller.willMove(toParentViewController: nil)

            coordinator.animate(alongsideTransition: { _ in
                controller.view.alpha = 0
            }, completion: { _ in
                controller.view.removeFromSuperview()
                controller.removeFromParentViewController()
                self.landscapeVC = nil
            })
        }
    }

    // MARK:- Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath

            let searchResult = searchResults[indexPath.row]
            detailViewController.searchResult = searchResult
        }
    }



    // MARK:- Private Methods
    func iTunesURL(searchText: String, category: Int) -> URL {
        let kind: String
        switch category {
        case 1: kind = "musicTrack"
        case 2: kind = "software"
        case 3: kind = "ebook"
        default: kind = ""
        }

        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(encodedText)&limit=200&entity=\(kind)"
        print(urlString)
        let url = URL(string: urlString)
        return url!
    }

    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: '\(error)'")
            return []
        }
    }

    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...",
                                      message: "There was an error accessing the iTunes Store." +
                                                " Please try again.",
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


// MARK:- SearchBarDelegate methods

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }

    func performSearch() {

        if !searchBar.text!.isEmpty {

            searchBar.resignFirstResponder()

            dataTask?.cancel()
            isLoading = true
            tableView.reloadData()

            searchResults = []

            let url = iTunesURL(searchText: searchBar.text!,
                                category: segmentedControl.selectedSegmentIndex)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url) {
                (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error as NSError?, error.code == -999 {
                    return // Search cancelled
                } else if let httpResponse = response as? HTTPURLResponse,
                              httpResponse.statusCode == 200 {
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        self.searchResults.sort(by: <)
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.hasSearched = true
                            self.tableView.reloadData()
                        }
                        return
                    }
                } else {
                    print("Failure! \(response!)")
                }

                DispatchQueue.main.async {
                    self.hasSearched = false
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
            }
            dataTask?.resume()
        }
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


// MARK:- TableViewDelegate and DataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell,
                                                     for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
                                                 for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell,
                                                     for: indexPath)
                as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.configure(for: searchResult)
            return cell

        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}
