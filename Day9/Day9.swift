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

// Day 9 - Solutions
func silver(_ input: [Int], preambleSize: Int = 25) -> Int {
    for index in input.indices.dropFirst(preambleSize) {
        let preamble = Set(input[(index - preambleSize)...index])
        let firstValid = preamble.first {
            let remainder = input[index] - $0
            return remainder != $0 && preamble.contains(remainder)
        }
        if firstValid == nil { return input[index] }
    }
    fatalError()
}

func gold(_ input: [Int]) -> Int {
    let invalid = silver(input)
    var (left, right) = (0, 1)
    var sum = input[left] + input[right]
    while right < input.count {
        if sum == invalid {
            break
        } else if sum < invalid {
            right += 1
            sum += input[right]
        } else {
            sum -= input[left]
            left += 1
        }
    }
    let sequence = input[left...right]
    return sequence.min()! + sequence.max()!
}

// Day 9 - Main
freopen("input.txt", "r", stdin)
let input = readInput(Int.init)
print(silver(input))
print(gold(input))