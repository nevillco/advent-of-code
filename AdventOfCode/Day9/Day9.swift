//
//  Day9.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/9/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day9: Day {

    class Marble {

        let value: Int
        var clockwise: Marble!
        var counterClockwise: Marble!

        init(_ value: Int) {
            self.value = value
            clockwise = self
            counterClockwise = self
        }

        func clockwise(_ times: Int = 1) -> Marble {
            var value = self
            for _ in 0..<times { value = value.clockwise }
            return value
        }

        func counterClockwise(_ times: Int = 1) -> Marble {
            var value = self
            for _ in 0..<times { value = value.counterClockwise }
            return value
        }

        func insert(after value: Int) -> Marble {
            let after = clockwise!

            let new = Marble(value)
            clockwise = new
            new.counterClockwise = self

            after.counterClockwise = new
            new.clockwise = after

            return new
        }

        func insert(before value: Int) -> Marble {
            return counterClockwise!.insert(after: value)
        }

        typealias RemovalResult = (before: Marble, after: Marble)
        func remove() -> Marble {
            let before = counterClockwise!
            let after = clockwise!

            before.clockwise = after
            after.counterClockwise = before

            self.clockwise = nil
            self.counterClockwise = nil

            return after
        }

    }

    func maxPlayerScore(playerCount: Int, lastMarble: Int) -> Int {
        var scores: [Int: Int] = [:]
        var currentPlayer = 0
        var currentMarble = Marble(0)
        for marbleScore in 1...lastMarble {
            if marbleScore % 23 == 0 {
                currentMarble = currentMarble.counterClockwise(7)
                scores[currentPlayer, default: 0] += (marbleScore + currentMarble.value)
                currentMarble = currentMarble.remove()
            }
            else {
                currentMarble = currentMarble.clockwise().insert(after: marbleScore)
            }
            currentPlayer = (currentPlayer + 1) % playerCount
        }
        return scores.values.max()!

    }

    func part1() -> String {
        let value = maxPlayerScore(playerCount: 429, lastMarble: 70901)
        return String(describing: value)
    }

    func part2() -> String {
        let value = maxPlayerScore(playerCount: 429, lastMarble: 7090100)
        return String(describing: value)
    }

}
