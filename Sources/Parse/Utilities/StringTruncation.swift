import Foundation

/// Text truncation position options.
public enum TruncationPosition: Sendable {
    case start
    case middle
    case end
}

extension String {
    /// Truncates the string to the specified length with an ellipsis indicator.
    public func truncated(
        toLength length: Int,
        position: TruncationPosition = .end,
        ellipsis: String = "..."
    ) -> String {
        guard count > length else { return self }
        guard length > ellipsis.count else { return String(ellipsis.prefix(length)) }

        let availableLength = length - ellipsis.count

        switch position {
        case .end:
            let endIndex = index(startIndex, offsetBy: availableLength)
            return String(self[..<endIndex]) + ellipsis

        case .start:
            let startIndex = index(endIndex, offsetBy: -availableLength)
            return ellipsis + String(self[startIndex...])

        case .middle:
            let leftLength = availableLength / 2
            let rightLength = availableLength - leftLength

            let leftEnd = index(startIndex, offsetBy: leftLength)
            let rightStart = index(endIndex, offsetBy: -rightLength)

            return String(self[..<leftEnd]) + ellipsis + String(self[rightStart...])
        }
    }

    /// Truncates the string at the end with an ellipsis.
    public func truncatedAtEnd(toLength length: Int, ellipsis: String = "...") -> String {
        truncated(toLength: length, position: .end, ellipsis: ellipsis)
    }

    /// Truncates the string at the start with an ellipsis.
    public func truncatedAtStart(toLength length: Int, ellipsis: String = "...") -> String {
        truncated(toLength: length, position: .start, ellipsis: ellipsis)
    }

    /// Truncates the string in the middle with an ellipsis.
    public func truncatedInMiddle(toLength length: Int, ellipsis: String = "...") -> String {
        truncated(toLength: length, position: .middle, ellipsis: ellipsis)
    }
}
