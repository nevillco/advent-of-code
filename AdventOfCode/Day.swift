//
//  Day.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/3/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

protocol Day {

    func part1() -> String
    func part2() -> String

}

extension Day {

    func run() {
        print("part1: \(part1())\npart2: \(part2())")
    }

    func input() -> String {
        guard let path = Bundle.main.path(forResource: String(describing: type(of: self)), ofType: "txt") else {
            fatalError("Input text file not found in bundle")
        }
        let contents: String
        do {
            contents = try String(contentsOfFile: path)
        }
        catch {
            fatalError("Unable to parse input file: \(error.localizedDescription)")
        }
        return contents
    }

    func lines() -> [String] {
        return input().split(separator: "\n").map({ String($0) })
    }

}

extension Day {

    func part1() -> String {
        return ""
    }

    func part2() -> String {
        return ""
    }

}
