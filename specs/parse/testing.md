---
spec: parse.spec.md
---

## Automated Testing

| Test file | Tests | Requirements | Implemented behavior exercised |
|-----------|------:|--------------|--------------------------------|
| `Tests/ParseTests/AnalysisTests.swift` | 12 | REQ-parse-001 | Text statistics counts, segmentation, averages, extrema, syllables, whitespace, and empty text. Readability and character-frequency details are source-reviewed. |
| `Tests/ParseTests/EncodingTests.swift` | 21 | REQ-parse-002 | Standard/URL-safe Base64 strings/data/errors and essential/all/named/numeric HTML entity behavior. EscapeSequences and URL encoding are source-reviewed. |
| `Tests/ParseTests/FormattersTests.swift` | 33 | REQ-parse-003 | Plural suffix/irregular/case/count behavior, ordinal ranges/words, and relative-time units/styles/direction. ByteFormatter and DurationFormatter are source-reviewed. |
| `Tests/ParseTests/GeneratorsTests.swift` | 20 | REQ-parse-004 | RandomSource seed determinism, values/ranges/bools/elements/shuffle, and LoremIpsum counts/classic prefix/seed consistency. MarkovChain and NameGenerator are source-reviewed. |
| `Tests/ParseTests/MatchingTests.swift` | 18 | REQ-parse-005 | Levenshtein distance/similarity/empty cases and glob exact, wildcard, range, negation, case, filtering, and edge behavior. Other matching algorithms are source-reviewed. |
| `Tests/ParseTests/ParsingTests.swift` | 16 | REQ-parse-006 | CSV headers, custom delimiters, quotes, trimming, empties, safe indexing, formatting, single-column, extension, and round-trip behavior. KeyValueParser and Tokenizer are source-reviewed. |
| `Tests/ParseTests/TemplatesTests.swift` | 25 | REQ-parse-007 | Context lookup/merge/setting/literals, all delimiter presets/custom syntax, rendering, repeated/missing variables, discovery, validation, extensions, empty and edge cases. |
| `Tests/ParseTests/UtilitiesTests.swift` | 30 | REQ-parse-008 | Case conversion, left/right/center padding, start/middle/end truncation, wrapping/newlines/long-word breaking, and slug options/edges. General String helpers are source-reviewed. |
| `Tests/ParseTests/ParseTests.swift` | 10 | REQ-parse-001, REQ-parse-002, REQ-parse-003, REQ-parse-005, REQ-parse-006, REQ-parse-007, REQ-parse-008 | End-to-end compositions across statistics/templates, slug/padding, Base64/truncation, Lorem/wrapping, CSV/HTML, pluralization, glob, Levenshtein, and case conversion. |

The native command is `fledge lanes run verify`, which runs `swift build` and `swift test`. The observed baseline is 185 passing XCTest methods in nine classes. Surfaces named source-reviewed above are not presented as executed test evidence.

## Hosted Validation

- Existing CodeQL analyzes Actions and Swift.
- Existing package and documentation workflows remain independent and unchanged.
- Added `trust` job runs on every pull request and main push using the immutable Trust 1.0.0 commit and the native Fledge lane.

## Edge Cases and Boundary Conditions

| Scenario | Expected behavior |
|----------|-------------------|
| Empty text analysis | Empty collections/optional extrema and zero ratio scores where prerequisites are absent. |
| Invalid Base64 | Throw `TextError.decodingFailed`; optional String conveniences return `nil`. |
| Missing key/value separator | Throw `TextError.parsingFailed`. |
| CSV invalid row index | Return `nil`. |
| Empty matching pair | Levenshtein/LCS normalized similarity is `1.0`; one empty operand behaves per its algorithm. |
| Empty random candidates or non-positive integer bound | Return `nil` or zero respectively. |
| Missing template variable | Render empty string and include the name in validation output. |
| Requested truncation shorter than ellipsis | Return the ellipsis prefix at requested character length. |
| Overlong word with `breakWords == false` | Preserve the word intact on its own line. |

## Manual Review

- Confirm the companion names all 38 exact-case `Sources/Parse` paths and every parser-visible export.
- Confirm `git diff origin/main...HEAD -- Sources Tests Package.swift README.md` is empty.
- Confirm artifacts contain final substantive content and no TODO, placeholder, or early hosted-success claim.
