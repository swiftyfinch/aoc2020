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

// Day 3 - Solutions
enum Cell { case tree, empty }
typealias Input = [[Cell]]

func silver(_ input: Input, step: (x: Int, y: Int) = (3, 1)) -> Int {
    var (x, y) = step
    var trees = 0
    while y < input.count {
        let modX = x % input[y].count
        trees += input[y][modX] == .tree ? 1 : 0
        x += step.x
        y += step.y
    }
    return trees
}

func gold(_ input: Input) -> Int {
    return silver(input, step: (1, 1))
      * silver(input, step: (3, 1))
      * silver(input, step: (5, 1))
      * silver(input, step: (7, 1))
      * silver(input, step: (1, 2))
}

// Day 3 - Main
freopen("input.txt", "r", stdin)
let input: Input = readInput {
    $0.map { $0 == "#" ? .tree : .empty }
}
print(silver(input))
print(gold(input))