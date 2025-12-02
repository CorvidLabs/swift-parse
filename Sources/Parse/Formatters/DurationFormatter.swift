import Foundation

/// Formats time durations into human-readable strings.
public struct DurationFormatter: Sendable {
    /// The style of duration formatting.
    public enum Style: Sendable {
        case short      // "2h 30m"
        case medium     // "2 hours 30 minutes"
        case long       // "2 hours, 30 minutes"
        case compact    // "2:30:00"
    }

    /// The formatting style.
    public let style: Style

    /// Whether to include zero components.
    public let includeZeroComponents: Bool

    /// Creates a duration formatter with the specified configuration.
    public init(style: Style = .medium, includeZeroComponents: Bool = false) {
        self.style = style
        self.includeZeroComponents = includeZeroComponents
    }

    /// Formats a time interval as a duration string.
    public func format(_ timeInterval: TimeInterval) -> String {
        let seconds = Int(abs(timeInterval))

        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60

        switch style {
        case .compact:
            return String(format: "%d:%02d:%02d", hours, minutes, secs)

        case .short:
            return formatComponents(
                hours: hours,
                minutes: minutes,
                seconds: secs,
                hourUnit: "h",
                minuteUnit: "m",
                secondUnit: "s",
                separator: " "
            )

        case .medium:
            return formatComponents(
                hours: hours,
                minutes: minutes,
                seconds: secs,
                hourUnit: "hour",
                minuteUnit: "minute",
                secondUnit: "second",
                separator: " ",
                pluralize: true
            )

        case .long:
            return formatComponents(
                hours: hours,
                minutes: minutes,
                seconds: secs,
                hourUnit: "hour",
                minuteUnit: "minute",
                secondUnit: "second",
                separator: ", ",
                pluralize: true
            )
        }
    }

    /// Formats individual time components.
    private func formatComponents(
        hours: Int,
        minutes: Int,
        seconds: Int,
        hourUnit: String,
        minuteUnit: String,
        secondUnit: String,
        separator: String,
        pluralize: Bool = false
    ) -> String {
        var components: [String] = []

        if hours > 0 || includeZeroComponents {
            let unit = pluralize ? pluralizeUnit(hourUnit, count: hours) : hourUnit
            components.append("\(hours) \(unit)")
        }

        if minutes > 0 || (includeZeroComponents && hours > 0) {
            let unit = pluralize ? pluralizeUnit(minuteUnit, count: minutes) : minuteUnit
            components.append("\(minutes) \(unit)")
        }

        if seconds > 0 || components.isEmpty || includeZeroComponents {
            let unit = pluralize ? pluralizeUnit(secondUnit, count: seconds) : secondUnit
            components.append("\(seconds) \(unit)")
        }

        return components.joined(separator: separator)
    }

    /// Pluralizes a unit name based on count.
    private func pluralizeUnit(_ unit: String, count: Int) -> String {
        count == 1 ? unit : unit + "s"
    }
}

extension TimeInterval {
    /// Formats the time interval as a duration string.
    public func formattedDuration(
        style: DurationFormatter.Style = .medium,
        includeZeroComponents: Bool = false
    ) -> String {
        DurationFormatter(style: style, includeZeroComponents: includeZeroComponents).format(self)
    }
}

extension Int {
    /// Formats the number of seconds as a duration string.
    public func formattedDuration(
        style: DurationFormatter.Style = .medium,
        includeZeroComponents: Bool = false
    ) -> String {
        TimeInterval(self).formattedDuration(style: style, includeZeroComponents: includeZeroComponents)
    }
}
