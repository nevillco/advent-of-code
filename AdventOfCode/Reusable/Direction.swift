//
//  Direction.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/13/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

enum Direction {
    case up
    case down
    case left
    case right

    func turningLeft() -> Direction {
        switch self {
        case .up: return .left
        case .down: return .right
        case .left: return .down
        case .right: return .up
        }
    }

    func turningRight() -> Direction {
        switch self {
        case .up: return .right
        case .down: return .left
        case .left: return .up
        case .right: return .down
        }
    }

    var isVertical: Bool {
        switch self {
        case .up, .down: return true
        case .left, .right: return false
        }
    }

    var isHorizontal: Bool { return !isVertical }

}
