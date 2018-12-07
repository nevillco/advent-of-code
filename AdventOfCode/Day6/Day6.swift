//
//  Day6.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/6/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day6: Day {

    struct IDPosition: Equatable, Hashable {
        let x: Int
        let y: Int
        let id: Int

        static var nextID = 0

        init(line: String) {
            let parts = line.split(separator: ",")
            let x = Int(parts[0])!
            let y = Int(parts[1].dropFirst())!
            self.init(x: x, y: y)
        }

        init(x: Int, y: Int) {
            self.x = x
            self.y = y
            id = IDPosition.nextID
            IDPosition.nextID += 1
        }

        func distance(from other: Position) -> Int {
            return abs(x - other.x) + abs(y - other.y)
        }

    }

    struct Position {
        let x: Int
        let y: Int

        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }
    lazy var positions: [IDPosition] = { lines().map({ IDPosition(line: $0) }) }()

    typealias Bounds = (x: ClosedRange<Int>, y: ClosedRange<Int>)
    lazy var outerBounds: Day6.Bounds = {
        let xs = positions.sorted { $0.x < $1.x }
        let ys = positions.sorted { $0.y < $1.y }
        let (minX, maxX) = (xs.first!.x, xs.last!.x)
        let (minY, maxY) = (ys.first!.y, ys.last!.y)
        return (minX...maxX, minY...maxY)
    }()
    lazy var checkablePositions: [Position] = {
        return outerBounds.x.flatMap { x in outerBounds.y.map { y in Position(x: x, y: y)  }}
    }()

    func part1() -> String {
        // [Position ID: number of times being closest]
        var closest: [Int: Int] = [:]
        for position in checkablePositions {
            if let winner = self.closest(to: position) {
                closest[winner.id, default: 0] += 1
            }
        }
        let invalidIDs = infiniteAreaPositions().map({ $0.id })
        let winner = closest.sorted { $0.value > $1.value }
            .first { !invalidIDs.contains($0.key) }!.value
        return String(describing: winner)
    }

    func part2() -> String {
        let answer = checkablePositions.map { absoluteDistance(to: $0) }
            .filter { $0 < 10000 }
            .count
        return String(describing: answer)
    }

    func infiniteAreaPositions() -> [IDPosition] {
        let minX = outerBounds.x.min()!
        let maxX = outerBounds.x.max()!
        let minY = outerBounds.y.min()!
        let maxY = outerBounds.y.max()!
        let upperBoundRow = (minX...maxX).map({ Day6.Position(x: $0, y: minY - 1) })
        let lowerBoundRow = (minX...maxX).map({ Day6.Position(x: $0, y: maxY + 1) })
        let leftBoundRow = (minY...maxY).map({ Day6.Position(x: minX - 1, y: $0) })
        let rightBoundRow = (minY...maxY).map({ Day6.Position(x: maxX + 1, y: $0) })
        let boundChecks = [upperBoundRow, lowerBoundRow, leftBoundRow, rightBoundRow].flatMap({ $0 })
        let infiniteAreas = boundChecks.compactMap({ closest(to: $0) })
        return Array(Set(infiniteAreas))
    }

    func closest(to position: Day6.Position) -> Day6.IDPosition? {
        let sorted = positions.sorted { $0.distance(from: position) < $1.distance(from: position) }
        let closest = sorted.first!
        let second = sorted[1]
        let isTie = closest.distance(from: position) == second.distance(from: position)
        return isTie ? nil : closest
    }

    func absoluteDistance(to position: Day6.Position) -> Int {
        return positions.reduce(into: 0, { $0 += $1.distance(from: position) })
    }

}
