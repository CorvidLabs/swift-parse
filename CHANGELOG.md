# Changelog

## [0.1.0] - 2025-12-02

### Added

#### Utilities
- Case conversion (camelCase, PascalCase, snake_case, kebab-case)
- String padding (left, right, center)
- String truncation with customizable ellipsis
- Word wrapping with configurable width
- Slug generation for URL-safe strings

#### Analysis
- Text statistics (word count, character count, sentence count)
- Character frequency analysis
- Readability scores (Flesch-Kincaid, Gunning Fog, SMOG)

#### Matching
- Levenshtein distance calculation
- Longest Common Subsequence (LCS)
- Jaro-Winkler similarity
- Fuzzy string matching with configurable thresholds
- Glob pattern matching

#### Generators
- Lorem Ipsum text generation
- Random name generation
- Markov chain text generation

#### Formatters
- Pluralization with irregular word support
- Ordinal number formatting (1st, 2nd, 3rd)
- Relative time formatting
- Byte size formatting
- Duration formatting

#### Encoding
- Base64 encoding/decoding
- URL encoding/decoding
- HTML entity encoding/decoding
- Escape sequence handling

#### Parsing
- Tokenizer for text splitting
- CSV parsing
- Key-value pair parsing

#### Templates
- Mustache-style template rendering
- Custom delimiter support
- Template context with nested values

#### Platform Support
- iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+
- Linux support via Swift 6.0
- Full Swift 6 concurrency safety (Sendable conformance)
