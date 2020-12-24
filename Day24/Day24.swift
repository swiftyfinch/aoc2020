import Foundation

// Common Utils

func collect<T>(while collect: () -> T?) -> [T] {
    var input: [T] = []
    while let some = collect() { input.append(some) }
    return input
}

func readInput<T>(_ transform: (String) -> T?) -> [T] {
    collect(while: { readLine() }).compactMap(transform)
}

// Day 24 - Solutions

struct Position: Hashable {
    var x, y: Int
    init(x: Int = 0, y: Int = 0) { self.x = x; self.y = y }
    static func + (_ lhs: Position, _ rhs: Position) -> Position {
        Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
let mapDirections: [String: Position] = [
    "e": .init(x: 1, y: 1),
    "w": .init(x: -1, y: -1),
    "se": .init(x: 1),
    "sw": .init(y: -1),
    "ne": .init(y: 1),
    "nw": .init(x: -1)
]

func silver(_ input: [[Position]]) -> Set<Position> {
    input.reduce(into: Set<Position>()) {
        let finalPosition = $1.reduce(Position(), +)
        if !$0.insert(finalPosition).inserted {
            $0.remove(finalPosition)
        }
    }
}

func gold(_ input: Set<Position>) -> Int {
    let adjustments = mapDirections.values
    var write = input
    for _ in 0..<100 {
        let read = write
        for position in read {
            // Black
            let black = adjustments.reduce(0) { $0 + (read.contains(position + $1) ? 1 : 0) }
            if black == 0 || black > 2 { write.remove(position) }
            
            // White
            for adjustment in adjustments {
                let adjacent = position + adjustment
                if read.contains(adjacent) { continue }
                let black = adjustments.reduce(0) { $0 + (read.contains(adjacent + $1) ? 1 : 0) }
                if black == 2 { write.insert(adjacent) }
            }
        }
    }
    return write.count
}

// Day 24
freopen("input.txt", "r", stdin)
let input: [[Position]] = readInput { line in
    var directions: [Position] = []
    var buffer = ""
    for character in line {
        buffer.append(character)
        if let direction = mapDirections[buffer] {
            directions.append(direction)
            buffer.removeAll()
        }
    }
    return directions
}

let floor = silver(input)
print(floor.count)
print(gold(floor))