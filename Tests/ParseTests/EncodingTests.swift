import XCTest
@testable import Parse

final class EncodingTests: XCTestCase {

    // MARK: - Base64Codec Tests

    func testBase64EncodeBasicString() {
        let original = "Hello, World!"
        let encoded = original.base64Encoded

        XCTAssertNotEqual(original, encoded)
        XCTAssertFalse(encoded.isEmpty)
    }

    func testBase64EncodeDecode() {
        let original = "Hello, World!"
        let encoded = original.base64Encoded
        let decoded = encoded.base64Decoded

        XCTAssertEqual(decoded, original)
    }

    func testBase64EncodeDecodeEmptyString() {
        let original = ""
        let encoded = original.base64Encoded
        let decoded = encoded.base64Decoded

        XCTAssertEqual(decoded, original)
    }

    func testBase64EncodeDecodeUnicode() {
        let original = "Hello 👋 World 🌍"
        let encoded = original.base64Encoded
        let decoded = encoded.base64Decoded

        XCTAssertEqual(decoded, original)
    }

    func testBase64URLSafeEncoding() {
        let original = "Hello, World!"
        let encoded = original.urlSafeBase64Encoded

        XCTAssertFalse(encoded.contains("+"))
        XCTAssertFalse(encoded.contains("/"))
        XCTAssertFalse(encoded.contains("="))
    }

    func testBase64URLSafeEncodeDecode() {
        let original = "Hello, World! This is a test."
        let encoded = original.urlSafeBase64Encoded
        let decoded = encoded.urlSafeBase64Decoded

        XCTAssertEqual(decoded, original)
    }

    func testBase64CodecStruct() {
        let codec = Base64Codec()
        let original = "Test string"
        let encoded = codec.encode(original)

        XCTAssertNoThrow(try codec.decode(encoded))
        XCTAssertEqual(try? codec.decode(encoded), original)
    }

    func testBase64CodecWithData() throws {
        let codec = Base64Codec()
        let data = Data([0x48, 0x65, 0x6C, 0x6C, 0x6F]) // "Hello"
        let encoded = codec.encode(data)
        let decoded = try codec.decodeToData(encoded)

        XCTAssertEqual(decoded, data)
    }

    func testBase64InvalidDecoding() {
        let codec = Base64Codec()

        XCTAssertThrowsError(try codec.decode("not valid base64!@#$"))
    }

    func testBase64URLSafeCodec() throws {
        let codec = Base64Codec(options: .urlSafe)
        let original = "Hello, World!"
        let encoded = codec.encode(original)

        XCTAssertFalse(encoded.contains("+"))
        XCTAssertFalse(encoded.contains("/"))

        let decoded = try codec.decode(encoded)
        XCTAssertEqual(decoded, original)
    }

    // MARK: - HTMLEntities Tests

    func testHTMLEntityEncodeBasic() {
        XCTAssertEqual("&".htmlEncoded, "&amp;")
        XCTAssertEqual("<".htmlEncoded, "&lt;")
        XCTAssertEqual(">".htmlEncoded, "&gt;")
        XCTAssertEqual("\"".htmlEncoded, "&quot;")
        // The actual implementation uses &apos; instead of &#39;
        XCTAssertEqual("'".htmlEncoded, "&apos;")
    }

    func testHTMLEntityEncodeString() {
        let original = "<div>Hello & goodbye</div>"
        let encoded = original.htmlEncoded

        XCTAssertEqual(encoded, "&lt;div&gt;Hello &amp; goodbye&lt;/div&gt;")
    }

    func testHTMLEntityDecode() {
        let encoded = "&lt;div&gt;Hello &amp; goodbye&lt;/div&gt;"
        let decoded = encoded.htmlDecoded

        XCTAssertEqual(decoded, "<div>Hello & goodbye</div>")
    }

    func testHTMLEntityEncodeDecodeRoundTrip() {
        let original = "<script>alert('test');</script>"
        let encoded = original.htmlEncoded
        let decoded = encoded.htmlDecoded

        XCTAssertEqual(decoded, original)
    }

    func testHTMLEntityDecodeCommon() {
        XCTAssertEqual("&amp;".htmlDecoded, "&")
        XCTAssertEqual("&lt;".htmlDecoded, "<")
        XCTAssertEqual("&gt;".htmlDecoded, ">")
        XCTAssertEqual("&quot;".htmlDecoded, "\"")
    }

    func testHTMLEntityDecodeNumeric() {
        XCTAssertEqual("&#65;".htmlDecoded, "A")
        XCTAssertEqual("&#x41;".htmlDecoded, "A")
        XCTAssertEqual("&#72;&#101;&#108;&#108;&#111;".htmlDecoded, "Hello")
    }

    func testHTMLEntityStruct() {
        let encoder = HTMLEntities()
        XCTAssertEqual(encoder.encode("<test>"), "&lt;test&gt;")
        XCTAssertEqual(encoder.decode("&lt;test&gt;"), "<test>")
    }

    func testHTMLEntityEncodeAllOption() {
        let encoder = HTMLEntities(encodeAll: true)
        let result = encoder.encode("café")

        // Should encode special characters when encodeAll is true
        XCTAssertNotEqual(result, "café")
    }

    func testHTMLEntityOnlyEssentialEncoding() {
        let encoder = HTMLEntities(encodeAll: false)
        let result = encoder.encode("Hello <world>")

        XCTAssertTrue(result.contains("&lt;"))
        XCTAssertTrue(result.contains("&gt;"))
        XCTAssertTrue(result.contains("Hello"))
    }

    func testHTMLEntityEmptyString() {
        XCTAssertEqual("".htmlEncoded, "")
        XCTAssertEqual("".htmlDecoded, "")
    }

    func testHTMLEntityNoSpecialCharacters() {
        let original = "Hello World 123"
        XCTAssertEqual(original.htmlEncoded, original)
    }
}
