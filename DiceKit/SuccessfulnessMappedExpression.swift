//
//  SuccessfulnessMappedExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 12/20/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

/// An expression that adjusts the successfulness of the wrapped expression.
public struct SuccessfulnessMappedExpression<BaseExpression: protocol<ExpressionType, Equatable>>: Equatable {

    /// Maps an expression's outcome to a `Successfulness`.
    public typealias SuccessfulnessMapping = (ExpressionResultValue) -> Successfulness

    public let base: BaseExpression

    /// Maps the base expression's outcome to a new outcome, with it's `successfulness`
    /// replaced by the supplied `SuccessfulnessMapping`.
    let outcomeMapping: Result.OutcomeMapping

    public init(_ base: BaseExpression, successfulnessMapping: SuccessfulnessMapping) {
        self.base = base
        self.outcomeMapping = {
            // Keep existing outcome but set new successfulness
            ExpressionResultValue($0.outcome, successfulness: successfulnessMapping($0))
        }
    }
}

// MARK: - ExpressionType

extension SuccessfulnessMappedExpression: ExpressionType {

    public typealias Result = SuccessfulnessMappedExpressionResult<BaseExpression.Result>

    public func evaluate() -> Result {
        return Result(base.evaluate(), outcomeMapping: outcomeMapping)
    }

    public var probabilityMass: ExpressionProbabilityMass {
        return base.probabilityMass.mapOutcomes(outcomeMapping)
    }
}

// MARK: - CustomStringConvertible

extension SuccessfulnessMappedExpression: CustomStringConvertible {

    public var description: String {
        return "successfulnessMapped(\(base))"
    }
}

// MARK: - CustomDebugStringConvertible

extension SuccessfulnessMappedExpression: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "successfulnessMapped(\(String(reflecting: base)))"
    }
}

// MARK: - Equatable

/// Tests that the expressions have the same base expressions.
/// This can't test that they have the same `outcomeMapping`.
public func == <E>(lhs: SuccessfulnessMappedExpression<E>, rhs: SuccessfulnessMappedExpression<E>) -> Bool {
    return lhs.base == rhs.base
}

// MARK: - Operators
