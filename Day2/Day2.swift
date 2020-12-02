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

// Day 2 - Solutions

typealias Input = (range: ClosedRange<Int>, requiredLetter: Character, password: String)

func silver(_ inputs: [Input]) -> Int {
    var validPasswordCount = 0
    for (range, requiredLetter, password) in inputs {
        let count = password.reduce(0, { $0 + ($1 == requiredLetter ? 1 : 0) })
        validPasswordCount += range.contains(count) ? 1 : 0
    }
    return validPasswordCount
}

func gold(_ inputs: [Input]) -> Int {
    var validPasswordCount = 0
    for (range, requiredLetter, password) in inputs {
        let firstIndex = password.index(password.startIndex, offsetBy: range.lowerBound - 1)
        let secondIndex = password.index(password.startIndex, offsetBy: range.upperBound - 1)
        let first = password[firstIndex]
        let second = password[secondIndex]
        if (first == requiredLetter || second == requiredLetter) && first != second {
            validPasswordCount += 1
        }
    }
    return validPasswordCount
}

// Day 2 - Main
freopen("input.txt", "r", stdin)
let input: [Input] = readInput { 
    let parts = $0.components(separatedBy: " ")
    let bounds = parts[0].components(separatedBy: "-").compactMap(Int.init)
    let range = ClosedRange(uncheckedBounds: (bounds[0], bounds[1]))
    let character = parts[1].first!
    let password = parts[2]
    return (range, character, password)
}
print(silver(input))
print(gold(input))