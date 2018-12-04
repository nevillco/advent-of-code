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
    lazy var sleepRanges: [Int: [Range<Int>]] = {
        var sleepRanges: [Int: [Range<Int>]] = [:]
        var activeGuardID: Int!
        var lastTimestamp: Date!
        for entry in entries {
            switch entry.type {
            case .guardStarting(let id):
                activeGuardID = id
            case .fallsAsleep:
                lastTimestamp = entry.date
            case .wakesUp:
                let sleepMinute = Calendar.current.component(.minute, from: lastTimestamp)
                let wakeMinute = Calendar.current.component(.minute, from: entry.date)
                let range = [sleepMinute..<wakeMinute]
                sleepRanges[activeGuardID, default: []].append(contentsOf: range)
            }
        }
        return sleepRanges
    }()

    func part1() -> String {
        let timeAsleep = sleepRanges.mapValues { ranges in
            return ranges.reduce(into: 0, { (result, range) in
                result += (range.endIndex - range.startIndex)
            })
        }
        let maxTimeAsleep = timeAsleep.max(by: { (tuple1, tuple2) -> Bool in
            return tuple1.value < tuple2.value
        })!
        let guardID = maxTimeAsleep.key
        let checksum = guardID * mostCommonMinuteAsleep(guardID: guardID).minute
        return String(describing: checksum)
    }

    func part2() -> String {
        let maxFrequencies: [Int: MinuteFrequency] = sleepRanges.reduce(into: [:]) { (result, tuple) in
            result[tuple.key] = mostCommonMinuteAsleep(guardID: tuple.key)
        }
        let winner = maxFrequencies.max(by: { (tuple1, tuple2) -> Bool in
            return tuple1.value.frequency < tuple2.value.frequency
        })!
        let checksum = winner.key * winner.value.minute
        print(winner)
        return String(describing: checksum)
    }

    func sleepFrequenciesByMinute(guardID: Int) -> [Int: Int] {
        return (0..<59).reduce(into: [Int: Int](), { (result, next) in
            let frequencies = sleepRanges[guardID]!.filter({ range in
                return range.contains(next)
            })
            result[next] = frequencies.count
        })
    }

    typealias MinuteFrequency = (minute: Int, frequency: Int)
    func mostCommonMinuteAsleep(guardID: Int) -> MinuteFrequency {
        let result = sleepFrequenciesByMinute(guardID: guardID).max(by: { tuple1, tuple2 -> Bool in
            return tuple1.value < tuple2.value
        })
        return (result!.key, result!.value)
    }

}
