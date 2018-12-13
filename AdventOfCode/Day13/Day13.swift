//
//  Day13.swift
//  AdventOfCode
//
//  Created by Connor Neville on 12/13/18.
//  Copyright © 2018 Connor Neville. All rights reserved.
//

import Foundation

extension Direction {
    init?(cartCharacter: Character) {
        switch cartCharacter {
        case "^": self = .up
        case "v": self = .down
        case "<": self = .left
        case ">": self = .right
        default: return nil
        }
    }
}

final class Day13: Day {

    struct Cart {
        let position: AnyPosition
        let direction: Direction
        let intersectionCount: Int
    }

    enum TrackItem {
        case intersection
        case vertical
        case horizontal
        case leftCorner
        case rightCorner

        init(cartDirection: Direction) {
            switch cartDirection {
            case .up, .down: self = .vertical
            case .left, .right: self = .horizontal
            }
        }

        init?(trackCharacter: Character) {
            switch trackCharacter {
            case "+": self = .intersection
            case "|": self = .vertical
            case "-": self = .horizontal
            case "/": self = .leftCorner
            case "\\": self = .rightCorner
            case " ": return nil
            default: fatalError()
            }
        }
    }

    struct Track {
        let trackItems: [AnyPosition: TrackItem]
        let carts: [Cart]

        init(trackItems: [AnyPosition: TrackItem], carts: [Cart]) {
            self.trackItems = trackItems
            self.carts = carts
        }

        init(lines: [String]) {
            var carts: [Cart] = []
            var trackItems: [AnyPosition: TrackItem] = [:]
            for (y, line) in lines.enumerated() {
                for (x, character) in line.enumerated() {
                    let position = AnyPosition(x: x, y: y)
                    if let direction = Direction(cartCharacter: character) {
                        let cart = Cart(position: position, direction: direction, intersectionCount: 0)
                        carts.append(cart)
                        trackItems[position] = .init(cartDirection: direction)
                    }
                    else {
                        trackItems[position] = TrackItem(trackCharacter: character)
                    }
                }
            }
            self.init(trackItems: trackItems, carts: carts)
        }
    }

    lazy var track: Track = { .init(lines: input().lines) }()

    func findCollision(_ track: Track) -> AnyPosition {
        let (nextTrack, collisions) = iterate(track)
        return collisions.first ?? findCollision(nextTrack)
    }

    func iterate(_ track: Track) -> (Track, [AnyPosition]) {
        let oldCarts = track.carts.sorted { $0.position.y < $1.position.y && $0.position.x < $1.position.x }
        var newCarts: [Cart] = []
        var collisions: [AnyPosition] = []
        for (index, cart) in oldCarts.enumerated() {
            guard !collisions.contains(cart.position) else {
                continue
            }
            let newCart = move(cart: cart, in: track)
            let foundCollision: (Cart) -> Bool = { newCart.position == $0.position }
            if let movedCollidingCart = newCarts.index(where: foundCollision) {
                collisions.append(newCart.position)
                newCarts.remove(at: movedCollidingCart)
            }
            else if oldCarts[index...].contains(where: foundCollision) {
                collisions.append(newCart.position)
            }
            else {
                newCarts.append(newCart)
            }
        }
        return (Track(trackItems: track.trackItems, carts: newCarts), collisions)
    }

    func move(cart: Cart, in track: Track) -> Cart {
        let direction: Direction
        let trackItem = track.trackItems[cart.position]!
        switch trackItem {
        case .vertical, .horizontal:
            direction = cart.direction
        case .leftCorner:
            direction = cart.direction.isVertical ?
                cart.direction.turningRight() : cart.direction.turningLeft()
        case .rightCorner:
            direction = cart.direction.isVertical ?
                cart.direction.turningLeft() : cart.direction.turningRight()
        case .intersection:
            switch cart.intersectionCount % 3 {
            case 0: direction = cart.direction.turningLeft()
            case 1: direction = cart.direction
            case 2: direction = cart.direction.turningRight()
            default: fatalError()
            }
        }
        let intersectionCount = trackItem == .intersection ?
            cart.intersectionCount + 1 : cart.intersectionCount
        return .init(
            position: cart.position.next(direction: direction),
            direction: direction,
            intersectionCount: intersectionCount)
    }

    func part1() -> String {
        let collision = findCollision(track)
        return "\(collision.x),\(collision.y)"
    }

    func part2() -> String {
        var currentTrack = track
        while currentTrack.carts.count > 1 {
            (currentTrack, _) = iterate(currentTrack)
        }
        let lastCart = currentTrack.carts.first!.position
        return "\(lastCart.x),\(lastCart.y)"
    }

}
