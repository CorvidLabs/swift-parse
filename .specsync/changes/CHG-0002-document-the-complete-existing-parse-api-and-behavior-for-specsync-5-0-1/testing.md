---
change: CHG-0002-document-the-complete-existing-parse-api-and-behavior-for-specsync-5-0-1
artifact: testing
---

# Testing

- Run `specsync check --strict --require-coverage 100 --force` and require 38/38 files, 3,278/3,278 lines, A/100 quality, and 276/276 documented exports.
- Run `fledge lanes run verify` and require the native build plus all 185 tests in nine XCTest classes to pass.
- Run `specsync agents status` and `fledge trust doctor`.
- Run committed-range Trust and exact-head hosted Trust/CodeQL before merge.
- Confirm `git diff origin/main...HEAD -- Sources Tests Package.swift README.md` is empty.
- Treat named source-reviewed surfaces as review evidence only; do not convert them into fabricated executed-test claims.

## Requirement Evidence Mapping

| Requirement | Verification evidence |
|-------------|-----------------------|
| REQ-parse-001 | All 12 analysis tests plus source review of readability and character-frequency exports. |
| REQ-parse-002 | All 21 encoding tests plus source review of EscapeSequences and URL query behavior. |
| REQ-parse-003 | All 33 formatter tests plus source review of byte/duration formatting. |
| REQ-parse-004 | All 20 generator tests plus source review of MarkovChain and NameGenerator. |
| REQ-parse-005 | All 18 matching tests plus source review of Jaro-Winkler, FuzzyMatcher, and LCS. |
| REQ-parse-006 | All 16 parsing tests plus source review of KeyValueParser and Tokenizer. |
| REQ-parse-007 | All 25 template tests. |
| REQ-parse-008 | All 30 utility tests plus source review of general String extensions. |
| REQ-parse-009 | Native build, all 185 tests, sendability compilation, and unchanged product files. |
| REQ-parse-010 | A/100 score, 276/276 exports, and 38/38 files at 3,278/3,278 lines. |
