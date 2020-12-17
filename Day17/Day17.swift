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

// Day 17 - Solutions

func silver(_ input: [[Bool]], useFourthDimension: Bool = false) -> Int {
    let cycles = 6
    let size = input.count + (cycles + 1) * 2
    var space = Array(repeating: Array(repeating: Array(repeating: Array(repeating: false,
                                                                         count: size),
                                                        count: size),
                                       count: size),
                      count: useFourthDimension ? size : 1)
    
    for y in input.indices {
        for x in input[y].indices {
            space[space.count / 2][size / 2][cycles + 1 + y][ cycles + 1 + x] = input[y][x]
        }
    }
    
    var new = space
    for cycle in 1...cycles {
        let scope = cycles - cycle + 1
        let wScope = useFourthDimension ? scope : 0
        let current = new
        for w in current.indices.dropFirst(wScope).dropLast(wScope) {
            for z in current[w].indices.dropFirst(scope).dropLast(scope) {
                for y in current[w][z].indices.dropFirst(scope).dropLast(scope) {
                    for x in current[w][z][y].indices.dropFirst(scope).dropLast(scope) {
                        var active = 0
                        let wwRange = useFourthDimension ? (w - 1)...(w + 1) : w...w
                        for ww in wwRange {
                            for zz in (z - 1)...(z + 1) {
                                for yy in (y - 1)...(y + 1) {
                                    for xx in (x - 1)...(x + 1) {
                                        if ww == w && zz == z && yy == y && xx == x { continue }
                                        active += current[ww][zz][yy][xx] ? 1 : 0
                                    }
                                }
                            }
                        }
                        
                        if current[w][z][y][x] {
                            new[w][z][y][x] = (active == 2 || active == 3)
                        } else {
                            new[w][z][y][x] = (active == 3)
                        }
                    }
                }
            }
        }
    }
    
    return new.flatMap {
        $0.flatMap {
            $0.flatMap { $0 }
        }
    }
    .reduce(into: 0) { $0 += ($1 ? 1 : 0) }
}

func gold(_ input: [[Bool]]) -> Int {
    silver(input, useFourthDimension: true)
}

// Day 17 - Main
freopen("input.txt", "r", stdin)
let input: [[Bool]] = readInput({ $0.map({ $0 == "#" }) })
print(silver(input))
print(gold(input)) // 27s