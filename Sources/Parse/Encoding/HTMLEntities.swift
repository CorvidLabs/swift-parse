import Foundation

/// Encodes and decodes HTML entities.
public struct HTMLEntities: Sendable {
    /// Whether to encode all characters or only essential ones.
    public let encodeAll: Bool

    /// Creates an HTML entity encoder/decoder.
    public init(encodeAll: Bool = false) {
        self.encodeAll = encodeAll
    }

    /// Encodes special characters as HTML entities.
    public func encode(_ string: String) -> String {
        var result = ""

        for char in string {
            let charString = String(char)

            if encodeAll, let entity = HTMLEntityMap.entities[charString] {
                result += entity
            } else if isEssentialEntity(charString) {
                result += HTMLEntityMap.entities[charString] ?? charString
            } else {
                result += charString
            }
        }

        return result
    }

    /// Decodes HTML entities to characters.
    public func decode(_ string: String) -> String {
        var result = string

        // Decode named entities
        for (entity, char) in HTMLEntityMap.reverseMap {
            result = result.replacingOccurrences(of: entity, with: char)
        }

        // Decode numeric entities (&#123; or &#x7B;)
        let numericPattern = "&#(x?)([0-9a-fA-F]+);"
        if let regex = try? NSRegularExpression(pattern: numericPattern) {
            let range = NSRange(result.startIndex..., in: result)
            let matches = regex.matches(in: result, range: range).reversed()

            for match in matches {
                guard match.numberOfRanges == 3,
                      let isHexRange = Range(match.range(at: 1), in: result),
                      let numberRange = Range(match.range(at: 2), in: result),
                      let fullRange = Range(match.range(at: 0), in: result) else {
                    continue
                }

                let isHex = !result[isHexRange].isEmpty
                let numberString = String(result[numberRange])

                if let code = Int(numberString, radix: isHex ? 16 : 10),
                   let scalar = UnicodeScalar(code) {
                    result.replaceSubrange(fullRange, with: String(Character(scalar)))
                }
            }
        }

        return result
    }

    /// Checks if a character should always be encoded.
    private func isEssentialEntity(_ char: String) -> Bool {
        ["&", "<", ">", "\"", "'"].contains(char)
    }
}

extension String {
    /// Encodes HTML entities in the string.
    public var htmlEncoded: String {
        HTMLEntities().encode(self)
    }

    /// Decodes HTML entities in the string.
    public var htmlDecoded: String {
        HTMLEntities().decode(self)
    }

    /// Encodes all special characters as HTML entities.
    public var htmlEncodedAll: String {
        HTMLEntities(encodeAll: true).encode(self)
    }
}
