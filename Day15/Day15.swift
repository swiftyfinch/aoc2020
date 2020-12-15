
func silver(_ input: [Int], turns: Int = 2020) -> Int {
    var spoken = ContiguousArray(repeating: -1, count: turns)
    input.enumerated().forEach { spoken[$1] = $0 + 1 }
    var last = input.last!
    for idx in input.count..<turns {
        // Always use last spoken number = idx.
        (spoken[last], last) = (idx, spoken[last] == -1 ? 0 : idx - spoken[last])
    }
    return last
}

func gold(_ input: [Int]) -> Int {
    silver(input, turns: 30_000_000)
}

let input = [8,11,0,19,1,2]
print(silver(input))
print(gold(input)) // 21s