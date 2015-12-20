//
//  MinimizationExpressionResult.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MinimizationExpressionResult<MinimizationExpressionResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let resultValue: ExpressionResultValue
    
    public init(_ resultValue: ExpressionResultValue) {
        self.resultValue = resultValue
    }
    
}

// MARK: - CustomStringConvertible

extension MinimizationExpressionResult: CustomStringConvertible {
    
    public var description: String {
        return "\(resultValue)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MinimizationExpressionResult: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(String(reflecting: resultValue))"
    }
    
}

// MARK: - Equatable

public func == <L>(lhs: MinimizationExpressionResult<L>, rhs: MinimizationExpressionResult<L>) -> Bool {
    return lhs.resultValue == rhs.resultValue
}

// MARK: - ExpressionResultType

extension MinimizationExpressionResult: ExpressionResultType {
    
    // Already conforms because of `resultValue`
    
}
