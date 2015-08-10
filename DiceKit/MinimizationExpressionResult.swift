//
//  MinimizationExpressionResult.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MinimizationExpressionResult<MinimizationExpressionResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let minimizationExpressionResult: ExpressionProbabilityMass.Outcome
    
    public init(_ minimizationExpressionResult: ExpressionProbabilityMass.Outcome) {
        self.minimizationExpressionResult = minimizationExpressionResult
    }
    
}

// MARK: - CustomStringConvertible

extension MinimizationExpressionResult: CustomStringConvertible {
    
    public var description: String {
        return "\(minimizationExpressionResult)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MinimizationExpressionResult: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(String(reflecting: minimizationExpressionResult))"
    }
    
}

// MARK: - Equatable

public func == <L>(lhs: MinimizationExpressionResult<L>, rhs: MinimizationExpressionResult<L>) -> Bool {
    return lhs.value == rhs.value
}

// MARK: - ExpressionResultType

extension MinimizationExpressionResult: ExpressionResultType {
    
    public var value: Int {
        return minimizationExpressionResult
    }

    public var successfulness: Successfulness {
        return .Undetermined
    }
    
}
