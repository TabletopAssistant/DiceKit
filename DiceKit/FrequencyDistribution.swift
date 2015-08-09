//
//  FrequencyDistribution.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/24/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public protocol FrequencyDistributionOutcomeType: InvertibleMultiplicativeType, Hashable {
    
    var multiplierEquivalent: Int { get }
    
}

extension Int: InvertibleMultiplicativeType, FrequencyDistributionOutcomeType {
    
    public static let additiveIdentity: Int = 0
    public static let multiplicativeIdentity: Int = 1
    
    public var multiplierEquivalent: Int {
        return self
    }
    
}

extension Double: InvertibleMultiplicativeType {
    
    public static let additiveIdentity: Double = 0.0
    public static let multiplicativeIdentity: Double = 1.0
    
    public var multiplierEquivalent: Double {
        return self
    }
    
}

public struct FrequencyDistribution<OutcomeType: FrequencyDistributionOutcomeType>: Equatable {
    
    public typealias Outcome = OutcomeType
    public typealias Frequency = Double
    public typealias FrequenciesPerOutcome = [Outcome: Frequency]
    
    // TODO: Change to stored properties when allowed by Swift
    public static var additiveIdentity: FrequencyDistribution {
        return FrequencyDistribution(FrequenciesPerOutcome())
    }
    public static var multiplicativeIdentity: FrequencyDistribution {
        return FrequencyDistribution([Outcome.additiveIdentity: Frequency.multiplicativeIdentity])
    }
    
    public let frequenciesPerOutcome: FrequenciesPerOutcome
    private let orderedOutcomes: [Outcome]
    
    public var totalFrequencies: Frequency {
        return frequenciesPerOutcome.reduce(0) {
            let (_, value) = $1
            return $0 + value
        }
    }
    
    public init(_ frequenciesPerOutcome: FrequenciesPerOutcome) {
        self.frequenciesPerOutcome = frequenciesPerOutcome
        self.orderedOutcomes = frequenciesPerOutcome.map { $0.0 }.sort()
    }
    
}

// MARK: - CustomStringConvertible

extension FrequencyDistribution: CustomStringConvertible {
    
    public var description: String {
        let sortedFrequenciesPerOutcome = frequenciesPerOutcome.sort {
            $0.0 < $1.0
        }
        let stringifiedFrequenciesPerOutcome: [String] = sortedFrequenciesPerOutcome.map {
            "\($0.0): \($0.1)"
        }
        let innerDesc = ", ".join(stringifiedFrequenciesPerOutcome)
        let desc = "[\(innerDesc)]"
        
        return desc
    }
    
}

// MARK: - Equatable

public func == <V>(lhs: FrequencyDistribution<V>, rhs: FrequencyDistribution<V>) -> Bool {
    return lhs.frequenciesPerOutcome == rhs.frequenciesPerOutcome
}

// MARK: - Indexable

extension FrequencyDistribution: Indexable {
    
    public typealias Index = FrequencyDistributionIndex<Outcome>
    public typealias _Element = (Outcome, Frequency) // This is needed to prevent ambigious Indexable conformance...
    
    /// Returns the `Index` for the given value, or `nil` if the value is not
    /// present in the frequency distribution.
    public func indexForOutcome(outcome: Outcome) -> Index? {
        guard frequenciesPerOutcome[outcome] != nil else {
            return nil
        }
        
        let index = orderedOutcomes.indexOf(outcome)! // This won't crash because we already know the value exists. This isn't used in the guard, because checking if it exists is O(1), while this is O(n)
        return FrequencyDistributionIndex(index: index, orderedOutcomes: orderedOutcomes)
    }
    
    public var startIndex: Index {
        return FrequencyDistributionIndex.startIndex(orderedOutcomes)
    }
    
    public var endIndex: Index {
        return FrequencyDistributionIndex.endIndex(orderedOutcomes)
    }
    
    public subscript(index: Index) -> (Outcome, Frequency) {
        let outcome = index.value!
        let frequency = frequenciesPerOutcome[outcome]!
        return (outcome, frequency)
    }
    
}

// MARK: - CollectionType

extension FrequencyDistribution: CollectionType {
    // Protocol defaults cover implmentation after conforming to `Indexable`
}

// MARK: - Operations

extension FrequencyDistribution {
    
    // MARK: Foundational Operations
    
    public func mapOutcomes(@noescape transform: (Outcome) -> Outcome) -> FrequencyDistribution {
        let newFrequenciesPerOutcome = frequenciesPerOutcome.mapKeys ({ $1 + $2 }) {
            (baseOutcome, _) in transform(baseOutcome)
        }
        
        return FrequencyDistribution(newFrequenciesPerOutcome)
    }
    
    public func mapFrequencies(@noescape transform: (Frequency) -> Frequency) -> FrequencyDistribution {
        let newFrequenciesPerOutcome = frequenciesPerOutcome.mapValues {
            (_, frequency) in transform(frequency)
        }
        
        return FrequencyDistribution(newFrequenciesPerOutcome)
    }
    
    // MARK: Primitive Operations
    
    public subscript(outcome: Outcome) -> Frequency? {
        get {
            return frequenciesPerOutcome[outcome]
        }
    }
    
    public func approximatelyEqual(x: FrequencyDistribution, delta: Frequency) -> Bool {
        guard frequenciesPerOutcome.count == x.frequenciesPerOutcome.count else {
            return false
        }
        
        for (outcome, frequency) in frequenciesPerOutcome {
            guard let otherFrequency = x.frequenciesPerOutcome[outcome] else {
                return false
            }
            
            let diff = abs(frequency - otherFrequency)
            if diff > delta {
                return false
            }
        }
        
        return true
    }
    
    public func negateOutcomes() -> FrequencyDistribution {
        return mapOutcomes { -$0 }
    }
    
    public func shiftOutcomes(outcome: Outcome) -> FrequencyDistribution {
        return mapOutcomes { $0 + outcome }
    }
    
    public func scaleFrequencies(frequency: Frequency) -> FrequencyDistribution {
        return mapFrequencies { $0 * frequency }
    }
    
    public func normalizeFrequencies() -> FrequencyDistribution {
        let frequencies = totalFrequencies
        return mapFrequencies { $0 / frequencies }
    }
    
    // MARK: Advanced Operations
    
    public func add(x: FrequencyDistribution) -> FrequencyDistribution {
        var newFrequenciesPerOutcome = frequenciesPerOutcome
        for (outcome, frequency) in x.frequenciesPerOutcome {
            let exisitingFrequency = newFrequenciesPerOutcome[outcome] ?? 0
            let newFrequency = exisitingFrequency + frequency
            newFrequenciesPerOutcome[outcome] = newFrequency
        }
        
        return FrequencyDistribution(newFrequenciesPerOutcome)
    }
    
    // TODO: public func subtract(x: FrequencyDistribution) -> FrequencyDistribution
    // Probably needed to support divide
    
    public func multiply(x: FrequencyDistribution) -> FrequencyDistribution {
        return frequenciesPerOutcome.reduce(.additiveIdentity) {
            let (outcome, frequency) = $1
            let addend = x.shiftOutcomes(outcome).scaleFrequencies(frequency)
            return $0.add(addend)
        }
    }
    
    // TODO: public func divide(x: FrequencyDistribution) -> FrequencyDistribution
    // Needed to support power(-n)
    
    
    /// This is a special case of `power(x: FrequencyDistribution)`,
    /// for when `x` is `FrequencyDistribution([x: 1])`.
    public func power(x: Outcome) -> FrequencyDistribution {
        let power = x.multiplierEquivalent
        guard power != 0 else { return .multiplicativeIdentity }
        
        // Crappy implementation. Currently O(n). Can be O(log(n)).
        var freqDist = self
        for _ in 1..<abs(power) {
            freqDist = freqDist.multiply(self)
        }
        
//        if (power < 0) {
//            return FrequencyDistribution.multiplicativeIdentity.divide(freqDist)
//        } else {
            return freqDist
//        }
    }
    
    public func power(x: FrequencyDistribution) -> FrequencyDistribution {
        return frequenciesPerOutcome.reduce(.additiveIdentity) {
            let (outcome, frequency) = $1
            let addend = x.power(outcome).normalizeFrequencies().scaleFrequencies(frequency)
            return $0.add(addend)
        }
    }
    
}
