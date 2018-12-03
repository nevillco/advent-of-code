//
//  Day3.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/3/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day3: Day {

    struct Position {
        let x: Int
        let y: Int

        init(substring: String) {
            let separated = substring.split(separator: ",")
            x = Int(separated[0])!
            y = Int(separated[1])!
        }
    }

    struct Size {
        let width: Int
        let height: Int

        init(substring: String) {
            let separated = substring.split(separator: "x")
            width = Int(separated[0])!
            height = Int(separated[0])!
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
    }

    func part1() -> String {
        print(lines().map({ Claim(line: $0) }))
        return ""
    }

    func part2() -> String {
        return ""
    }

}
