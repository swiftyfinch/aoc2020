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

// Day 10 - Solutions
func silver(_ input: [Int]) -> Int {
    var diffs = [0, 0, 0, 1]
    for index in input.indices.dropLast() {
        let diff = input[index + 1] - input[index]
        if diff > 3 { break }
        diffs[diff] += 1
    }
    return diffs[1] * diffs[3]
}

func gold(_ input: [Int], begin: Int = 0, cache: inout [Int]) -> Int {
    guard cache[begin] == Int.min else { return cache[begin] }
    guard begin + 1 < input.count else { return 1 }
    cache[begin] = input.indices.dropFirst(begin).dropLast().prefix(4).reduce(into: 0) {
        guard input[$1 + 1] - input[begin] <= 3 else { return }
        $0 += gold(input, begin: $1 + 1, cache: &cache)
    }
    return cache[begin]
}

// Day 10 - Main
freopen("input.txt", "r", stdin)
let input = [0] + readInput(Int.init).sorted()

print(silver(input))

var cache: [Int] = .init(repeating: Int.min, count: input.count)
print(gold(input, cache: &cache))