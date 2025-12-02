import Foundation

/// Matches strings against Unix-style glob patterns.
public struct GlobPattern: Sendable {
    /// The glob pattern string.
    public let pattern: String

    /// Whether matching should be case-sensitive.
    public let caseSensitive: Bool

    /// Creates a glob pattern matcher.
    public init(_ pattern: String, caseSensitive: Bool = true) {
        self.pattern = pattern
        self.caseSensitive = caseSensitive
    }

    /// Checks if a string matches the glob pattern.
    public func matches(_ string: String) -> Bool {
        let patternChars = Array(caseSensitive ? pattern : pattern.lowercased())
        let stringChars = Array(caseSensitive ? string : string.lowercased())

        return match(patternChars, stringChars, 0, 0)
    }

    /// Recursively matches pattern against string.
    private func match(_ pattern: [Character], _ string: [Character], _ pIndex: Int, _ sIndex: Int) -> Bool {
        // End of both pattern and string
        if pIndex == pattern.count && sIndex == string.count {
            return true
        }

        // End of pattern but not string
        if pIndex == pattern.count {
            return false
        }

        // Handle wildcard (*)
        if pattern[pIndex] == "*" {
            // Try matching zero characters
            if match(pattern, string, pIndex + 1, sIndex) {
                return true
            }

            // Try matching one or more characters
            if sIndex < string.count {
                return match(pattern, string, pIndex, sIndex + 1)
            }

            return false
        }

        // End of string but not pattern
        if sIndex == string.count {
            return false
        }

        // Handle single character wildcard (?)
        if pattern[pIndex] == "?" {
            return match(pattern, string, pIndex + 1, sIndex + 1)
        }

        // Handle character sets [abc] or [a-z]
        if pattern[pIndex] == "[" {
            if let closingBracket = findClosingBracket(pattern, from: pIndex) {
                let charSet = pattern[(pIndex + 1)..<closingBracket]
                if matchesCharacterSet(string[sIndex], charSet: Array(charSet)) {
                    return match(pattern, string, closingBracket + 1, sIndex + 1)
                }
                return false
            }
        }

        // Match exact character
        if pattern[pIndex] == string[sIndex] {
            return match(pattern, string, pIndex + 1, sIndex + 1)
        }

        return false
    }

    /// Finds the closing bracket for a character set.
    private func findClosingBracket(_ pattern: [Character], from start: Int) -> Int? {
        for i in (start + 1)..<pattern.count {
            if pattern[i] == "]" {
                return i
            }
        }
        return nil
    }

    /// Checks if a character matches a character set pattern.
    private func matchesCharacterSet(_ char: Character, charSet: [Character]) -> Bool {
        guard !charSet.isEmpty else { return false }

        // Handle negation [!abc]
        let negated = charSet[0] == "!"
        let set = negated ? Array(charSet.dropFirst()) : charSet

        // Handle ranges [a-z]
        var i = 0
        while i < set.count {
            if i + 2 < set.count && set[i + 1] == "-" {
                let start = set[i]
                let end = set[i + 2]
                if char >= start && char <= end {
                    return !negated
                }
                i += 3
            } else {
                if char == set[i] {
                    return !negated
                }
                i += 1
            }
        }

        return negated
    }

    /// Filters an array of strings to those matching the pattern.
    public func filter(_ strings: [String]) -> [String] {
        strings.filter { matches($0) }
    }
}

extension String {
    /// Checks if the string matches a glob pattern.
    public func matchesGlob(_ pattern: String, caseSensitive: Bool = true) -> Bool {
        GlobPattern(pattern, caseSensitive: caseSensitive).matches(self)
    }
}
