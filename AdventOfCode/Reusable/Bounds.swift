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

    var allPositions: [AnyPosition] {
        return xValues.flatMap { x in yValues.map { y in AnyPosition(x: x, y: y)  }}
    }

}
