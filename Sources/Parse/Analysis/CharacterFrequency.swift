import Foundation

/// Analyzes character frequency in text.
public struct CharacterFrequency: Sendable {
    /// The original text being analyzed.
    public let text: String

    /// Creates a character frequency analyzer for the given text.
    public init(text: String) {
        self.text = text
    }

    /// Returns a dictionary mapping characters to their frequency counts.
    public var frequencies: [Character: Int] {
        text.reduce(into: [:]) { counts, character in
            counts[character, default: 0] += 1
        }
    }

    /// Returns a dictionary mapping characters to their relative frequencies (0.0 to 1.0).
    public var relativeFrequencies: [Character: Double] {
        let total = Double(text.count)
        guard total > 0 else { return [:] }

        return frequencies.mapValues { Double($0) / total }
    }

    /// Returns characters sorted by frequency (most frequent first).
    public var sortedByFrequency: [(character: Character, count: Int)] {
        frequencies.sorted { $0.value > $1.value }.map { (character: $0.key, count: $0.value) }
    }

    /// Returns the most frequent character.
    public var mostFrequent: Character? {
        frequencies.max { $0.value < $1.value }?.key
    }

    /// Returns the least frequent character.
    public var leastFrequent: Character? {
        frequencies.min { $0.value < $1.value }?.key
    }

    /// Returns the frequency of a specific character.
    public func frequency(of character: Character) -> Int {
        frequencies[character] ?? 0
    }

    /// Returns the relative frequency of a specific character.
    public func relativeFrequency(of character: Character) -> Double {
        relativeFrequencies[character] ?? 0.0
    }

    /// Returns characters that appear more than the specified threshold.
    public func characters(appearingMoreThan threshold: Int) -> [Character] {
        frequencies.filter { $0.value > threshold }.map { $0.key }
    }

    /// Returns unique characters in the text.
    public var uniqueCharacters: Set<Character> {
        Set(text)
    }

    /// Returns the number of unique characters.
    public var uniqueCharacterCount: Int {
        uniqueCharacters.count
    }
}

extension String {
    /// Returns character frequency analysis for the string.
    public var characterFrequency: CharacterFrequency {
        CharacterFrequency(text: self)
    }
}
