//
//  MinimizationExpression.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MinimizationExpression<Expression: protocol<ExpressionType, Equatable>>: Equatable {
    
    public let expression: Expression
    
    public init(_ expression: Expression) {
        self.expression = expression
    }
    
}

// MARK: - ExpressionType

extension MinimizationExpression: ExpressionType {
    
    public typealias Result = MinimizationExpressionResult<Expression.Result>
    
    public func evaluate() -> Result {
        guard let minOutcome = expression.probabilityMass.minimumOutcome() else {
            return Result(0)
        }
        return Result(minOutcome)
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        if let minimumOutcome = expression.probabilityMass.minimumOutcome() {
            return ProbabilityMass(minimumOutcome)
        }
        
        return ProbabilityMass(FrequencyDistribution.additiveIdentity)
    }
    
}

// MARK: CustomStringConvertible

extension MinimizationExpression: CustomStringConvertible {
    
    public var description: String {
        return "min(\(expression))"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MinimizationExpression: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "min(\(String(reflecting: expression)))"
    }
    
}

// MARK: - Equatable

public func == <E>(lhs: MinimizationExpression<E>, rhs: MinimizationExpression<E>) -> Bool {
    return lhs.expression == rhs.expression
}

