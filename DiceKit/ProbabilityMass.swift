//
//  ProbabilityMass.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct ProbabilityMass: ApproximatelyEquatable {
    
    public typealias Outcome = FrequencyDistribution.Outcome
    public typealias Probability = Double
    
    public static let defaultProbabilityEqualityDelta = 1e-16 // This is for 64-bit. What should 32-bit be?
    public static var probabilityEqualityDelta = defaultProbabilityEqualityDelta
    
    public static let zero = ProbabilityMass(FrequencyDistribution.additiveIdentity)
    
    public let frequencyDistribution: FrequencyDistribution
    
    internal init(_ frequencyDistribution: FrequencyDistribution, normalize: Bool) {
        self.frequencyDistribution = normalize ? frequencyDistribution.normalizeFrequencies() : frequencyDistribution
    }
    
    public init(_ frequencyDistribution: FrequencyDistribution) {
        self.init(frequencyDistribution, normalize: true)
    }
    
    public init(_ constant: Int) {
        self.init(FrequencyDistribution([constant : 1]), normalize: false)
    }
    
}

// MARK: - CustomStringConvertible

extension ProbabilityMass: CustomStringConvertible {
    
    public var description: String {
        return frequencyDistribution.description
    }
    
}

// MARK: - Equatable

public func == (lhs: ProbabilityMass, rhs: ProbabilityMass) -> Bool {
    return lhs.frequencyDistribution == rhs.frequencyDistribution
}

// MARK: - ApproximatelyEquatable

public func ≈ (lhs: ProbabilityMass, rhs: ProbabilityMass) -> Bool {
    return lhs.frequencyDistribution.approximatelyEqual(rhs.frequencyDistribution, delta: ProbabilityMass.probabilityEqualityDelta)
}

// MARK: - Indexable

extension ProbabilityMass: Indexable {
    
    public typealias Index = FrequencyDistributionIndex
    public typealias _Element = (Outcome, Probability)
    
    /// Returns the `Index` for the given value, or `nil` if the value is not
    /// present in the frequency distribution.
    public func indexForOutcome(outcome: Outcome) -> Index? {
        return frequencyDistribution.indexForOutcome(outcome)
    }
    
    public var startIndex: Index {
        return frequencyDistribution.startIndex
    }
    
    public var endIndex: Index {
        return frequencyDistribution.endIndex
    }
    
    public subscript(index: Index) -> (Outcome, Probability) {
        return frequencyDistribution[index]
    }
    
}

// MARK: - CollectionType

extension ProbabilityMass: CollectionType {
    // Protocol defaults cover implmentation after conforming to `Indexable`
}

// MARK: - Operations

extension ProbabilityMass {
    
    public subscript(value: Outcome) -> Probability? {
        get {
            return frequencyDistribution[value]
        }
    }
    
    public func negate() -> ProbabilityMass {
        let freqDist = frequencyDistribution.negateOutcomes()
        
        return ProbabilityMass(freqDist, normalize: false)
    }
    
    public func xor(x: ProbabilityMass) -> ProbabilityMass {
        let freqDist = frequencyDistribution.add(x.frequencyDistribution)
        
        return ProbabilityMass(freqDist, normalize: true)
    }
    
    public func and(x: ProbabilityMass) -> ProbabilityMass {
        let freqDist = frequencyDistribution.multiply(x.frequencyDistribution)
        
        return ProbabilityMass(freqDist, normalize: true)
    }
    
    public func product(x: ProbabilityMass) -> ProbabilityMass {
        let freqDist = frequencyDistribution.power(x.frequencyDistribution)
        
        return ProbabilityMass(freqDist, normalize: true)
    }
    
}

// MARK: - Operators

public prefix func - (x: ProbabilityMass) -> ProbabilityMass {
    return x.negate()
}

// Logical XOR
infix operator ^^ {
    associativity left
    precedence 110
}

public func ^^ (lhs: ProbabilityMass, rhs: ProbabilityMass) -> ProbabilityMass {
    return lhs.xor(rhs)
}

public func && (lhs: ProbabilityMass, rhs: ProbabilityMass) -> ProbabilityMass {
    return lhs.and(rhs)
}

public func * (lhs: ProbabilityMass, rhs: ProbabilityMass) -> ProbabilityMass {
    return lhs.product(rhs)
}
