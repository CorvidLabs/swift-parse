import XCTest
@testable import Parse

final class FormattersTests: XCTestCase {

    // MARK: - Pluralizer Tests

    func testPluralizerRegularWords() {
        XCTAssertEqual("cat".pluralized, "cats")
        XCTAssertEqual("dog".pluralized, "dogs")
        XCTAssertEqual("house".pluralized, "houses")
    }

    func testPluralizerWordsEndingInS() {
        XCTAssertEqual("bus".pluralized, "buses")
        XCTAssertEqual("class".pluralized, "classes")
        XCTAssertEqual("glass".pluralized, "glasses")
    }

    func testPluralizerWordsEndingInSH() {
        XCTAssertEqual("dish".pluralized, "dishes")
        XCTAssertEqual("brush".pluralized, "brushes")
    }

    func testPluralizerWordsEndingInCH() {
        XCTAssertEqual("bench".pluralized, "benches")
        XCTAssertEqual("church".pluralized, "churches")
    }

    func testPluralizerWordsEndingInX() {
        XCTAssertEqual("box".pluralized, "boxes")
        XCTAssertEqual("fox".pluralized, "foxes")
    }

    func testPluralizerWordsEndingInConsonantY() {
        XCTAssertEqual("city".pluralized, "cities")
        XCTAssertEqual("baby".pluralized, "babies")
        XCTAssertEqual("story".pluralized, "stories")
    }

    func testPluralizerWordsEndingInVowelY() {
        XCTAssertEqual("boy".pluralized, "boys")
        XCTAssertEqual("day".pluralized, "days")
    }

    func testPluralizerWordsEndingInF() {
        XCTAssertEqual("leaf".pluralized, "leaves")
        XCTAssertEqual("knife".pluralized, "knives")
        XCTAssertEqual("wolf".pluralized, "wolves")
    }

    func testPluralizerWordsEndingInO() {
        XCTAssertEqual("hero".pluralized, "heroes")
        XCTAssertEqual("potato".pluralized, "potatoes")
    }

    func testPluralizerIrregularWords() {
        XCTAssertEqual("child".pluralized, "children")
        XCTAssertEqual("person".pluralized, "people")
        XCTAssertEqual("man".pluralized, "men")
        XCTAssertEqual("woman".pluralized, "women")
        XCTAssertEqual("tooth".pluralized, "teeth")
        XCTAssertEqual("foot".pluralized, "feet")
        XCTAssertEqual("mouse".pluralized, "mice")
    }

    func testPluralizerWithCount() {
        XCTAssertEqual("cat".pluralized(count: 0), "cats")
        XCTAssertEqual("cat".pluralized(count: 1), "cat")
        XCTAssertEqual("cat".pluralized(count: 2), "cats")
        XCTAssertEqual("child".pluralized(count: 1), "child")
        XCTAssertEqual("child".pluralized(count: 2), "children")
    }

    func testPluralizerQuantify() {
        XCTAssertEqual("apple".quantified(count: 1), "1 apple")
        XCTAssertEqual("apple".quantified(count: 5), "5 apples")
        XCTAssertEqual("child".quantified(count: 3), "3 children")
    }

    func testPluralizerCasePreservation() {
        XCTAssertEqual("Cat".pluralized, "Cats")
        // Uppercase preservation appends lowercase 's'
        XCTAssertEqual("DOG".pluralized, "DOGs")
    }

    // MARK: - Ordinalizer Tests

    func testOrdinalizerBasicNumbers() {
        XCTAssertEqual(1.ordinalized, "1st")
        XCTAssertEqual(2.ordinalized, "2nd")
        XCTAssertEqual(3.ordinalized, "3rd")
        XCTAssertEqual(4.ordinalized, "4th")
        XCTAssertEqual(5.ordinalized, "5th")
    }

    func testOrdinalizerTeens() {
        XCTAssertEqual(11.ordinalized, "11th")
        XCTAssertEqual(12.ordinalized, "12th")
        XCTAssertEqual(13.ordinalized, "13th")
    }

    func testOrdinalizerTwenties() {
        XCTAssertEqual(21.ordinalized, "21st")
        XCTAssertEqual(22.ordinalized, "22nd")
        XCTAssertEqual(23.ordinalized, "23rd")
        XCTAssertEqual(24.ordinalized, "24th")
    }

    func testOrdinalizerLargeNumbers() {
        XCTAssertEqual(101.ordinalized, "101st")
        XCTAssertEqual(102.ordinalized, "102nd")
        XCTAssertEqual(103.ordinalized, "103rd")
        XCTAssertEqual(111.ordinalized, "111th")
        XCTAssertEqual(121.ordinalized, "121st")
    }

    func testOrdinalizerNegativeNumbers() {
        XCTAssertEqual((-1).ordinalized, "-1st")
        XCTAssertEqual((-2).ordinalized, "-2nd")
        XCTAssertEqual((-11).ordinalized, "-11th")
    }

    func testOrdinalizerSuffix() {
        XCTAssertEqual(1.ordinalSuffix, "st")
        XCTAssertEqual(2.ordinalSuffix, "nd")
        XCTAssertEqual(3.ordinalSuffix, "rd")
        XCTAssertEqual(4.ordinalSuffix, "th")
        XCTAssertEqual(11.ordinalSuffix, "th")
        XCTAssertEqual(21.ordinalSuffix, "st")
    }

    func testOrdinalizerWords() {
        XCTAssertEqual(1.ordinalWord, "first")
        XCTAssertEqual(2.ordinalWord, "second")
        XCTAssertEqual(3.ordinalWord, "third")
        XCTAssertEqual(10.ordinalWord, "tenth")
        XCTAssertEqual(20.ordinalWord, "twentieth")
        XCTAssertNil(21.ordinalWord)
        XCTAssertNil(0.ordinalWord)
    }

    func testOrdinalizerStatic() {
        XCTAssertEqual(Ordinalizer.ordinalize(1), "1st")
        XCTAssertEqual(Ordinalizer.suffix(for: 2), "nd")
        XCTAssertEqual(Ordinalizer.ordinalWord(for: 5), "fifth")
    }

    // MARK: - RelativeTimeFormatter Tests

    func testRelativeTimeFormatterSeconds() {
        let formatter = RelativeTimeFormatter(style: .medium)

        XCTAssertEqual(formatter.format(timeInterval: 30), "30 seconds ago")
        XCTAssertEqual(formatter.format(timeInterval: 1), "1 second ago")
        XCTAssertEqual(formatter.format(timeInterval: -30), "in 30 seconds")
    }

    func testRelativeTimeFormatterMinutes() {
        let formatter = RelativeTimeFormatter(style: .medium)

        XCTAssertEqual(formatter.format(timeInterval: 120), "2 minutes ago")
        XCTAssertEqual(formatter.format(timeInterval: 60), "1 minute ago")
    }

    func testRelativeTimeFormatterHours() {
        let formatter = RelativeTimeFormatter(style: .medium)

        XCTAssertEqual(formatter.format(timeInterval: 7200), "2 hours ago")
        XCTAssertEqual(formatter.format(timeInterval: 3600), "1 hour ago")
    }

    func testRelativeTimeFormatterDays() {
        let formatter = RelativeTimeFormatter(style: .medium)

        XCTAssertEqual(formatter.format(timeInterval: 172800), "2 days ago")
        XCTAssertEqual(formatter.format(timeInterval: 86400), "1 day ago")
    }

    func testRelativeTimeFormatterWeeks() {
        let formatter = RelativeTimeFormatter(style: .medium)

        XCTAssertEqual(formatter.format(timeInterval: 1209600), "2 weeks ago")
        XCTAssertEqual(formatter.format(timeInterval: 604800), "1 week ago")
    }

    func testRelativeTimeFormatterMonths() {
        let formatter = RelativeTimeFormatter(style: .medium)

        XCTAssertEqual(formatter.format(timeInterval: 5184000), "2 months ago")
        XCTAssertEqual(formatter.format(timeInterval: 2592000), "1 month ago")
    }

    func testRelativeTimeFormatterYears() {
        let formatter = RelativeTimeFormatter(style: .medium)

        XCTAssertEqual(formatter.format(timeInterval: 63072000), "2 years ago")
        XCTAssertEqual(formatter.format(timeInterval: 31536000), "1 year ago")
    }

    func testRelativeTimeFormatterShortStyle() {
        let formatter = RelativeTimeFormatter(style: .short)

        XCTAssertEqual(formatter.format(timeInterval: 30), "30s")
        XCTAssertEqual(formatter.format(timeInterval: 120), "2m")
        XCTAssertEqual(formatter.format(timeInterval: 7200), "2h")
        XCTAssertEqual(formatter.format(timeInterval: 172800), "2d")
    }

    func testRelativeTimeFormatterFuture() {
        let formatter = RelativeTimeFormatter(style: .medium)

        XCTAssertEqual(formatter.format(timeInterval: -60), "in 1 minute")
        XCTAssertEqual(formatter.format(timeInterval: -3600), "in 1 hour")
    }

    func testRelativeTimeFormatterFutureShortStyle() {
        let formatter = RelativeTimeFormatter(style: .short)

        XCTAssertEqual(formatter.format(timeInterval: -60), "in 1m")
        XCTAssertEqual(formatter.format(timeInterval: -3600), "in 1h")
    }

    func testRelativeTimeFormatterWithDate() {
        let formatter = RelativeTimeFormatter(style: .medium)
        let now = Date()
        let twoHoursAgo = now.addingTimeInterval(-7200)

        let result = formatter.format(twoHoursAgo, relativeTo: now)
        XCTAssertEqual(result, "2 hours ago")
    }

    func testTimeIntervalExtension() {
        let interval: TimeInterval = 3600
        XCTAssertEqual(interval.relativeTime(style: .medium), "1 hour ago")
        XCTAssertEqual(interval.relativeTime(style: .short), "1h")
    }
}
