---
spec: parse.spec.md
---

## Key Decisions

- The package remains one Foundation-based `Parse` library target. The companion groups the existing API by capability without inventing new source modules or behavior.
- Seeded generators are mutable values; all other utilities are value types or static/String extensions. No actor, callback, network, persistence, or autonomous scheduling contract exists.
- Failure behavior remains the implemented mix of `TextError`, optionals, booleans, and empty/original values. The spec does not claim that every public `TextError` case is currently thrown.
- Governance enforces 100% coverage while leaving `Sources/`, `Tests/`, `Package.swift`, and existing platform/documentation workflows unchanged.

## Files to Read First

- `Package.swift` for supported platforms and the DocC-only dependency.
- `Sources/Parse/Parsing/CSVParser.swift`, `KeyValueParser.swift`, and `Tokenizer.swift` for parsing boundaries.
- `Sources/Parse/Matching/FuzzyMatcher.swift` and its algorithm implementations for similarity behavior.
- `Sources/Parse/Generators/RandomSource.swift` for deterministic generation.
- `Tests/ParseTests/` for 185 executable examples across nine XCTest classes.

## Current Status

- The existing implementation is 38 production Swift files and 3,278 lines; nine test files bring the audited total to 47 files and 4,847 lines.
- Native `fledge lanes run verify` builds successfully and passes all 185 tests.
- The migration documents the existing API and adds SpecSync 5.0.1/Trust 1.0.0 governance without product edits.

## Known Boundaries

- CSV is a lightweight physical-line parser, not a standards-complete multiline RFC 4180 implementation.
- Readability, syllable, email, URL, pluralization, case-detection, and slug behavior are deterministic heuristics, not linguistic or standards-validation services.
- Random generation is reproducible utility randomness and is not cryptographically secure.
- Dictionary/set ordering, Markov starting-prefix order, and equal-score tie order are not stable API promises.
