//
//  Day15.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/15/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day15: Day {

    struct Unit {
        let isElf: Bool
        let position: AnyPosition
    }

    struct Grid {
        // Keys are true if the position is open cavern
        let positions: [AnyPosition: Bool]
        let units: [Unit]
    }

    func parse(_ lines: [String]) -> Grid {
        var positions: [AnyPosition: Bool] = [:]
        var units: [Unit] = []
        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                let position = AnyPosition(x: x, y: y)
                switch character {
                case ".", "#":
                    positions[position] = character == "."
                case "E", "G":
                    positions[position] = true
                    let unit = Unit(isElf: character == "E", position: position)
                    units.append(unit)
                default:
                    fatalError()
                }
            }
        }
        return .init(positions: positions, units: units)
    }

    func part1() -> String {
        return String(describing: parse(input().lines))
    }

}
