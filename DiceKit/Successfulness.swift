//
//  Successfulness.swift
//  DiceKit
//
//  Created by Brentley Jones on 10/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

/// The number of successes and failures of an `ExpressionType`.
///
/// `Successfulness` can represent the actual number of successes and failures that occured while evaluating an
/// `ExpressionType`, or it can represent the possibility of successes and failures in the context of
/// a `FrequencyDistribution`.
public struct Successfulness: Equatable {
    /// The number of successes.
    ///
    /// This value cannot be negative. See `rawSuccesses`.
    public let successes: Int
    /// The number of failures.
    ///
    /// This value cannot be negative. See `rawFailures`.
    public let failures: Int

    /// The raw number of successes.
    ///
    /// This value can be negative. It's used as part of arithmetic.
    public let rawSuccesses: Int
    /// The raw number of failures.
    ///
    /// This value can be negative. It's used as part of arithmetic.
    public let rawFailures: Int

    public init(successes: Int, failures: Int) {
        self.rawSuccesses = successes
        self.rawFailures = failures

        self.successes = max(0,successes)
        self.failures = max(0,failures)
    }
}

// MARK: - CustomStringConvertible

extension Successfulness: CustomStringConvertible {
    public var description: String {
        return rawDescription(surroundWithParentheses: true)
    }

    func rawDescription(surroundWithParentheses surround: Bool) -> String {
        let innerDescription: String
        switch (successes, failures) {
        case (0, 0):
            innerDescription = "0 Successes"
        case let (s, 0):
            innerDescription = "\(s) Successes"
        case let (0, f):
            innerDescription = "\(f) Failures"
        case let (s, f):
            innerDescription = "\(s) Successes and \(f) Failures"
        }

        return surround ? "(\(innerDescription))" : innerDescription
    }
}

// MARK: - CustomDebugStringConvertible

extension Successfulness: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Successfulness(rawSuccesses: \(rawSuccesses), rawFailures: \(rawFailures))"
    }
}

// MARK: - CustomPlaygroundQuickLookable

extension Successfulness: CustomPlaygroundQuickLookable {
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        return PlaygroundQuickLook.Point(Float64(successes), Float64(failures))
    }
}

// MARK: - Equatable

public func == (lhs: Successfulness, rhs: Successfulness) -> Bool {
    return lhs.rawSuccesses == rhs.rawSuccesses && lhs.rawFailures == rhs.rawFailures
}

// MARK: - Comparable 

extension Successfulness: Comparable {
}

public func < (lhs: Successfulness, rhs: Successfulness) -> Bool {
    let lhsMult = lhs.multiplierEquivalent
    let rhsMult = rhs.multiplierEquivalent
    if lhsMult == rhsMult {
        if lhs.rawSuccesses == rhs.rawSuccesses {
            return lhs.rawFailures < rhs.rawFailures
        } else {
            return lhs.rawSuccesses < rhs.rawSuccesses
        }
    } else {
        return lhsMult < rhsMult
    }
}

// MARK: - Hashable

extension Successfulness: Hashable {
    public var hashValue: Int {
        return rawSuccesses.hashValue ^ rawFailures.hashValue
    }
}

// MARK: - ArithmeticType

extension Successfulness: ArithmeticType {
    public static let additiveIdentity = Successfulness(successes: 0, failures: 0)
    public static let multiplicativeIdentity = Successfulness(successes: 1, failures: 1)

    // MARK: IntegerLiteralType

    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: IntegerLiteralType) {
        let successes: Int
        let failures: Int
        if value > 0 {
            // Interpret it as a successes count
            successes = value
            failures = 0
        } else if value < 0 {
            // Interpret it as a failures count
            successes = 0
            failures = -value
        } else {
            successes = 0
            failures = 0
        }

        self.init(successes: successes, failures: failures)
    }
}

public func + (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let successes = lhs.rawSuccesses + rhs.rawSuccesses
    let failures = lhs.rawFailures + rhs.rawFailures
    return Successfulness(successes: successes, failures: failures)
}

public func - (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let successes = lhs.rawSuccesses - rhs.rawSuccesses
    let failures = lhs.rawFailures - rhs.rawFailures
    return Successfulness(successes: successes, failures: failures)
}

public func * (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let successes = lhs.rawSuccesses * rhs.rawSuccesses
    let failures = lhs.rawFailures * rhs.rawFailures
    return Successfulness(successes: successes, failures: failures)
}

public func / (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let successes = lhs.rawSuccesses / rhs.rawSuccesses
    let failures = lhs.rawFailures / rhs.rawFailures
    return Successfulness(successes: successes, failures: failures)
}

public func % (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let successes = lhs.rawSuccesses % rhs.rawSuccesses
    let failures = lhs.rawFailures % rhs.rawFailures
    return Successfulness(successes: successes, failures: failures)
}

// MARK: - FrequencyDistributionOutcomeType

extension Successfulness: FrequencyDistributionOutcomeType {

    public var multiplierEquivalent: Int {
        return successes - failures
    }

}
