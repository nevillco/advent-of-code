//
//  Day.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/3/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

protocol Day {

    typealias Solutions = (part1: String, part2: String)
    func compute() -> Solutions

}

extension Day {

    func getInput() -> String {
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

}
