import Foundation

/// Encodes and decodes URL percent encoding.
public struct URLEncoder: Sendable {
    /// The character set to encode.
    public let allowedCharacters: CharacterSet

    /// Creates a URL encoder with the specified allowed characters.
    public init(allowedCharacters: CharacterSet = .urlQueryAllowed) {
        self.allowedCharacters = allowedCharacters
    }

    /// Encodes a string for use in URLs.
    public func encode(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? string
    }

    /// Decodes a percent-encoded URL string.
    public func decode(_ encoded: String) -> String {
        encoded.removingPercentEncoding ?? encoded
    }

    /// Encodes query parameters as a URL query string.
    public func encodeQueryParameters(_ parameters: [String: String]) -> String {
        parameters
            .map { key, value in
                let encodedKey = encode(key)
                let encodedValue = encode(value)
                return "\(encodedKey)=\(encodedValue)"
            }
            .joined(separator: "&")
    }

    /// Decodes a URL query string into parameters.
    public func decodeQueryString(_ queryString: String) -> [String: String] {
        var parameters: [String: String] = [:]

        let pairs = queryString.split(separator: "&")
        for pair in pairs {
            let components = pair.split(separator: "=", maxSplits: 1)
            if components.count == 2 {
                let key = decode(String(components[0]))
                let value = decode(String(components[1]))
                parameters[key] = value
            }
        }

        return parameters
    }
}

extension String {
    /// Encodes the string for use in URLs.
    public var urlEncoded: String {
        URLEncoder().encode(self)
    }

    /// Decodes the percent-encoded URL string.
    public var urlDecoded: String {
        URLEncoder().decode(self)
    }

    /// Encodes the string for use in URL paths.
    public var urlPathEncoded: String {
        URLEncoder(allowedCharacters: .urlPathAllowed).encode(self)
    }

    /// Encodes the string for use in URL query parameters.
    public var urlQueryEncoded: String {
        URLEncoder(allowedCharacters: .urlQueryAllowed).encode(self)
    }

    /// Encodes the string for use in URL fragments.
    public var urlFragmentEncoded: String {
        URLEncoder(allowedCharacters: .urlFragmentAllowed).encode(self)
    }
}

extension Dictionary where Key == String, Value == String {
    /// Converts the dictionary to a URL query string.
    public var queryString: String {
        URLEncoder().encodeQueryParameters(self)
    }
}
