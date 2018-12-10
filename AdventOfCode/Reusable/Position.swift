//
//  Position.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/10/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

struct Position: Equatable, Hashable {

    let x: Int
    let y: Int

    func distance(from other: Position) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }

}
