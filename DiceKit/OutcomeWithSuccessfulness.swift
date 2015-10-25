//
//  OutcomeWithSuccessfulness.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/2/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public protocol OutcomeWithSuccessfulnessType {
    
    var outcome: Int { get }
    var successfulness: Successfulness { get }
    
    init(_ value: Int, _ successfulness: Successfulness)
    
}

// TODO: Determine the best name for this
public struct OutcomeWithSuccessfulness: OutcomeWithSuccessfulnessType, Comparable, Equatable {
    
    public let outcome: Int
    public let successfulness: Successfulness
    
    public init(_ outcome: Int, _ successfulness: Successfulness = .Undetermined) {
        self.outcome = outcome
        self.successfulness = successfulness
    }
    
}

// MARK: - CustomStringConvertible

extension OutcomeWithSuccessfulness: CustomStringConvertible {
    
    public var description: String {
        switch successfulness {
        case .Undetermined:
            return "\(outcome)"
        default:
            return "(\(outcome), \(successfulness))"
        }
    }
    
}

// MARK: - CustomPlaygroundQuickLookable

extension OutcomeWithSuccessfulness: CustomPlaygroundQuickLookable {
    
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        return PlaygroundQuickLook.Int(Int64(outcome))
    }
    
}

// MARK: - Equatable

public func == (lhs: OutcomeWithSuccessfulness, rhs: OutcomeWithSuccessfulness) -> Bool {
    return lhs.outcome == rhs.outcome && lhs.successfulness == rhs.successfulness
}

// MARK: - Comparable

public func < (lhs: OutcomeWithSuccessfulness, rhs: OutcomeWithSuccessfulness) -> Bool {
    if lhs.outcome == rhs.outcome {
        return lhs.successfulness < rhs.successfulness
    } else {
        return lhs.outcome < rhs.outcome
    }
}

// MARK: - FrequencyDistributionOutcomeType

extension OutcomeWithSuccessfulness: FrequencyDistributionOutcomeType, IntegerArithmeticType {
    
    // MARK: FrequencyDistributionValueType
    
    public static let additiveIdentity = OutcomeWithSuccessfulness(Int.additiveIdentity)
    public static let multiplicativeIdentity = OutcomeWithSuccessfulness(Int.multiplicativeIdentity)
    public var multiplierEquivalent: Int {
        return outcome
    }
    
    // MARK: IntegerLiteralConvertible
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    // MARK: Hashable
    
    public var hashValue: Int {
        return "\(outcome.hashValue),\(successfulness.hashValue)".hashValue
    }

    // MARK: ForwardIndexType

    public func successor() -> OutcomeWithSuccessfulness {
        let successfulnessSuccessor = successfulness.successor()
        if successfulnessSuccessor == .endIndex {
            return OutcomeWithSuccessfulness(outcome + 1, .startIndex)
        } else {
            return OutcomeWithSuccessfulness(outcome, successfulnessSuccessor)
        }
    }
    
    // MARK: IntegerArithmeticType
    
    public static func addWithOverflow(lhs: OutcomeWithSuccessfulness, _ rhs: OutcomeWithSuccessfulness) -> (OutcomeWithSuccessfulness, overflow: Bool) {
        let (outcome, overflow) = Int.addWithOverflow(lhs.outcome, rhs.outcome)
        let successfulness = lhs.successfulness + rhs.successfulness
        return (OutcomeWithSuccessfulness(outcome, successfulness), overflow: overflow)
    }
    
    public static func subtractWithOverflow(lhs: OutcomeWithSuccessfulness, _ rhs: OutcomeWithSuccessfulness) -> (OutcomeWithSuccessfulness, overflow: Bool) {
        let (outcome, overflow) = Int.subtractWithOverflow(lhs.outcome, rhs.outcome)
        let successfulness = lhs.successfulness - rhs.successfulness
        return (OutcomeWithSuccessfulness(outcome, successfulness), overflow: overflow)
    }
    
    public static func multiplyWithOverflow(lhs: OutcomeWithSuccessfulness, _ rhs: OutcomeWithSuccessfulness) -> (OutcomeWithSuccessfulness, overflow: Bool) {
        let (outcome, overflow) = Int.multiplyWithOverflow(lhs.outcome, rhs.outcome)
        let successfulness = lhs.successfulness * rhs.successfulness
        return (OutcomeWithSuccessfulness(outcome, successfulness), overflow: overflow)
    }
    
    public static func divideWithOverflow(lhs: OutcomeWithSuccessfulness, _ rhs: OutcomeWithSuccessfulness) -> (OutcomeWithSuccessfulness, overflow: Bool) {
        let (outcome, overflow) = Int.divideWithOverflow(lhs.outcome, rhs.outcome)
        let successfulness = lhs.successfulness / rhs.successfulness
        return (OutcomeWithSuccessfulness(outcome, successfulness), overflow: overflow)
    }
    
    public static func remainderWithOverflow(lhs: OutcomeWithSuccessfulness, _ rhs: OutcomeWithSuccessfulness) -> (OutcomeWithSuccessfulness, overflow: Bool) {
        let (outcome, overflow) = Int.remainderWithOverflow(lhs.outcome, rhs.outcome)
        let successfulness = lhs.successfulness % rhs.successfulness
        return (OutcomeWithSuccessfulness(outcome, successfulness), overflow: overflow)
    }
    
    public func toIntMax() -> IntMax {
        return outcome.toIntMax()
    }
    
}
