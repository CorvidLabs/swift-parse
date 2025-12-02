import Foundation

/// Wraps text to fit within a specified width.
public struct WordWrapper: Sendable {
    /// The maximum width for wrapped text.
    public let width: Int

    /// Whether to break words that exceed the width.
    public let breakWords: Bool

    /// Creates a word wrapper with the specified configuration.
    public init(width: Int, breakWords: Bool = false) {
        self.width = width
        self.breakWords = breakWords
    }

    /// Wraps the given text to the configured width.
    public func wrap(_ text: String) -> String {
        let lines = text.split(separator: "\n", omittingEmptySubsequences: false)
        return lines.map { wrapLine(String($0)) }.joined(separator: "\n")
    }

    /// Wraps a single line of text.
    private func wrapLine(_ line: String) -> String {
        guard !line.isEmpty else { return "" }

        let words = line.split(separator: " ", omittingEmptySubsequences: false).map(String.init)
        var wrappedLines: [String] = []
        var currentLine = ""

        for word in words {
            let testLine = currentLine.isEmpty ? word : currentLine + " " + word

            if testLine.count <= width {
                currentLine = testLine
            } else if word.count > width && breakWords {
                // Break the word if it's too long and breakWords is enabled
                if !currentLine.isEmpty {
                    wrappedLines.append(currentLine)
                }
                wrappedLines.append(contentsOf: breakWord(word))
                currentLine = ""
            } else {
                if !currentLine.isEmpty {
                    wrappedLines.append(currentLine)
                }
                currentLine = word
            }
        }

        if !currentLine.isEmpty {
            wrappedLines.append(currentLine)
        }

        return wrappedLines.joined(separator: "\n")
    }

    /// Breaks a long word into chunks that fit the width.
    private func breakWord(_ word: String) -> [String] {
        var chunks: [String] = []
        var remaining = word

        while !remaining.isEmpty {
            let endIndex = remaining.index(
                remaining.startIndex,
                offsetBy: min(width, remaining.count)
            )
            chunks.append(String(remaining[..<endIndex]))
            remaining = String(remaining[endIndex...])
        }

        return chunks
    }
}

extension String {
    /// Wraps the string to the specified width.
    public func wrapped(toWidth width: Int, breakWords: Bool = false) -> String {
        WordWrapper(width: width, breakWords: breakWords).wrap(self)
    }
}
