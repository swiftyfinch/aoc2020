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

extension String {
    subscript(_ pattern: String, groups: [Int] = [0]) -> [String] {
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(self.startIndex..., in: self)
        guard let match = regex?.firstMatch(in: self, range: range) else { return [] }
        return groups.map(match.range).compactMap { Range($0, in: self) }.map { String(self[$0]) }
    }
}

func bfs(_ map: [String: Set<String>], begin: String) -> Set<String> {
    var visited: Set<String> = [begin]
    var queue = [begin]
    while !queue.isEmpty {
        let children = map[queue.removeFirst()] ?? []
        for name in children where !visited.contains(name) {
            queue.append(name)
            visited.insert(name)
        }
    }
    return visited
}

func dfs(_ map: [String: [String: Int]], begin: String) -> Int {
    (map[begin] ?? [:]).reduce(into: 1) { sum, child in
        sum += child.value * dfs(map, begin: child.key)
    }
}

// Day 7 - Solutions
func silver(_ input: [String: Set<String>]) -> Int {
    bfs(input, begin: "shiny gold").count - 1
}

func gold(_ input: [String: [String: Int]]) -> Int {
    dfs(input, begin: "shiny gold") - 1
}

// Day 7 - Main
freopen("input.txt", "r", stdin)
let rawInput = readInput { $0 }

let silverInput: [String: Set<String>] = rawInput.reduce(into: [:]) { map, line in
    let parts = line.components(separatedBy: " bags contain ")
    let bags = parts[1].components(separatedBy: ",")
    guard bags[0] != "no other bags." else { return }
    let childrens = bags.map { $0[#"\s?(\d+) (\w+ \w+)"#, [2]][0] }
    childrens.forEach { child in
        map[child, default: []].insert(parts[0])
    }
}
print(silver(silverInput))

let goldInput: [String: [String: Int]] = rawInput.reduce(into: [:]) { map, line in
    let parts = line.components(separatedBy: " bags contain ")
    let bags = parts[1].components(separatedBy: ",")
    guard bags[0] != "no other bags." else { return }
    map[parts[0]] = bags.reduce(into: [String: Int]()) { children, bag in
        let nameAndCount = bag[#"\s?(\d+) (\w+ \w+)"#, [2, 1]]
        children[nameAndCount[0]] = Int(nameAndCount[1])!
    }
}
print(gold(goldInput))