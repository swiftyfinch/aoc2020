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

// Day 1 - Solutions

func silver(_ input: Set<Int>) -> Int {
    for int in input {
        let remainder = 2020 - int
        if input.contains(remainder) {
            return int * remainder
        }
    }
    return -1
}

func gold(_ input: Set<Int>) -> Int {
    for (index, a) in input.enumerated() {
        for b in input.dropFirst(index + 1) {
            let remainder = 2020 - a - b
            if input.contains(remainder) {
                return a * b * remainder
            }
        }
    }
    return -1
}

// Day 1 - Main
freopen("input.txt", "r", stdin)
let input = Set(readInput(Int.init))
print(silver(input))
print(gold(input))