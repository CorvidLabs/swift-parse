import Foundation

/// A simple template engine with variable interpolation.
public struct Template: Sendable {
    /// Template syntax options.
    public struct Syntax: Sendable {
        public let openDelimiter: String
        public let closeDelimiter: String

        public init(openDelimiter: String = "{{", closeDelimiter: String = "}}") {
            self.openDelimiter = openDelimiter
            self.closeDelimiter = closeDelimiter
        }

        public static let mustache = Syntax(openDelimiter: "{{", closeDelimiter: "}}")
        public static let dollar = Syntax(openDelimiter: "${", closeDelimiter: "}")
        public static let percent = Syntax(openDelimiter: "%{", closeDelimiter: "}")
    }

    /// The template text.
    public let text: String

    /// The template syntax.
    public let syntax: Syntax

    /// Creates a template with the given text and syntax.
    public init(_ text: String, syntax: Syntax = .mustache) {
        self.text = text
        self.syntax = syntax
    }

    /// Renders the template with the given context.
    public func render(with context: TemplateContext) -> String {
        var result = text
        let pattern = NSRegularExpression.escapedPattern(for: syntax.openDelimiter) +
                     "\\s*([a-zA-Z_][a-zA-Z0-9_]*)\\s*" +
                     NSRegularExpression.escapedPattern(for: syntax.closeDelimiter)

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return text
        }

        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range).reversed()

        for match in matches {
            guard match.numberOfRanges == 2,
                  let fullRange = Range(match.range(at: 0), in: text),
                  let nameRange = Range(match.range(at: 1), in: text) else {
                continue
            }

            let variableName = String(text[nameRange])
            let replacement = context.value(for: variableName) ?? ""
            result.replaceSubrange(fullRange, with: replacement)
        }

        return result
    }

    /// Renders the template with a dictionary of variables.
    public func render(with variables: [String: String]) -> String {
        render(with: TemplateContext(variables: variables))
    }

    /// Finds all variable names in the template.
    public var variableNames: [String] {
        let pattern = NSRegularExpression.escapedPattern(for: syntax.openDelimiter) +
                     "\\s*([a-zA-Z_][a-zA-Z0-9_]*)\\s*" +
                     NSRegularExpression.escapedPattern(for: syntax.closeDelimiter)

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        let range = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: range)

        return matches.compactMap { match in
            guard match.numberOfRanges == 2,
                  let nameRange = Range(match.range(at: 1), in: text) else {
                return nil
            }
            return String(text[nameRange])
        }
    }

    /// Validates that all variables in the template exist in the context.
    public func validate(with context: TemplateContext) -> [String] {
        variableNames.filter { context.value(for: $0) == nil }
    }
}

extension String {
    /// Renders the string as a template with the given context.
    public func renderTemplate(
        with context: TemplateContext,
        syntax: Template.Syntax = .mustache
    ) -> String {
        Template(self, syntax: syntax).render(with: context)
    }

    /// Renders the string as a template with the given variables.
    public func renderTemplate(
        with variables: [String: String],
        syntax: Template.Syntax = .mustache
    ) -> String {
        Template(self, syntax: syntax).render(with: variables)
    }
}
