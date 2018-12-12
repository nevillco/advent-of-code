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
        return self.input().lines
            .map({ Entry(line: $0) })
            .sorted(by: { (e1, e2) in e1.date < e2.date })
    }()
    // [Guard ID: ranges when asleep]
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
        // [Guard ID: total time asleep]
        let timeAsleep = sleepRanges.mapValues { ranges in
            return ranges.reduce(into: 0) { $0 += ($1.endIndex - $1.startIndex) }
        }
        let maxTimeAsleep = timeAsleep.max { $0.value < $1.value }!
        let guardID = maxTimeAsleep.key
        let checksum = guardID * mostCommonMinuteAsleep(guardID: guardID).minute
        return String(describing: checksum)
    }

    func part2() -> String {
        // [Guard ID: (minute most commonly asleep, # of times asleep that minute)]
        let maxFrequencies: [Int: MinuteFrequency] = sleepRanges.reduce(into: [:]) { (result, tuple) in
            result[tuple.key] = mostCommonMinuteAsleep(guardID: tuple.key)
        }
        let winner = maxFrequencies.max { $0.value.frequency < $1.value.frequency }!
        let checksum = winner.key * winner.value.minute
        return String(describing: checksum)
    }

    typealias MinuteFrequency = (minute: Int, frequency: Int)
    func mostCommonMinuteAsleep(guardID: Int) -> MinuteFrequency {
        let result = sleepFrequenciesByMinute(guardID: guardID).max { $0.value < $1.value }!
        return (result.key, result.value)
    }

    // [Minute: number of times asleep]
    func sleepFrequenciesByMinute(guardID: Int) -> [Int: Int] {
        return (0..<59).reduce(into: [:], { (result, next) in
            let frequencies = sleepRanges[guardID]!.filter({ range in
                return range.contains(next)
            })
            result[next] = frequencies.count
        })
    }

}
