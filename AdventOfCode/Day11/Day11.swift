//
//  Day11.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/11/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day11: Day {

    let serialNumber = 5791
    let grid = Bounds(xValues: 1...300, yValues: 1...300)
    lazy var flattenedPositions: [AnyPosition] = { grid.flattenedPositions }()
    lazy var allPowerLevels: [AnyPosition: Int] = {
        return flattenedPositions.reduce(into: [:], { $0[$1] = powerLevel($1) })
    }()

    func part1() -> String {
        let answer = flattenedPositions
            .compactMap { grid.subrange(topLeft: $0, x: 2, y: 2) }
            .map { ($0, powerLevelSum($0)) }
            .max(by: { $0.1 < $1.1 })!.0
        return "(\(answer.minX),\(answer.minY))"
    }

    func part2() -> String {
        var maxPowerPosition: AnyPosition!
        var maxPowerSize: Int!
        var maxPowerLevel = Int.min
        for position in flattenedPositions {
            var previousSizePowerLevel = allPowerLevels[position]!
            for subrangeSize in 0...20 {
                guard let subrange = grid.subrange(topLeft: position, x: subrangeSize, y: subrangeSize) else {
                    continue
                }
                let powerLevel: Int
                if subrangeSize == 0 {
                    powerLevel = allPowerLevels[position]!
                }
                else {
                    powerLevel = outerPositions(subrange)
                        .reduce(previousSizePowerLevel) { $0 + allPowerLevels[$1]! }
                }
                if powerLevel > maxPowerLevel {
                    maxPowerPosition = position
                    maxPowerSize = subrangeSize + 1
                    maxPowerLevel = powerLevel
                }
                previousSizePowerLevel = powerLevel
            }
        }
        return "(\(maxPowerPosition.x),\(maxPowerPosition.y),\(maxPowerSize!))"
    }

    func powerLevelSum(_ bounds: Bounds) -> Int {
        return bounds.flattenedPositions.reduce(0, { $0 + allPowerLevels[$1]! })
    }

    func powerLevel(_ position: AnyPosition) -> Int {
        let rackID = position.x + 10
        let intermediate = (((rackID * position.y) + serialNumber) * rackID).digits
        let hundreds = intermediate[intermediate.count - 3]
        return hundreds - 5
    }

    func outerPositions(_ subrange: Bounds) -> [AnyPosition] {
        let newBottomRow = subrange.xValues.map { AnyPosition(x: $0, y: subrange.maxY) }
        let newRightRow = subrange.yValues.dropLast().map { AnyPosition(x: subrange.maxX, y: $0) }
        return newBottomRow + newRightRow
    }

}
