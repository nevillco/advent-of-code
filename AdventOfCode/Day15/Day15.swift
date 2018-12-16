//
//  Day15.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/15/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day15: Day {

    struct Unit: CustomStringConvertible {
        let isElf: Bool
        var position: AnyPosition

        var description: String { return "\(isElf ? "Elf" : "Goblin") at \(position)" }
    }

    struct Grid: CustomStringConvertible {
        // Keys are true if the position is open cavern
        let positions: [AnyPosition: Bool]
        var units: [Unit]

        var description: String {
            return units.map { String(describing: $0) }.joined(separator: "\n")
        }
    }
    lazy var grid: Grid = { parse(input().lines) }()

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

    func iterate(_ grid: inout Grid) {

    }

    func part1() -> String {
        return String(describing: grid)
    }

}
