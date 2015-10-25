//
//  SuccessfulnessExpression.Comparison.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/6/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

// Only not nested in `SuccessfulnessExpression` because its generic
public struct SuccessfulnessExpressionComparison<ComparisonExpression: protocol<ExpressionType, Equatable>>: Equatable {
    
    public let operation: SuccessfulnessExpressionComparisonOperation
    public let comparedWith: ComparisonExpression
    
    public init(_ operation: SuccessfulnessExpressionComparisonOperation, _ comparedWith: ComparisonExpression) {
        self.operation = operation
        self.comparedWith = comparedWith
    }
    
}

// MARK: - Equatable

public func == <C>(lhs: SuccessfulnessExpressionComparison<C>, rhs: SuccessfulnessExpressionComparison<C>) -> Bool {
    return lhs.operation == rhs.operation
        && lhs.comparedWith == rhs.comparedWith
}
