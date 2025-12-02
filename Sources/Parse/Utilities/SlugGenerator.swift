import Foundation

/// Generates URL-safe slugs from text.
public struct SlugGenerator: Sendable {
    /// The separator character to use between words.
    public let separator: String

    /// Whether to convert to lowercase.
    public let lowercase: Bool

    /// Creates a slug generator with the specified configuration.
    public init(separator: String = "-", lowercase: Bool = true) {
        self.separator = separator
        self.lowercase = lowercase
    }

    /// Generates a URL-safe slug from the given text.
    public func generate(from text: String) -> String {
        var result = text

        // Convert to lowercase if needed
        if lowercase {
            result = result.lowercased()
        }

        // Remove or replace special characters
        result = result
            .replacingOccurrences(of: "[^a-zA-Z0-9\\s-]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Replace whitespace and multiple separators with single separator
        result = result
            .replacingOccurrences(of: "\\s+", with: separator, options: .regularExpression)
            .replacingOccurrences(of: "\(separator)+", with: separator, options: .regularExpression)

        // Trim separators from start and end
        while result.hasPrefix(separator) {
            result = String(result.dropFirst(separator.count))
        }
        while result.hasSuffix(separator) {
            result = String(result.dropLast(separator.count))
        }

        return result
    }
}

extension String {
    /// Converts the string to a URL-safe slug.
    public func slugified(separator: String = "-", lowercase: Bool = true) -> String {
        SlugGenerator(separator: separator, lowercase: lowercase).generate(from: self)
    }

    /// Converts the string to a URL-safe slug using default settings.
    public var slug: String {
        slugified()
    }
}
