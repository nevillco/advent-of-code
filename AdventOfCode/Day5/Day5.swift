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
        return String(describing: input.performingReaction().count)
    }

    func part2() -> String {
        let answer: Int = (0..<26)
            .map({ Character(UnicodeScalar($0 + 65)) })
            .map({ input.removingCases(of: $0).performingReaction().count }).min()!
        return String(describing: answer)
    }

}

private extension String {

    func removingCases(of character: Character) -> String {
        return self.filter({ String($0).lowercased() != String(character).lowercased() })
    }

    func performingReaction() -> String {
        var counter = 0
        var output = self
        while counter < output.count - 1 {
            let currentIndex = output.index(output.startIndex, offsetBy: counter)
            let currentChar = output[currentIndex]
            let nextIndex = output.index(output.startIndex, offsetBy: counter + 1)
            let nextChar = output[nextIndex]
            if currentChar.canReact(with: nextChar) {
                let subRange = currentIndex...nextIndex
                output.removeSubrange(subRange)
                counter = max(counter - 1, 0)
            }
            else {
                counter += 1
            }
        }
        return output
    }

}

private extension Character {

    func canReact(with other: Character) -> Bool {
        let string1 = String(other)
        let string2 = String(self)
        return string1 != string2 && string1.uppercased() == string2.uppercased()
    }

}
