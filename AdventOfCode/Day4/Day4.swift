//
//  Day4.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/3/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day4: Day {

    enum EntryType {
        case guardStarting(id: Int)
        case fallsAsleep
        case wakesUp

        init(substring: String) {
            let keyword = substring.split(separator: " ")[1]
            switch keyword {
            case "up":
                self = .wakesUp
            case "asleep":
                self = .fallsAsleep
            default:
                let number = Int(keyword.dropFirst())!
                self = .guardStarting(id: number)
            }
        }
    }

    struct Entry {
        let date: Date
        let type: EntryType

        static var formatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyy-MM-dd HH:mm"
            return f
        }()

        init(line: String) {
            let dateStart = line.index(line.startIndex, offsetBy: 1)
            let dateEnd = line.firstIndex(of: "]")!
            let dateString = String(line[dateStart..<dateEnd])
            date = Entry.formatter.date(from: dateString)!
            let typeString = String(line[line.index(dateEnd, offsetBy: 2)...])
            type = .init(substring: typeString)
        }
    }
    lazy var entries: [Entry] = {
        return self.lines()
            .map({ Entry(line: $0) })
            .sorted(by: { (e1, e2) in e1.date < e2.date })
    }()

    func part1() -> String {
        print(entries.map({ $0.type}))
        return ""
    }

    func part2() -> String {
        return ""
    }

}
