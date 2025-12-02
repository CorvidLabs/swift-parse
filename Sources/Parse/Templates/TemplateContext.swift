import Foundation

/// A context for template variable substitution.
public struct TemplateContext: Sendable {
    /// The variables available in the context.
    private let variables: [String: String]

    /// Creates a template context with the given variables.
    public init(variables: [String: String] = [:]) {
        self.variables = variables
    }

    /// Retrieves a variable value by name.
    public func value(for name: String) -> String? {
        variables[name]
    }

    /// Creates a new context with additional variables.
    public func merging(_ other: [String: String]) -> TemplateContext {
        TemplateContext(variables: variables.merging(other) { _, new in new })
    }

    /// Creates a new context with an additional variable.
    public func setting(_ name: String, to value: String) -> TemplateContext {
        var newVariables = variables
        newVariables[name] = value
        return TemplateContext(variables: newVariables)
    }

    /// All variable names in the context.
    public var variableNames: [String] {
        Array(variables.keys)
    }
}

extension TemplateContext: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self.variables = Dictionary(uniqueKeysWithValues: elements)
    }
}
