//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Martin Rist on 01/01/2018.
//  Copyright © 2018 Martin Rist. All rights reserved.
//

import Foundation

class SearchResult: Codable, CustomStringConvertible {

    var kind = ""
    var artistName = ""
    var trackName = ""
    var trackPrice = 0.0
    var currency = ""
    var artworkUrl60 = ""
    var artworkUrl100 = ""
    var trackViewUrl = ""
    var primaryGenreName = ""

    var name: String {
        return trackName
    }

    var description: String {
        return "Kind: \(kind), Name: \(name), Artist Name: \(artistName)"
    }
}

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}
