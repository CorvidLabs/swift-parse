import Foundation

/// Represents different text casing styles.
public enum CaseStyle: Sendable {
    case camelCase
    case pascalCase
    case snakeCase
    case kebabCase
    case screamingSnakeCase
    case titleCase
    case sentenceCase

    /// Converts a string from one case style to another.
    public func convert(_ text: String, from sourceStyle: CaseStyle? = nil) -> String {
        let words = sourceStyle?.extractWords(from: text) ?? detectAndExtractWords(from: text)
        return apply(to: words)
    }

    /// Detects the source style and extracts words.
    private func detectAndExtractWords(from text: String) -> [String] {
        guard !text.isEmpty else { return [] }

        // Try to detect the source style
        if text.contains("_") {
            return text.split(separator: "_").map(String.init)
        } else if text.contains("-") {
            return text.split(separator: "-").map(String.init)
        } else if text.contains(" ") {
            return text.split(separator: " ").map(String.init)
        } else if text.contains(where: { $0.isUppercase }) {
            return splitCamelCase(text)
        }

        return [text]
    }

    /// Extracts words from text based on the case style.
    private func extractWords(from text: String) -> [String] {
        guard !text.isEmpty else { return [] }

        switch self {
        case .camelCase, .pascalCase:
            return splitCamelCase(text)
        case .snakeCase, .screamingSnakeCase:
            return text.split(separator: "_").map(String.init)
        case .kebabCase:
            return text.split(separator: "-").map(String.init)
        case .titleCase, .sentenceCase:
            return text.split(separator: " ").map(String.init)
        }
    }

    /// Applies the case style to a list of words.
    private func apply(to words: [String]) -> String {
        guard !words.isEmpty else { return "" }

        switch self {
        case .camelCase:
            let first = words[0].lowercased()
            let rest = words.dropFirst().map { $0.capitalized }
            return ([first] + rest).joined()

        case .pascalCase:
            return words.map { $0.capitalized }.joined()

        case .snakeCase:
            return words.map { $0.lowercased() }.joined(separator: "_")

        case .kebabCase:
            return words.map { $0.lowercased() }.joined(separator: "-")

        case .screamingSnakeCase:
            return words.map { $0.uppercased() }.joined(separator: "_")

        case .titleCase:
            return words.map { $0.capitalized }.joined(separator: " ")

        case .sentenceCase:
            let first = words[0].capitalized
            let rest = words.dropFirst().map { $0.lowercased() }
            return ([first] + rest).joined(separator: " ")
        }
    }

    /// Splits camelCase or PascalCase text into words.
    private func splitCamelCase(_ text: String) -> [String] {
        var words: [String] = []
        var currentWord = ""

        for char in text {
            if char.isUppercase && !currentWord.isEmpty {
                words.append(currentWord)
                currentWord = String(char)
            } else {
                currentWord.append(char)
            }
        }

        if !currentWord.isEmpty {
            words.append(currentWord)
        }

        return words
    }
}

extension String {
    /// Converts the string to the specified case style.
    public func convertCase(to style: CaseStyle, from sourceStyle: CaseStyle? = nil) -> String {
        style.convert(self, from: sourceStyle)
    }

    /// Converts the string to camelCase.
    public var camelCased: String {
        convertCase(to: .camelCase)
    }

    /// Converts the string to PascalCase.
    public var pascalCased: String {
        convertCase(to: .pascalCase)
    }

    /// Converts the string to snake_case.
    public var snakeCased: String {
        convertCase(to: .snakeCase)
    }

    /// Converts the string to kebab-case.
    public var kebabCased: String {
        convertCase(to: .kebabCase)
    }

    /// Converts the string to SCREAMING_SNAKE_CASE.
    public var screamingSnakeCased: String {
        convertCase(to: .screamingSnakeCase)
    }
}
