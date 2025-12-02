import Foundation

extension String {
    /// Returns true if the string contains only whitespace characters.
    public var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Returns the string with leading and trailing whitespace removed.
    public var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Returns the number of lines in the string.
    public var lineCount: Int {
        split(separator: "\n", omittingEmptySubsequences: false).count
    }

    /// Returns true if the string is a valid email address.
    public var isValidEmail: Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return range(of: emailRegex, options: .regularExpression) != nil
    }

    /// Returns true if the string is a valid URL.
    public var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil && url.host != nil
    }

    /// Repeats the string the specified number of times.
    public func repeated(_ count: Int) -> String {
        guard count > 0 else { return "" }
        return String(repeating: self, count: count)
    }

    /// Returns the reversed string.
    public var reversed: String {
        String(reversed())
    }

    /// Returns the first character of the string, if any.
    public var firstCharacter: Character? {
        first
    }

    /// Returns the last character of the string, if any.
    public var lastCharacter: Character? {
        last
    }

    /// Removes all occurrences of the specified character set.
    public func removing(_ characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    /// Removes all whitespace from the string.
    public var removingWhitespace: String {
        removing(.whitespacesAndNewlines)
    }

    /// Returns the string with the first character capitalized.
    public var capitalizedFirst: String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }

    /// Splits the string into lines.
    public var lines: [String] {
        split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }

    /// Removes empty lines from the string.
    public var removingEmptyLines: String {
        lines.filter { !$0.isBlank }.joined(separator: "\n")
    }

    /// Indents each line of the string with the specified prefix.
    public func indented(by prefix: String = "    ") -> String {
        lines.map { prefix + $0 }.joined(separator: "\n")
    }

    /// Returns the similarity ratio to another string (0.0 to 1.0).
    public func similarity(to other: String) -> Double {
        let distance = LevenshteinDistance.calculate(from: self, to: other)
        let maxLength = max(count, other.count)
        guard maxLength > 0 else { return 1.0 }
        return 1.0 - Double(distance) / Double(maxLength)
    }
}
