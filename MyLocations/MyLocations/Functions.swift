//
//  Functions.swift
//  MyLocations
//
//  Created by Martin Rist on 13/11/2017.
//  Copyright © 2017 Martin Rist. All rights reserved.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
