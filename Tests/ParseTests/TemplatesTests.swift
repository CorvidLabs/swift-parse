import XCTest
@testable import Parse

final class TemplatesTests: XCTestCase {

    // MARK: - TemplateContext Tests

    func testTemplateContextBasic() {
        let context = TemplateContext(variables: ["name": "Alice", "age": "30"])

        XCTAssertEqual(context.value(for: "name"), "Alice")
        XCTAssertEqual(context.value(for: "age"), "30")
        XCTAssertNil(context.value(for: "missing"))
    }

    func testTemplateContextMerging() {
        let context1 = TemplateContext(variables: ["a": "1", "b": "2"])
        let context2 = context1.merging(["c": "3", "a": "4"])

        XCTAssertEqual(context2.value(for: "a"), "4")
        XCTAssertEqual(context2.value(for: "b"), "2")
        XCTAssertEqual(context2.value(for: "c"), "3")
    }

    func testTemplateContextSetting() {
        let context = TemplateContext(variables: ["a": "1"])
        let updated = context.setting("b", to: "2")

        XCTAssertEqual(updated.value(for: "a"), "1")
        XCTAssertEqual(updated.value(for: "b"), "2")
        XCTAssertNil(context.value(for: "b")) // Original unchanged
    }

    func testTemplateContextVariableNames() {
        let context = TemplateContext(variables: ["name": "Alice", "age": "30"])
        let names = context.variableNames

        XCTAssertEqual(names.count, 2)
        XCTAssertTrue(names.contains("name"))
        XCTAssertTrue(names.contains("age"))
    }

    func testTemplateContextDictionaryLiteral() {
        let context: TemplateContext = ["name": "Bob", "city": "NYC"]

        XCTAssertEqual(context.value(for: "name"), "Bob")
        XCTAssertEqual(context.value(for: "city"), "NYC")
    }

    // MARK: - Template Tests

    func testTemplateBasicRendering() {
        let template = Template("Hello, {{name}}!")
        let context = TemplateContext(variables: ["name": "Alice"])
        let result = template.render(with: context)

        XCTAssertEqual(result, "Hello, Alice!")
    }

    func testTemplateMultipleVariables() {
        let template = Template("{{greeting}}, {{name}}! You are {{age}} years old.")
        let result = template.render(with: [
            "greeting": "Hello",
            "name": "Bob",
            "age": "25"
        ])

        XCTAssertEqual(result, "Hello, Bob! You are 25 years old.")
    }

    func testTemplateWithWhitespace() {
        let template = Template("{{ name }} is {{ age }}")
        let result = template.render(with: ["name": "Charlie", "age": "30"])

        XCTAssertEqual(result, "Charlie is 30")
    }

    func testTemplateMissingVariable() {
        let template = Template("Hello, {{name}}!")
        let context = TemplateContext(variables: [:])
        let result = template.render(with: context)

        XCTAssertEqual(result, "Hello, !")
    }

    func testTemplateNoVariables() {
        let template = Template("Hello, World!")
        let result = template.render(with: [:])

        XCTAssertEqual(result, "Hello, World!")
    }

    func testTemplateRepeatedVariable() {
        let template = Template("{{name}} loves {{name}}")
        let result = template.render(with: ["name": "Alice"])

        XCTAssertEqual(result, "Alice loves Alice")
    }

    func testTemplateDollarSyntax() {
        let template = Template("Hello, ${name}!", syntax: .dollar)
        let result = template.render(with: ["name": "Diana"])

        XCTAssertEqual(result, "Hello, Diana!")
    }

    func testTemplatePercentSyntax() {
        let template = Template("Hello, %{name}!", syntax: .percent)
        let result = template.render(with: ["name": "Eve"])

        XCTAssertEqual(result, "Hello, Eve!")
    }

    func testTemplateCustomSyntax() {
        let syntax = Template.Syntax(openDelimiter: "<<", closeDelimiter: ">>")
        let template = Template("Hello, <<name>>!", syntax: syntax)
        let result = template.render(with: ["name": "Frank"])

        XCTAssertEqual(result, "Hello, Frank!")
    }

    func testTemplateVariableNames() {
        let template = Template("{{greeting}}, {{name}}! You are {{age}}.")
        let names = template.variableNames

        XCTAssertEqual(names.count, 3)
        XCTAssertTrue(names.contains("greeting"))
        XCTAssertTrue(names.contains("name"))
        XCTAssertTrue(names.contains("age"))
    }

    func testTemplateVariableNamesWithDuplicates() {
        let template = Template("{{name}} and {{name}}")
        let names = template.variableNames

        XCTAssertEqual(names.count, 2) // Duplicates included
        XCTAssertTrue(names.allSatisfy { $0 == "name" })
    }

    func testTemplateValidation() {
        let template = Template("Hello, {{name}}! You are {{age}}.")
        let context = TemplateContext(variables: ["name": "George"])
        let missing = template.validate(with: context)

        XCTAssertEqual(missing.count, 1)
        XCTAssertTrue(missing.contains("age"))
    }

    func testTemplateValidationAllPresent() {
        let template = Template("Hello, {{name}}!")
        let context = TemplateContext(variables: ["name": "Helen"])
        let missing = template.validate(with: context)

        XCTAssertEqual(missing.count, 0)
    }

    func testTemplateStringExtension() {
        let result = "Hello, {{name}}!".renderTemplate(
            with: ["name": "Ivan"]
        )

        XCTAssertEqual(result, "Hello, Ivan!")
    }

    func testTemplateStringExtensionWithContext() {
        let context = TemplateContext(variables: ["name": "Julia"])
        let result = "Hello, {{name}}!".renderTemplate(with: context)

        XCTAssertEqual(result, "Hello, Julia!")
    }

    func testTemplateStringExtensionCustomSyntax() {
        let result = "Hello, ${name}!".renderTemplate(
            with: ["name": "Kevin"],
            syntax: .dollar
        )

        XCTAssertEqual(result, "Hello, Kevin!")
    }

    func testTemplateComplexText() {
        let template = Template("""
        Dear {{name}},

        Thank you for your order #{{order_id}}.
        Your total is {{total}}.

        Best regards,
        {{company}}
        """)

        let result = template.render(with: [
            "name": "Laura",
            "order_id": "12345",
            "total": "$99.99",
            "company": "ACME Corp"
        ])

        XCTAssertTrue(result.contains("Dear Laura"))
        XCTAssertTrue(result.contains("order #12345"))
        XCTAssertTrue(result.contains("$99.99"))
        XCTAssertTrue(result.contains("ACME Corp"))
    }

    func testTemplateEmptyString() {
        let template = Template("")
        let result = template.render(with: ["name": "Mike"])

        XCTAssertEqual(result, "")
    }

    func testTemplateVariableNamesOnly() {
        let template = Template("{{a}}{{b}}{{c}}")
        let names = template.variableNames

        XCTAssertEqual(names.count, 3)
    }

    func testTemplateEdgeCases() {
        // Variable with numbers
        let template1 = Template("{{var123}}")
        XCTAssertEqual(template1.variableNames, ["var123"])

        // Variable with underscores
        let template2 = Template("{{my_var}}")
        XCTAssertEqual(template2.variableNames, ["my_var"])

        // Not a valid variable (starts with number)
        let template3 = Template("{{123var}}")
        XCTAssertEqual(template3.variableNames.count, 0)
    }
}
