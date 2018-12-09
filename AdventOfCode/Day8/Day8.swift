//
//  Day8.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/9/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

final class Day8: Day {

    struct Node {

        let children: [Node]
        let metadata: [Int]

        var metadataSum: Int {
            return metadata.reduce(0, +) + children.map { $0.metadataSum }.reduce(0, +)
        }

        var value: Int {
            guard !children.isEmpty else {
                return metadata.reduce(0, +)
            }
            return metadata.compactMap { self.child(at: $0 - 1)?.value }.reduce(0, +)
        }

        func child(at index: Int) -> Node? {
            guard self.children.indices.contains(index) else {
                return nil
            }
            return self.children[index]
        }

    }
    lazy var rootNode: Node = {
        var iterator = input().split(separator: " ")
            .map { Int($0.trimmingCharacters(in: .newlines))! }
            .makeIterator()
        return parseNode(iterator: &iterator)
    }()

    func part1() -> String {
        return String(describing: rootNode.metadataSum)
    }

    func part2() -> String {
        return String(describing: rootNode.value)
    }

    func parseNode(iterator: inout IndexingIterator<[Int]>) -> Node {
        let numChildren = iterator.next()!
        let numMetadata = iterator.next()!
        let children = (0..<numChildren).map({ _ in parseNode(iterator: &iterator) })
        let metadata = (0..<numMetadata).map { _ in iterator.next()! }
        return Node(children: children, metadata: metadata)
    }

}
