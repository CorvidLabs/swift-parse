import Foundation

/// Performs fuzzy string matching with configurable algorithms and thresholds.
public struct FuzzyMatcher: Sendable {
    /// The similarity algorithm to use.
    public enum Algorithm: Sendable {
        case levenshtein
        case jaro
        case jaroWinkler
        case lcs
    }

    /// The matching algorithm.
    public let algorithm: Algorithm

    /// The minimum similarity threshold (0.0 to 1.0).
    public let threshold: Double

    /// Creates a fuzzy matcher with the specified configuration.
    public init(algorithm: Algorithm = .jaroWinkler, threshold: Double = 0.7) {
        self.algorithm = algorithm
        self.threshold = threshold
    }

    /// Checks if two strings match based on the configured similarity threshold.
    public func matches(_ first: String, _ second: String) -> Bool {
        similarity(from: first, to: second) >= threshold
    }

    /// Calculates the similarity between two strings using the configured algorithm.
    public func similarity(from first: String, to second: String) -> Double {
        switch algorithm {
        case .levenshtein:
            return LevenshteinDistance.similarity(from: first, to: second)
        case .jaro:
            return JaroWinkler().jaroSimilarity(from: first, to: second)
        case .jaroWinkler:
            return JaroWinkler().similarity(from: first, to: second)
        case .lcs:
            return LongestCommonSubsequence.similarity(of: first, and: second)
        }
    }

    /// Finds the best match for a query string in a list of candidates.
    public func bestMatch(for query: String, in candidates: [String]) -> (match: String, similarity: Double)? {
        guard !candidates.isEmpty else { return nil }

        return candidates
            .map { (match: $0, similarity: similarity(from: query, to: $0)) }
            .max { $0.similarity < $1.similarity }
    }

    /// Finds all matches above the threshold for a query string in a list of candidates.
    public func findMatches(for query: String, in candidates: [String]) -> [(match: String, similarity: Double)] {
        candidates
            .map { (match: $0, similarity: similarity(from: query, to: $0)) }
            .filter { $0.similarity >= threshold }
            .sorted { $0.similarity > $1.similarity }
    }

    /// Finds the closest matches, sorted by similarity.
    public func closestMatches(for query: String, in candidates: [String], limit: Int? = nil) -> [(match: String, similarity: Double)] {
        let sorted = candidates
            .map { (match: $0, similarity: similarity(from: query, to: $0)) }
            .sorted { $0.similarity > $1.similarity }

        if let limit = limit {
            return Array(sorted.prefix(limit))
        }

        return sorted
    }
}

extension String {
    /// Checks if this string fuzzy matches another string.
    public func fuzzyMatches(_ other: String, threshold: Double = 0.7, algorithm: FuzzyMatcher.Algorithm = .jaroWinkler) -> Bool {
        FuzzyMatcher(algorithm: algorithm, threshold: threshold).matches(self, other)
    }

    /// Finds the best fuzzy match in a list of candidates.
    public func bestFuzzyMatch(in candidates: [String], algorithm: FuzzyMatcher.Algorithm = .jaroWinkler) -> (match: String, similarity: Double)? {
        FuzzyMatcher(algorithm: algorithm).bestMatch(for: self, in: candidates)
    }
}
