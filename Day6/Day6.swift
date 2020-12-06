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

// Day 6 - Solutions
typealias Input = [[String]]

func silver(_ input: Input) -> Int {
    input.reduce(into: 0) { sum, group in
        sum += Set(group.flatMap { $0 }).count
    }
}

func gold(_ input: Input) -> Int {
    input.reduce(into: 0) { sum, group in
        let first = Set(group[0])
        let sets = group.dropFirst().map(Set.init)
        let intersection = sets.reduce(into: first) { common, answers in
            common.formIntersection(answers)
        }
        sum += intersection.count
    }
}

// Day 6 - Main
freopen("input.txt", "r", stdin)
var group: Input.Element = []
let input: Input = readInput { line in
    // If not new line - \n
    guard line != "" else {
        defer { group = [] }
        return group
    }

    group.append(line)
    return nil
}
print(silver(input))
print(gold(input))