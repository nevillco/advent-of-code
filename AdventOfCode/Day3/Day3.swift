//
//  Day3.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/3/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day3: Day {

    struct Position: Hashable {
        let x: Int
        let y: Int

        init(substring: String) {
            let separated = substring.split(separator: ",")
            x = Int(separated[0])!
            y = Int(separated[1])!
        }

        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }

    struct Size {
        let width: Int
        let height: Int

        init(substring: String) {
            let separated = substring.split(separator: "x")
            width = Int(separated[0])!
            height = Int(separated[1])!
        }
    }

    struct Claim {
        let position: Position
        let size: Size
        init(line: String) {
            let items = line.split(separator: " ")
            let positionString = String(items[2].dropLast())
            let sizeString = String(items[3])
            position = .init(substring: positionString)
            size = .init(substring: sizeString)
        }

        var allPositions: [Position] {
            let topRow = (0..<size.width).map({ Position(x: self.position.x + $0, y: self.position.y) })
            return topRow.flatMap({ position in
                return (0..<self.size.height).map({ Position(x: position.x, y: position.y + $0) })
            })
        }

    }
    lazy var claims: [Claim] = {
        return self.lines().map(Claim.init)
    }()
    enum ClaimState {
        case taken
        case overlapped
    }

    func part1() -> String {
        var claimStates: [Position: ClaimState] = [:]
        for claim in claims {
            for position in claim.allPositions {
                switch claimStates[position] {
                case .some:
                    claimStates[position] = .overlapped
                case nil:
                    claimStates[position] = .taken
                }
            }
        }
        let numOverlaps = claimStates.reduce(into: 0) { (result, tuple) in
            switch tuple.value {
            case .overlapped:
                result += 1
            case .taken:
                break
            }
        }
        return String(describing: numOverlaps)
    }

    func part2() -> String {
        return ""
    }

}
