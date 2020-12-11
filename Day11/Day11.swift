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

// Day 11 - Utils

typealias Matrix<T> = [[T]]
extension Matrix where Element == Array<Cell> {
    func count(_ lookup: Cell = .occupied,
               except: Cell = .floor,
               around: (row: Int, column: Int),
               maxOffset max: Int = 1) -> Int {
        [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)].reduce(into: 0) {
            $0 += first(from: around, offset: $1, maxOffset: max, except: except) == lookup ? 1 : 0
        }
    }
    
    func first(from: (row: Int, column: Int),
               offset: (row: Int, column: Int),
               maxOffset: Int,
               except: Cell) -> Cell? {
        var step = 1
        var row = from.row + offset.row * step
        var column = from.column + offset.column * step
        while indices ~= row && self[row].indices ~= column && step <= maxOffset {
            guard except == self[row][column] else { return self[row][column] }
            step += 1
            row = from.row + offset.row * step
            column = from.column + offset.column * step
        }
        return nil
    }

    func each(_ closure: ((row: Int, column: Int)) -> Void) {
        for row in indices {
            for column in self[row].indices {
                closure((row, column))
            }
        }
    }
    
    func count(_ lookup: Cell) -> Int {
        flatMap { $0 }.reduce(into: 0) { $0 += ($1 == lookup ? 1 : 0) }
    }
}

// Day 11 - Solutions

func silver(_ input: Matrix<Cell>, maxOffset: Int = 1, adjacentOccupied: Int = 4) -> Int {
    var hasChanges = false
    var nextRound = input
    repeat {
        let current = nextRound
        hasChanges = false
        current.each { row, column in
            let occupied = current.count(around: (row, column), maxOffset: maxOffset)
            if current[row][column] == .empty && occupied == 0 {
                nextRound[row][column] = .occupied
                hasChanges = true
            } else if current[row][column] == .occupied && occupied >= adjacentOccupied {
                nextRound[row][column] = .empty
                hasChanges = true
            }
        }
    } while hasChanges
    return nextRound.count(.occupied)
}

func gold(_ input: Matrix<Cell>) -> Int {
    silver(input, maxOffset: Int.max, adjacentOccupied: 5)
}

// Day 11 - Main
freopen("input.txt", "r", stdin)

enum Cell { case empty, floor, occupied }
let input: Matrix<Cell> = readInput { line in
    line.map {
        if $0 == "L" { return .empty }
        if $0 == "#" { return .occupied }
        return .floor
    }
}
print(silver(input))
print(gold(input))