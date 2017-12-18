//
//  String+AddText.swift
//  MyLocations
//
//  Created by Martin Rist on 18/12/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import Foundation

extension String {

    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
