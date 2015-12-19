//
//  MaximizationExpression.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MaximizationExpression<BaseExpression: protocol<ExpressionType, Equatable>>: Equatable {
    
    public let base: BaseExpression
    
    public init(_ base: BaseExpression) {
        self.base = base
    }
    
}

// MARK: - ExpressionType

extension MaximizationExpression: ExpressionType {
    
    public typealias Result = MaximizationExpressionResult<BaseExpression.Result>
    
    public func evaluate() -> Result {
        guard let maxOutcome = base.probabilityMass.maximumOutcome() else {
            return Result(0)
        }
        
        return Result(maxOutcome)
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        if let maximumOutcome = base.probabilityMass.maximumOutcome() {
            return ProbabilityMass(maximumOutcome)
        }
        
        return ProbabilityMass(FrequencyDistribution.additiveIdentity)
    }
    
}

// MARK: CustomStringConvertible

extension MaximizationExpression: CustomStringConvertible {
    
    public var description: String {
        return "max(\(base))"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MaximizationExpression: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "max(\(String(reflecting: base)))"
    }
    
}

// MARK: - Equatable

public func == <E>(lhs: MaximizationExpression<E>, rhs: MaximizationExpression<E>) -> Bool {
    return lhs.base == rhs.base
}

