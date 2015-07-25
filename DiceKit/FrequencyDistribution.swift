//
//  FrequencyDistribution.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/24/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct FrequencyDistribution: Equatable {
    
    public typealias Value = Int
    public typealias Outcome = Double
    public typealias OutcomesPerValue = [Value: Outcome]
    
    public static let additiveIdentity = FrequencyDistribution([:])
    public static let multiplicativeIdentity = FrequencyDistribution([1:1.0])
    
    public let outcomesPerValue: OutcomesPerValue
    private let orderedValues: [Value]
    
    public var totalOutcomes: Outcome {
        return outcomesPerValue.reduce(0) {
            let (_, value) = $1
            return $0 + value
        }
    }
    
    public init(_ outcomesPerValue: OutcomesPerValue) {
        self.outcomesPerValue = outcomesPerValue
        self.orderedValues = outcomesPerValue.map { $0.0 }.sort()
    }
    
}

// MARK: - CustomStringConvertible

extension FrequencyDistribution: CustomStringConvertible {
    
    public var description: String {
        let sortedOutcomesPerValue = outcomesPerValue.sort {
            $0.0 < $1.0
        }
        let stringifiedOutcomesPerValue: [String] = sortedOutcomesPerValue.map {
            "\($0.0): \($0.1)"
        }
        let innerDesc = ", ".join(stringifiedOutcomesPerValue)
        let desc = "[\(innerDesc)]"
        
        return desc
    }
    
}

// MARK: - Equatable

public func == (lhs: FrequencyDistribution, rhs: FrequencyDistribution) -> Bool {
    return lhs.outcomesPerValue == rhs.outcomesPerValue
}

// MARK: - Indexable

extension FrequencyDistribution: Indexable {
    
    public typealias Index = FrequencyDistributionIndex
    public typealias _Element = (Value, Outcome)
    
    /// Returns the `Index` for the given value, or `nil` if the value is not
    /// present in the frequency distribution.
    public func indexForValue(value: Value) -> Index? {
        guard outcomesPerValue[value] != nil else {
            return nil
        }
        
        let index = orderedValues.indexOf(value)! // This won't crash because we already know the value exists. This isn't used in the guard, because checking if it exists is O(1), while this is O(n)
        return FrequencyDistributionIndex(index: index, orderedValues: orderedValues)
    }
    
    public var startIndex: Index {
        return FrequencyDistributionIndex.startIndex(orderedValues)
    }
    
    public var endIndex: Index {
        return FrequencyDistributionIndex.endIndex(orderedValues)
    }
    
    public subscript(index: Index) -> (Value, Outcome) {
        let value = index.value!
        let outcome = outcomesPerValue[value]!
        return (value, outcome)
    }
    
}

// MARK: - CollectionType

extension FrequencyDistribution: CollectionType {
    // Protocol defaults cover implmentation after conforming to `Indexable`
}

// MARK: - Operations

extension FrequencyDistribution {
    
    // MARK: Primitive Operations
    
    public subscript(value: Value) -> Outcome? {
        get {
            return outcomesPerValue[value]
        }
    }
    
    public func approximatelyEqual(x: FrequencyDistribution, delta: Outcome) -> Bool {
        guard outcomesPerValue.count == x.outcomesPerValue.count else {
            return false
        }
        
        for (value, outcome) in outcomesPerValue {
            let otherOutcome = x.outcomesPerValue[value]!
            if abs(outcome - otherOutcome) > delta {
                return false
            }
        }
        
        return true
    }
    
    public func negateValues() -> FrequencyDistribution {
        let newOutcomesPerValue = outcomesPerValue.mapKeys {
            (value, _) in -value
        }
        
        return FrequencyDistribution(newOutcomesPerValue)
    }
    
    public func shiftValues(value: Value) -> FrequencyDistribution {
        let newOutcomesPerValue = outcomesPerValue.mapKeys {
            (baseValue, _) in baseValue + value
        }
        
        return FrequencyDistribution(newOutcomesPerValue)
    }
    
    public func scaleOutcomes(scalar: Double) -> FrequencyDistribution {
        let newOutcomesPerValue = outcomesPerValue.mapValues {
            (_, outcome) in outcome * scalar
        }
        
        return FrequencyDistribution(newOutcomesPerValue)
    }
    
    public func normalizeOutcomes() -> FrequencyDistribution {
        let outcomes = totalOutcomes
        let normalizedOutcomesPerValue = outcomesPerValue.mapValues {
            (_, outcome) in outcome / outcomes
        }
        
        return FrequencyDistribution(normalizedOutcomesPerValue)
    }
    
    // MARK: Advanced Operations
    
    public func add(x: FrequencyDistribution) -> FrequencyDistribution {
        var newOutcomesPerValue = outcomesPerValue
        for (value, outcome) in x.outcomesPerValue {
            let exisitingOutcome = newOutcomesPerValue[value] ?? 0
            let newOutcome = exisitingOutcome + outcome
            newOutcomesPerValue[value] = newOutcome
        }
        
        return FrequencyDistribution(newOutcomesPerValue)
    }
    
    // TODO: public func subtract(x: FrequencyDistribution) -> FrequencyDistribution
    // Probably needed to support divide
    
    public func multiply(x: FrequencyDistribution) -> FrequencyDistribution {
        return outcomesPerValue.reduce(.additiveIdentity) {
            let (value, outcome) = $1
            let addend = x.shiftValues(value).scaleOutcomes(outcome)
            return $0.add(addend)
        }
    }
    
    // TODO: public func divide(x: FrequencyDistribution) -> FrequencyDistribution
    // Needed to support power(-n)
    
    
    /// This is a special case of `power(x: FrequencyDistribution)`,
    /// for when `x` is `FrequencyDistribution([x: 1])`.
    public func power(x: Int) -> FrequencyDistribution {
        guard x != 0 else { return .multiplicativeIdentity }
        
        // Crappy implementation. Currently O(n). Can be O(log(n)).
        // TODO: Handle negative properly
        var freqDist = self
        for _ in 1..<abs(x) {
            freqDist = freqDist.multiply(self)
        }
        
        return freqDist
    }
    
    public func power(x: FrequencyDistribution) -> FrequencyDistribution {
        return outcomesPerValue.reduce(.additiveIdentity) {
            let (value, outcome) = $1
            let addend = x.power(value).normalizeOutcomes().scaleOutcomes(outcome)
            return $0.add(addend)
        }
    }
}
