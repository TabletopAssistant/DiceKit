//
//  SuccessfulnessExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/2/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public struct SuccessfulnessExpression<BaseExpression: protocol<ExpressionType, Equatable>, ComparisonExpression: protocol<ExpressionType, Equatable>>: Equatable {
    
    public typealias Comparison = SuccessfulnessExpressionComparison<ComparisonExpression>
    
    public let base: BaseExpression
    
    public let successComparison: Comparison?
    public let failComparison: Comparison?
    
    public init(_ base: BaseExpression, successComparison: Comparison?, failComparison: Comparison?) {
        self.base = base
        self.successComparison = successComparison
        self.failComparison = failComparison
    }
    
}

// MARK: - Equatable

public func == <B, C>(lhs: SuccessfulnessExpression<B, C>, rhs: SuccessfulnessExpression<B, C>) -> Bool {
    return lhs.base == rhs.base
        && lhs.successComparison == rhs.successComparison
        && lhs.failComparison == rhs.failComparison
}

// MARK: - ExpressionType

extension SuccessfulnessExpression: ExpressionType {
    
    public typealias Result = SuccessfulnessExpressionResult<BaseExpression.Result, ComparisonExpression.Result>
    
    public func evaluate() -> Result {
        let successComparisonResult = successComparison.flatMap {
            Result.Comparison($0.operation, $0.comparedWith.evaluate())
        }
        let failComparisonResult = failComparison.flatMap {
            Result.Comparison($0.operation, $0.comparedWith.evaluate())
        }
        return Result(base.evaluate(), successComparison: successComparisonResult, failComparison: failComparisonResult)
    }
    
    private typealias ComparisonClosure = (ExpressionProbabilityMass.Outcome, ExpressionProbabilityMass.Outcome) -> Bool
    
    private func compareOnlyUndetermined(@noescape comparison: SuccessfulnessExpressionComparisonOperation.Closure)(_ lhs: ExpressionProbabilityMass.Outcome, _ rhs: ExpressionProbabilityMass.Outcome) -> Bool {
        guard lhs.successfulness == .Undetermined else {
            return false
        }
        
        return comparison(lhs.outcome, rhs.outcome)
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        // Collect success or fail mappings
        var mappings: [(successfulness: Successfulness, comparisonClosure: ComparisonClosure, comparedWith: ExpressionProbabilityMass)] = []
        if let successComparison = successComparison {
            mappings.append( (.Success, compareOnlyUndetermined(successComparison.operation.closure), successComparison.comparedWith.probabilityMass) )
        }
        if let failComparison = failComparison {
            mappings.append( (.Fail, compareOnlyUndetermined(failComparison.operation.closure), failComparison.comparedWith.probabilityMass) )
        }
        
        let probMass = mappings.reduce(base.probabilityMass) { (acc, mapping) -> ExpressionProbabilityMass in
            acc.setSuccessfulness(mapping.successfulness, comparedWith: mapping.comparedWith, passingComparison: mapping.comparisonClosure)
        }
        
        return probMass
    }
    
}
