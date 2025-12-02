import Foundation

/// Simple tokenization of text.
public struct Tokenizer: Sendable {
    /// Token types.
    public enum TokenType: Sendable {
        case word
        case whitespace
        case punctuation
        case number
        case symbol
    }

    /// A token with its type and value.
    public struct Token: Sendable, Equatable {
        public let type: TokenType
        public let value: String

        public init(type: TokenType, value: String) {
            self.type = type
            self.value = value
        }
    }

    /// Tokenizes text into words.
    public static func words(from text: String) -> [String] {
        text
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
    }

    /// Tokenizes text into tokens with types.
    public static func tokenize(_ text: String) -> [Token] {
        var tokens: [Token] = []
        var currentToken = ""
        var currentType: TokenType?

        for char in text {
            let type = classifyCharacter(char)

            if currentType == type {
                currentToken.append(char)
            } else {
                if let prevType = currentType, !currentToken.isEmpty {
                    tokens.append(Token(type: prevType, value: currentToken))
                }
                currentToken = String(char)
                currentType = type
            }
        }

        if let type = currentType, !currentToken.isEmpty {
            tokens.append(Token(type: type, value: currentToken))
        }

        return tokens
    }

    /// Tokenizes text into sentences.
    public static func sentences(from text: String) -> [String] {
        let pattern = #"[^.!?]+[.!?]+"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return [text]
        }

        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)

        return matches.compactMap { match in
            guard let range = Range(match.range, in: text) else { return nil }
            return String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    /// Classifies a character by type.
    private static func classifyCharacter(_ char: Character) -> TokenType {
        if char.isWhitespace {
            return .whitespace
        } else if char.isLetter {
            return .word
        } else if char.isNumber {
            return .number
        } else if char.isPunctuation {
            return .punctuation
        } else {
            return .symbol
        }
    }

    /// Filters tokens by type.
    public static func filter(_ tokens: [Token], byType type: TokenType) -> [Token] {
        tokens.filter { $0.type == type }
    }

    /// Extracts token values from tokens of a specific type.
    public static func values(from tokens: [Token], ofType type: TokenType) -> [String] {
        filter(tokens, byType: type).map { $0.value }
    }
}

extension String {
    /// Tokenizes the string into words.
    public var words: [String] {
        Tokenizer.words(from: self)
    }

    /// Tokenizes the string into tokens with types.
    public var tokens: [Tokenizer.Token] {
        Tokenizer.tokenize(self)
    }

    /// Tokenizes the string into sentences.
    public var sentences: [String] {
        Tokenizer.sentences(from: self)
    }
}
