//
//  MaximizationExpression.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MaximizationExpression<Expression: protocol<ExpressionType, Equatable>>: Equatable {
    
    public let expression: Expression
    
    public init(_ expression: Expression) {
        self.expression = expression
    }
    
}

// MARK: - ExpressionType

extension MaximizationExpression: ExpressionType {
    
    public typealias Result = MaximizationExpressionResult<Expression.Result>
    
    public func evaluate() -> Result {
        guard let maxOutcome = expression.probabilityMass.maximumOutcome() else {
            return Result(0)
        }
        
        return Result(maxOutcome)
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        if let maximumOutcome = expression.probabilityMass.maximumOutcome() {
            return ProbabilityMass(maximumOutcome)
        }
        
        return ProbabilityMass(FrequencyDistribution.additiveIdentity)
    }
    
}

// MARK: CustomStringConvertible

extension MaximizationExpression: CustomStringConvertible {
    
    public var description: String {
        return "max(\(expression))"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MaximizationExpression: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "max(\(String(reflecting: expression)))"
    }
    
}

// MARK: - Equatable

public func == <E>(lhs: MaximizationExpression<E>, rhs: MaximizationExpression<E>) -> Bool {
    return lhs.expression == rhs.expression
}

