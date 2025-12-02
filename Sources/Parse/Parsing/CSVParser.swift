import Foundation

/// Parses CSV (Comma-Separated Values) text.
public struct CSVParser: Sendable {
    /// CSV parsing options.
    public struct Options: Sendable {
        public let delimiter: Character
        public let quote: Character
        public let escape: Character
        public let hasHeaderRow: Bool
        public let trimWhitespace: Bool

        public init(
            delimiter: Character = ",",
            quote: Character = "\"",
            escape: Character = "\\",
            hasHeaderRow: Bool = true,
            trimWhitespace: Bool = true
        ) {
            self.delimiter = delimiter
            self.quote = quote
            self.escape = escape
            self.hasHeaderRow = hasHeaderRow
            self.trimWhitespace = trimWhitespace
        }

        public static let `default` = Options()
    }

    /// A parsed CSV row.
    public struct Row: Sendable {
        public let values: [String]

        public init(values: [String]) {
            self.values = values
        }

        public subscript(index: Int) -> String? {
            guard index >= 0 && index < values.count else { return nil }
            return values[index]
        }
    }

    /// Parsed CSV data.
    public struct Data: Sendable {
        public let headers: [String]?
        public let rows: [Row]

        public init(headers: [String]? = nil, rows: [Row]) {
            self.headers = headers
            self.rows = rows
        }

        public var count: Int { rows.count }

        public subscript(index: Int) -> Row? {
            guard index >= 0 && index < rows.count else { return nil }
            return rows[index]
        }
    }

    /// The parsing options.
    public let options: Options

    /// Creates a CSV parser with the specified options.
    public init(options: Options = .default) {
        self.options = options
    }

    /// Parses CSV text.
    public func parse(_ text: String) throws -> Data {
        let lines = text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        var rows: [Row] = []
        var headers: [String]?

        for (index, line) in lines.enumerated() {
            guard !line.isEmpty else { continue }

            let values = try parseLine(line)

            if options.hasHeaderRow && index == 0 {
                headers = values
            } else {
                rows.append(Row(values: values))
            }
        }

        return Data(headers: headers, rows: rows)
    }

    /// Parses a single CSV line.
    private func parseLine(_ line: String) throws -> [String] {
        var values: [String] = []
        var currentValue = ""
        var inQuotes = false
        var escaped = false

        for char in line {
            if escaped {
                currentValue.append(char)
                escaped = false
            } else if char == options.escape {
                escaped = true
            } else if char == options.quote {
                inQuotes.toggle()
            } else if char == options.delimiter && !inQuotes {
                values.append(options.trimWhitespace ? currentValue.trimmingCharacters(in: .whitespaces) : currentValue)
                currentValue = ""
            } else {
                currentValue.append(char)
            }
        }

        values.append(options.trimWhitespace ? currentValue.trimmingCharacters(in: .whitespaces) : currentValue)

        return values
    }

    /// Formats data as CSV text.
    public func format(_ data: Data) -> String {
        var lines: [String] = []

        if let headers = data.headers {
            lines.append(formatRow(headers))
        }

        for row in data.rows {
            lines.append(formatRow(row.values))
        }

        return lines.joined(separator: "\n")
    }

    /// Formats a row of values as CSV.
    private func formatRow(_ values: [String]) -> String {
        values.map { formatValue($0) }.joined(separator: String(options.delimiter))
    }

    /// Formats a single value, adding quotes if necessary.
    private func formatValue(_ value: String) -> String {
        let needsQuotes = value.contains(options.delimiter) ||
                         value.contains(options.quote) ||
                         value.contains("\n")

        if needsQuotes {
            let escaped = value.replacingOccurrences(
                of: String(options.quote),
                with: "\(options.escape)\(options.quote)"
            )
            return "\(options.quote)\(escaped)\(options.quote)"
        }

        return value
    }
}

extension String {
    /// Parses the string as CSV.
    public func parseCSV(options: CSVParser.Options = .default) throws -> CSVParser.Data {
        try CSVParser(options: options).parse(self)
    }
}
