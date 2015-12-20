//
//  MaximizationExpressionResult.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MaximizationExpressionResult<MaximizationExpressionResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let resultValue: ExpressionResultValue
    
    public init(_ resultValue: ExpressionResultValue) {
        self.resultValue = resultValue
    }
    
}

// MARK: - CustomStringConvertible

extension MaximizationExpressionResult: CustomStringConvertible {
    
    public var description: String {
        return "\(resultValue)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MaximizationExpressionResult: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(String(reflecting: resultValue))"
    }
    
}

// MARK: - Equatable

public func == <L>(lhs: MaximizationExpressionResult<L>, rhs: MaximizationExpressionResult<L>) -> Bool {
    return lhs.resultValue == rhs.resultValue
}

// MARK: - ExpressionResultType

extension MaximizationExpressionResult: ExpressionResultType {
    
    // Already conforms because of `resultValue`
    
}
