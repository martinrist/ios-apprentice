//
//  Search.swift
//  StoreSearch
//
//  Created by Martin Rist on 15/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {

    enum Category: Int {
        case all = 0
        case music = 1
        case software = 2
        case ebooks = 3

        var type: String {
            switch self {
            case .all: return ""
            case .music: return "musicTrack"
            case .software: return "software"
            case .ebooks: return "ebook"
            }
        }
    }

    var searchResults: [SearchResult] = []
    var hasSearched = false
    var isLoading = false

    private var dataTask: URLSessionDataTask? = nil

    private func iTunesURL(searchText: String, category: Category) -> URL {
        let kind = category.type

        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(encodedText)&limit=200&entity=\(kind)"
        print(urlString)
        let url = URL(string: urlString)
        return url!
    }

    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: '\(error)'")
            return []
        }
    }

    func performSearch(for text: String, category: Category,
                       completion: @escaping SearchComplete) {

        if !text.isEmpty {

            dataTask?.cancel()

            isLoading = true
            hasSearched = true
            searchResults = []

            let url = iTunesURL(searchText: text, category: category)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url) {
                (data: Data?, response: URLResponse?, error: Error?) in
                var success = false
                if let error = error as NSError?, error.code == -999 {
                    return // Search cancelled
                }

                if let httpResponse = response as? HTTPURLResponse,
                       httpResponse.statusCode == 200, let data = data {
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sort(by: <)

                    print("Success!")
                    self.isLoading = false
                    success = true
                }

                if !success {
                    self.hasSearched = false
                    self.isLoading = false
                }

                DispatchQueue.main.async {
                    completion(success)
                }
            }

            dataTask?.resume()
        }
    }
}
