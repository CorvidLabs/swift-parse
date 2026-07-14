---
spec: parse.spec.md
---

## Requirements

The stable requirements for this existing API are introduced atomically by CHG-0002 after definition approval and successful native verification.

### REQ-parse-001

Text analysis SHALL preserve documented counting, segmentation, approximate syllable, readability-formula, empty-input, and grade-label behavior.
Acceptance Criteria
- `AnalysisTests` passes all 12 tests and every analysis export is documented.

### REQ-parse-002

Encoding helpers SHALL preserve standard/URL-safe Base64, escape-sequence, HTML entity, URL percent-encoding, and explicit invalid-input behavior.
Acceptance Criteria
- `EncodingTests` passes all 21 tests; EscapeSequences and URL query behavior are source-reviewed without fabricated direct-test claims.

### REQ-parse-003

Formatting helpers SHALL preserve binary/decimal byte units, absolute duration components, English ordinals/plurals, and relative-time buckets and styles.
Acceptance Criteria
- `FormattersTests` passes all 33 tests; byte/duration surfaces without direct cases are identified as source-reviewed.

### REQ-parse-004

Seeded generation SHALL be deterministic for identical seed and call order, preserve documented empty/non-positive handling, and remain explicitly non-cryptographic.
Acceptance Criteria
- `GeneratorsTests` passes all 20 tests; Markov and name generation are source-reviewed where no direct test exists.

### REQ-parse-005

String matching SHALL preserve Levenshtein, LCS, Jaro, Jaro-Winkler, fuzzy-ranking, threshold, empty-input, and full-string glob behavior.
Acceptance Criteria
- `MatchingTests` passes all 18 tests; Jaro-Winkler, FuzzyMatcher, and LCS details are source-reviewed where not directly tested.

### REQ-parse-006

CSV, key/value, and token parsing SHALL preserve documented configuration, bounds, error, physical-line, and round-trip behavior without claiming unsupported standards completeness.
Acceptance Criteria
- `ParsingTests` passes all 16 tests; KeyValueParser and Tokenizer are source-reviewed where no direct test exists.

### REQ-parse-007

Templates SHALL support immutable string contexts, configured delimiters, identifier-shaped substitution, missing-variable validation, and empty substitution for missing values.
Acceptance Criteria
- `TemplatesTests` passes all 25 tests.

### REQ-parse-008

String case, slug, padding, truncation, wrapping, and general transformations SHALL preserve their documented character-count and boundary behavior.
Acceptance Criteria
- `UtilitiesTests` passes all 30 tests; general String extensions not directly exercised are source-reviewed.

### REQ-parse-009

The Parse product SHALL remain a synchronous, Foundation-based, `Sendable` value API with no hidden I/O, persistence, localization, background work, or runtime third-party dependency.
Acceptance Criteria
- Native build and all 185 tests pass with `Sources/`, `Tests/`, `Package.swift`, and README unchanged by this migration.

### REQ-parse-010

All 276 parser-visible exports and all 38 production Swift files SHALL remain represented by the active canonical companion at 100% file and line coverage.
Acceptance Criteria
- `specsync score parse` is A/100 with no suggestions and strict coverage reports 38/38 files and 3,278/3,278 lines.

