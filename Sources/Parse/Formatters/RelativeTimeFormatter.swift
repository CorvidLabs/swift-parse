import Foundation

/// Formats time intervals as relative time strings.
public struct RelativeTimeFormatter: Sendable {
    /// The style of relative time formatting.
    public enum Style: Sendable {
        case short    // "2h ago"
        case medium   // "2 hours ago"
        case long     // "2 hours ago"
    }

    /// The formatting style.
    public let style: Style

    /// Creates a relative time formatter with the specified style.
    public init(style: Style = .medium) {
        self.style = style
    }

    /// Formats a date relative to now.
    public func format(_ date: Date, relativeTo now: Date = Date()) -> String {
        let interval = now.timeIntervalSince(date)
        return format(timeInterval: interval)
    }

    /// Formats a time interval as relative time.
    public func format(timeInterval: TimeInterval) -> String {
        let absInterval = abs(timeInterval)
        let isPast = timeInterval >= 0

        let (value, unit) = unit(for: absInterval)

        let formattedUnit = formatUnit(unit, value: value)
        let suffix = isPast ? "ago" : "from now"

        switch style {
        case .short:
            return isPast ? "\(value)\(shortUnit(unit))" : "in \(value)\(shortUnit(unit))"
        case .medium, .long:
            return isPast ? "\(value) \(formattedUnit) \(suffix)" : "in \(value) \(formattedUnit)"
        }
    }

    /// Determines the appropriate unit for a time interval.
    private func unit(for interval: TimeInterval) -> (value: Int, unit: String) {
        let seconds = Int(interval)

        if seconds < 60 {
            return (seconds, "second")
        } else if seconds < 3600 {
            return (seconds / 60, "minute")
        } else if seconds < 86400 {
            return (seconds / 3600, "hour")
        } else if seconds < 604800 {
            return (seconds / 86400, "day")
        } else if seconds < 2592000 {
            return (seconds / 604800, "week")
        } else if seconds < 31536000 {
            return (seconds / 2592000, "month")
        } else {
            return (seconds / 31536000, "year")
        }
    }

    /// Formats a unit name with proper pluralization.
    private func formatUnit(_ unit: String, value: Int) -> String {
        value == 1 ? unit : unit + "s"
    }

    /// Returns the short form of a unit.
    private func shortUnit(_ unit: String) -> String {
        switch unit {
        case "second": return "s"
        case "minute": return "m"
        case "hour": return "h"
        case "day": return "d"
        case "week": return "w"
        case "month": return "mo"
        case "year": return "y"
        default: return unit
        }
    }
}

extension Date {
    /// Returns a relative time string from now.
    public func relativeTime(style: RelativeTimeFormatter.Style = .medium) -> String {
        RelativeTimeFormatter(style: style).format(self)
    }

    /// Returns a relative time string from another date.
    public func relativeTime(to other: Date, style: RelativeTimeFormatter.Style = .medium) -> String {
        RelativeTimeFormatter(style: style).format(self, relativeTo: other)
    }
}

extension TimeInterval {
    /// Returns a relative time string for this interval.
    public func relativeTime(style: RelativeTimeFormatter.Style = .medium) -> String {
        RelativeTimeFormatter(style: style).format(timeInterval: self)
    }
}
