import XCTest
@testable import Parse

final class GeneratorsTests: XCTestCase {

    // MARK: - RandomSource Tests

    func testRandomSourceDeterministic() {
        var rng1 = RandomSource(seed: 12345)
        var rng2 = RandomSource(seed: 12345)

        XCTAssertEqual(rng1.nextUInt64(), rng2.nextUInt64())
        XCTAssertEqual(rng1.nextUInt64(), rng2.nextUInt64())
        XCTAssertEqual(rng1.nextUInt64(), rng2.nextUInt64())
    }

    func testRandomSourceDifferentSeeds() {
        var rng1 = RandomSource(seed: 12345)
        var rng2 = RandomSource(seed: 54321)

        XCTAssertNotEqual(rng1.nextUInt64(), rng2.nextUInt64())
    }

    func testRandomSourceDouble() {
        var rng = RandomSource(seed: 12345)

        for _ in 0..<100 {
            let value = rng.nextDouble()
            XCTAssertGreaterThanOrEqual(value, 0.0)
            XCTAssertLessThan(value, 1.0)
        }
    }

    func testRandomSourceDoubleInRange() {
        var rng = RandomSource(seed: 12345)

        for _ in 0..<100 {
            let value = rng.nextDouble(in: 10.0...20.0)
            XCTAssertGreaterThanOrEqual(value, 10.0)
            XCTAssertLessThanOrEqual(value, 20.0)
        }
    }

    func testRandomSourceInt() {
        var rng = RandomSource(seed: 12345)

        for _ in 0..<100 {
            let value = rng.nextInt(upperBound: 10)
            XCTAssertGreaterThanOrEqual(value, 0)
            XCTAssertLessThan(value, 10)
        }
    }

    func testRandomSourceIntInRange() {
        var rng = RandomSource(seed: 12345)

        for _ in 0..<100 {
            let value = rng.nextInt(in: 5...15)
            XCTAssertGreaterThanOrEqual(value, 5)
            XCTAssertLessThanOrEqual(value, 15)
        }
    }

    func testRandomSourceBool() {
        var rng = RandomSource(seed: 12345)
        var trueCount = 0

        for _ in 0..<1000 {
            if rng.nextBool() {
                trueCount += 1
            }
        }

        // Should be roughly 50% true
        XCTAssertGreaterThan(trueCount, 400)
        XCTAssertLessThan(trueCount, 600)
    }

    func testRandomSourceElement() {
        var rng = RandomSource(seed: 12345)
        let array = ["a", "b", "c", "d", "e"]

        for _ in 0..<10 {
            let element = rng.nextElement(from: array)
            XCTAssertNotNil(element)
            XCTAssertTrue(array.contains(element!))
        }
    }

    func testRandomSourceShuffle() {
        var rng = RandomSource(seed: 12345)
        let original = [1, 2, 3, 4, 5]
        let shuffled = rng.shuffled(original)

        XCTAssertEqual(shuffled.sorted(), original)
        // With seed, should be deterministic
        var rng2 = RandomSource(seed: 12345)
        let shuffled2 = rng2.shuffled(original)
        XCTAssertEqual(shuffled, shuffled2)
    }

    // MARK: - LoremIpsum Tests

    func testLoremIpsumWords() {
        var generator = LoremIpsum(seed: 12345)
        let words = generator.words(count: 10)
        let wordArray = words.split(separator: " ")

        XCTAssertEqual(wordArray.count, 10)
    }

    func testLoremIpsumWordsStartWithClassic() {
        var generator = LoremIpsum(seed: 12345, startWithClassic: true)
        let words = generator.words(count: 10)

        XCTAssertTrue(words.hasPrefix("Lorem ipsum dolor sit amet"))
    }

    func testLoremIpsumWordsWithoutClassicStart() {
        var generator = LoremIpsum(seed: 12345, startWithClassic: false)
        let words = generator.words(count: 5)

        XCTAssertFalse(words.hasPrefix("Lorem ipsum dolor sit amet"))
    }

    func testLoremIpsumSentences() {
        var generator = LoremIpsum(seed: 12345)
        let sentences = generator.sentences(count: 3)
        let sentenceArray = sentences.components(separatedBy: ". ")

        XCTAssertGreaterThanOrEqual(sentenceArray.count, 3)
        XCTAssertTrue(sentences.contains("."))
    }

    func testLoremIpsumParagraphs() {
        var generator = LoremIpsum(seed: 12345)
        let paragraphs = generator.paragraphs(count: 2)
        let paragraphArray = paragraphs.components(separatedBy: "\n\n")

        XCTAssertEqual(paragraphArray.count, 2)
    }

    func testLoremIpsumCharacters() {
        var generator = LoremIpsum(seed: 12345)
        let text = generator.characters(count: 100)

        XCTAssertLessThanOrEqual(text.count, 100)
        XCTAssertGreaterThan(text.count, 95) // Should be close to requested count
    }

    func testLoremIpsumDeterministic() {
        var gen1 = LoremIpsum(seed: 12345)
        var gen2 = LoremIpsum(seed: 12345)

        XCTAssertEqual(gen1.words(count: 5), gen2.words(count: 5))
        XCTAssertEqual(gen1.words(count: 5), gen2.words(count: 5))
    }

    func testLoremIpsumStringExtensions() {
        let words = String.loremWords(5, seed: 12345)
        XCTAssertEqual(words.split(separator: " ").count, 5)

        let sentences = String.loremSentences(2, seed: 12345)
        XCTAssertTrue(sentences.contains("."))

        let paragraphs = String.loremParagraphs(2, seed: 12345)
        XCTAssertTrue(paragraphs.contains("\n\n"))
    }

    func testLoremIpsumZeroCount() {
        var generator = LoremIpsum(seed: 12345)

        XCTAssertEqual(generator.words(count: 0), "")
        XCTAssertEqual(generator.sentences(count: 0), "")
        XCTAssertEqual(generator.paragraphs(count: 0), "")
    }

    func testLoremIpsumSingleWord() {
        var generator = LoremIpsum(seed: 12345, startWithClassic: false)
        let word = generator.words(count: 1)

        XCTAssertFalse(word.contains(" "))
        XCTAssertGreaterThan(word.count, 0)
    }

    func testLoremIpsumConsistentWithSameSeed() {
        let text1 = String.loremParagraphs(3, seed: 99999)
        let text2 = String.loremParagraphs(3, seed: 99999)

        XCTAssertEqual(text1, text2)
    }
}
