//
//  Day12.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/12/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day12: Day {

    struct PotArrangement {
        let values: [Bool]
        let rules: [Rule]
        let offset: Int

        init(values: [Bool], rules: [Rule], offset: Int) {
            self.values = values
            self.rules = rules
            self.offset = offset
        }

        init(lines: [String]) {
            let values = lines[0].split(separator: " ").last!.map { $0.potValue }
            let rules = lines[1...].map { Rule(line: $0) }
            self.init(values: values, rules: rules, offset: 0)
        }

        subscript(value index: Int) -> Bool {
            guard values.indices.contains(index) else {
                return false
            }
            return values[index]
        }

        var plantValue: Int {
            return values.enumerated().reduce(0) { (result, tuple) in
                let (index, value) = tuple
                return value ? (result + index - offset) : result
            }
        }

        func addingPadding() -> PotArrangement {
            let values = [false, false] + self.values + [false, false]
            return .init(values: values, rules: rules, offset: offset + 2)
        }

        func ruleResult(at index: Int) -> Bool {
            let values = ((index - 2)...(index + 2)).map { self[value: $0] }
            return rules.first { $0.inputs == values }!.output
        }

        func applyingRules() -> PotArrangement {
            let padded = addingPadding()
            let newValues = padded.values.indices.map { padded.ruleResult(at: $0) }
            return .init(values: newValues, rules: padded.rules, offset: padded.offset)
        }
    }

    struct Rule {
        let inputs: [Bool]
        let output: Bool

        init(line: String) {
            let separated = line.split(separator: " ")
            inputs = separated[0].map { $0.potValue }
            output = separated.last!.first!.potValue
        }
    }

    lazy var arrangement: PotArrangement = { .init(lines: lines()) }()

    func iterate(_ arrangement: PotArrangement, times: Int) -> PotArrangement {
        guard times > 0 else {
            return arrangement
        }
        return iterate(arrangement.applyingRules(), times: times - 1)
    }

    typealias ConstantGrowth = (currentValue: Int, iterationsComplete: Int, constantGrowth: Int)
    func detectConstantGrowth() -> ConstantGrowth {
        var iterations = 1
        var current = arrangement.applyingRules()
        var currentGrowth = current.plantValue - arrangement.plantValue
        var consecutiveConstantGrowths = 0
        // If we detect the plant value growing by the same amount
        // 5 times in a row, we determine the algorithm has settled
        while consecutiveConstantGrowths < 5 {
            let next = current.applyingRules()
            let growth = next.plantValue - current.plantValue
            if growth == currentGrowth {
                consecutiveConstantGrowths += 1
            }
            else {
                currentGrowth = growth
                consecutiveConstantGrowths = 0
            }
            iterations += 1
            current = next
        }
        return (current.plantValue, iterations, currentGrowth)
    }

    func part1() -> String {
        return String(iterate(arrangement, times: 20).plantValue)
    }

    func part2() -> String {
        let (current, iterations, constantGrowth) = detectConstantGrowth()
        let targetIterations = 50_000_000_000
        let remainingIterations = targetIterations - iterations
        let remainingGrowth = constantGrowth * remainingIterations
        return String(current + remainingGrowth)
    }

}

private extension Character {

    var potValue: Bool {
        switch self {
        case "#": return true
        case ".": return false
        default: fatalError()
        }
    }

}
