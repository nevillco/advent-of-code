//
//  Day14.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/14/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day14: Day {

    let input = 320851
    typealias RecipeChain = (scores: [Int], elves: [Int])
    let initial: RecipeChain = ([3, 7], [0, 1])

    func iterate(chain: inout RecipeChain) {
        let newScores = chain.elves
            .map { chain.scores[$0] }
            .reduce(0, +).digits
        chain.scores.append(contentsOf: newScores)
        chain.elves = chain.elves.map { ($0 + 1 + chain.scores[$0]) % chain.scores.count }
    }

    func part1() -> String {
        let count = input + 10
        var current = initial
        while current.scores.count < count {
            iterate(chain: &current)
        }
        let result = current.scores[input..<count].stringValue
        return result
    }

    func part2() -> String {
        let scanValue = ArraySlice(input.digits)
        var current = initial
        var lastScanPosition = 0
        while true {
            iterate(chain: &current)
            while (lastScanPosition + scanValue.count) <= current.scores.count {
                let endIndex = lastScanPosition + scanValue.count
                let slice = current.scores[lastScanPosition..<endIndex]
                if slice == scanValue {
                    return String(lastScanPosition)
                }
                lastScanPosition += 1
            }
        }
    }

}

extension Collection where Element == Int {

    var stringValue: String {
        return map { String($0) }.joined()
    }

}
