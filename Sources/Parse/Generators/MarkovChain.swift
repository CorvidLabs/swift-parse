import Foundation

/// Generates text using a Markov chain model.
public struct MarkovChain: Sendable {
    /// The order of the Markov chain (number of previous words to consider).
    public let order: Int

    /// The chain data mapping prefixes to possible next words.
    private let chain: [String: [String]]

    /// Creates a Markov chain from training text.
    public init(text: String, order: Int = 2) {
        self.order = order
        self.chain = Self.buildChain(from: text, order: order)
    }

    /// Builds the Markov chain from text.
    private static func buildChain(from text: String, order: Int) -> [String: [String]] {
        let words = text
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        guard words.count > order else { return [:] }

        var chain: [String: [String]] = [:]

        for i in 0..<(words.count - order) {
            let prefix = words[i..<(i + order)].joined(separator: " ")
            let next = words[i + order]

            chain[prefix, default: []].append(next)
        }

        return chain
    }

    /// Generates text of approximately the specified word count.
    public func generate(wordCount: Int, seed: UInt64? = nil) -> String {
        guard wordCount > 0, !chain.isEmpty else { return "" }

        var random = seed.map { RandomSource(seed: $0) } ?? RandomSource()

        // Pick a random starting prefix
        guard let startPrefix = random.nextElement(from: Array(chain.keys)) else {
            return ""
        }

        var words = startPrefix.components(separatedBy: " ")
        var currentPrefix = startPrefix

        while words.count < wordCount {
            guard let nextWords = chain[currentPrefix],
                  let nextWord = random.nextElement(from: nextWords) else {
                // If we can't continue, pick a new random prefix
                guard let newPrefix = random.nextElement(from: Array(chain.keys)) else {
                    break
                }
                currentPrefix = newPrefix
                continue
            }

            words.append(nextWord)

            // Update prefix by dropping first word and adding the new word
            let prefixWords = currentPrefix.components(separatedBy: " ").dropFirst() + [nextWord]
            currentPrefix = prefixWords.joined(separator: " ")
        }

        return words.prefix(wordCount).joined(separator: " ")
    }

    /// Generates a sentence using the Markov chain.
    public func generateSentence(maxWords: Int = 20, seed: UInt64? = nil) -> String {
        let text = generate(wordCount: maxWords, seed: seed)
        guard !text.isEmpty else { return "" }

        var result = text.prefix(1).uppercased() + text.dropFirst()

        if !result.hasSuffix(".") && !result.hasSuffix("!") && !result.hasSuffix("?") {
            result += "."
        }

        return result
    }

    /// Generates multiple sentences.
    public func generateSentences(count: Int, maxWordsPerSentence: Int = 20, seed: UInt64? = nil) -> String {
        guard count > 0 else { return "" }

        var random = seed.map { RandomSource(seed: $0) } ?? RandomSource()
        var sentences: [String] = []

        for _ in 0..<count {
            let nextSeed = random.nextUInt64()
            let sentence = generateSentence(maxWords: maxWordsPerSentence, seed: nextSeed)
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
        }

        return sentences.joined(separator: " ")
    }
}
