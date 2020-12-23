import Foundation

// Common Utils

func collect<T>(while collect: () -> T?) -> [T] {
    var input: [T] = []
    while let some = collect() { input.append(some) }
    return input
}

@discardableResult
func readInput<T>(_ transform: (String) -> T?) -> [T] {
    collect(while: { readLine() }).compactMap(transform)
}

// Day 21 - Solutions

func round(_ lhs: [Int], _ rhs: [Int], recursion: Bool = false) -> (lhs: [Int], rhs: [Int]) {
    var cache: (lhs: Set<[Int]>, rhs: Set<[Int]>) = ([], [])
    var (lhs, rhs) = (lhs, rhs)
    while !lhs.isEmpty && !rhs.isEmpty {
        if cache.lhs.contains(lhs) && cache.rhs.contains(rhs) {
            return ([1], [])
        } else {
            cache.lhs.insert(lhs)
            cache.rhs.insert(rhs)
        }
        
        let (left, right) = (lhs.removeFirst(), rhs.removeFirst())
        var isLeftWin = left > right
        if recursion && lhs.count >= left && rhs.count >= right {
            let lhsCopy = Array(lhs.prefix(left))
            let rhsCopy = Array(rhs.prefix(right))
            isLeftWin = round(lhsCopy, rhsCopy, recursion: recursion).rhs.isEmpty
        }
        isLeftWin ? lhs.append(left) : rhs.append(right)
        isLeftWin ? lhs.append(right) : rhs.append(left)
    }
    return (lhs, rhs)
}

func silver(_ crabCards: [Int], _ myCards: [Int]) -> Int {
    let result = round(crabCards, myCards)
    let winner = result.lhs.isEmpty ? result.rhs : result.lhs
    return winner.enumerated().reduce(0) { $0 + (winner.count - $1.offset) * $1.element }
}

func gold(_ crabCards: [Int], _ myCards: [Int]) -> Int {
    let result = round(crabCards, myCards, recursion: true)
    let winner = result.lhs.isEmpty ? result.rhs : result.lhs
    return winner.enumerated().reduce(0) { $0 + (winner.count - $1.offset) * $1.element }
}

// Day 21 - Main
freopen("input.txt", "r", stdin)
var isFirstPlayer = true
var (crabCards, myCards) = ([Int](), [Int]())
readInput { line in
    if line == "Player 2:" { isFirstPlayer = false }
    Int(line).map { isFirstPlayer ? crabCards.append($0) : myCards.append($0) }
}
print(silver(crabCards, myCards))
print(gold(crabCards, myCards)) // <1s