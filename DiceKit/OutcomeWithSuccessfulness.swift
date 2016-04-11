//
//  OutcomeWithSuccessfulness.swift
//  DiceKit
//
//  Created by Brentley Jones on 10/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

/// A paired `FrequencyDistributionOutcomeType` and `Successfulness`.
public struct OutcomeWithSuccessfulness<Outcome: FrequencyDistributionOutcomeType>: Equatable {
    
    public let outcome: Outcome
    public let successfulness: Successfulness

    public init(_ outcome: Outcome, successfulness: Successfulness) {
        self.outcome = outcome
        self.successfulness = successfulness
    }
}

// MARK: - CustomStringConvertible

extension OutcomeWithSuccessfulness: CustomStringConvertible {
    public var description: String {
        if successfulness == .additiveIdentity {
            return "\(outcome)"
        } else {
            return "(\(outcome) with \(successfulness.rawDescription(surroundWithParentheses: false)))"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension OutcomeWithSuccessfulness: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "OutcomeWithSuccessfulness(\(String(reflecting: outcome)), successfulness: \(String(reflecting: successfulness)))"
    }
}

// MARK: - Equatable

public func == <O>(lhs: OutcomeWithSuccessfulness<O>, rhs: OutcomeWithSuccessfulness<O>) -> Bool {
    return lhs.outcome == rhs.outcome && lhs.successfulness == rhs.successfulness
}

// MARK: - Comparable

extension OutcomeWithSuccessfulness: Comparable {
}

public func < <O>(lhs: OutcomeWithSuccessfulness<O>, rhs: OutcomeWithSuccessfulness<O>) -> Bool {
    if lhs.outcome == rhs.outcome {
        return lhs.successfulness < rhs.successfulness
    } else {
        return lhs.outcome < rhs.outcome
    }
}

// MARK: - Hashable

extension OutcomeWithSuccessfulness: Hashable {
    
    public var hashValue: Int {
        return outcome.hashValue ^ successfulness.hashValue
    }
}

// MARK: - ArithmeticType

extension OutcomeWithSuccessfulness: ArithmeticType {

    // TODO: Change to stored properties when allowed by Swift
    public static var additiveIdentity: OutcomeWithSuccessfulness {
        return OutcomeWithSuccessfulness(.additiveIdentity, successfulness: .additiveIdentity)
    }
    public static var multiplicativeIdentity: OutcomeWithSuccessfulness {
        return OutcomeWithSuccessfulness(.multiplicativeIdentity, successfulness: .multiplicativeIdentity)
    }

    // MARK: IntegerLiteralType

    public init(integerLiteral value: Int) {
        self.init(Outcome(integerLiteral: value), successfulness: 0)
    }
}

public func + <O>(lhs: OutcomeWithSuccessfulness<O>, rhs: OutcomeWithSuccessfulness<O>) -> OutcomeWithSuccessfulness<O> {
    let outcome = lhs.outcome + rhs.outcome
    let successfulness = lhs.successfulness + rhs.successfulness
    return OutcomeWithSuccessfulness(outcome, successfulness: successfulness)
}

public func - <O>(lhs: OutcomeWithSuccessfulness<O>, rhs: OutcomeWithSuccessfulness<O>) -> OutcomeWithSuccessfulness<O> {
    let outcome = lhs.outcome - rhs.outcome
    let successfulness = lhs.successfulness - rhs.successfulness
    return OutcomeWithSuccessfulness(outcome, successfulness: successfulness)
}

public func * <O>(lhs: OutcomeWithSuccessfulness<O>, rhs: OutcomeWithSuccessfulness<O>) -> OutcomeWithSuccessfulness<O> {
    let outcome = lhs.outcome * rhs.outcome
    let successfulness = lhs.successfulness * rhs.successfulness
    return OutcomeWithSuccessfulness(outcome, successfulness: successfulness)
}

public func / <O>(lhs: OutcomeWithSuccessfulness<O>, rhs: OutcomeWithSuccessfulness<O>) -> OutcomeWithSuccessfulness<O> {
    let outcome = lhs.outcome / rhs.outcome
    let successfulness = lhs.successfulness / rhs.successfulness
    return OutcomeWithSuccessfulness(outcome, successfulness: successfulness)
}

public func % <O>(lhs: OutcomeWithSuccessfulness<O>, rhs: OutcomeWithSuccessfulness<O>) -> OutcomeWithSuccessfulness<O> {
    let outcome = lhs.outcome % rhs.outcome
    let successfulness = lhs.successfulness % rhs.successfulness
    return OutcomeWithSuccessfulness(outcome, successfulness: successfulness)
}

// MARK: - FrequencyDistributionOutcomeType

extension OutcomeWithSuccessfulness: FrequencyDistributionOutcomeType {

    public var multiplierEquivalent: Int {
        return outcome.multiplierEquivalent
    }
}
