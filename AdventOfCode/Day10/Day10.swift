//
//  Day10.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/10/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day10: Day {

    struct Vector {
        let position: AnyPosition
        let velocity: AnyPosition

        init(line: String) {
            let indices: ((Character) -> String.Index?) -> ClosedRange<String.Index> = { function in
                return line.index(after: function("<")!)...line.index(before: function(">")!)
            }
            let values: (Substring) -> [Int] = { substring in
                return substring.split(separator: ",")
                    .map { Int($0.trimmingCharacters(in: .whitespaces))! }
            }
            let firstPair = values(line[indices(line.firstIndex)])
            position = .init(x: firstPair[0], y: firstPair[1])
            let secondPair = values(line[indices(line.lastIndex)])
            velocity = .init(x: secondPair[0], y: secondPair[1])
        }

        init(position: AnyPosition, velocity: AnyPosition) {
            self.position = position
            self.velocity = velocity
        }

        var next: Vector {
            return .init(position: position + velocity, velocity: velocity)
        }
    }
    lazy var vectors: [Vector] = { input().lines.map { .init(line: $0) } }()

    func run() {
        let (newVectors, increments) = incrementUntilValid(vectors)
        let part1 = printableStrings(newVectors)
        print("part1:")
        for line in part1 {
            print(line)
        }
        print("part2: \(increments)")
    }

    func printableStrings(_ vectors: [Vector]) -> [String] {
        var positions: [AnyPosition: Bool] = vectors.reduce(into: [:]) { (result, vector) in
            result[vector.position] = true
        }
        let bounds = vectors.map { $0.position }.bounds
        return bounds.yValues.reduce(into: []) { (arrayResult, yValue) in
            let row: String = bounds.xValues.reduce(into: "", { (stringResult, xValue) in
                let testPosition = AnyPosition(x: xValue, y: yValue)
                stringResult.append(positions[testPosition, default: false] ? "X" : "_")
            })
            arrayResult.append(row)
        }
    }

    func incrementUntilValid(_ vectors: [Vector]) -> ([Vector], Int) {
        var increments = 0
        var vectors = vectors
        var bounds = vectors.map { $0.position }.bounds
        while bounds.yValues.count > 10 {
            vectors = vectors.map { $0.next }
            bounds = vectors.map { $0.position }.bounds
            increments += 1
        }
        return (vectors, increments)
    }

}
