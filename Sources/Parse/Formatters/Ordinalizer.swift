import Foundation

/// Converts numbers to ordinal form (1st, 2nd, 3rd, etc.).
public struct Ordinalizer: Sendable {
    /// Returns the ordinal suffix for a number.
    public static func suffix(for number: Int) -> String {
        let absNumber = abs(number)
        let lastTwoDigits = absNumber % 100
        let lastDigit = absNumber % 10

        if (11...13).contains(lastTwoDigits) {
            return "th"
        }

        switch lastDigit {
        case 1:
            return "st"
        case 2:
            return "nd"
        case 3:
            return "rd"
        default:
            return "th"
        }
    }

    /// Converts a number to its ordinal form.
    public static func ordinalize(_ number: Int) -> String {
        "\(number)\(suffix(for: number))"
    }

    /// Converts a number to its spelled-out ordinal form.
    public static func ordinalWord(for number: Int) -> String? {
        guard (1...20).contains(number) else { return nil }

        let words = [
            "first", "second", "third", "fourth", "fifth",
            "sixth", "seventh", "eighth", "ninth", "tenth",
            "eleventh", "twelfth", "thirteenth", "fourteenth", "fifteenth",
            "sixteenth", "seventeenth", "eighteenth", "nineteenth", "twentieth"
        ]

        return words[number - 1]
    }
}

extension Int {
    /// Returns the ordinal suffix for this number.
    public var ordinalSuffix: String {
        Ordinalizer.suffix(for: self)
    }

    /// Returns the ordinal form of this number (e.g., "1st", "2nd").
    public var ordinalized: String {
        Ordinalizer.ordinalize(self)
    }

    /// Returns the spelled-out ordinal form (e.g., "first", "second").
    public var ordinalWord: String? {
        Ordinalizer.ordinalWord(for: self)
    }
}
