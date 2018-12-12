//
//  Day2.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/3/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day2: Day {

    lazy var lines: [String] = {
        return input().lines
    }()

    func part1() -> String {
        var doubleOccurrenceLines = 0
        var tripleOccurrenceLines = 0
        for line in lines {
            let characterOccurrences: [Character: Int] = line.reduce(into: [:]) { (result, next) in
                result[next, default: 0] += 1
            }
            if characterOccurrences.contains(value: 2) {
                doubleOccurrenceLines += 1
            }
            if characterOccurrences.contains(value: 3) {
                tripleOccurrenceLines += 1
            }
        }
        let checksum = doubleOccurrenceLines * tripleOccurrenceLines
        return String(describing: checksum)
    }

    func part2() -> String {
        for line in lines {
            let isMatch: (String) -> Bool = { otherLine in
                return self.isMatch(line, otherLine)
            }
            if let firstMatch = lines.first(where: isMatch) {
                return charactersInCommon(line, firstMatch)
            }
        }
        fatalError("Unreachable")
    }

    func isMatch(_ line1: String, _ line2: String) -> Bool {
        return zip(line1, line2).filter({ $0.0 != $0.1 }).count == 1
    }

    func charactersInCommon(_ line1: String, _ line2: String) -> String {
        return String(zip(line1, line2).filter({ $0.0 == $0.1 }).map({ $0.0 }))
    }

}

private extension Dictionary where Value: Equatable {

    func contains(value: Value) -> Bool {
        return self.contains(where: { tuple in
            return tuple.value == value
        })
    }

}
