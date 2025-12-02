import Foundation

/// Provides statistical analysis of text content.
public struct TextStatistics: Sendable {
    /// The original text being analyzed.
    public let text: String

    /// Creates a text statistics analyzer for the given text.
    public init(text: String) {
        self.text = text
    }

    /// The total number of characters including whitespace.
    public var characterCount: Int {
        text.count
    }

    /// The number of characters excluding whitespace.
    public var characterCountWithoutWhitespace: Int {
        text.filter { !$0.isWhitespace }.count
    }

    /// The number of letters in the text.
    public var letterCount: Int {
        text.filter { $0.isLetter }.count
    }

    /// The number of digits in the text.
    public var digitCount: Int {
        text.filter { $0.isNumber }.count
    }

    /// The number of words in the text.
    public var wordCount: Int {
        words.count
    }

    /// The number of sentences in the text.
    public var sentenceCount: Int {
        sentences.count
    }

    /// The number of paragraphs in the text.
    public var paragraphCount: Int {
        paragraphs.count
    }

    /// The number of lines in the text.
    public var lineCount: Int {
        text.split(separator: "\n", omittingEmptySubsequences: false).count
    }

    /// The average word length.
    public var averageWordLength: Double {
        guard wordCount > 0 else { return 0 }
        let totalLength = words.reduce(0) { $0 + $1.count }
        return Double(totalLength) / Double(wordCount)
    }

    /// The average sentence length in words.
    public var averageSentenceLength: Double {
        guard sentenceCount > 0 else { return 0 }
        return Double(wordCount) / Double(sentenceCount)
    }

    /// Array of words in the text.
    public var words: [String] {
        text
            .components(separatedBy: .whitespacesAndNewlines)
            .map { $0.trimmingCharacters(in: .punctuationCharacters) }
            .filter { !$0.isEmpty }
    }

    /// Array of sentences in the text.
    public var sentences: [String] {
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

    /// Array of paragraphs in the text.
    public var paragraphs: [String] {
        text
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    /// The longest word in the text.
    public var longestWord: String? {
        words.max { $0.count < $1.count }
    }

    /// The shortest word in the text.
    public var shortestWord: String? {
        words.min { $0.count < $1.count }
    }

    /// Counts the syllables in the text (approximation).
    public var syllableCount: Int {
        words.reduce(0) { $0 + countSyllables(in: $1) }
    }

    /// Estimates the number of syllables in a word.
    private func countSyllables(in word: String) -> Int {
        let vowels = CharacterSet(charactersIn: "aeiouyAEIOUY")
        let lowercased = word.lowercased()
        var count = 0
        var previousWasVowel = false

        for char in lowercased {
            let isVowel = String(char).rangeOfCharacter(from: vowels) != nil

            if isVowel && !previousWasVowel {
                count += 1
            }

            previousWasVowel = isVowel
        }

        // Adjust for silent 'e'
        if lowercased.hasSuffix("e") && count > 1 {
            count -= 1
        }

        return max(count, 1)
    }
}

extension String {
    /// Returns text statistics for the string.
    public var statistics: TextStatistics {
        TextStatistics(text: self)
    }
}
