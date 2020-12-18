import Foundation

// Common Utils

func collect<T>(while collect: () -> T?) -> [T] {
    var input: [T] = []
    while let some = collect() { input.append(some) }
    return input
}

func readInput<T>(_ transform: (String) -> T?) -> [T] {
    collect(while: { readLine() }).compactMap(transform)
}

// Day 18 - Utils

protocol Operand {
    func calc() -> Int
}
final class MixNode: Operand {
    private let left, right: Operand
    private let operation: (Int, Int) -> Int
    init(_ left: Operand, _ right: Operand, _ operation: @escaping (Int, Int) -> Int) {
        self.left = left; self.right = right; self.operation = operation
    }
    func calc() -> Int { operation(left.calc(), right.calc()) }
}
final class NumberNode: Operand {
    private let value: Int
    init(_ value: Int) { self.value = value }
    func calc() -> Int { value }
}
func scan(_ input: [Character], index: inout Int, addFirst: Bool = false) -> Operand {
    var left = scanOperand(input, index: &index, addFirst: addFirst)
    while index < input.count {
        var isMultiply = false
        if input[index] == " " { index += 1 }
        let operation: (Int, Int) -> Int
        if input[index] == "+" { operation = (+) }
        else if input[index] == "*" { operation = (*); isMultiply = true }
        else { /* It's ')' */ index += 1; break; }
        index += 2
        
        if addFirst && isMultiply {
            left = MixNode(left, scan(input, index: &index, addFirst: addFirst), operation)
        } else {
            left = MixNode(left, scanOperand(input, index: &index, addFirst: addFirst), operation)
        }
        if addFirst && isMultiply { break }
    }
    return left
}
func scanOperand(_ input: [Character], index: inout Int, addFirst: Bool) -> Operand {
    if input[index] == "(" {
        index += 1
        return scan(input, index: &index, addFirst: addFirst)
    }
    let end = input.dropFirst(index).firstIndex(where: { $0 == " " || $0 == ")" }) ?? input.count
    let number = Int(String(input[index..<end]))!
    index = (end < input.count && input[end] == ")") ? end : end + 1
    return NumberNode(number)
}

// Day 18 - Solutions

func silver(_ input: [[Character]]) -> Int {
    input.reduce(0) {
        var index = 0
        return $0 + scan($1, index: &index).calc()
    }
}

func gold(_ input: [[Character]]) -> Int {
    input.reduce(0) {
        var index = 0
        return $0 + scan($1, index: &index, addFirst: true).calc()
    }
}

// Day 18 - Main
freopen("input.txt", "r", stdin)
let input: [[Character]] = readInput { $0.map { $0 } }
print(silver(input) == 5374004645253)
print(gold(input) == 88782789402798)