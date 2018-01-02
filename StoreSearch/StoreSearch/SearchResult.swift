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
    var imageSmall = ""
    var imageLarge = ""
    var storeURL = ""
    var genre = ""

    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case storeURL = "trackViewUrl"
        case genre = "primaryGenreName"
        case kind, artistName, trackName
        case trackPrice, currency
    }
    
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
