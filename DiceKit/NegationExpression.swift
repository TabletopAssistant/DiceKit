//
//  NegationExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct NegationExpression<BaseExpression: protocol<ExpressionType, Equatable>>: Equatable {

    public let base: BaseExpression
    
    public init(_ base: BaseExpression) {
        self.base = base
    }
    
}

// MARK: - ExpressionType

extension NegationExpression: ExpressionType {
    
    public typealias Result = NegationExpressionResult<BaseExpression.Result>
    
    public func evaluate() -> Result {
        return Result(base.evaluate())
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        return -base.probabilityMass
    }
    
}

// MARK: - CustomStringConvertible

extension NegationExpression: CustomStringConvertible {
    
    public var description: String {
        return "-\(base)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension NegationExpression: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "-\(String(reflecting: base))"
    }
    
}

// MARK: - Equatable

public func == <E>(lhs: NegationExpression<E>, rhs: NegationExpression<E>) -> Bool {
    return lhs.base == rhs.base
}

// MARK: - Operators

public prefix func - <E: protocol<ExpressionType, Equatable>>(base: E) -> NegationExpression<E> {
    return NegationExpression(base)
}
