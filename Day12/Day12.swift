import Foundation

// Common Utils

func collect<T>(while collect: () -> T?) -> [T] {
    var input: [T] = []
    while let some = collect() {
        input.append(some)
    }
    return input
}

func readInput<T>(_ transform: (String) -> T?) -> [T] {
    collect(while: { readLine() }).compactMap(transform)
}

// Day 12 - Utils

infix operator %%
func %%(_ lhs: Int, _ rhs: Int) -> Int { lhs % rhs >= 0 ? lhs % rhs : lhs % rhs + rhs }

extension Int {
    func times(_ closure: () -> Void) {
        (0..<self).forEach { _ in closure() }
    }
}

// Day 12 - Solutions

func silver(_ input: [Command]) -> Int {
    let directions: [(e: Int, n: Int)] = [(1, 0), (0, -1), (-1, 0), (0, 1)]
    var direction = 0
    var ship = (e: 0, n: 0)
    input.forEach {
        switch $0.type {
        case .n: ship.n += $0.value
        case .s: ship.n -= $0.value
        case .e: ship.e += $0.value
        case .w: ship.e -= $0.value
        case .l: direction = (direction - $0.value / 90) %% directions.count
        case .r: direction = (direction + $0.value / 90) %% directions.count
        case .f:
            ship.e += directions[direction].e * $0.value
            ship.n += directions[direction].n * $0.value
        }
    }
    return abs(ship.e) + abs(ship.n)
}

func gold(_ input: [Command]) -> Int {
    var ship = (e: 0, n: 0)
    var waypoint = (e: 10, n: 1)
    input.forEach {
        switch $0.type {
        case .n: waypoint.n += $0.value
        case .s: waypoint.n -= $0.value
        case .e: waypoint.e += $0.value
        case .w: waypoint.e -= $0.value
        case .l: ($0.value / 90).times { (waypoint.e, waypoint.n) = (-waypoint.n, waypoint.e) }
        case .r: ($0.value / 90).times { (waypoint.e, waypoint.n) = (waypoint.n, -waypoint.e) }
        case .f:
            ship.e += waypoint.e * $0.value
            ship.n += waypoint.n * $0.value
        }
    }
    return abs(ship.e) + abs(ship.n)
}

// Day 11 - Main
freopen("input.txt", "r", stdin)

struct Command {
    enum CommandType: String { case n, s, e, w, l, r, f }
    let type: CommandType, value: Int
}
let input: [Command] = readInput {
    let type = Command.CommandType(rawValue: String($0.first!).lowercased())!
    return Command(type: type, value: Int($0.dropFirst())!)
}
print(silver(input))
print(gold(input))