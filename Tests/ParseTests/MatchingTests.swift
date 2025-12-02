import XCTest
@testable import Parse

final class MatchingTests: XCTestCase {

    // MARK: - LevenshteinDistance Tests

    func testLevenshteinDistanceBasic() {
        XCTAssertEqual("kitten".levenshteinDistance(to: "sitting"), 3)
        XCTAssertEqual("saturday".levenshteinDistance(to: "sunday"), 3)
        XCTAssertEqual("foo".levenshteinDistance(to: "foo"), 0)
    }

    func testLevenshteinDistanceEmptyStrings() {
        XCTAssertEqual("".levenshteinDistance(to: "hello"), 5)
        XCTAssertEqual("hello".levenshteinDistance(to: ""), 5)
        XCTAssertEqual("".levenshteinDistance(to: ""), 0)
    }

    func testLevenshteinDistanceIdenticalStrings() {
        XCTAssertEqual("hello".levenshteinDistance(to: "hello"), 0)
        XCTAssertEqual("world".levenshteinDistance(to: "world"), 0)
    }

    func testLevenshteinDistanceCompletelyDifferent() {
        XCTAssertEqual("abc".levenshteinDistance(to: "xyz"), 3)
        XCTAssertEqual("hello".levenshteinDistance(to: "world"), 4)
    }

    func testLevenshteinSimilarity() {
        XCTAssertEqual("hello".levenshteinSimilarity(to: "hello"), 1.0, accuracy: 0.001)
        XCTAssertEqual("".levenshteinSimilarity(to: ""), 1.0, accuracy: 0.001)
        XCTAssertGreaterThan("kitten".levenshteinSimilarity(to: "sitting"), 0.5)
    }

    func testLevenshteinDistanceStatic() {
        XCTAssertEqual(
            LevenshteinDistance.calculate(from: "test", to: "text"),
            1
        )
        XCTAssertEqual(
            LevenshteinDistance.similarity(from: "hello", to: "hallo"),
            0.8,
            accuracy: 0.001
        )
    }

    // MARK: - GlobPattern Tests

    func testGlobPatternExactMatch() {
        XCTAssertTrue("hello".matchesGlob("hello"))
        XCTAssertFalse("hello".matchesGlob("world"))
    }

    func testGlobPatternWildcard() {
        XCTAssertTrue("hello.txt".matchesGlob("*.txt"))
        XCTAssertTrue("file.txt".matchesGlob("*.txt"))
        XCTAssertFalse("file.md".matchesGlob("*.txt"))
    }

    func testGlobPatternMultipleWildcards() {
        XCTAssertTrue("hello.test.txt".matchesGlob("*.*.txt"))
        XCTAssertTrue("file.backup.log".matchesGlob("*.backup.*"))
    }

    func testGlobPatternQuestionMark() {
        XCTAssertTrue("test".matchesGlob("te?t"))
        XCTAssertTrue("text".matchesGlob("te?t"))
        XCTAssertFalse("tet".matchesGlob("te?t"))
    }

    func testGlobPatternCharacterSets() {
        XCTAssertTrue("test".matchesGlob("te[sx]t"))
        XCTAssertTrue("text".matchesGlob("te[sx]t"))
        XCTAssertFalse("teat".matchesGlob("te[sx]t"))
    }

    func testGlobPatternCharacterRanges() {
        XCTAssertTrue("a".matchesGlob("[a-z]"))
        XCTAssertTrue("m".matchesGlob("[a-z]"))
        XCTAssertTrue("z".matchesGlob("[a-z]"))
        XCTAssertFalse("A".matchesGlob("[a-z]"))
    }

    func testGlobPatternNegatedCharacterSet() {
        XCTAssertFalse("test".matchesGlob("te[!sx]t"))
        XCTAssertTrue("teat".matchesGlob("te[!sx]t"))
    }

    func testGlobPatternCaseSensitivity() {
        XCTAssertTrue("Hello".matchesGlob("hello", caseSensitive: false))
        XCTAssertFalse("Hello".matchesGlob("hello", caseSensitive: true))
    }

    func testGlobPatternComplex() {
        XCTAssertTrue("file-2024.txt".matchesGlob("file-*.txt"))
        XCTAssertTrue("test_file.log".matchesGlob("test_*.log"))
        XCTAssertTrue("abc123def".matchesGlob("abc*def"))
    }

    func testGlobPatternStruct() {
        let pattern = GlobPattern("*.swift")
        XCTAssertTrue(pattern.matches("File.swift"))
        XCTAssertFalse(pattern.matches("File.txt"))
    }

    func testGlobPatternFilter() {
        let pattern = GlobPattern("*.txt")
        let files = ["file1.txt", "file2.md", "file3.txt", "readme.md"]
        let matches = pattern.filter(files)

        XCTAssertEqual(matches.count, 2)
        XCTAssertTrue(matches.contains("file1.txt"))
        XCTAssertTrue(matches.contains("file3.txt"))
    }

    func testGlobPatternEdgeCases() {
        XCTAssertTrue("".matchesGlob(""))
        XCTAssertTrue("anything".matchesGlob("*"))
        XCTAssertFalse("test".matchesGlob(""))
    }
}
