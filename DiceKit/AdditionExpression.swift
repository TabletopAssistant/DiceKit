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

// MARK: - Expression
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

public func ==<E>(lhs: AdditionExpression<E, E>, rhs: AdditionExpression<E, E>) -> Bool {
    if equate(lhs, rhs) {
        return true
    }
    
    // Commutative
    return lhs.leftAddend == rhs.rightAddend && lhs.rightAddend == rhs.leftAddend
}

public func ==<L, R>(lhs: AdditionExpression<L, R>, rhs: AdditionExpression<L, R>) -> Bool {
    return equate(lhs, rhs)
}
