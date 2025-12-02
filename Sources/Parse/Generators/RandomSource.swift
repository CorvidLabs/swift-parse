import Foundation

/// A seedable pseudo-random number generator using the xorshift64 algorithm.
public struct RandomSource: Sendable {
    private var state: UInt64

    /// Creates a random source with the given seed.
    public init(seed: UInt64) {
        self.state = seed != 0 ? seed : 1
    }

    /// Creates a random source with a seed based on the current time.
    public init() {
        self.init(seed: UInt64(Date().timeIntervalSince1970 * 1_000_000))
    }

    /// Generates the next random UInt64 using xorshift64.
    public mutating func nextUInt64() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }

    /// Generates a random Double in the range [0, 1).
    public mutating func nextDouble() -> Double {
        Double(nextUInt64()) / Double(UInt64.max)
    }

    /// Generates a random Double in the specified range.
    public mutating func nextDouble(in range: ClosedRange<Double>) -> Double {
        let normalized = nextDouble()
        return range.lowerBound + normalized * (range.upperBound - range.lowerBound)
    }

    /// Generates a random Int in the range [0, upperBound).
    public mutating func nextInt(upperBound: Int) -> Int {
        guard upperBound > 0 else { return 0 }
        return Int(nextUInt64() % UInt64(upperBound))
    }

    /// Generates a random Int in the specified range.
    public mutating func nextInt(in range: ClosedRange<Int>) -> Int {
        let count = range.upperBound - range.lowerBound + 1
        return range.lowerBound + nextInt(upperBound: count)
    }

    /// Generates a random Bool with the given probability of being true.
    public mutating func nextBool(probability: Double = 0.5) -> Bool {
        nextDouble() < probability
    }

    /// Returns a random element from the given array.
    public mutating func nextElement<T>(from array: [T]) -> T? {
        guard !array.isEmpty else { return nil }
        let index = nextInt(upperBound: array.count)
        return array[index]
    }

    /// Shuffles an array in place using Fisher-Yates algorithm.
    public mutating func shuffle<T>(_ array: inout [T]) {
        guard array.count > 1 else { return }

        for i in (1..<array.count).reversed() {
            let j = nextInt(upperBound: i + 1)
            array.swapAt(i, j)
        }
    }

    /// Returns a shuffled copy of the array.
    public mutating func shuffled<T>(_ array: [T]) -> [T] {
        var result = array
        shuffle(&result)
        return result
    }
}
