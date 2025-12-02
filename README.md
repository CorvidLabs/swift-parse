# SwiftParse

![Swift 6.0+](https://img.shields.io/badge/Swift-6.0+-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20visionOS%20%7C%20Linux-lightgrey.svg)
![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)

A comprehensive Swift 6 package for text processing, analysis, and manipulation.

## Features

### Utilities
- **Case Conversion**: Convert between camelCase, snake_case, kebab-case, PascalCase, and more
- **String Padding**: Pad strings left, right, or center
- **Truncation**: Truncate strings with ellipsis at start, end, or middle
- **Word Wrapping**: Wrap text to specified width with optional word breaking
- **Slug Generation**: Create URL-safe slugs from text
- **String Extensions**: Rich set of convenience methods

### Analysis
- **Text Statistics**: Word count, sentence count, character counts, average lengths
- **Character Frequency**: Analyze character distribution and frequency
- **Readability Scores**: Flesch-Kincaid, Gunning-Fog, SMOG, Coleman-Liau, ARI

### Matching
- **Levenshtein Distance**: Edit distance calculation
- **Longest Common Subsequence**: Find LCS between strings
- **Jaro-Winkler**: Similarity metrics for fuzzy matching
- **Fuzzy Matcher**: Configurable fuzzy matching with multiple algorithms
- **Glob Patterns**: Unix-style glob pattern matching

### Generators
- **Lorem Ipsum**: Generate placeholder text
- **Name Generator**: Random name generation
- **Markov Chain**: Text generation from training data
- **Random Source**: Seedable PRNG for reproducible generation

### Formatters
- **Pluralizer**: English pluralization with irregular forms
- **Ordinalizer**: Convert numbers to ordinal form (1st, 2nd, 3rd)
- **Relative Time**: Format dates as "2 hours ago"
- **Byte Formatter**: Human-readable file sizes (KB, MB, GB)
- **Duration Formatter**: Format time intervals

### Encoding
- **Base64**: Standard and URL-safe Base64 encoding/decoding
- **URL Encoding**: Percent encoding for URLs
- **HTML Entities**: HTML entity encoding/decoding
- **Escape Sequences**: Handle escape sequences like \n, \t, etc.

### Parsing
- **Tokenizer**: Word and sentence tokenization
- **Key-Value Parser**: Parse key=value pairs
- **CSV Parser**: Full-featured CSV parsing and formatting

### Templates
- **Template Engine**: Simple variable interpolation with {{mustache}} syntax
- **Template Context**: Type-safe variable substitution

## Requirements

- Swift 6.0+
- Platforms: iOS 15+, macOS 12+, tvOS 15+, watchOS 8+, visionOS 1+

## Installation

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/CorvidLabs/swift-parse.git", from: "0.1.0")
]
```

## Usage Examples

### Case Conversion

```swift
import Parse

let text = "helloWorld"
print(text.snakeCased)    // "hello_world"
print(text.kebabCased)    // "hello-world"
print(text.pascalCased)   // "HelloWorld"
```

### String Utilities

```swift
let text = "hello"
print(text.paddedRight(toWidth: 10))  // "hello     "
print(text.centered(inWidth: 11))     // "   hello   "

let long = "Hello, World!"
print(long.truncatedAtEnd(toLength: 8))  // "Hello..."
```

### Text Analysis

```swift
let article = "This is a sample text for analysis."
let stats = article.statistics

print(stats.wordCount)              // 7
print(stats.sentenceCount)          // 1
print(stats.averageWordLength)      // ~4.3

let score = article.readabilityScore
print(score.fleschReadingEase)      // Reading ease score
print(score.readabilityGrade)       // "Very Easy", "Standard", etc.
```

### Fuzzy Matching

```swift
let matcher = FuzzyMatcher(algorithm: .jaroWinkler, threshold: 0.7)

if matcher.matches("kitten", "sitting") {
    print("Match found!")
}

let candidates = ["apple", "banana", "orange"]
if let best = "aple".bestFuzzyMatch(in: candidates) {
    print("Best match: \(best.match) (similarity: \(best.similarity))")
}
```

### Text Generation

```swift
// Lorem Ipsum
var lorem = LoremIpsum()
print(lorem.words(count: 5))
print(lorem.sentences(count: 3))
print(lorem.paragraphs(count: 2))

// Name Generation
var names = NameGenerator()
print(names.fullName())
print(names.email(domain: "example.com"))

// Markov Chain
let training = "The quick brown fox jumps over the lazy dog..."
let markov = MarkovChain(text: training, order: 2)
print(markov.generate(wordCount: 10))
```

### Formatting

```swift
// Pluralization
print("cat".pluralized)                    // "cats"
print("child".pluralized)                  // "children"
print("item".quantified(count: 5))         // "5 items"

// Ordinals
print(1.ordinalized)     // "1st"
print(2.ordinalized)     // "2nd"
print(3.ordinalWord)     // "third"

// Byte Formatting
let bytes: Int64 = 1_234_567_890
print(bytes.formattedBytes())  // "1.15 GiB"

// Duration
let seconds = 7325
print(seconds.formattedDuration())  // "2 hours 2 minutes 5 seconds"

// Relative Time
let date = Date().addingTimeInterval(-3600)
print(date.relativeTime())  // "1 hour ago"
```

### Encoding

```swift
// Base64
let text = "Hello, World!"
let encoded = text.base64Encoded
let decoded = encoded.base64Decoded

// URL Encoding
let query = "hello world"
print(query.urlEncoded)  // "hello%20world"

// HTML Entities
let html = "<p>Hello & goodbye</p>"
print(html.htmlEncoded)   // "&lt;p&gt;Hello &amp; goodbye&lt;/p&gt;"
print(html.htmlDecoded)   // Original text
```

### Parsing

```swift
// CSV
let csv = """
name,age,city
Alice,30,NYC
Bob,25,LA
"""

let data = try csv.parseCSV()
print(data.headers)  // ["name", "age", "city"]
print(data.rows[0].values)  // ["Alice", "30", "NYC"]

// Key-Value
let config = """
name=John
age=30
city=NYC
"""

let values = try config.parseKeyValues()
print(values["name"])  // "John"
```

### Templates

```swift
let template = Template("Hello, {{name}}! Welcome to {{place}}.")
let context: TemplateContext = [
    "name": "Alice",
    "place": "Swift"
]

print(template.render(with: context))
// "Hello, Alice! Welcome to Swift."

// Or use string extension
let text = "{{greeting}}, {{name}}!"
print(text.renderTemplate(with: ["greeting": "Hi", "name": "Bob"]))
// "Hi, Bob!"
```

## Architecture

The package is organized into focused modules:

- **Utilities**: String manipulation and transformation
- **Analysis**: Text analysis and statistics
- **Matching**: String similarity and pattern matching
- **Generators**: Text and data generation
- **Formatters**: Number and text formatting
- **Encoding**: Character encoding and escaping
- **Parsing**: Text parsing and tokenization
- **Templates**: Template rendering

All types conform to `Sendable` for Swift 6 concurrency safety, and the package has strict concurrency checking enabled.

## Design Principles

Following 0xLeif's coding style:

- **Protocol-Oriented**: Leverages protocols and extensions for clean APIs
- **Value Types**: Primarily uses structs for safety and performance
- **Type Safety**: Strong typing prevents errors at compile time
- **Functional**: Prefers immutability and functional patterns
- **Modern Swift**: Uses latest Swift features including async/await support
- **No Dependencies**: Pure Swift implementation (except swift-docc-plugin)

## License

MIT License
