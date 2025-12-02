import Foundation

/// Handles escape sequences in strings.
public struct EscapeSequences: Sendable {
    /// Escapes special characters in a string.
    public static func escape(_ string: String) -> String {
        var result = ""

        for char in string {
            switch char {
            case "\n":
                result += "\\n"
            case "\r":
                result += "\\r"
            case "\t":
                result += "\\t"
            case "\\":
                result += "\\\\"
            case "\"":
                result += "\\\""
            case "\'":
                result += "\\\'"
            case "\u{0008}": // backspace
                result += "\\b"
            case "\u{000C}": // form feed
                result += "\\f"
            default:
                if char.isASCII && char.isPrintable {
                    result.append(char)
                } else {
                    // Escape non-printable characters as Unicode
                    let scalar = char.unicodeScalars.first!
                    result += String(format: "\\u{%04X}", scalar.value)
                }
            }
        }

        return result
    }

    /// Unescapes escape sequences in a string.
    public static func unescape(_ string: String) -> String {
        var result = ""
        let chars = Array(string)
        var i = 0

        while i < chars.count {
            if chars[i] == "\\" && i + 1 < chars.count {
                i += 1
                switch chars[i] {
                case "n":
                    result.append("\n")
                case "r":
                    result.append("\r")
                case "t":
                    result.append("\t")
                case "\\":
                    result.append("\\")
                case "\"":
                    result.append("\"")
                case "'":
                    result.append("'")
                case "b":
                    result.append("\u{0008}")
                case "f":
                    result.append("\u{000C}")
                case "u":
                    // Handle Unicode escape sequences \u{XXXX}
                    if i + 1 < chars.count && chars[i + 1] == "{" {
                        i += 2
                        var hexString = ""
                        while i < chars.count && chars[i] != "}" {
                            hexString.append(chars[i])
                            i += 1
                        }
                        if let value = UInt32(hexString, radix: 16),
                           let scalar = UnicodeScalar(value) {
                            result.append(Character(scalar))
                        }
                    }
                default:
                    result.append(chars[i])
                }
            } else {
                result.append(chars[i])
            }
            i += 1
        }

        return result
    }
}

extension String {
    /// Escapes special characters in the string.
    public var escaped: String {
        EscapeSequences.escape(self)
    }

    /// Unescapes escape sequences in the string.
    public var unescaped: String {
        EscapeSequences.unescape(self)
    }
}

extension Character {
    /// Returns true if the character is printable.
    fileprivate var isPrintable: Bool {
        let scalar = unicodeScalars.first!
        return scalar.value >= 0x20 && scalar.value != 0x7F
    }
}
