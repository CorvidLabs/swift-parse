import XCTest
@testable import Parse

final class ParsingTests: XCTestCase {

    // MARK: - CSVParser Tests

    func testCSVParserBasic() throws {
        let csv = "name,age,city\nJohn,30,NYC\nJane,25,LA"
        let parser = CSVParser()
        let data = try parser.parse(csv)

        XCTAssertEqual(data.headers, ["name", "age", "city"])
        XCTAssertEqual(data.count, 2)
        XCTAssertEqual(data[0]?.values, ["John", "30", "NYC"])
        XCTAssertEqual(data[1]?.values, ["Jane", "25", "LA"])
    }

    func testCSVParserNoHeaders() throws {
        let csv = "John,30,NYC\nJane,25,LA"
        let options = CSVParser.Options(hasHeaderRow: false)
        let parser = CSVParser(options: options)
        let data = try parser.parse(csv)

        XCTAssertNil(data.headers)
        XCTAssertEqual(data.count, 2)
    }

    func testCSVParserWithQuotes() throws {
        let csv = "name,description\n\"John Doe\",\"A \"\"good\"\" person\""
        let parser = CSVParser()
        let data = try parser.parse(csv)

        XCTAssertEqual(data.count, 1)
        XCTAssertEqual(data[0]?.values[0], "John Doe")
    }

    func testCSVParserWithCommasInQuotes() throws {
        let csv = "name,location\nJohn,\"New York, NY\""
        let parser = CSVParser()
        let data = try parser.parse(csv)

        XCTAssertEqual(data[0]?.values[1], "New York, NY")
    }

    func testCSVParserCustomDelimiter() throws {
        let csv = "name;age;city\nJohn;30;NYC"
        let options = CSVParser.Options(delimiter: ";")
        let parser = CSVParser(options: options)
        let data = try parser.parse(csv)

        XCTAssertEqual(data.headers, ["name", "age", "city"])
        XCTAssertEqual(data[0]?.values, ["John", "30", "NYC"])
    }

    func testCSVParserTrimWhitespace() throws {
        let csv = "name , age , city\n John , 30 , NYC "
        let options = CSVParser.Options(trimWhitespace: true)
        let parser = CSVParser(options: options)
        let data = try parser.parse(csv)

        XCTAssertEqual(data.headers, ["name", "age", "city"])
        XCTAssertEqual(data[0]?.values, ["John", "30", "NYC"])
    }

    func testCSVParserNoTrimWhitespace() throws {
        let csv = "name , age\n John , 30 "
        let options = CSVParser.Options(trimWhitespace: false)
        let parser = CSVParser(options: options)
        let data = try parser.parse(csv)

        XCTAssertEqual(data[0]?.values[0], " John ")
    }

    func testCSVParserEmptyFields() throws {
        let csv = "a,b,c\n1,,3\n,2,"
        let parser = CSVParser()
        let data = try parser.parse(csv)

        XCTAssertEqual(data[0]?.values, ["1", "", "3"])
        XCTAssertEqual(data[1]?.values, ["", "2", ""])
    }

    func testCSVParserRowSubscript() throws {
        let csv = "a,b,c\n1,2,3"
        let parser = CSVParser()
        let data = try parser.parse(csv)

        XCTAssertEqual(data[0]?[0], "1")
        XCTAssertEqual(data[0]?[1], "2")
        XCTAssertEqual(data[0]?[2], "3")
        XCTAssertNil(data[0]?[3])
    }

    func testCSVParserOutOfBounds() throws {
        let csv = "a,b\n1,2"
        let parser = CSVParser()
        let data = try parser.parse(csv)

        XCTAssertNil(data[5])
        XCTAssertNil(data[-1])
    }

    func testCSVParserStringExtension() throws {
        let csv = "name,age\nJohn,30"
        let data = try csv.parseCSV()

        XCTAssertEqual(data.headers, ["name", "age"])
        XCTAssertEqual(data[0]?.values, ["John", "30"])
    }

    func testCSVParserFormat() {
        let headers = ["name", "age", "city"]
        let rows = [
            CSVParser.Row(values: ["John", "30", "NYC"]),
            CSVParser.Row(values: ["Jane", "25", "LA"])
        ]
        let data = CSVParser.Data(headers: headers, rows: rows)
        let parser = CSVParser()
        let csv = parser.format(data)

        XCTAssertTrue(csv.contains("name,age,city"))
        XCTAssertTrue(csv.contains("John,30,NYC"))
        XCTAssertTrue(csv.contains("Jane,25,LA"))
    }

    func testCSVParserFormatWithQuotes() {
        let headers = ["name", "description"]
        let rows = [
            CSVParser.Row(values: ["John", "A, B, C"])
        ]
        let data = CSVParser.Data(headers: headers, rows: rows)
        let parser = CSVParser()
        let csv = parser.format(data)

        XCTAssertTrue(csv.contains("\"A, B, C\""))
    }

    func testCSVParserEmptyString() throws {
        let parser = CSVParser()
        let data = try parser.parse("")

        XCTAssertEqual(data.count, 0)
    }

    func testCSVParserSingleColumn() throws {
        let csv = "name\nJohn\nJane"
        let parser = CSVParser()
        let data = try parser.parse(csv)

        XCTAssertEqual(data.headers, ["name"])
        XCTAssertEqual(data.count, 2)
        XCTAssertEqual(data[0]?.values, ["John"])
        XCTAssertEqual(data[1]?.values, ["Jane"])
    }

    func testCSVParserRoundTrip() throws {
        let original = "name,age,city\nJohn,30,NYC\nJane,25,LA"
        let parser = CSVParser()
        let data = try parser.parse(original)
        let formatted = parser.format(data)
        let reparsed = try parser.parse(formatted)

        XCTAssertEqual(data.count, reparsed.count)
        XCTAssertEqual(data.headers, reparsed.headers)
        XCTAssertEqual(data[0]?.values, reparsed[0]?.values)
    }
}
