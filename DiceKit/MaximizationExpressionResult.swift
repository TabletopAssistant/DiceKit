//
//  MaximizationExpressionResult.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MaximizationExpressionResult<MaximizationExpressionResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let maximizationExpressionResult: ExpressionProbabilityMass.Outcome
    
    public init(_ maximizationExpressionResult: ExpressionProbabilityMass.Outcome) {
        self.maximizationExpressionResult = maximizationExpressionResult
    }
    
}

// MARK: - CustomStringConvertible

extension MaximizationExpressionResult: CustomStringConvertible {
    
    public var description: String {
        return "\(maximizationExpressionResult)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MaximizationExpressionResult: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(String(reflecting: maximizationExpressionResult))"
    }
    
}

// MARK: - Equatable

public func == <L>(lhs: MaximizationExpressionResult<L>, rhs: MaximizationExpressionResult<L>) -> Bool {
    return lhs.value == rhs.value
}

// MARK: - ExpressionResultType

extension MaximizationExpressionResult: ExpressionResultType {
    
    public var value: Int {
        return maximizationExpressionResult
    }

    public var successfulness: Successfulness {
        return .Undetermined
    }
    
}
