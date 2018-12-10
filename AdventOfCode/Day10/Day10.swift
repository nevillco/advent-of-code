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
    lazy var vectors: [Vector] = { lines().map { .init(line: $0) } }()

    func part1() -> String {
        return ""
    }

}
