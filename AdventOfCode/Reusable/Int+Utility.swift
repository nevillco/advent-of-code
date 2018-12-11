//
//  Int+Utility.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/11/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

extension Int {

    var digits: [Int] { return String(self).map { Int(String($0))! } }

}
