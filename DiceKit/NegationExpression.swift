//
//  NegationExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct NegationExpression<BaseExpression: ExpressionType where BaseExpression: Equatable>: Equatable {

    public let base: BaseExpression
    
    public init(_ base: BaseExpression) {
        self.base = base
    }
    
}

// MARK: - ExpressionType

extension NegationExpression: ExpressionType {
    
    public typealias Result = NegationExpressionResult<BaseExpression.Result>
    
    public func evaluate() -> Result {
        return NegationExpressionResult(base.evaluate())
    }
    
    public var probabilityMass: ProbabilityMass {
        return -base.probabilityMass
    }
    
}

// MARK: - Equatable

public func == <E>(lhs: NegationExpression<E>, rhs: NegationExpression<E>) -> Bool {
    return lhs.base == rhs.base
}

// MARK: - Operators

public prefix func - <E: ExpressionType where E: Equatable>(base: E) -> NegationExpression<E> {
    return NegationExpression(base)
}
