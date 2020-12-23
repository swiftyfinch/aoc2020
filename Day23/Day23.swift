import Foundation

// Day 23 - Utils

final class Circle<T: CustomStringConvertible>: CustomStringConvertible where T: Equatable {
    final class Node<T> {
        let value: T
        var next: Node<T>?
        init(value: T) { self.value = value }
    }
    
    private(set) var head: Node<T>
    
    init(_ collection: [T]) {
        head = Node(value: collection[0])
        var tail = head
        for element in collection.dropFirst() {
            let node = Node(value: element)
            tail.next = node
            tail = node
        }
        tail.next = head
    }
    
    func firstNode(value: T) -> Node<T>? {
        var tail = head
        while tail.value != value, let current = tail.next, current !== head {
            tail = current
        }
        return tail
    }
    
    func buildArray() -> [T] {
        var tail = head
        var array: [T] = [tail.value]
        while let current = tail.next, current !== head {
            tail = current
            array.append(tail.value)
        }
        return array
    }
    
    var description: String {
        buildArray().map(\.description).joined(separator: ", ")
    }
}

func crabCups(_ input: [Int], moves: Int) -> [Int] {
    let circle = Circle(input)
    let max = input.max()!
    var current = circle.head
    
    typealias Node = Circle<Int>.Node<Int>
    var map: [Int: Node] = [current.value: current]
    var tail = current
    while let now = tail.next, now !== current {
        map[now.value] = now
        tail = now
    }
    
    for _ in 0..<moves {
        var pickUp: [Node] = []
        var last = current
        for _ in 0..<3 {
            last = last.next!
            pickUp.append(last)
        }
        
        var destinationValue = current.value - 1 > 0 ? current.value - 1 : max
        while pickUp.map(\.value).contains(destinationValue) {
            destinationValue = destinationValue - 1 > 0 ? destinationValue - 1 : max
        }
        
        let destination = map[destinationValue]!
        current.next = pickUp.last?.next
        let destinationNext = destination.next
        destination.next = pickUp[0]
        pickUp.last?.next = destinationNext
        current = current.next!
    }
    return circle.buildArray()
}

// Day 23 - Solutions

func silver(_ input: [Int]) -> String {
    let circle = crabCups(input, moves: 100)
    let first = circle.firstIndex(of: 1)!
    let resultArray = Array(circle[(first + 1)..<circle.count]) + Array(circle[0..<first])
    return resultArray.map(String.init).joined()
}

func gold(_ input: [Int]) -> Int {
    let max = input.max()!
    let extendedInput = input + Array((max + 1)...1_000_000)
    let result = crabCups(extendedInput, moves: 10_000_000)
    let firstIndex = result.firstIndex(of: 1)!
    return result[(firstIndex + 1) % result.count] * result[(firstIndex + 2) % result.count]
}

// Day 23
let input = "962713854".map(String.init).compactMap(Int.init)
print(silver(input))
print(gold(input)) // Compile flags: -O, 11s