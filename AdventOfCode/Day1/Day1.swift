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
        let integers = lines().map({ Int($0)! })
        var allFrequencies: [Int: Bool] = [:]
        var firstRepeatedFrequency: Int? = nil
        func handleIteration(result: inout Int, next: Int) {
            result += next
            if allFrequencies[result] == true, firstRepeatedFrequency == nil {
                firstRepeatedFrequency = result
            }
            allFrequencies[result] = true
        }
        let finalFrequency = integers.reduce(into: 0) { (result, next) in
            handleIteration(result: &result, next: next)
        }
        var result = finalFrequency
        while firstRepeatedFrequency == nil {
            for next in integers {
                handleIteration(result: &result, next: next)
            }
        }
        return ("\(finalFrequency)", "\(firstRepeatedFrequency!)")
    }

}
