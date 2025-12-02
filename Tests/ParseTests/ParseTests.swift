import XCTest
@testable import Parse

final class TextTests: XCTestCase {

    // MARK: - Integration Tests

    func testEndToEndWorkflow() {
        // Test a realistic workflow using multiple text utilities
        let rawText = "  hello_WORLD  "
        let cleaned = rawText.trimmingCharacters(in: .whitespaces)
        let camelCased = cleaned.camelCased
        let slug = camelCased.slug

        // camelCase doesn't have word boundaries, so slug becomes one word
        XCTAssertEqual(slug, "helloworld")
    }

    func testTemplateWithStatistics() {
        let template = "Hello, {{name}}! You have {{count}} items."
        let rendered = template.renderTemplate(with: [
            "name": "Alice",
            "count": "42"
        ])

        let stats = rendered.statistics
        XCTAssertEqual(stats.wordCount, 6)
        XCTAssertTrue(rendered.contains("Alice"))
    }

    func testSlugWithPadding() {
        let text = "Hello World"
        let slug = text.slug
        let padded = slug.centered(inWidth: 20, with: "-")

        XCTAssertEqual(padded, "----hello-world-----")
    }

    func testBase64WithTruncation() {
        let original = "This is a very long string that will be encoded and truncated"
        let encoded = original.base64Encoded
        let truncated = encoded.truncatedAtEnd(toLength: 20)

        XCTAssertEqual(truncated.count, 20)
        XCTAssertTrue(truncated.hasSuffix("..."))
    }

    func testLoremIpsumWithWordWrap() {
        var generator = LoremIpsum(seed: 12345)
        let lorem = generator.words(count: 50)
        let wrapped = lorem.wrapped(toWidth: 40)
        let lines = wrapped.split(separator: "\n")

        XCTAssertTrue(lines.allSatisfy { $0.count <= 40 })
    }

    func testCSVWithHTMLEncoding() throws {
        let csv = "name,description\nTest,<script>alert('xss')</script>"
        let data = try csv.parseCSV()

        if let description = data[0]?[1] {
            let safe = description.htmlEncoded
            XCTAssertTrue(safe.contains("&lt;"))
            XCTAssertTrue(safe.contains("&gt;"))
        } else {
            XCTFail("CSV parsing failed")
        }
    }

    func testPluralizationWithQuantification() {
        let items = ["apple", "banana", "orange"]
        let counts = [1, 5, 0]

        let results = zip(items, counts).map { item, count in
            item.quantified(count: count)
        }

        XCTAssertEqual(results[0], "1 apple")
        XCTAssertEqual(results[1], "5 bananas")
        XCTAssertEqual(results[2], "0 oranges")
    }

    func testGlobPatternWithFileNames() {
        let files = [
            "Document.txt",
            "Image.png",
            "Script.swift",
            "README.md",
            "test.swift"
        ]

        let swiftPattern = GlobPattern("*.swift")
        let swiftFiles = swiftPattern.filter(files)

        XCTAssertEqual(swiftFiles.count, 2)
        XCTAssertTrue(swiftFiles.contains("Script.swift"))
        XCTAssertTrue(swiftFiles.contains("test.swift"))
    }

    func testLevenshteinForSimilarity() {
        let words = ["hello", "hallo", "hullo", "world"]
        let target = "hello"

        let similar = words.filter { word in
            word.levenshteinSimilarity(to: target) > 0.6
        }

        XCTAssertTrue(similar.contains("hello"))
        XCTAssertTrue(similar.contains("hallo"))
        XCTAssertTrue(similar.contains("hullo"))
        XCTAssertFalse(similar.contains("world"))
    }

    func testCaseConversionChain() {
        let original = "HelloWorld"
        let snake = original.snakeCased
        let kebab = snake.kebabCased
        let camel = kebab.camelCased
        let pascal = camel.pascalCased

        XCTAssertEqual(snake, "hello_world")
        XCTAssertEqual(kebab, "hello-world")
        XCTAssertEqual(camel, "helloWorld")
        XCTAssertEqual(pascal, "HelloWorld")
    }
}
