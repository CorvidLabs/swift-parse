import Foundation

/// Errors that can occur in the Text framework.
public enum TextError: Error, Sendable, CustomStringConvertible {
    case invalidInput(String)
    case invalidPattern(String)
    case invalidFormat(String)
    case parsingFailed(String)
    case encodingFailed(String)
    case decodingFailed(String)
    case outOfBounds(String)

    public var description: String {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .invalidPattern(let message):
            return "Invalid pattern: \(message)"
        case .invalidFormat(let message):
            return "Invalid format: \(message)"
        case .parsingFailed(let message):
            return "Parsing failed: \(message)"
        case .encodingFailed(let message):
            return "Encoding failed: \(message)"
        case .decodingFailed(let message):
            return "Decoding failed: \(message)"
        case .outOfBounds(let message):
            return "Out of bounds: \(message)"
        }
    }
}
