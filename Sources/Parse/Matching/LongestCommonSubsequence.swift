import Foundation

/// Finds the longest common subsequence between strings.
public struct LongestCommonSubsequence: Sendable {
    /// Calculates the length of the longest common subsequence.
    public static func length(of first: String, and second: String) -> Int {
        let firstArray = Array(first)
        let secondArray = Array(second)
        let m = firstArray.count
        let n = secondArray.count

        guard m > 0 && n > 0 else { return 0 }

        var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

        for i in 1...m {
            for j in 1...n {
                if firstArray[i - 1] == secondArray[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1] + 1
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
                }
            }
        }

        return dp[m][n]
    }

    /// Finds the actual longest common subsequence.
    public static func find(in first: String, and second: String) -> String {
        let firstArray = Array(first)
        let secondArray = Array(second)
        let m = firstArray.count
        let n = secondArray.count

        guard m > 0 && n > 0 else { return "" }

        var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

        for i in 1...m {
            for j in 1...n {
                if firstArray[i - 1] == secondArray[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1] + 1
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
                }
            }
        }

        // Backtrack to find the actual subsequence
        var result: [Character] = []
        var i = m
        var j = n

        while i > 0 && j > 0 {
            if firstArray[i - 1] == secondArray[j - 1] {
                result.insert(firstArray[i - 1], at: 0)
                i -= 1
                j -= 1
            } else if dp[i - 1][j] > dp[i][j - 1] {
                i -= 1
            } else {
                j -= 1
            }
        }

        return String(result)
    }

    /// Calculates the LCS similarity ratio (0.0 to 1.0).
    public static func similarity(of first: String, and second: String) -> Double {
        let lcsLength = length(of: first, and: second)
        let maxLength = max(first.count, second.count)
        guard maxLength > 0 else { return 1.0 }
        return Double(lcsLength) / Double(maxLength)
    }
}

extension String {
    /// Finds the longest common subsequence with another string.
    public func longestCommonSubsequence(with other: String) -> String {
        LongestCommonSubsequence.find(in: self, and: other)
    }

    /// Calculates the LCS length with another string.
    public func longestCommonSubsequenceLength(with other: String) -> Int {
        LongestCommonSubsequence.length(of: self, and: other)
    }

    /// Calculates the LCS similarity ratio with another string (0.0 to 1.0).
    public func lcsSimilarity(to other: String) -> Double {
        LongestCommonSubsequence.similarity(of: self, and: other)
    }
}
