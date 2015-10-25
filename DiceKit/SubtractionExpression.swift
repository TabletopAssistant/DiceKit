//
//  SubtractionExpression.swift
//  DiceKit
//
//  Created by Jonathan Hoffman on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct SubtractionExpression<LeftExpression: protocol<ExpressionType, Equatable>, RightExpression: protocol<ExpressionType, Equatable>>: Equatable {
    
    public let minuend: LeftExpression
    public let subtrahend: RightExpression
    
    public init(_ minuend: LeftExpression, _ subtrahend: RightExpression) {
        self.minuend = minuend
        self.subtrahend = subtrahend
    }
    
}

// MARK: - ExpressionType

extension SubtractionExpression: ExpressionType {
    
    public typealias Result = SubtractionExpressionResult<LeftExpression.Result, RightExpression.Result>
    
    public func evaluate() -> Result {
        let leftResult = minuend.evaluate()
        let rightResult = subtrahend.evaluate()
        
        return Result(leftResult, rightResult)
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        return minuend.probabilityMass && subtrahend.probabilityMass.negate()
    }
    
}

// MARK: - CustomStringConvertible

extension SubtractionExpression: CustomStringConvertible {
    
    public var description: String {
        return "\(minuend) - \(subtrahend)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension SubtractionExpression: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(String(reflecting: minuend)) - \(String(reflecting: subtrahend))"
    }
    
}

// MARK: - Equatable

public func == <L, R>(lhs: SubtractionExpression<L, R>, rhs: SubtractionExpression<L, R>) -> Bool {
    return lhs.minuend == rhs.minuend && lhs.subtrahend == rhs.subtrahend
}

// MARK: - Operators

public func - <L: protocol<ExpressionType, Equatable>, R: protocol<ExpressionType, Equatable>>(lhs: L, rhs: R) -> SubtractionExpression<L, R> {
    return SubtractionExpression(lhs, rhs)
}

public func - <R: protocol<ExpressionType, Equatable>>(lhs: ExpressionResultValue, rhs: R) -> SubtractionExpression<Constant, R> {
    return SubtractionExpression(Constant(lhs), rhs)
}

public func - <L: protocol<ExpressionType, Equatable>>(lhs: L, rhs: ExpressionResultValue) -> SubtractionExpression<L, Constant> {
    return SubtractionExpression(lhs, Constant(rhs))
}
