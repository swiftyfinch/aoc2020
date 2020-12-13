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

// Day 13 - Solutions

func silver(_ time: Int, _ buses: [String]) -> Int {
    let buses = buses.compactMap(Int.init)
    let delays = buses.map { (id: $0, await: time % $0) }
    let best = delays.max { $0.await < $1.await }!
    return best.id * (best.id - best.await)
}

func gold(_ buses: [String]) -> Int {
    let ids = buses.map { Int($0) ?? 1 }
    var index = 1
    var (timestamp, increment) = (ids[0], ids[0])
    while index < ids.count {
        let id = ids[index]
        // If bus is in sequence (correct timestamp with shift):
        if (timestamp + index) % id == 0 {
            // Changing increment to production, because it doesn't change modulo.
            increment *= id
            // Let's handle the next bus.
            index += 1
        } else {
            // Adding increment if bus isn't in sequence.
            timestamp += increment
        }
    }
    return timestamp
}

// Day 13 - Main
freopen("input.txt", "r", stdin)
let input = readInput { $0 }
let time = Int(input[0])!
let buses = input[1].components(separatedBy: ",")
print(silver(time, buses))
print(gold(buses))
