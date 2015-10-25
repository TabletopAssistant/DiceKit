//
//  MinimizationExpression.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MinimizationExpression<BaseExpression: protocol<ExpressionType, Equatable>>: Equatable {
    
    public let base: BaseExpression
    
    public init(_ base: BaseExpression) {
        self.base = base
    }
    
}

// MARK: - ExpressionType

extension MinimizationExpression: ExpressionType {
    
    public typealias Result = MinimizationExpressionResult<BaseExpression.Result>
    
    public func evaluate() -> Result {
        guard let minOutcome = base.probabilityMass.minimumOutcome() else {
            return Result(0)
        }
        
        return Result(minOutcome)
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        if let minimumOutcome = base.probabilityMass.minimumOutcome() {
            return ProbabilityMass(minimumOutcome)
        }
        
        return ProbabilityMass(FrequencyDistribution.additiveIdentity)
    }
    
}

// MARK: CustomStringConvertible

extension MinimizationExpression: CustomStringConvertible {
    
    public var description: String {
        return "min(\(base))"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension MinimizationExpression: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "min(\(String(reflecting: base)))"
    }
    
}

// MARK: - Equatable

public func == <E>(lhs: MinimizationExpression<E>, rhs: MinimizationExpression<E>) -> Bool {
    return lhs.base == rhs.base
}

