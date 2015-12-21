//
//  SuccessfulnessMappedExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 12/20/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public struct SuccessfulnessMappedExpressionResult<BaseResult: protocol<ExpressionResultType, Equatable>>: Equatable {

    /// Maps an expression's outcome to a new outcome.
    public typealias OutcomeMapping = (ExpressionResultValue) -> ExpressionResultValue

    public let base: BaseResult
    
    let outcomeMapping: OutcomeMapping

    public init(_ base: BaseResult, outcomeMapping: OutcomeMapping) {
        self.base = base
        self.outcomeMapping = outcomeMapping
    }
}

// MARK: - CustomStringConvertible

extension SuccessfulnessMappedExpressionResult: CustomStringConvertible {

    public var description: String {
        return "successfulnessMapped(\(base))"
    }
}

// MARK: - CustomDebugStringConvertible

extension SuccessfulnessMappedExpressionResult: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "successfulnessMapped(\(String(reflecting: base)))"
    }
}

// MARK: - Equatable

/// Tests that the expressions have the same base expressions.
/// This can't test that they have the same `outcomeMapping`.
public func == <B>(lhs: SuccessfulnessMappedExpressionResult<B>, rhs: SuccessfulnessMappedExpressionResult<B>) -> Bool {
    return lhs.base == rhs.base
}

// MARK: - ExpressionResultType

extension SuccessfulnessMappedExpressionResult: ExpressionResultType {

    public var resultValue: ExpressionResultValue {
        return outcomeMapping(base.resultValue)
    }
}
