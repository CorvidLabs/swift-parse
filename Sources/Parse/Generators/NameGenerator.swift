import Foundation

/// Generates random names.
public struct NameGenerator: Sendable {
    /// The random source for generation.
    private var random: RandomSource

    /// Creates a name generator.
    public init(seed: UInt64? = nil) {
        self.random = seed.map { RandomSource(seed: $0) } ?? RandomSource()
    }

    /// Generates a random first name.
    public mutating func firstName() -> String {
        random.nextElement(from: FirstNames.names) ?? "John"
    }

    /// Generates a random last name.
    public mutating func lastName() -> String {
        random.nextElement(from: LastNames.names) ?? "Doe"
    }

    /// Generates a random full name.
    public mutating func fullName() -> String {
        "\(firstName()) \(lastName())"
    }

    /// Generates multiple random full names.
    public mutating func fullNames(count: Int) -> [String] {
        (0..<count).map { _ in fullName() }
    }

    /// Generates a random username from a name.
    public mutating func username(separator: String = ".") -> String {
        let first = firstName().lowercased()
        let last = lastName().lowercased()
        return "\(first)\(separator)\(last)"
    }

    /// Generates a random email address.
    public mutating func email(domain: String = "example.com") -> String {
        let username = username(separator: ".")
        return "\(username)@\(domain)"
    }

    /// Generates random initials.
    public mutating func initials() -> String {
        let first = firstName().prefix(1)
        let last = lastName().prefix(1)
        return "\(first)\(last)"
    }
}

extension String {
    /// Generates a random full name.
    public static func randomName(seed: UInt64? = nil) -> String {
        var generator = NameGenerator(seed: seed)
        return generator.fullName()
    }

    /// Generates a random email address.
    public static func randomEmail(domain: String = "example.com", seed: UInt64? = nil) -> String {
        var generator = NameGenerator(seed: seed)
        return generator.email(domain: domain)
    }
}
