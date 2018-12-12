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

        init(required: String, enabling: String) {
            self.enabling = enabling
            self.required = required
        }
    }
    lazy var stepRequirements: [StepRequirement] = {
        return input().lines
            .map { StepRequirement(line: $0) }
            .sorted { $0.required < $1.required }
    }()
    lazy var allSteps: [String] = {
        return Array(Set(stepRequirements.map { $0.required } + stepRequirements.map { $0.enabling }))
    }()

    class Assignment {
        let step: String
        var timeRemaining: Int

        init(step: String) {
            self.step = step
            // Unicode scalar of "A" = 65. Offset by 65, then
            // re-offset by 61 for problem specs
            timeRemaining = Int(step.unicodeScalars.first!.value) - 4
        }
    }

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

    func part2() -> String {
        let maxWorkers = 5
        var currentAssignments: [Assignment] = []
        var requirements = stepRequirements
        var completed: [String] = []
        var totalTime = 0
        while completed.count < allSteps.count {
            let enabled = enabledSteps(with: requirements, completed: completed, assignments: currentAssignments)
            let availableSteps = enabled.count
            let availableWorkers = maxWorkers - currentAssignments.count
            for index in 0..<min(availableSteps, availableWorkers) {
                let assignment = Assignment(step: enabled[index])
                currentAssignments.append(assignment)
            }
            for assignment in currentAssignments {
                assignment.timeRemaining -= 1
                if assignment.timeRemaining == 0 {
                    completed.append(assignment.step)
                    requirements = requirements.filtering(step: assignment.step)
                }
            }
            currentAssignments = currentAssignments.filter { $0.timeRemaining > 0 }
            totalTime += 1
        }
        return String(describing: totalTime)
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

    func enabledSteps(with requirements: [StepRequirement], completed: [String], assignments: [Assignment]) -> [String] {
        return enabledSteps(with: requirements, completed: completed).filter({ step in
            !assignments.contains { $0.step == step }
        })
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
