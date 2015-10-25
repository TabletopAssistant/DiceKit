//
//  SuccessfulnessExpressionResult.Comparison.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/7/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

// Only not nested in `SuccessfulnessExpressionResult` because its generic
public struct SuccessfulnessExpressionResultComparison<ComparisonResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let operation: SuccessfulnessExpressionComparisonOperation
    public let comparedWith: ComparisonResult
    
    public init(_ operation: SuccessfulnessExpressionComparisonOperation, _ comparedWith: ComparisonResult) {
        self.operation = operation
        self.comparedWith = comparedWith
    }
    
}

// MARK: - Equatable

public func == <C>(lhs: SuccessfulnessExpressionResultComparison<C>, rhs: SuccessfulnessExpressionResultComparison<C>) -> Bool {
    return lhs.operation == rhs.operation
        && lhs.comparedWith == rhs.comparedWith
}
