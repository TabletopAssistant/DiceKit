//
//  AdditionExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct AdditionExpression<LeftExpression: ExpressionType, RightExpression: ExpressionType where LeftExpression: Equatable, RightExpression: Equatable>: Equatable {
    
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
        
        return AdditionExpressionResult(leftResult, rightResult)
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

public func + <L: ExpressionType, R: ExpressionType where L: Equatable, R: Equatable>(lhs: L, rhs: R) -> AdditionExpression<L, R> {
    return AdditionExpression(lhs, rhs)
}

public func + <R: ExpressionType where R: Equatable>(lhs: Int, rhs: R) -> AdditionExpression<Constant, R> {
    return AdditionExpression(Constant(lhs), rhs)
}

public func + <L: ExpressionType where L: Equatable>(lhs: L, rhs: Int) -> AdditionExpression<L, Constant> {
    return AdditionExpression(lhs, Constant(rhs))
}
