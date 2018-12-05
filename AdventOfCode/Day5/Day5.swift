//
//  Day5.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/4/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day5: Day {

    lazy var input: String = { return self.input().trimmingCharacters(in: .newlines) }()

    func part1() -> String {
        var counter = 0
        var output = input
        while counter < output.count - 1 {
            let currentIndex = output.index(input.startIndex, offsetBy: counter)
            let currentChar = output[currentIndex]
            let nextIndex = output.index(input.startIndex, offsetBy: counter + 1)
            let nextChar = output[nextIndex]
            if canReact(currentChar, nextChar) {
                let subRange = currentIndex...nextIndex
                output.removeSubrange(subRange)
                counter = max(counter - 1, 0)
            }
            else {
                counter += 1
            }
        }
        return String(describing: output.count)
    }

    func canReact(_ char1: Character, _ char2: Character) -> Bool {
        let string1 = String(char1)
        let string2 = String(char2)
        return string1 != string2 && string1.uppercased() == string2.uppercased()
    }

}
