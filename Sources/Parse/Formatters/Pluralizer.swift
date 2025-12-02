import Foundation

/// Converts words between singular and plural forms.
public struct Pluralizer: Sendable {
    /// Converts a singular word to its plural form.
    public static func pluralize(_ word: String) -> String {
        guard !word.isEmpty else { return word }

        let lowercased = word.lowercased()

        // Check for irregular plurals
        if let irregular = IrregularPlurals.plurals[lowercased] {
            return preserveCase(original: word, transformed: irregular)
        }

        // Apply rules
        if lowercased.hasSuffix("s") || lowercased.hasSuffix("ss") ||
           lowercased.hasSuffix("sh") || lowercased.hasSuffix("ch") ||
           lowercased.hasSuffix("x") || lowercased.hasSuffix("z") {
            return word + "es"
        }

        if lowercased.hasSuffix("y") {
            let beforeY = lowercased.dropLast()
            if !beforeY.isEmpty && !"aeiou".contains(beforeY.last!) {
                return String(word.dropLast()) + "ies"
            }
        }

        if lowercased.hasSuffix("f") {
            return String(word.dropLast()) + "ves"
        }

        if lowercased.hasSuffix("fe") {
            return String(word.dropLast(2)) + "ves"
        }

        if lowercased.hasSuffix("o") {
            let beforeO = lowercased.dropLast()
            if !beforeO.isEmpty && !"aeiou".contains(beforeO.last!) {
                return word + "es"
            }
        }

        return word + "s"
    }

    /// Pluralizes a word if the count is not 1.
    public static func pluralize(_ word: String, count: Int) -> String {
        count == 1 ? word : pluralize(word)
    }

    /// Returns a formatted string with count and plural form.
    public static func quantify(_ word: String, count: Int) -> String {
        let pluralized = pluralize(word, count: count)
        return "\(count) \(pluralized)"
    }

    /// Preserves the case of the original word in the transformed word.
    private static func preserveCase(original: String, transformed: String) -> String {
        guard !original.isEmpty else { return transformed }

        if original.allSatisfy({ $0.isUppercase }) {
            return transformed.uppercased()
        }

        if original.first?.isUppercase == true {
            return transformed.prefix(1).uppercased() + transformed.dropFirst()
        }

        return transformed
    }
}

extension String {
    /// Returns the plural form of the string.
    public var pluralized: String {
        Pluralizer.pluralize(self)
    }

    /// Pluralizes the string if the count is not 1.
    public func pluralized(count: Int) -> String {
        Pluralizer.pluralize(self, count: count)
    }

    /// Returns a formatted string with count and plural form.
    public func quantified(count: Int) -> String {
        Pluralizer.quantify(self, count: count)
    }
}
