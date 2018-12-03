//
//  Day1.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/2/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day1: Day {

    func compute() -> Solutions {
        let integers = getInput()
            .split(separator: "\n")
            .map({ Int($0)! })
        var allFrequencies: [Int: Bool] = [:]
        var firstRepeatedFrequency: Int? = nil
        let finalFrequency = integers.reduce(into: 0) { (result, next) in
            result += next
            if allFrequencies[result] == true, firstRepeatedFrequency == nil {
                firstRepeatedFrequency = result
            }
            allFrequencies[result] = true
        }
        var result = finalFrequency
        while firstRepeatedFrequency == nil {
            for next in integers {
                result += next
                if allFrequencies[result] == true, firstRepeatedFrequency == nil {
                    firstRepeatedFrequency = result
                }
                allFrequencies[result] = true
            }
        }
        return ("\(finalFrequency)", "\(firstRepeatedFrequency!)")
    }

}
