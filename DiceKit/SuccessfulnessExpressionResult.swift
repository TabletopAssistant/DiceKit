//
//  SuccessfulnessExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/2/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public struct SuccessfulnessExpressionResult<BaseResult: protocol<ExpressionResultType, Equatable>, ComparisonResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public typealias Comparison = SuccessfulnessExpressionResultComparison<ComparisonResult>
    
    public let base: BaseResult
    
    public let successComparison: Comparison?
    public let failComparison: Comparison?
    
    public init(_ base: BaseResult, successComparison: Comparison?, failComparison: Comparison?) {
        self.base = base
        self.successComparison = successComparison
        self.failComparison = failComparison
    }
    
}

// MARK: - Equatable

public func == <B, C>(lhs: SuccessfulnessExpressionResult<B, C>, rhs: SuccessfulnessExpressionResult<B, C>) -> Bool {
    return lhs.base == rhs.base
        && lhs.successComparison?.operation == rhs.successComparison?.operation
        && lhs.successComparison?.comparedWith == rhs.successComparison?.comparedWith
        && lhs.failComparison?.operation == rhs.failComparison?.operation
        && lhs.failComparison?.comparedWith == rhs.failComparison?.comparedWith
}

// MARK: - ExpressionResultType

extension SuccessfulnessExpressionResult: ExpressionResultType {
    
    public var value: Int {
        return base.value
    }
    
    public var successfulness: Successfulness {
        let baseSuccessfulness = base .successfulness
        guard baseSuccessfulness == .Undetermined else {
            return baseSuccessfulness
        }
        
        let computedValue = value
        
        if let s = successComparison where s.operation.closure(computedValue, s.comparedWith.value) {
            return .Success
        }
        if let f = failComparison where f.operation.closure(computedValue, f.comparedWith.value) {
            return .Fail
        }
        
        return .Undetermined
    }
    
}
