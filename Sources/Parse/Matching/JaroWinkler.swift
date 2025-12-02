import Foundation

/// Calculates Jaro and Jaro-Winkler similarity between strings.
public struct JaroWinkler: Sendable {
    /// The scaling factor for the Jaro-Winkler algorithm (default: 0.1).
    public let scalingFactor: Double

    /// The maximum prefix length to consider (default: 4).
    public let maxPrefixLength: Int

    /// Creates a Jaro-Winkler calculator with the specified parameters.
    public init(scalingFactor: Double = 0.1, maxPrefixLength: Int = 4) {
        self.scalingFactor = scalingFactor
        self.maxPrefixLength = maxPrefixLength
    }

    /// Calculates the Jaro similarity between two strings (0.0 to 1.0).
    public func jaroSimilarity(from first: String, to second: String) -> Double {
        guard !first.isEmpty && !second.isEmpty else {
            return first.isEmpty && second.isEmpty ? 1.0 : 0.0
        }

        let firstArray = Array(first)
        let secondArray = Array(second)
        let maxDistance = max(firstArray.count, secondArray.count) / 2 - 1

        guard maxDistance >= 0 else { return 1.0 }

        var firstMatches = Array(repeating: false, count: firstArray.count)
        var secondMatches = Array(repeating: false, count: secondArray.count)
        var matches = 0
        var transpositions = 0

        // Find matches
        for i in 0..<firstArray.count {
            let start = max(0, i - maxDistance)
            let end = min(i + maxDistance + 1, secondArray.count)

            for j in start..<end {
                if secondMatches[j] || firstArray[i] != secondArray[j] {
                    continue
                }

                firstMatches[i] = true
                secondMatches[j] = true
                matches += 1
                break
            }
        }

        guard matches > 0 else { return 0.0 }

        // Count transpositions
        var k = 0
        for i in 0..<firstArray.count {
            if !firstMatches[i] { continue }

            while !secondMatches[k] { k += 1 }

            if firstArray[i] != secondArray[k] {
                transpositions += 1
            }

            k += 1
        }

        let m = Double(matches)
        let t = Double(transpositions) / 2.0

        return (m / Double(firstArray.count) + m / Double(secondArray.count) + (m - t) / m) / 3.0
    }

    /// Calculates the Jaro-Winkler similarity between two strings (0.0 to 1.0).
    public func similarity(from first: String, to second: String) -> Double {
        let jaroScore = jaroSimilarity(from: first, to: second)

        let firstArray = Array(first)
        let secondArray = Array(second)
        let prefixLength = commonPrefixLength(firstArray, secondArray, maxLength: maxPrefixLength)

        return jaroScore + (Double(prefixLength) * scalingFactor * (1.0 - jaroScore))
    }

    /// Finds the length of the common prefix.
    private func commonPrefixLength(_ first: [Character], _ second: [Character], maxLength: Int) -> Int {
        let length = min(min(first.count, second.count), maxLength)
        var count = 0

        for i in 0..<length {
            if first[i] == second[i] {
                count += 1
            } else {
                break
            }
        }

        return count
    }
}

extension String {
    /// Calculates the Jaro similarity to another string (0.0 to 1.0).
    public func jaroSimilarity(to other: String) -> Double {
        JaroWinkler().jaroSimilarity(from: self, to: other)
    }

    /// Calculates the Jaro-Winkler similarity to another string (0.0 to 1.0).
    public func jaroWinklerSimilarity(to other: String) -> Double {
        JaroWinkler().similarity(from: self, to: other)
    }
}
