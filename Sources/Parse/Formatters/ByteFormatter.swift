import Foundation

/// Formats byte counts into human-readable strings.
public struct ByteFormatter: Sendable {
    /// The unit system to use for formatting.
    public enum UnitSystem: Sendable {
        case binary   // 1024 bytes = 1 KiB
        case decimal  // 1000 bytes = 1 KB
    }

    /// The unit system.
    public let unitSystem: UnitSystem

    /// The number of decimal places.
    public let decimalPlaces: Int

    /// Creates a byte formatter with the specified configuration.
    public init(unitSystem: UnitSystem = .binary, decimalPlaces: Int = 2) {
        self.unitSystem = unitSystem
        self.decimalPlaces = decimalPlaces
    }

    /// Formats a byte count as a human-readable string.
    public func format(_ bytes: Int64) -> String {
        let units: [String]
        let divisor: Double

        switch unitSystem {
        case .binary:
            units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"]
            divisor = 1024
        case .decimal:
            units = ["B", "KB", "MB", "GB", "TB", "PB", "EB"]
            divisor = 1000
        }

        var value = Double(bytes)
        var unitIndex = 0

        while value >= divisor && unitIndex < units.count - 1 {
            value /= divisor
            unitIndex += 1
        }

        let formatString = unitIndex == 0 ? "%.0f %@" : "%.\(decimalPlaces)f %@"
        return String(format: formatString, value, units[unitIndex])
    }

    /// Formats a byte count with a specific unit.
    public func format(_ bytes: Int64, unit: String) -> String {
        let units: [String]
        let divisor: Double

        switch unitSystem {
        case .binary:
            units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"]
            divisor = 1024
        case .decimal:
            units = ["B", "KB", "MB", "GB", "TB", "PB", "EB"]
            divisor = 1000
        }

        guard let unitIndex = units.firstIndex(of: unit) else {
            return format(bytes)
        }

        let value = Double(bytes) / pow(divisor, Double(unitIndex))
        let formatString = unitIndex == 0 ? "%.0f %@" : "%.\(decimalPlaces)f %@"
        return String(format: formatString, value, unit)
    }
}

extension Int64 {
    /// Formats the byte count as a human-readable string.
    public func formattedBytes(
        unitSystem: ByteFormatter.UnitSystem = .binary,
        decimalPlaces: Int = 2
    ) -> String {
        ByteFormatter(unitSystem: unitSystem, decimalPlaces: decimalPlaces).format(self)
    }
}

extension Int {
    /// Formats the byte count as a human-readable string.
    public func formattedBytes(
        unitSystem: ByteFormatter.UnitSystem = .binary,
        decimalPlaces: Int = 2
    ) -> String {
        Int64(self).formattedBytes(unitSystem: unitSystem, decimalPlaces: decimalPlaces)
    }
}
