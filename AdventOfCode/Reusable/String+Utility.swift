//
//  String+Utility.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/12/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

extension String {

    var lines: [String] {
        return Array(components(separatedBy: .newlines).dropLast())
    }

}
