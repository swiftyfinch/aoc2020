import Foundation

// Common Utils

func collect<T>(while collect: () -> T?) -> [T] {
    var input: [T] = []
    while let some = collect() { input.append(some) }
    return input
}

@discardableResult
func readInput<T>(_ transform: (String) -> T?) -> [T] {
    collect(while: { readLine() }).compactMap(transform)
}

// Day 21 - Solutions

func findAllergens(_ allergens: inout [String: Set<String>]) {
    while allergens.values.contains(where: { $0.count > 1 }) {
        for found in allergens where found.value.count == 1 {
            for unknown in allergens where unknown.value.count > 1 {
                guard let ingredient = found.value.first else { fatalError() }
                allergens[unknown.key]?.remove(ingredient)
            }
        }
    }
}

func silver(_ allergens: [String: Set<String>], ingredients: [String]) -> Int {
    let haveAllergens = Set(allergens.values.flatMap { $0 })
    return ingredients.reduce(0) { $0 + (haveAllergens.contains($1) ? 0 : 1) }
}

func gold(_ allergens: [String: Set<String>]) -> String {
    allergens.keys.sorted().map { allergens[$0]!.first! }.joined(separator: ",")
}

// Day 21 - Main
freopen("input.txt", "r", stdin)
var ingredients: [String] = []
var allergens: [String: Set<String>] = [:]
readInput { line in
    let parts = line.dropLast().components(separatedBy: " (")
    let lineIngredients = Set(parts[0].components(separatedBy: " "))
    ingredients.append(contentsOf: lineIngredients)
    parts[1].dropFirst(9).components(separatedBy: ", ").forEach {
        allergens[$0, default: lineIngredients].formIntersection(lineIngredients)
    }
}
findAllergens(&allergens)
print(silver(allergens, ingredients: ingredients))
print(gold(allergens))