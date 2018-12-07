//
//  Day7.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/7/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day7: Day {

    struct StepRequirement {
        let required: String
        let enabling: String

        init(line: String) {
            let separated = line.split(separator: " ")
            required = String(separated[1])
            enabling = String(separated[7])
        }
    }
    lazy var stepRequirements: [StepRequirement] = {
        return lines().map { StepRequirement(line: $0) }.sorted { $0.required < $1.required }
    }()
    lazy var allSteps: [String] = {
        return Array(Set(stepRequirements.map { $0.required } + stepRequirements.map { $0.enabling }))
    }()

    func part1() -> String {
        var requirements = stepRequirements
        var completed: [String] = []
        while completed.count < allSteps.count {
            let next = nextStep(with: requirements, completed: completed)
            completed.append(next)
            requirements = requirements.filtering(step: next)
        }
        return completed.joined()
    }

    func enabledSteps(with requirements: [StepRequirement], completed: [String]) -> [String] {
        let isEnabled: (String) -> Bool = { string in
            return !requirements.contains(where: { requirement in
                requirement.enabling == string
            })
        }
        return (0..<26)
            .map({ String(Character(UnicodeScalar($0 + 65))) })
            .filter(isEnabled)
            .filter { !completed.contains($0) }
    }

    func nextStep(with requirements: [StepRequirement], completed: [String]) -> String {
        return enabledSteps(with: requirements, completed: completed).first!
    }

}

extension Array where Element == Day7.StepRequirement {

    func filtering(step: String) -> [Day7.StepRequirement] {
        return filter { $0.required != step }
    }

}
