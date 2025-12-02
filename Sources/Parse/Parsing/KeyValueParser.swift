import Foundation

/// Parses key-value pairs from text.
public struct KeyValueParser: Sendable {
    /// The separator between key and value.
    public let separator: String

    /// The separator between pairs.
    public let pairSeparator: String

    /// Whether to trim whitespace from keys and values.
    public let trimWhitespace: Bool

    /// Creates a key-value parser with the specified configuration.
    public init(
        separator: String = "=",
        pairSeparator: String = "\n",
        trimWhitespace: Bool = true
    ) {
        self.separator = separator
        self.pairSeparator = pairSeparator
        self.trimWhitespace = trimWhitespace
    }

    /// Parses key-value pairs from text.
    public func parse(_ text: String) throws -> [String: String] {
        var result: [String: String] = [:]

        let pairSep = pairSeparator.first ?? "\n"
        let pairs = text.split(separator: pairSep)

        for pair in pairs {
            let trimmedPair = trimWhitespace ? pair.trimmingCharacters(in: CharacterSet.whitespaces) : String(pair)

            guard !trimmedPair.isEmpty else { continue }

            let keySep = separator.first ?? "="
            let components = trimmedPair.split(separator: keySep, maxSplits: 1)

            guard components.count == 2 else {
                throw TextError.parsingFailed("Invalid key-value pair: \(trimmedPair)")
            }

            let key = trimWhitespace ? components[0].trimmingCharacters(in: CharacterSet.whitespaces) : String(components[0])
            let value = trimWhitespace ? components[1].trimmingCharacters(in: CharacterSet.whitespaces) : String(components[1])

            result[key] = value
        }

        return result
    }

    /// Formats a dictionary as key-value text.
    public func format(_ dictionary: [String: String]) -> String {
        dictionary
            .map { "\($0.key)\(separator)\($0.value)" }
            .joined(separator: pairSeparator)
    }
}

extension String {
    /// Parses the string as key-value pairs.
    public func parseKeyValues(
        separator: String = "=",
        pairSeparator: String = "\n"
    ) throws -> [String: String] {
        try KeyValueParser(separator: separator, pairSeparator: pairSeparator).parse(self)
    }
}

extension Dictionary where Key == String, Value == String {
    /// Formats the dictionary as key-value text.
    public func formatKeyValues(
        separator: String = "=",
        pairSeparator: String = "\n"
    ) -> String {
        KeyValueParser(separator: separator, pairSeparator: pairSeparator).format(self)
    }
}
