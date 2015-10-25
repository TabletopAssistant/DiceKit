//
//  AdditionExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct AdditionExpression<LeftExpression: protocol<ExpressionType, Equatable>, RightExpression: protocol<ExpressionType, Equatable>>: Equatable {
    
    public let leftAddend: LeftExpression
    public let rightAddend: RightExpression
    
    public init(_ leftAddend: LeftExpression, _ rightAddend: RightExpression) {
        self.leftAddend = leftAddend
        self.rightAddend = rightAddend
    }
    
}

// MARK: - ExpressionType

extension AdditionExpression: ExpressionType {
    
    public typealias Result = AdditionExpressionResult<LeftExpression.Result, RightExpression.Result>
    
    public func evaluate() -> Result {
        let leftResult = leftAddend.evaluate()
        let rightResult = rightAddend.evaluate()
        
        return Result(leftResult, rightResult)
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        return leftAddend.probabilityMass && rightAddend.probabilityMass
    }
    
}

// MARK: - CustomStringConvertible

extension AdditionExpression: CustomStringConvertible {
    
    public var description: String {
        return "\(leftAddend) + \(rightAddend)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension AdditionExpression: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(String(reflecting: leftAddend)) + \(String(reflecting: rightAddend))"
    }
    
}

// MARK: - Equatable

private func equate<L, R>(lhs: AdditionExpression<L, R>, _ rhs: AdditionExpression<L, R>) -> Bool {
    return lhs.leftAddend == rhs.leftAddend && lhs.rightAddend == rhs.rightAddend
}

// When the same types check for commutative
public func == <E>(lhs: AdditionExpression<E, E>, rhs: AdditionExpression<E, E>) -> Bool {
    if equate(lhs, rhs) {
        return true
    }
    
    // Commutative
    return lhs.leftAddend == rhs.rightAddend && lhs.rightAddend == rhs.leftAddend
}

public func == <L, R>(lhs: AdditionExpression<L, R>, rhs: AdditionExpression<L, R>) -> Bool {
    return equate(lhs, rhs)
}

// MARK: - Operators

public func + <L: protocol<ExpressionType, Equatable>, R: protocol<ExpressionType, Equatable>>(lhs: L, rhs: R) -> AdditionExpression<L, R> {
    return AdditionExpression(lhs, rhs)
}

public func + <R: protocol<ExpressionType, Equatable>>(lhs: ExpressionResultValue, rhs: R) -> AdditionExpression<Constant, R> {
    return AdditionExpression(Constant(lhs), rhs)
}

public func + <L: protocol<ExpressionType, Equatable>>(lhs: L, rhs: ExpressionResultValue) -> AdditionExpression<L, Constant> {
    return AdditionExpression(lhs, Constant(rhs))
}
