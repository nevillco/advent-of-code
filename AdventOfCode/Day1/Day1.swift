//
//  Day1.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/2/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day1: Day {

    lazy var integers: [Int] = {
        return lines().map({ Int($0)! })
    }()

    func part1() -> String {
        let finalFrequency = integers.reduce(into: 0) { (result, next) in
            result += next
        }
        return String(describing: finalFrequency)
    }

    func part2() -> String {
        var allFrequencies: [Int: Bool] = [:]
        var result = 0
        while true {
            for next in integers {
                if allFrequencies[result] == true {
                    return "\(result)"
                }
                allFrequencies[result] = true
                result += next
            }
        }
    }

}
