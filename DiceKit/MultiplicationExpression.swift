//
//  MultiplicationExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MultiplicationExpression<LeftExpression: ExpressionType, RightExpression: ExpressionType where LeftExpression: Equatable, RightExpression: Equatable>: Equatable {

    public let multiplier: LeftExpression
    public let multiplicand: RightExpression
    
    public init(_ multiplier: LeftExpression, _ multiplicand: RightExpression) {
        self.multiplier = multiplier
        self.multiplicand = multiplicand
    }
    
}

// MARK: - Expression
extension MultiplicationExpression: ExpressionType {
    
    public typealias Result = MultiplicationExpressionResult<LeftExpression.Result, RightExpression.Result>
    
    public func evaluate() -> Result {
        let muliplierResult = multiplier.evaluate()
        let muliplierValue = muliplierResult.value
        
        // Negation is handled in the result
        let multiplicandResultCount = abs(muliplierValue)
        let multiplicandResult = (0..<multiplicandResultCount).map { _ in self.multiplicand.evaluate() }
        
        return MultiplicationExpressionResult(multiplierResult: muliplierResult, multiplicandResults: multiplicandResult)
    }
    
}

// MARK: - Equatable
public func ==<L, R>(lhs: MultiplicationExpression<L, R>, rhs: MultiplicationExpression<L, R>) -> Bool {
    return lhs.multiplier == rhs.multiplier && lhs.multiplicand == rhs.multiplicand
}
