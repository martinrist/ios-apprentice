//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Martin Rist on 01/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import Foundation

class SearchResult: Codable, CustomStringConvertible {
    var artistName = ""
    var trackName = ""

    var name: String {
        return trackName
    }

    var description: String {
        return "Name: \(name), Artist Name: \(artistName)"
    }
}

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}
