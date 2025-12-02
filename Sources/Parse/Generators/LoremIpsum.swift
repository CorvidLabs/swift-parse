import Foundation

/// Generates Lorem Ipsum placeholder text.
public struct LoremIpsum: Sendable {
    /// The random source for generation.
    private var random: RandomSource

    /// Whether to start with the classic "Lorem ipsum dolor sit amet".
    public let startWithClassic: Bool

    /// Creates a Lorem Ipsum generator.
    public init(seed: UInt64? = nil, startWithClassic: Bool = true) {
        self.random = seed.map { RandomSource(seed: $0) } ?? RandomSource()
        self.startWithClassic = startWithClassic
    }

    /// Generates random words.
    public mutating func words(count: Int) -> String {
        guard count > 0 else { return "" }

        var result: [String] = []

        if startWithClassic && count >= 5 {
            result = ["Lorem", "ipsum", "dolor", "sit", "amet"]
            for _ in 5..<count {
                if let word = random.nextElement(from: LoremWords.words) {
                    result.append(word)
                }
            }
        } else {
            for _ in 0..<count {
                if let word = random.nextElement(from: LoremWords.words) {
                    result.append(word)
                }
            }
        }

        return result.joined(separator: " ")
    }

    /// Generates random sentences.
    public mutating func sentences(count: Int) -> String {
        guard count > 0 else { return "" }

        var result: [String] = []

        for _ in 0..<count {
            let wordCount = random.nextInt(in: 5...15)
            var sentence = words(count: wordCount)
            sentence = sentence.prefix(1).uppercased() + sentence.dropFirst()
            sentence += "."
            result.append(sentence)
        }

        return result.joined(separator: " ")
    }

    /// Generates random paragraphs.
    public mutating func paragraphs(count: Int) -> String {
        guard count > 0 else { return "" }

        var result: [String] = []

        for _ in 0..<count {
            let sentenceCount = random.nextInt(in: 3...7)
            result.append(sentences(count: sentenceCount))
        }

        return result.joined(separator: "\n\n")
    }

    /// Generates text of approximately the specified character length.
    public mutating func characters(count: Int) -> String {
        var result = ""

        while result.count < count {
            result += words(count: 1) + " "
        }

        let endIndex = result.index(result.startIndex, offsetBy: min(count, result.count))
        return String(result[..<endIndex]).trimmingCharacters(in: .whitespaces)
    }
}

extension String {
    /// Generates Lorem Ipsum words.
    public static func loremWords(_ count: Int, seed: UInt64? = nil) -> String {
        var generator = LoremIpsum(seed: seed)
        return generator.words(count: count)
    }

    /// Generates Lorem Ipsum sentences.
    public static func loremSentences(_ count: Int, seed: UInt64? = nil) -> String {
        var generator = LoremIpsum(seed: seed)
        return generator.sentences(count: count)
    }

    /// Generates Lorem Ipsum paragraphs.
    public static func loremParagraphs(_ count: Int, seed: UInt64? = nil) -> String {
        var generator = LoremIpsum(seed: seed)
        return generator.paragraphs(count: count)
    }
}
