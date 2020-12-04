import Foundation

// Common Utils

// Shortcut for += bool to integer
func += (_ integer: inout Int, bool: Bool) { integer += (bool ? 1 : 0) }

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

// Day 4 - Solutions

func silver(_ inputs: [String]) -> Int {
    let fields = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]
    return inputs.reduce(into: 0) { sum, current in
      sum += fields.allSatisfy { current.contains($0) }
    }
}

func gold(_ inputs: [String]) -> Int {
    var valid = 0
    let fieldsCount = 7
    let eyeColors: Set = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    for input in inputs {
        let tokens = input.components(separatedBy: [" ", ":"])
        var validTokens = 0
        for index in stride(from: 0, to: tokens.count, by: 2) {
            let field = tokens[index]
            let value = tokens[index + 1]
            switch field {
                case "byr":
                    guard let int = Int(value) else { break }
                    validTokens += (int >= 1920 && int <= 2002)
                case "iyr":
                    guard let int = Int(value) else { break }
                    validTokens += (int >= 2010 && int <= 2020)
                case "eyr":
                    guard let int = Int(value) else { break }
                    validTokens += (int >= 2020 && int <= 2030)
                case "hgt":
                    if value.hasSuffix("cm") {
                        guard let int = Int(value.dropLast(2)) else { break }
                        validTokens += (int >= 150 && int <= 193)
                    } else if value.hasSuffix("in") {
                        guard let int = Int(value.dropLast(2)) else { break }
                        validTokens += (int >= 59 && int <= 76)
                    }
                case "hcl":
                    guard value.hasPrefix("#") else { break }
                    validTokens += (Int(value.dropFirst(), radix: 16) != nil)
                case "ecl":
                    validTokens += eyeColors.contains(value)
                case "pid":
                    validTokens += (value.count == 9 && Int(value) != nil)
                default: break
            }
        }
        valid += (validTokens >= fieldsCount)
    }
    return valid
}

// Day 4 - Main
freopen("input.txt", "r", stdin)
var buffer = ""
let input: [String] = readInput { line in
    // If not new line - \n
    guard line != "" else {
        defer { buffer = "" }
        return buffer
    }
  
    if !buffer.isEmpty { buffer.append(" ") }
    buffer.append(line)
    return nil
}
print(silver(input))
print(gold(input))