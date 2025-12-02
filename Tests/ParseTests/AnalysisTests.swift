import XCTest
@testable import Parse

final class AnalysisTests: XCTestCase {

    // MARK: - TextStatistics Tests

    func testBasicTextStatistics() {
        let text = "Hello, World!"
        let stats = text.statistics

        XCTAssertEqual(stats.characterCount, 13)
        XCTAssertEqual(stats.wordCount, 2)
        XCTAssertEqual(stats.letterCount, 10)
    }

    func testTextStatisticsWordCounting() {
        let text = "The quick brown fox jumps over the lazy dog."
        let stats = TextStatistics(text: text)

        XCTAssertEqual(stats.wordCount, 9)
        XCTAssertEqual(stats.sentenceCount, 1)
    }

    func testTextStatisticsSentenceCounting() {
        let text = "Hello! How are you? I'm fine."
        let stats = text.statistics

        XCTAssertEqual(stats.sentenceCount, 3)
        XCTAssertEqual(stats.wordCount, 6)
    }

    func testTextStatisticsParagraphCounting() {
        let text = "First paragraph.\n\nSecond paragraph.\n\nThird paragraph."
        let stats = text.statistics

        XCTAssertEqual(stats.paragraphCount, 3)
    }

    func testTextStatisticsCharacterCounts() {
        let text = "Hello123!!"
        let stats = text.statistics

        XCTAssertEqual(stats.characterCount, 10)
        XCTAssertEqual(stats.characterCountWithoutWhitespace, 10)
        XCTAssertEqual(stats.letterCount, 5)
        XCTAssertEqual(stats.digitCount, 3)
    }

    func testTextStatisticsAverages() {
        let text = "Hello world. This is a test."
        let stats = text.statistics

        XCTAssertGreaterThan(stats.averageWordLength, 0)
        XCTAssertGreaterThan(stats.averageSentenceLength, 0)
    }

    func testTextStatisticsWords() {
        let text = "Hello, world! How are you?"
        let stats = text.statistics

        XCTAssertEqual(stats.words, ["Hello", "world", "How", "are", "you"])
    }

    func testTextStatisticsLongestAndShortestWords() {
        let text = "The quick brown fox"
        let stats = text.statistics

        XCTAssertEqual(stats.longestWord, "quick")
        XCTAssertEqual(stats.shortestWord, "The")
    }

    func testTextStatisticsLineCount() {
        let text = "Line 1\nLine 2\nLine 3"
        let stats = text.statistics

        XCTAssertEqual(stats.lineCount, 3)
    }

    func testTextStatisticsSyllableCount() {
        let text = "hello"
        let stats = text.statistics

        XCTAssertGreaterThan(stats.syllableCount, 0)
    }

    func testEmptyTextStatistics() {
        let text = ""
        let stats = text.statistics

        XCTAssertEqual(stats.characterCount, 0)
        XCTAssertEqual(stats.wordCount, 0)
        XCTAssertEqual(stats.sentenceCount, 0)
        XCTAssertEqual(stats.averageWordLength, 0)
    }

    func testTextStatisticsWithWhitespace() {
        let text = "Hello   World  "
        let stats = text.statistics

        XCTAssertEqual(stats.wordCount, 2)
        XCTAssertEqual(stats.characterCount, 15)
        XCTAssertLessThan(stats.characterCountWithoutWhitespace, stats.characterCount)
    }
}
