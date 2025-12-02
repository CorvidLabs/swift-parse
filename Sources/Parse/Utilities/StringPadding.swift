import Foundation

/// Text padding alignment options.
public enum PaddingAlignment: Sendable {
    case left
    case right
    case center
}

extension String {
    /// Pads the string to the specified width with the given character and alignment.
    public func padded(
        toWidth width: Int,
        with character: Character = " ",
        alignment: PaddingAlignment = .left
    ) -> String {
        guard count < width else { return self }

        let paddingCount = width - count

        switch alignment {
        case .left:
            return self + String(repeating: character, count: paddingCount)

        case .right:
            return String(repeating: character, count: paddingCount) + self

        case .center:
            let leftPadding = paddingCount / 2
            let rightPadding = paddingCount - leftPadding
            return String(repeating: character, count: leftPadding) + self + String(repeating: character, count: rightPadding)
        }
    }

    /// Pads the string on the left to the specified width.
    public func paddedLeft(toWidth width: Int, with character: Character = " ") -> String {
        padded(toWidth: width, with: character, alignment: .right)
    }

    /// Pads the string on the right to the specified width.
    public func paddedRight(toWidth width: Int, with character: Character = " ") -> String {
        padded(toWidth: width, with: character, alignment: .left)
    }

    /// Centers the string within the specified width.
    public func centered(inWidth width: Int, with character: Character = " ") -> String {
        padded(toWidth: width, with: character, alignment: .center)
    }
}
