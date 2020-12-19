# Swift uses the ICU RegEx engine which doesn’t support recursion.
# Soo, it's my Ruby solution :)

def buildRule(start, rules)
	result = ""
	rule = rules[start]
	if rule.include?("|")
		orParts = rule.split(" | ")
		result += "("
		for orPart in orParts
			result += orPart.split(" ").reduce("") { |r, i| r + buildRule(i.to_i, rules) }
			result += "|" if orPart != orParts[-1]
		end
		result += ")"
	elsif rule.start_with?("\"")
		result += rule[1...-2]
	else
		result += "("
		result += "?<test>" if rule.include?("\\g<test>?")
		hasPlus = false
		indices = rule.split(" ")
		for index in indices
			(result += "\\g<test>?"; next) if index == "\\g<test>?"
			(hasPlus = true; break) if index == "+"
			result += buildRule(index.to_i, rules)
		end
		result += ")"
		result += "+" if hasPlus
	end
	return result
end

def silver(rules, messages)
	regexp = Regexp.new("^" + buildRule(0, rules) + "$")
	messages.reduce(0) { |s, m| s + (m.match(regexp) ? 1 : 0) }
end

def gold(rules, messages)
	rules[8] = "42 +"
	rules[11] = "42 \\g<test>? 31"
	silver(rules, messages)
end

rules = {}
messages = []
File.readlines("input.txt").each do |line|
	next if line == $/
	parts = line.split(": ")
	rules[parts[0].to_i] = parts[1] if parts.count > 1
	messages.append(line) if parts.count == 1
end

puts silver(rules, messages)
puts gold(rules, messages)
# silver + gold = 112ms