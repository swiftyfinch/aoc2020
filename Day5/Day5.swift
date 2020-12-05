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

// Day 5 - Solutions

func silver(_ inputs: [Int]) -> Int { inputs.max()! }

func gold(_ inputs: [Int]) -> Int {
    let max = silver(inputs)
    let seatRange = 1...max
    var remainingSeats = Set(seatRange).subtracting(Set(inputs))
    _ = seatRange.first { remainingSeats.remove($0) == nil }
    return remainingSeats.first!
}

// Day 5 - Main
freopen("input.txt", "r", stdin)
var buffer = ""
let input: [Int] = readInput {
    let binaryString = String($0.map { $0 == "F" || $0 == "L" ? "0" : "1" })
    return Int(binaryString, radix: 2)
}
print(silver(input))
print(gold(input))