//
//  Die.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/12/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

/// An imaginary die with `0` to `Int.max` sides. Default value is `defaultSides`.
public struct Die: Equatable {
    
    // TODO: Determine if there is a better way to do this.
    // Per-die rollers probably aren't the answer, but type-wide ones seem odd as well
    public static var roller = defaultRoller
    
    public let sides: Int
    
    /// Returns default number of sides for `Die`
    public static let defaultSides = 6
    
    public init(sides: Int = defaultSides) {
        self.sides = sides
    }
    
    /// Rolls the die and returns the result as a `Die.Roll`.
    ///
    /// - returns: A `Die.Roll` initiated with `self` and the value determined by
    ///     `Die.roller` by passing in `self.sides` for `sides`.
    public func roll() -> Roll {
        let result = Die.roller(sides: sides)
        return Roll(die: self, value: result)
    }
    
}

// MARK: - Convenience Initialization Functions

public func d(sides: Int) -> Die {
    return Die(sides: sides)
}

public func d() -> Die {
    return Die()
}

// MARK: - RollerType

extension Die {
    
    /// A type that "rolls" an imaginary die with `sides` number of sides
    /// and returns the result.
    public typealias RollerType = (sides: Int) -> Int
    
    /// The default `RollerType` that is used by `Die`.
    public static let defaultRoller: RollerType = Die.signedClosedRoller
    
    /// Rolls and returns a random number in `1...sides`, or `0` when `sides <= 0`.
    ///
    /// - returns: `0` when `sides <= 0`.
    ///   A number from `1...sides` when `sides > 0`.
    public static func unsignedRoller(sides sides: Int) -> Int {
        guard sides > 0 else { return 0 }
        
        return Int.random(lower: 0, upper: sides) + 1 // 1...n
    }
    
    /// Rolls and returns a random number in `1...sides`, `sides...-1`, or `0`
    /// depending on the sign.
    ///
    /// - returns: `0` when `sides == 0`,
    ///   a number from `1...sides` when `sides > 0`,
    ///   and a number from `sides...-1` when `sides < 0`.
    public static func signedClosedRoller(sides sides: Int) -> Int {
        if sides == 0 {
            return 0
        } else if sides < 0 {
            return Int.random(lower: sides, upper: 0) // -n..<0
        } else {
            return Int.random(lower: 0, upper: sides) + 1 // 1...n
        }
    }
    
    /// Rolls a returns a random number in `-sides...sides` (including `0`).
    ///
    /// Most useful for `sides = 1` to produce Fudge results (-1, 0, +1).
    ///
    /// Note: Because this is an open range, `-sides` is the same as `sides`.
    /// If `Int.min` is passed in it will be interpretted as
    /// `Int.max` (1 less value).
    /// - returns: A number in the range `-sides...sides`.
    public static func signedOpenRoller(sides sides: Int) -> Int {
        // Int.min has one more value than Int.max, causing a crash when doing abs()
        // This also allows us to subtract one below, to get the full range
        let bound = sides == Int.min ? Int.max : abs(sides)
        return Int.random(lower: -bound-1, upper: bound) + 1 // -n...n
    }
    
}

// MARK: - ExpressionType

extension Die: ExpressionType {
    
    public typealias Result = Roll
    
    public func evaluate() -> Roll {
        return roll()
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        guard sides != 0 else {
            return ProbabilityMass.zero
        }
        
        var frequenciesPerOutcome = FrequencyDistribution<ExpressionProbabilityMass.Outcome>.FrequenciesPerOutcome()
        let frequencyPerOutcome = 1.0/ExpressionProbabilityMass.Probability(abs(sides))
        let range = sides < 0 ? sides...(-1) : 1...sides
        
        for value in range {
            let outcome = ExpressionProbabilityMass.Outcome(value)
            frequenciesPerOutcome[outcome] = frequencyPerOutcome
        }
        
        return ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome), normalize: false)
    }
    
}

// MARK: - CustomStringConvertible

extension Die: CustomStringConvertible {
    
    public var description: String {
        if sides < 0 {
            return "d(\(sides))"
        } else {
            return "d\(sides)"
        }
    }
    
}

// MARK: - CustomDebugStringConvertible

extension Die: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Die(\(sides))"
    }
    
}

// MARK: - Equatable

public func == (lhs: Die, rhs: Die) -> Bool {
    return lhs.sides == rhs.sides
}
