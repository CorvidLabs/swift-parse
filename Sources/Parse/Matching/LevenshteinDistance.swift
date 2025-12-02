import Foundation

/// Calculates Levenshtein (edit) distance between strings.
public struct LevenshteinDistance: Sendable {
    /// Calculates the minimum edit distance between two strings.
    public static func calculate(from source: String, to target: String) -> Int {
        let sourceCount = source.count
        let targetCount = target.count

        guard sourceCount > 0 else { return targetCount }
        guard targetCount > 0 else { return sourceCount }

        let sourceArray = Array(source)
        let targetArray = Array(target)

        var previousRow = Array(0...targetCount)
        var currentRow = Array(repeating: 0, count: targetCount + 1)

        for i in 1...sourceCount {
            currentRow[0] = i

            for j in 1...targetCount {
                let cost = sourceArray[i - 1] == targetArray[j - 1] ? 0 : 1

                currentRow[j] = min(
                    previousRow[j] + 1,      // deletion
                    currentRow[j - 1] + 1,   // insertion
                    previousRow[j - 1] + cost // substitution
                )
            }

            swap(&previousRow, &currentRow)
        }

        return previousRow[targetCount]
    }

    /// Calculates the similarity ratio between two strings (0.0 to 1.0).
    public static func similarity(from source: String, to target: String) -> Double {
        let distance = calculate(from: source, to: target)
        let maxLength = max(source.count, target.count)
        guard maxLength > 0 else { return 1.0 }
        return 1.0 - Double(distance) / Double(maxLength)
    }
}

extension String {
    /// Calculates the Levenshtein distance to another string.
    public func levenshteinDistance(to other: String) -> Int {
        LevenshteinDistance.calculate(from: self, to: other)
    }

    /// Calculates the similarity ratio to another string (0.0 to 1.0).
    public func levenshteinSimilarity(to other: String) -> Double {
        LevenshteinDistance.similarity(from: self, to: other)
    }
}
