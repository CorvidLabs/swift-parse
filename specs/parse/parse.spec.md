---
module: parse
version: 2
status: active
files:
  - Sources/Parse/Analysis/CharacterFrequency.swift
  - Sources/Parse/Analysis/ReadabilityScore.swift
  - Sources/Parse/Analysis/TextStatistics.swift
  - Sources/Parse/Encoding/Base64Codec.swift
  - Sources/Parse/Encoding/Data/HTMLEntityMap.swift
  - Sources/Parse/Encoding/EscapeSequences.swift
  - Sources/Parse/Encoding/HTMLEntities.swift
  - Sources/Parse/Encoding/URLEncoder.swift
  - Sources/Parse/Formatters/ByteFormatter.swift
  - Sources/Parse/Formatters/Data/IrregularPlurals.swift
  - Sources/Parse/Formatters/DurationFormatter.swift
  - Sources/Parse/Formatters/Ordinalizer.swift
  - Sources/Parse/Formatters/Pluralizer.swift
  - Sources/Parse/Formatters/RelativeTimeFormatter.swift
  - Sources/Parse/Generators/Data/FirstNames.swift
  - Sources/Parse/Generators/Data/LastNames.swift
  - Sources/Parse/Generators/Data/LoremWords.swift
  - Sources/Parse/Generators/LoremIpsum.swift
  - Sources/Parse/Generators/MarkovChain.swift
  - Sources/Parse/Generators/NameGenerator.swift
  - Sources/Parse/Generators/RandomSource.swift
  - Sources/Parse/Matching/FuzzyMatcher.swift
  - Sources/Parse/Matching/GlobPattern.swift
  - Sources/Parse/Matching/JaroWinkler.swift
  - Sources/Parse/Matching/LevenshteinDistance.swift
  - Sources/Parse/Matching/LongestCommonSubsequence.swift
  - Sources/Parse/Parsing/CSVParser.swift
  - Sources/Parse/Parsing/KeyValueParser.swift
  - Sources/Parse/Parsing/Tokenizer.swift
  - Sources/Parse/Templates/Template.swift
  - Sources/Parse/Templates/TemplateContext.swift
  - Sources/Parse/TextError.swift
  - Sources/Parse/Utilities/CaseStyle.swift
  - Sources/Parse/Utilities/SlugGenerator.swift
  - Sources/Parse/Utilities/StringExtensions.swift
  - Sources/Parse/Utilities/StringPadding.swift
  - Sources/Parse/Utilities/StringTruncation.swift
  - Sources/Parse/Utilities/WordWrapper.swift
db_tables: []
depends_on: []
---

# Parse

## Purpose

`Parse` is a Foundation-based Swift library for analyzing, encoding, formatting, generating, matching, parsing, templating, and transforming text. Its public contract is synchronous and value-oriented: callers provide strings, data, dates, durations, collections, or deterministic seeds and receive values or explicit `TextError` failures. It does not perform network I/O, persistence, localization, HTML parsing, standards-complete CSV parsing, cryptographic randomness, or natural-language understanding.

## Public API

### Analysis

| Type | Public surface and behavior |
|------|-----------------------------|
| `CharacterFrequency` | Stores source `text`; exposes absolute and relative frequency dictionaries, descending frequency tuples, optional most/least-frequent characters, per-character lookups, threshold filtering, unique-character set/count, and `String.characterFrequency`. Empty text produces empty maps, `nil` extrema, and zero lookups. Equal-frequency ordering is not promised. |
| `TextStatistics` | Computes character, non-whitespace, letter, digit, word, sentence, paragraph, line, average-length, word-list, sentence-list, paragraph-list, longest/shortest-word, and approximate syllable values, with `String.statistics`. Words split on whitespace/newlines and trim punctuation; sentence recognition requires terminal `.`, `!`, or `?`; empty divisors yield zero and empty extrema yield `nil`. |
| `ReadabilityScore` | Derives Flesch Reading Ease, Flesch-Kincaid, Gunning Fog, SMOG, Coleman-Liau, Automated Readability Index, and a Flesch-based grade label from `TextStatistics`, with `String.readabilityScore`. Missing word/sentence prerequisites return zero; SMOG requires at least three sentences. Syllables are heuristic vowel-group counts with a trailing-e adjustment, not linguistic analysis. |

### Encoding

| Type | Public surface and behavior |
|------|-----------------------------|
| `Base64Codec` | Encodes `String`/Foundation `Data` using standard or unpadded URL-safe Base64. URL-safe decoding restores alphabet and padding; invalid Base64 or non-UTF-8 text throws `TextError.decodingFailed`. String conveniences provide standard/URL-safe encode and optional decode. |
| `EscapeSequences` | Escapes newline, return, tab, slash, quotes, backspace, form feed, and non-printable/non-ASCII leading scalars; unescapes those forms and `\\u{...}` scalar notation. Unknown escaped characters retain the character without the slash. `String.escaped` and `.unescaped` are conveniences. |
| `HTMLEntities` | Encodes the five essential HTML characters by default or every character present in the internal named-entity map when `encodeAll` is true. Decoding replaces known named entities and valid decimal/hex numeric entities; unknown/invalid entities remain text. String conveniences expose essential/all encoding and decoding. |
| `URLEncoder` | Percent-encodes with a caller-selected `CharacterSet`, decodes percent escapes, and maps string dictionaries to/from ampersand-separated query pairs. Malformed pairs are ignored; repeated keys overwrite earlier values; dictionary output order is not promised. String conveniences cover generic, path, query, and fragment sets. |

### Formatting

| Type | Public surface and behavior |
|------|-----------------------------|
| `ByteFormatter` | Formats `Int64`/`Int` byte counts using binary units (`B` through `EiB`, divisor 1024) or decimal units (`B` through `EB`, divisor 1000), configurable decimal places, automatic unit selection, and explicit-unit selection with fallback for unknown units. |
| `DurationFormatter` | Formats the absolute integer seconds of a `TimeInterval` as short, medium, long, or `h:mm:ss` compact output. `includeZeroComponents` controls zero-valued components; medium/long units pluralize by count. `TimeInterval` and `Int` expose conveniences. |
| `Ordinalizer` | Produces English numeric suffixes, numeric ordinal strings, and optional spelled ordinals for 1...20. Suffix selection uses absolute value and the 11...13 exception; `Int` exposes suffix/string/word conveniences. |
| `Pluralizer` | Applies the implemented irregular table and suffix rules, preserves all-uppercase or leading-uppercase irregular forms, leaves singular only when count equals one, and can prefix the count. This is an English heuristic inflector, not a general morphology engine. |
| `RelativeTimeFormatter` | Selects second/minute/hour/day/week/month/year buckets from the absolute interval and renders past/future medium/long phrases or compact suffixes. Positive intervals mean past; negative intervals mean future. `Date` and `TimeInterval` expose conveniences. |

### Generation

| Type | Public surface and behavior |
|------|-----------------------------|
| `RandomSource` | Mutable xorshift64 generator with deterministic nonzero seed normalization, time-seeded convenience init, unsigned/double/ranged-double/integer/ranged-integer/boolean/element APIs, in-place Fisher-Yates shuffle, and shuffled copy. Non-positive integer bounds return zero and empty element lookup returns `nil`. It is deterministic utility randomness, not cryptographic randomness. |
| `LoremIpsum` | Seedable generator for words, sentences, paragraphs, and an approximate character count. Positive word requests may begin with the classic five words; sentence lengths are 5...15 words and paragraph lengths 3...7 sentences. Non-positive word/sentence/paragraph counts return empty; String static conveniences create fresh generators. |
| `MarkovChain` | Builds an order-N word-prefix map from whitespace-separated training text and generates seedable text, terminal-punctuation-normalized sentences, or multiple sentences. Empty/insufficient chains and non-positive requests return empty results; generation may restart from another prefix when a chain path ends. |
| `NameGenerator` | Seedable selection from bundled first/last-name data with full-name arrays, username, email, initials, and String static conveniences. Empty internal tables fall back to `John`/`Doe`; output is sample data and is not guaranteed unique or identity-valid. |

### Matching

| Type | Public surface and behavior |
|------|-----------------------------|
| `LevenshteinDistance` | Computes insertion/deletion/substitution distance and max-length-normalized similarity, including distance zero and similarity one for two empty strings; String conveniences mirror both operations. |
| `LongestCommonSubsequence` | Computes LCS length, one backtracked subsequence, and max-length-normalized similarity; empty pairs have similarity one and any empty operand has length zero. String conveniences expose all forms. |
| `JaroWinkler` | Computes Jaro and prefix-boosted Jaro-Winkler similarity with configurable scaling factor and maximum prefix length. Two empty strings score one, one empty string scores zero; String conveniences use defaults. |
| `FuzzyMatcher` | Selects Levenshtein, Jaro, Jaro-Winkler, or LCS similarity; compares against a configurable threshold; returns best, threshold-filtered, or descending closest candidates. Empty best-match input yields `nil`; ties do not promise a stable winner. |
| `GlobPattern` | Full-string Unix-style matching for `*`, `?`, bracket members/ranges, and `[!... ]` negation, with optional case folding and array filtering. An unterminated `[` is treated as a literal that will generally fail unless matched literally by the remaining algorithm; there is no path-separator specialization. |

### Parsing and Templates

| Type | Public surface and behavior |
|------|-----------------------------|
| `CSVParser` | Configures delimiter, quote, escape, header-row handling, and trimming; parses non-empty physical lines into optional headers and bounds-safe rows; formats values with quoting when they contain delimiter, quote, or newline. It supports backslash-style escape handling but not multiline quoted records or RFC 4180 doubled-quote semantics. |
| `KeyValueParser` | Parses key/value pairs with configurable separator and pair separator, using the first character of each separator for parsing and the full strings for formatting. Empty pairs are skipped, duplicate keys overwrite earlier values, malformed pairs throw `TextError.parsingFailed`, and dictionary formatting order is not promised. |
| `Tokenizer` | Splits whitespace-delimited words, regex-recognized terminal-punctuation sentences, or adjacent runs classified as word, whitespace, punctuation, number, or symbol. It filters typed tokens and values; String exposes words/tokens/sentences. |
| `TemplateContext` | Immutable string dictionary context with lookup, overwrite-on-merge, functional setting, variable-name enumeration, and dictionary-literal construction. Enumeration order is not promised. |
| `Template` | Interpolates identifier-shaped variables using mustache, dollar, percent, or custom delimiters; missing values render as empty strings. It reports variable occurrences and missing names, including duplicates, and String exposes render conveniences. It does not implement escaping, sections, conditionals, or expression evaluation. |

### String Utilities and Errors

| Type | Public surface and behavior |
|------|-----------------------------|
| `CaseStyle` | Detects or explicitly interprets camel, Pascal, snake, kebab, screaming-snake, title, or sentence input and converts to any target style. Detection prioritizes underscore, hyphen, space, then uppercase boundaries; empty input returns empty. String conveniences cover five common targets. |
| `SlugGenerator` | Optionally lowercases, removes characters outside ASCII letters/digits/whitespace/hyphen, collapses whitespace and configured separators, and trims separators. It is ASCII-oriented and does not transliterate Unicode. |
| `PaddingAlignment` / String padding | Pads only when the requested width exceeds the current character count; left means content followed by padding, right means padding followed by content, and center assigns an odd extra character to the right. Convenience names `paddedLeft`/`paddedRight` describe where padding is placed. |
| `TruncationPosition` / String truncation | Preserves strings already within the requested length; otherwise inserts an ellipsis at start, middle, or end while keeping total character count at the requested length. If the length cannot hold the ellipsis it returns the ellipsis prefix. |
| `WordWrapper` | Wraps each existing line independently to a character-count width, optionally splitting overlong words into fixed-width chunks; without splitting, an overlong word remains intact. It preserves newline boundaries and exposes `String.wrapped`. Width is expected to be positive when `breakWords` is enabled. |
| String general utilities | `isBlank`, `trimmed`, `lineCount`, email/URL heuristics, positive-count repetition, reversal, first/last character, character-set removal, whitespace removal, first-character capitalization, line splitting, empty-line removal, indentation, and Levenshtein similarity are synchronous value transformations. |
| `TextError` | Sendable descriptive error vocabulary for invalid input/pattern/format, parsing, encoding, decoding, and bounds failures. Current throwing surfaces use parsing/decoding cases; other cases remain public vocabulary and are not claimed to be thrown everywhere. |

### Exported Symbol Index

The following parser-complete index maps every caller-visible symbol to its owning contract above.

| Export | Description |
|--------|-------------|
| `CharacterFrequency` | Semantics and constraints are defined by the owning public type contract above. |
| `text` | Semantics and constraints are defined by the owning public type contract above. |
| `frequencies` | Semantics and constraints are defined by the owning public type contract above. |
| `relativeFrequencies` | Semantics and constraints are defined by the owning public type contract above. |
| `sortedByFrequency` | Semantics and constraints are defined by the owning public type contract above. |
| `mostFrequent` | Semantics and constraints are defined by the owning public type contract above. |
| `leastFrequent` | Semantics and constraints are defined by the owning public type contract above. |
| `frequency` | Semantics and constraints are defined by the owning public type contract above. |
| `relativeFrequency` | Semantics and constraints are defined by the owning public type contract above. |
| `characters` | Semantics and constraints are defined by the owning public type contract above. |
| `uniqueCharacters` | Semantics and constraints are defined by the owning public type contract above. |
| `uniqueCharacterCount` | Semantics and constraints are defined by the owning public type contract above. |
| `characterFrequency` | Semantics and constraints are defined by the owning public type contract above. |
| `init` | Semantics and constraints are defined by the owning public type contract above. |
| `ReadabilityScore` | Semantics and constraints are defined by the owning public type contract above. |
| `fleschReadingEase` | Semantics and constraints are defined by the owning public type contract above. |
| `fleschKincaidGradeLevel` | Semantics and constraints are defined by the owning public type contract above. |
| `gunningFogIndex` | Semantics and constraints are defined by the owning public type contract above. |
| `smogIndex` | Semantics and constraints are defined by the owning public type contract above. |
| `colemanLiauIndex` | Semantics and constraints are defined by the owning public type contract above. |
| `automatedReadabilityIndex` | Semantics and constraints are defined by the owning public type contract above. |
| `readabilityGrade` | Semantics and constraints are defined by the owning public type contract above. |
| `readabilityScore` | Semantics and constraints are defined by the owning public type contract above. |
| `TextStatistics` | Semantics and constraints are defined by the owning public type contract above. |
| `characterCount` | Semantics and constraints are defined by the owning public type contract above. |
| `characterCountWithoutWhitespace` | Semantics and constraints are defined by the owning public type contract above. |
| `letterCount` | Semantics and constraints are defined by the owning public type contract above. |
| `digitCount` | Semantics and constraints are defined by the owning public type contract above. |
| `wordCount` | Semantics and constraints are defined by the owning public type contract above. |
| `sentenceCount` | Semantics and constraints are defined by the owning public type contract above. |
| `paragraphCount` | Semantics and constraints are defined by the owning public type contract above. |
| `lineCount` | Semantics and constraints are defined by the owning public type contract above. |
| `averageWordLength` | Semantics and constraints are defined by the owning public type contract above. |
| `averageSentenceLength` | Semantics and constraints are defined by the owning public type contract above. |
| `words` | Semantics and constraints are defined by the owning public type contract above. |
| `sentences` | Semantics and constraints are defined by the owning public type contract above. |
| `paragraphs` | Semantics and constraints are defined by the owning public type contract above. |
| `longestWord` | Semantics and constraints are defined by the owning public type contract above. |
| `shortestWord` | Semantics and constraints are defined by the owning public type contract above. |
| `syllableCount` | Semantics and constraints are defined by the owning public type contract above. |
| `statistics` | Semantics and constraints are defined by the owning public type contract above. |
| `Base64Codec` | Semantics and constraints are defined by the owning public type contract above. |
| `EncodingOptions` | Semantics and constraints are defined by the owning public type contract above. |
| `options` | Semantics and constraints are defined by the owning public type contract above. |
| `encode` | Semantics and constraints are defined by the owning public type contract above. |
| `decode` | Semantics and constraints are defined by the owning public type contract above. |
| `decodeToData` | Semantics and constraints are defined by the owning public type contract above. |
| `base64Encoded` | Semantics and constraints are defined by the owning public type contract above. |
| `base64Decoded` | Semantics and constraints are defined by the owning public type contract above. |
| `urlSafeBase64Encoded` | Semantics and constraints are defined by the owning public type contract above. |
| `urlSafeBase64Decoded` | Semantics and constraints are defined by the owning public type contract above. |
| `standard` | Semantics and constraints are defined by the owning public type contract above. |
| `urlSafe` | Semantics and constraints are defined by the owning public type contract above. |
| `EscapeSequences` | Semantics and constraints are defined by the owning public type contract above. |
| `escape` | Semantics and constraints are defined by the owning public type contract above. |
| `unescape` | Semantics and constraints are defined by the owning public type contract above. |
| `escaped` | Semantics and constraints are defined by the owning public type contract above. |
| `unescaped` | Semantics and constraints are defined by the owning public type contract above. |
| `HTMLEntities` | Semantics and constraints are defined by the owning public type contract above. |
| `encodeAll` | Semantics and constraints are defined by the owning public type contract above. |
| `htmlEncoded` | Semantics and constraints are defined by the owning public type contract above. |
| `htmlDecoded` | Semantics and constraints are defined by the owning public type contract above. |
| `htmlEncodedAll` | Semantics and constraints are defined by the owning public type contract above. |
| `URLEncoder` | Semantics and constraints are defined by the owning public type contract above. |
| `allowedCharacters` | Semantics and constraints are defined by the owning public type contract above. |
| `encodeQueryParameters` | Semantics and constraints are defined by the owning public type contract above. |
| `decodeQueryString` | Semantics and constraints are defined by the owning public type contract above. |
| `urlEncoded` | Semantics and constraints are defined by the owning public type contract above. |
| `urlDecoded` | Semantics and constraints are defined by the owning public type contract above. |
| `urlPathEncoded` | Semantics and constraints are defined by the owning public type contract above. |
| `urlQueryEncoded` | Semantics and constraints are defined by the owning public type contract above. |
| `urlFragmentEncoded` | Semantics and constraints are defined by the owning public type contract above. |
| `queryString` | Semantics and constraints are defined by the owning public type contract above. |
| `ByteFormatter` | Semantics and constraints are defined by the owning public type contract above. |
| `UnitSystem` | Semantics and constraints are defined by the owning public type contract above. |
| `unitSystem` | Semantics and constraints are defined by the owning public type contract above. |
| `decimalPlaces` | Semantics and constraints are defined by the owning public type contract above. |
| `format` | Semantics and constraints are defined by the owning public type contract above. |
| `formattedBytes` | Semantics and constraints are defined by the owning public type contract above. |
| `binary` | Semantics and constraints are defined by the owning public type contract above. |
| `decimal` | Semantics and constraints are defined by the owning public type contract above. |
| `DurationFormatter` | Semantics and constraints are defined by the owning public type contract above. |
| `Style` | Semantics and constraints are defined by the owning public type contract above. |
| `style` | Semantics and constraints are defined by the owning public type contract above. |
| `includeZeroComponents` | Semantics and constraints are defined by the owning public type contract above. |
| `formattedDuration` | Semantics and constraints are defined by the owning public type contract above. |
| `short` | Semantics and constraints are defined by the owning public type contract above. |
| `medium` | Semantics and constraints are defined by the owning public type contract above. |
| `long` | Semantics and constraints are defined by the owning public type contract above. |
| `compact` | Semantics and constraints are defined by the owning public type contract above. |
| `Ordinalizer` | Semantics and constraints are defined by the owning public type contract above. |
| `suffix` | Semantics and constraints are defined by the owning public type contract above. |
| `ordinalize` | Semantics and constraints are defined by the owning public type contract above. |
| `ordinalWord` | Semantics and constraints are defined by the owning public type contract above. |
| `ordinalSuffix` | Semantics and constraints are defined by the owning public type contract above. |
| `ordinalized` | Semantics and constraints are defined by the owning public type contract above. |
| `Pluralizer` | Semantics and constraints are defined by the owning public type contract above. |
| `pluralize` | Semantics and constraints are defined by the owning public type contract above. |
| `quantify` | Semantics and constraints are defined by the owning public type contract above. |
| `pluralized` | Semantics and constraints are defined by the owning public type contract above. |
| `quantified` | Semantics and constraints are defined by the owning public type contract above. |
| `RelativeTimeFormatter` | Semantics and constraints are defined by the owning public type contract above. |
| `relativeTime` | Semantics and constraints are defined by the owning public type contract above. |
| `LoremIpsum` | Semantics and constraints are defined by the owning public type contract above. |
| `startWithClassic` | Semantics and constraints are defined by the owning public type contract above. |
| `loremWords` | Semantics and constraints are defined by the owning public type contract above. |
| `loremSentences` | Semantics and constraints are defined by the owning public type contract above. |
| `loremParagraphs` | Semantics and constraints are defined by the owning public type contract above. |
| `MarkovChain` | Semantics and constraints are defined by the owning public type contract above. |
| `order` | Semantics and constraints are defined by the owning public type contract above. |
| `generate` | Semantics and constraints are defined by the owning public type contract above. |
| `generateSentence` | Semantics and constraints are defined by the owning public type contract above. |
| `generateSentences` | Semantics and constraints are defined by the owning public type contract above. |
| `NameGenerator` | Semantics and constraints are defined by the owning public type contract above. |
| `firstName` | Semantics and constraints are defined by the owning public type contract above. |
| `lastName` | Semantics and constraints are defined by the owning public type contract above. |
| `fullName` | Semantics and constraints are defined by the owning public type contract above. |
| `fullNames` | Semantics and constraints are defined by the owning public type contract above. |
| `username` | Semantics and constraints are defined by the owning public type contract above. |
| `email` | Semantics and constraints are defined by the owning public type contract above. |
| `initials` | Semantics and constraints are defined by the owning public type contract above. |
| `randomName` | Semantics and constraints are defined by the owning public type contract above. |
| `randomEmail` | Semantics and constraints are defined by the owning public type contract above. |
| `RandomSource` | Semantics and constraints are defined by the owning public type contract above. |
| `nextUInt64` | Semantics and constraints are defined by the owning public type contract above. |
| `nextDouble` | Semantics and constraints are defined by the owning public type contract above. |
| `nextInt` | Semantics and constraints are defined by the owning public type contract above. |
| `nextBool` | Semantics and constraints are defined by the owning public type contract above. |
| `nextElement` | Semantics and constraints are defined by the owning public type contract above. |
| `shuffle` | Semantics and constraints are defined by the owning public type contract above. |
| `shuffled` | Semantics and constraints are defined by the owning public type contract above. |
| `FuzzyMatcher` | Semantics and constraints are defined by the owning public type contract above. |
| `Algorithm` | Semantics and constraints are defined by the owning public type contract above. |
| `algorithm` | Semantics and constraints are defined by the owning public type contract above. |
| `threshold` | Semantics and constraints are defined by the owning public type contract above. |
| `matches` | Semantics and constraints are defined by the owning public type contract above. |
| `similarity` | Semantics and constraints are defined by the owning public type contract above. |
| `bestMatch` | Semantics and constraints are defined by the owning public type contract above. |
| `findMatches` | Semantics and constraints are defined by the owning public type contract above. |
| `closestMatches` | Semantics and constraints are defined by the owning public type contract above. |
| `fuzzyMatches` | Semantics and constraints are defined by the owning public type contract above. |
| `bestFuzzyMatch` | Semantics and constraints are defined by the owning public type contract above. |
| `levenshtein` | Semantics and constraints are defined by the owning public type contract above. |
| `jaro` | Semantics and constraints are defined by the owning public type contract above. |
| `jaroWinkler` | Semantics and constraints are defined by the owning public type contract above. |
| `lcs` | Semantics and constraints are defined by the owning public type contract above. |
| `GlobPattern` | Semantics and constraints are defined by the owning public type contract above. |
| `pattern` | Semantics and constraints are defined by the owning public type contract above. |
| `caseSensitive` | Semantics and constraints are defined by the owning public type contract above. |
| `filter` | Semantics and constraints are defined by the owning public type contract above. |
| `matchesGlob` | Semantics and constraints are defined by the owning public type contract above. |
| `JaroWinkler` | Semantics and constraints are defined by the owning public type contract above. |
| `scalingFactor` | Semantics and constraints are defined by the owning public type contract above. |
| `maxPrefixLength` | Semantics and constraints are defined by the owning public type contract above. |
| `jaroSimilarity` | Semantics and constraints are defined by the owning public type contract above. |
| `jaroWinklerSimilarity` | Semantics and constraints are defined by the owning public type contract above. |
| `LevenshteinDistance` | Semantics and constraints are defined by the owning public type contract above. |
| `calculate` | Semantics and constraints are defined by the owning public type contract above. |
| `levenshteinDistance` | Semantics and constraints are defined by the owning public type contract above. |
| `levenshteinSimilarity` | Semantics and constraints are defined by the owning public type contract above. |
| `LongestCommonSubsequence` | Semantics and constraints are defined by the owning public type contract above. |
| `length` | Semantics and constraints are defined by the owning public type contract above. |
| `find` | Semantics and constraints are defined by the owning public type contract above. |
| `longestCommonSubsequence` | Semantics and constraints are defined by the owning public type contract above. |
| `longestCommonSubsequenceLength` | Semantics and constraints are defined by the owning public type contract above. |
| `lcsSimilarity` | Semantics and constraints are defined by the owning public type contract above. |
| `CSVParser` | Semantics and constraints are defined by the owning public type contract above. |
| `Options` | Semantics and constraints are defined by the owning public type contract above. |
| `delimiter` | Semantics and constraints are defined by the owning public type contract above. |
| `quote` | Semantics and constraints are defined by the owning public type contract above. |
| `hasHeaderRow` | Semantics and constraints are defined by the owning public type contract above. |
| `trimWhitespace` | Semantics and constraints are defined by the owning public type contract above. |
| `Row` | Semantics and constraints are defined by the owning public type contract above. |
| `values` | Semantics and constraints are defined by the owning public type contract above. |
| `Data` | Semantics and constraints are defined by the owning public type contract above. |
| `headers` | Semantics and constraints are defined by the owning public type contract above. |
| `rows` | Semantics and constraints are defined by the owning public type contract above. |
| `count` | Semantics and constraints are defined by the owning public type contract above. |
| `parse` | Semantics and constraints are defined by the owning public type contract above. |
| `parseCSV` | Semantics and constraints are defined by the owning public type contract above. |
| `subscript` | Semantics and constraints are defined by the owning public type contract above. |
| `KeyValueParser` | Semantics and constraints are defined by the owning public type contract above. |
| `separator` | Semantics and constraints are defined by the owning public type contract above. |
| `pairSeparator` | Semantics and constraints are defined by the owning public type contract above. |
| `parseKeyValues` | Semantics and constraints are defined by the owning public type contract above. |
| `formatKeyValues` | Semantics and constraints are defined by the owning public type contract above. |
| `Tokenizer` | Semantics and constraints are defined by the owning public type contract above. |
| `TokenType` | Semantics and constraints are defined by the owning public type contract above. |
| `Token` | Semantics and constraints are defined by the owning public type contract above. |
| `type` | Semantics and constraints are defined by the owning public type contract above. |
| `value` | Semantics and constraints are defined by the owning public type contract above. |
| `tokenize` | Semantics and constraints are defined by the owning public type contract above. |
| `tokens` | Semantics and constraints are defined by the owning public type contract above. |
| `word` | Semantics and constraints are defined by the owning public type contract above. |
| `whitespace` | Semantics and constraints are defined by the owning public type contract above. |
| `punctuation` | Semantics and constraints are defined by the owning public type contract above. |
| `number` | Semantics and constraints are defined by the owning public type contract above. |
| `symbol` | Semantics and constraints are defined by the owning public type contract above. |
| `Template` | Semantics and constraints are defined by the owning public type contract above. |
| `Syntax` | Semantics and constraints are defined by the owning public type contract above. |
| `openDelimiter` | Semantics and constraints are defined by the owning public type contract above. |
| `closeDelimiter` | Semantics and constraints are defined by the owning public type contract above. |
| `mustache` | Semantics and constraints are defined by the owning public type contract above. |
| `dollar` | Semantics and constraints are defined by the owning public type contract above. |
| `percent` | Semantics and constraints are defined by the owning public type contract above. |
| `syntax` | Semantics and constraints are defined by the owning public type contract above. |
| `render` | Semantics and constraints are defined by the owning public type contract above. |
| `variableNames` | Semantics and constraints are defined by the owning public type contract above. |
| `validate` | Semantics and constraints are defined by the owning public type contract above. |
| `renderTemplate` | Semantics and constraints are defined by the owning public type contract above. |
| `TemplateContext` | Semantics and constraints are defined by the owning public type contract above. |
| `merging` | Semantics and constraints are defined by the owning public type contract above. |
| `setting` | Semantics and constraints are defined by the owning public type contract above. |
| `TextError` | Semantics and constraints are defined by the owning public type contract above. |
| `description` | Semantics and constraints are defined by the owning public type contract above. |
| `invalidInput` | Semantics and constraints are defined by the owning public type contract above. |
| `invalidPattern` | Semantics and constraints are defined by the owning public type contract above. |
| `invalidFormat` | Semantics and constraints are defined by the owning public type contract above. |
| `parsingFailed` | Semantics and constraints are defined by the owning public type contract above. |
| `encodingFailed` | Semantics and constraints are defined by the owning public type contract above. |
| `decodingFailed` | Semantics and constraints are defined by the owning public type contract above. |
| `outOfBounds` | Semantics and constraints are defined by the owning public type contract above. |
| `CaseStyle` | Semantics and constraints are defined by the owning public type contract above. |
| `convert` | Semantics and constraints are defined by the owning public type contract above. |
| `convertCase` | Semantics and constraints are defined by the owning public type contract above. |
| `camelCased` | Semantics and constraints are defined by the owning public type contract above. |
| `pascalCased` | Semantics and constraints are defined by the owning public type contract above. |
| `snakeCased` | Semantics and constraints are defined by the owning public type contract above. |
| `kebabCased` | Semantics and constraints are defined by the owning public type contract above. |
| `screamingSnakeCased` | Semantics and constraints are defined by the owning public type contract above. |
| `camelCase` | Semantics and constraints are defined by the owning public type contract above. |
| `pascalCase` | Semantics and constraints are defined by the owning public type contract above. |
| `snakeCase` | Semantics and constraints are defined by the owning public type contract above. |
| `kebabCase` | Semantics and constraints are defined by the owning public type contract above. |
| `screamingSnakeCase` | Semantics and constraints are defined by the owning public type contract above. |
| `titleCase` | Semantics and constraints are defined by the owning public type contract above. |
| `sentenceCase` | Semantics and constraints are defined by the owning public type contract above. |
| `SlugGenerator` | Semantics and constraints are defined by the owning public type contract above. |
| `lowercase` | Semantics and constraints are defined by the owning public type contract above. |
| `slugified` | Semantics and constraints are defined by the owning public type contract above. |
| `slug` | Semantics and constraints are defined by the owning public type contract above. |
| `isBlank` | Semantics and constraints are defined by the owning public type contract above. |
| `trimmed` | Semantics and constraints are defined by the owning public type contract above. |
| `isValidEmail` | Semantics and constraints are defined by the owning public type contract above. |
| `isValidURL` | Semantics and constraints are defined by the owning public type contract above. |
| `repeated` | Semantics and constraints are defined by the owning public type contract above. |
| `reversed` | Semantics and constraints are defined by the owning public type contract above. |
| `firstCharacter` | Semantics and constraints are defined by the owning public type contract above. |
| `lastCharacter` | Semantics and constraints are defined by the owning public type contract above. |
| `removing` | Semantics and constraints are defined by the owning public type contract above. |
| `removingWhitespace` | Semantics and constraints are defined by the owning public type contract above. |
| `capitalizedFirst` | Semantics and constraints are defined by the owning public type contract above. |
| `lines` | Semantics and constraints are defined by the owning public type contract above. |
| `removingEmptyLines` | Semantics and constraints are defined by the owning public type contract above. |
| `indented` | Semantics and constraints are defined by the owning public type contract above. |
| `PaddingAlignment` | Semantics and constraints are defined by the owning public type contract above. |
| `padded` | Semantics and constraints are defined by the owning public type contract above. |
| `paddedLeft` | Semantics and constraints are defined by the owning public type contract above. |
| `paddedRight` | Semantics and constraints are defined by the owning public type contract above. |
| `centered` | Semantics and constraints are defined by the owning public type contract above. |
| `left` | Semantics and constraints are defined by the owning public type contract above. |
| `right` | Semantics and constraints are defined by the owning public type contract above. |
| `center` | Semantics and constraints are defined by the owning public type contract above. |
| `TruncationPosition` | Semantics and constraints are defined by the owning public type contract above. |
| `truncated` | Semantics and constraints are defined by the owning public type contract above. |
| `truncatedAtEnd` | Semantics and constraints are defined by the owning public type contract above. |
| `truncatedAtStart` | Semantics and constraints are defined by the owning public type contract above. |
| `truncatedInMiddle` | Semantics and constraints are defined by the owning public type contract above. |
| `start` | Semantics and constraints are defined by the owning public type contract above. |
| `middle` | Semantics and constraints are defined by the owning public type contract above. |
| `end` | Semantics and constraints are defined by the owning public type contract above. |
| `WordWrapper` | Semantics and constraints are defined by the owning public type contract above. |
| `width` | Semantics and constraints are defined by the owning public type contract above. |
| `breakWords` | Semantics and constraints are defined by the owning public type contract above. |
| `wrap` | Semantics and constraints are defined by the owning public type contract above. |
| `wrapped` | Semantics and constraints are defined by the owning public type contract above. |

## Invariants

- Public value types and their stored configuration remain `Sendable`; mutable generators advance only through mutating calls and produce identical sequences for identical nonzero-normalized seeds and call order.
- Empty, invalid, and out-of-range inputs retain the explicit behavior documented above: optional conveniences return `nil`, nonthrowing transforms return safe empty/original values, and throwing parsers/codecs use `TextError`.
- `Parse` performs no hidden I/O or background work. Dictionary/set iteration and equal-score tie order are intentionally unspecified wherever Foundation collections provide the ordering.
- Character widths, truncation lengths, and wrapping widths use Swift `String.count`, not UTF-8 byte counts or terminal display columns.

## Behavioral Examples

- `"kitten".levenshteinDistance(to: "sitting")` is `3`; two empty strings have similarity `1.0`.
- `"Hello, World!".slug` is `"hello-world"`, while a custom separator is honored by `SlugGenerator`.
- A default `CSVParser` treats the first non-empty physical line as headers and subsequent lines as bounds-safe rows.
- `Template("Hello, {{ name }}!").render(with: ["name": "Corvid"])` substitutes `Corvid`; an absent `name` substitutes an empty string and is reported by `validate`.
- Two `RandomSource(seed: 42)` values produce the same sequence when called in the same order.

## Error Cases

- Invalid standard or URL-safe Base64 throws `TextError.decodingFailed`; optional String decode conveniences convert that failure to `nil`.
- A malformed key/value pair without the configured separator throws `TextError.parsingFailed`.
- CSV row/data subscripts return `nil` for negative or past-end indices; empty CSV lines are skipped.
- Empty candidate collections return `nil` from best-match selection, and empty random arrays return `nil` from element selection.
- Unsupported or unknown HTML entities and percent escapes remain unchanged rather than throwing.

## Dependencies

- Foundation supplies strings/data encoding, regular expressions, dates/time intervals, URLs, character sets, and localized-number formatting primitives.
- The package has no runtime third-party dependency; `swift-docc-plugin` is documentation tooling only.

## Change Log

| Change | Date | Version |
|--------|------|---------|
| Existing API documented for SpecSync 5.0.1 governance | 2026-07-14 | 1 |
| 2026-07-14 | CHG-0002-document-the-complete-existing-parse-api-and-behavior-for-specsync-5-0-1: Document the complete existing Parse API and behavior for SpecSync 5.0.1 |
