import Foundation

/// Calculates readability scores for text.
public struct ReadabilityScore: Sendable {
    /// The text statistics used for calculations.
    private let statistics: TextStatistics

    /// Creates a readability score calculator for the given text.
    public init(text: String) {
        self.statistics = TextStatistics(text: text)
    }

    /// Flesch Reading Ease score (0-100, higher is easier).
    /// 90-100: Very Easy
    /// 80-89: Easy
    /// 70-79: Fairly Easy
    /// 60-69: Standard
    /// 50-59: Fairly Difficult
    /// 30-49: Difficult
    /// 0-29: Very Confusing
    public var fleschReadingEase: Double {
        guard statistics.wordCount > 0, statistics.sentenceCount > 0 else { return 0 }

        let averageWordsPerSentence = Double(statistics.wordCount) / Double(statistics.sentenceCount)
        let averageSyllablesPerWord = Double(statistics.syllableCount) / Double(statistics.wordCount)

        return 206.835 - (1.015 * averageWordsPerSentence) - (84.6 * averageSyllablesPerWord)
    }

    /// Flesch-Kincaid Grade Level (US school grade level).
    public var fleschKincaidGradeLevel: Double {
        guard statistics.wordCount > 0, statistics.sentenceCount > 0 else { return 0 }

        let averageWordsPerSentence = Double(statistics.wordCount) / Double(statistics.sentenceCount)
        let averageSyllablesPerWord = Double(statistics.syllableCount) / Double(statistics.wordCount)

        return (0.39 * averageWordsPerSentence) + (11.8 * averageSyllablesPerWord) - 15.59
    }

    /// Gunning Fog Index (years of formal education needed).
    public var gunningFogIndex: Double {
        guard statistics.wordCount > 0, statistics.sentenceCount > 0 else { return 0 }

        let averageWordsPerSentence = Double(statistics.wordCount) / Double(statistics.sentenceCount)
        let complexWords = statistics.words.filter { countSyllables(in: $0) >= 3 }.count
        let percentageComplexWords = Double(complexWords) / Double(statistics.wordCount)

        return 0.4 * (averageWordsPerSentence + 100 * percentageComplexWords)
    }

    /// SMOG (Simple Measure of Gobbledygook) Index.
    public var smogIndex: Double {
        guard statistics.sentenceCount >= 3 else { return 0 }

        let complexWords = statistics.words.filter { countSyllables(in: $0) >= 3 }.count
        let polysyllableCount = Double(complexWords)
        let sentenceCount = Double(statistics.sentenceCount)

        return 1.0430 * sqrt(polysyllableCount * (30.0 / sentenceCount)) + 3.1291
    }

    /// Coleman-Liau Index (US grade level).
    public var colemanLiauIndex: Double {
        guard statistics.wordCount > 0 else { return 0 }

        let l = (Double(statistics.letterCount) / Double(statistics.wordCount)) * 100
        let s = (Double(statistics.sentenceCount) / Double(statistics.wordCount)) * 100

        return (0.0588 * l) - (0.296 * s) - 15.8
    }

    /// Automated Readability Index (US grade level).
    public var automatedReadabilityIndex: Double {
        guard statistics.wordCount > 0, statistics.sentenceCount > 0 else { return 0 }

        let charactersPerWord = Double(statistics.characterCountWithoutWhitespace) / Double(statistics.wordCount)
        let wordsPerSentence = Double(statistics.wordCount) / Double(statistics.sentenceCount)

        return (4.71 * charactersPerWord) + (0.5 * wordsPerSentence) - 21.43
    }

    /// Returns a readability grade description based on Flesch Reading Ease.
    public var readabilityGrade: String {
        let score = fleschReadingEase

        switch score {
        case 90...100:
            return "Very Easy"
        case 80..<90:
            return "Easy"
        case 70..<80:
            return "Fairly Easy"
        case 60..<70:
            return "Standard"
        case 50..<60:
            return "Fairly Difficult"
        case 30..<50:
            return "Difficult"
        default:
            return "Very Confusing"
        }
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
    /// Returns readability scores for the string.
    public var readabilityScore: ReadabilityScore {
        ReadabilityScore(text: self)
    }
}
