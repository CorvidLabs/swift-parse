---
change: CHG-0002-document-the-complete-existing-parse-api-and-behavior-for-specsync-5-0-1
artifact: context
---

# Context

Swift Parse already implements a broad public text utility API across 38 production source files and 3,278 lines, but adoption began without a canonical companion and with an advisory zero threshold. This documentation change records the existing contract at full coverage without modifying `Sources/`, `Tests/`, `Package.swift`, or README.

The companion separates executed evidence from source review: 185 deterministic XCTest methods cover principal behavior across nine classes, while readability, escape/URL encoding, byte/duration formatting, Markov/name generation, several similarity algorithms, key/value/token parsing, and general String conveniences without direct tests are explicitly labeled source-reviewed.
