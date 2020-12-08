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

// Day 8 - Solutions

func silver(_ input: [Operation]) -> (accumulator: Int, terminates: Bool) {
    var used: Set<Int> = []
    var (accumulator, position) = (0, 0)
    while position < input.count && used.insert(position).inserted {
        let operation = input[position]
        switch operation.type {
            case .acc:
                accumulator += operation.value
                position += 1
            case .jmp:
                position += operation.value
            case .nop:
                position += 1
        }
    }
    return (accumulator, used.insert(position).inserted)
}

func gold(_ input: [Operation]) -> Int {
    for (index, operation) in input.enumerated() where operation.type != .acc {
        var fixedInput = input
        fixedInput[index].type = operation.type == .jmp ? .nop : .jmp
        let (accumulator, terminates) = silver(fixedInput)
        if terminates { return accumulator }
    }
    fatalError()
}

// Day 8 - Main
freopen("input.txt", "r", stdin)
struct Operation {
    enum OperationType: String { case acc, nop, jmp }
    var type: OperationType, value: Int
}
let input: [Operation] = readInput {
    Operation(type: Operation.OperationType(rawValue: String($0.prefix(3)))!,
              value: Int($0.dropFirst(4))!)
}
print(silver(input).accumulator)
print(gold(input))