//
//  Bounds.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/10/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

struct Bounds {

    let xValues: ClosedRange<Int>
    let yValues: ClosedRange<Int>

    var minX: Int { return xValues.min()! }
    var maxX: Int { return xValues.max()! }
    var minY: Int { return yValues.min()! }
    var maxY: Int { return yValues.max()! }

    var allPositions: [[AnyPosition]] {
        return xValues.map { x in yValues.map { y in AnyPosition(x: x, y: y) }}
    }

    var flattenedPositions: [AnyPosition] {
        return xValues.flatMap { x in yValues.map { y in AnyPosition(x: x, y: y) }}
    }

    func subrange(topLeft: AnyPosition, x: Int, y: Int) -> Bounds? {
        let minX = topLeft.x
        let maxX = topLeft.x + x
        let minY = topLeft.y
        let maxY = topLeft.y + y
        guard xValues.contains(minX), xValues.contains(maxX),
            yValues.contains(minY), yValues.contains(maxY) else {
            return nil
        }
        return .init(xValues: minX...maxX, yValues: minY...maxY)
    }

}
