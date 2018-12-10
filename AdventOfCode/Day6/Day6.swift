//
//  Day6.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/6/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day6: Day {

    struct IDPosition: Position {

        let id: Int
        let x: Int
        let y: Int

        static var nextID = 0

        init(line: String) {
            let parts = line.split(separator: ",")
            let x = Int(parts[0])!
            let y = Int(parts[1].dropFirst())!
            self.init(x: x, y: y)
        }

        init(x: Int, y: Int) {
            id = IDPosition.nextID
            IDPosition.nextID += 1
            self.x = x
            self.y = y
        }

    }

    lazy var positions: [IDPosition] = { lines().map({ IDPosition(line: $0) }) }()
    lazy var bounds: Bounds = { positions.bounds }()

    func part1() -> String {
        let closest: [Int: Int] = bounds.allPositions.reduce(into: [:]) { (dict, next) in
            if let winner = self.closest(to: next) { dict[winner.id, default: 0] += 1 }
        }
        let invalidIDs = infiniteAreaPositions().map({ $0.id })
        let winner = closest.sorted { $0.value > $1.value }
            .first { !invalidIDs.contains($0.key) }!.value
        return String(describing: winner)
    }

    func part2() -> String {
        let answer = bounds.allPositions.map { absoluteDistance(to: $0) }
            .filter { $0 < 10000 }
            .count
        return String(describing: answer)
    }

    func infiniteAreaPositions() -> [IDPosition] {
        let upperBoundRow = bounds.xValues.map({ AnyPosition(x: $0, y: bounds.minY - 1) })
        let lowerBoundRow = bounds.xValues.map({ AnyPosition(x: $0, y: bounds.maxY + 1) })
        let leftBoundRow = bounds.yValues.map({ AnyPosition(x: bounds.minX - 1, y: $0) })
        let rightBoundRow = bounds.yValues.map({ AnyPosition(x: bounds.maxX + 1, y: $0) })
        let boundChecks = [upperBoundRow, lowerBoundRow, leftBoundRow, rightBoundRow].flatMap({ $0 })
        let infiniteAreas = boundChecks.compactMap({ closest(to: $0) })
        return Array(Set(infiniteAreas))
    }

    func closest(to position: AnyPosition) -> IDPosition? {
        let sorted = positions.sorted { $0.manhattanDistance(from: position) < $1.manhattanDistance(from: position) }
        let closest = sorted.first!
        let second = sorted[1]
        let isTie = closest.manhattanDistance(from: position) == second.manhattanDistance(from: position)
        return isTie ? nil : closest
    }

    func absoluteDistance(to position: AnyPosition) -> Int {
        return positions.reduce(into: 0, { $0 += $1.manhattanDistance(from: position) })
    }

}
