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

// Day 14 - Solutions

func silver(_ input: [Operation]) -> Int {
    var mask = (on: 0, off: 0)
    var memory: [Int: Int] = [:]
    for operation in input {
        switch operation {
        case .mask(let string):
            mask.on = Int(string.replacingOccurrences(of: "X", with: "0"), radix: 2)!
            mask.off = Int(string.replacingOccurrences(of: "X", with: "1"), radix: 2)!
        case .assign(let index, let value):
            memory[index] = (value | mask.on) & mask.off
        }
    }
    return memory.reduce(0) { $0 + $1.value }
}

func gold(_ input: [Operation]) -> Int {
    var maskOr = 0
    var memory: [Int: Int] = [:]
    var masks: [(or: Int, and: Int)] = []
    for operation in input {
        switch operation {
        case .mask(let mask):
            maskOr = Int(mask.replacingOccurrences(of: "X", with: "0"), radix: 2)!
            
            let xCount = mask.reduce(0) { $0 + ($1 == "X" ? 1 : 0) }
            masks = (0..<Int(pow(2, Double(xCount)))).map { generated in
                var generatedIndex = 0
                var generatedMask = mask
                for index in mask.indices {
                    if mask[index] == "X" {
                        let character = String((generated >> (xCount - 1 - generatedIndex)) & 1)
                        generatedMask.replaceSubrange(index...index, with: character)
                        generatedIndex += 1
                    } else {
                        generatedMask.replaceSubrange(index...index, with: "X")
                    }
                }
                return (Int(generatedMask.replacingOccurrences(of: "X", with: "0"), radix: 2)!,
                        Int(generatedMask.replacingOccurrences(of: "X", with: "1"), radix: 2)!)
            }
            
        case .assign(let index, let value):
            for m in masks {
                memory[(index | maskOr | m.or) & m.and] = value
            }
        }
    }
    return memory.reduce(into: 0) { $0 += $1.value }
}

// Day 14 - Main
freopen("input.txt", "r", stdin)
enum Operation {
    case mask(String)
    case assign(index: Int, value: Int)
}
let input: [Operation] = readInput { line in
    if line.hasPrefix("mask") { return .mask(String(line.suffix(36))) }
    let parts = line.dropFirst(4).components(separatedBy: "] = ")
    return .assign(index: Int(parts[0])!, value: Int(parts[1])!)
}

print(silver(input))
print(gold(input)) // 700 ms