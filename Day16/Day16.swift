import Foundation

// Common Utils

func collect<T>(while collect: () -> T?) -> [T] {
    var input: [T] = []
    while let some = collect() {
        input.append(some)
    }
    return input
}

@discardableResult
func readInput<T>(_ transform: (String) -> T?) -> [T] {
    collect(while: { readLine() }).compactMap(transform)
}

extension String {
    subscript(_ pattern: String, groups: [Int] = [0]) -> [String] {
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(self.startIndex..., in: self)
        guard let match = regex?.firstMatch(in: self, range: range) else { return [] }
        return groups.map(match.range).compactMap { Range($0, in: self) }.map { String(self[$0]) }
    }
}

// Day 16 - Solutions

func silver(ranges: [ClosedRange<Int>], tickets: [[Int]]) -> Int {
    tickets.reduce(0) { totalSum, ticket in
        totalSum + ticket.reduce(0) { ticketSum, number in
            ticketSum + (ranges.contains(where: { $0.contains(number) }) ? 0 : number)
        }
    }
}

func gold(ranges: [ClosedRange<Int>], myTicket: [Int], tickets: [[Int]]) -> Int {
    let valids = tickets.filter { ticket in
        ticket.allSatisfy { number in ranges.contains(where: { $0.contains(number) }) }
    }
    
    let row = Array(repeating: Set<Int>(), count: valids.count)
    var ticketsRangesByPosition: [[Set<Int>]] = .init(repeating: row, count: valids[0].count)
    for (ticketIndex, ticket) in valids.enumerated() {
        for (positionIndex, number) in ticket.enumerated() {
            for index in stride(from: 0, to: ranges.count, by: 2) {
                if ranges[index].contains(number) || ranges[index + 1].contains(number) {
                    ticketsRangesByPosition[positionIndex][ticketIndex].insert(index / 2)
                }
            }
        }
    }
    
    let rangeSets = ticketsRangesByPosition.enumerated().map { position, tickets in
        (position, rangeIndices: tickets.dropFirst().reduce(tickets[0]) { $0.intersection($1) })
    }.sorted(by: { $0.rangeIndices.count < $1.rangeIndices.count })
    
    var mapPostionToRangeIndex = Array(repeating: 0, count: ranges.count / 2)
    var used: Set<Int> = []
    for (ticketPosition, rangeIndices) in rangeSets {
        let rangeIndex = rangeIndices.subtracting(used).first!
        mapPostionToRangeIndex[rangeIndex] = ticketPosition
        used.insert(rangeIndex)
    }
    
    return mapPostionToRangeIndex[0..<6].reduce(1) { $0 * myTicket[$1] }
}

// Day 16 - Main
freopen("input.txt", "r", stdin)
var ranges: [ClosedRange<Int>] = []
var myTicket: [Int] = []
var tickets: [[Int]] = []
readInput { (line: String) -> Void in
    let match = line[#".*: (\d+)-(\d+) or (\d+)-(\d+)"#, [1, 2, 3, 4]].compactMap(Int.init)
    if match.count == 4 {
        ranges.append(ClosedRange(uncheckedBounds: (match[0], match[1])))
        ranges.append(ClosedRange(uncheckedBounds: (match[2], match[3])))
    } else {
        let numbers = line.components(separatedBy: ",").compactMap(Int.init)
        if !numbers.isEmpty {
            myTicket.isEmpty ? myTicket = numbers : tickets.append(numbers)
        }
    }
    return Void()
}
print(silver(ranges: ranges, tickets: tickets))
print(gold(ranges: ranges, myTicket: myTicket, tickets: tickets))