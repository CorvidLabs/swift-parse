import Foundation

/// Encodes and decodes Base64 strings.
public struct Base64Codec: Sendable {
    /// Base64 encoding options.
    public enum EncodingOptions: Sendable {
        case standard
        case urlSafe
    }

    /// The encoding options.
    public let options: EncodingOptions

    /// Creates a Base64 codec with the specified options.
    public init(options: EncodingOptions = .standard) {
        self.options = options
    }

    /// Encodes a string to Base64.
    public func encode(_ string: String) -> String {
        guard let data = string.data(using: .utf8) else { return "" }
        return encode(data)
    }

    /// Encodes data to Base64.
    public func encode(_ data: Data) -> String {
        var encoded = data.base64EncodedString()

        if options == .urlSafe {
            encoded = encoded
                .replacingOccurrences(of: "+", with: "-")
                .replacingOccurrences(of: "/", with: "_")
                .replacingOccurrences(of: "=", with: "")
        }

        return encoded
    }

    /// Decodes a Base64 string.
    public func decode(_ encoded: String) throws -> String {
        let data = try decodeToData(encoded)
        guard let string = String(data: data, encoding: .utf8) else {
            throw TextError.decodingFailed("Invalid UTF-8 data")
        }
        return string
    }

    /// Decodes a Base64 string to Data.
    public func decodeToData(_ encoded: String) throws -> Data {
        var base64 = encoded

        if options == .urlSafe {
            base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")

            // Add padding if needed
            let paddingLength = (4 - base64.count % 4) % 4
            base64 += String(repeating: "=", count: paddingLength)
        }

        guard let data = Data(base64Encoded: base64) else {
            throw TextError.decodingFailed("Invalid Base64 string")
        }

        return data
    }
}

extension String {
    /// Encodes the string to Base64.
    public var base64Encoded: String {
        Base64Codec().encode(self)
    }

    /// Decodes the Base64 string.
    public var base64Decoded: String? {
        try? Base64Codec().decode(self)
    }

    /// Encodes the string to URL-safe Base64.
    public var urlSafeBase64Encoded: String {
        Base64Codec(options: .urlSafe).encode(self)
    }

    /// Decodes the URL-safe Base64 string.
    public var urlSafeBase64Decoded: String? {
        try? Base64Codec(options: .urlSafe).decode(self)
    }
}
