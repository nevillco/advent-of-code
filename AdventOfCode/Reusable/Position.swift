//
//  Position.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/10/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

struct AnyPosition: Position {

    let x: Int
    let y: Int

    func next(direction: Direction) -> AnyPosition {
        switch direction {
        case .up: return .init(x: x, y: y - 1)
        case .down: return .init(x: x, y: y + 1)
        case .left: return .init(x: x - 1, y: y)
        case .right: return .init(x: x + 1, y: y)
        }
    }

}

protocol Position: Hashable, CustomStringConvertible {

    var x: Int { get }
    var y: Int { get }

}

extension Position {

    func manhattanDistance<Other: Position>(from other: Other) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }

    static func +(lhs: Self, rhs: Self) -> AnyPosition {
        return .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    var description: String {
        return "(\(x), \(y))"
    }

}

extension Array where Element: Position {

    var bounds: Bounds {
        let xs = sorted { $0.x < $1.x }
        let ys = sorted { $0.y < $1.y }
        let (minX, maxX) = (xs.first!.x, xs.last!.x)
        let (minY, maxY) = (ys.first!.y, ys.last!.y)
        let xValues = minX...maxX
        let yValues = minY...maxY
        return .init(xValues: xValues, yValues: yValues)
    }

}
