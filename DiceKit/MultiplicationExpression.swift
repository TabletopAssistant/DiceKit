//
//  MultiplicationExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MultiplicationExpression<LeftExpression: protocol<ExpressionType, Equatable>, RightExpression: protocol<ExpressionType, Equatable>>: Equatable {

    public let multiplier: LeftExpression
    public let multiplicand: RightExpression
    
    public init(_ multiplier: LeftExpression, _ multiplicand: RightExpression) {
        self.multiplier = multiplier
        self.multiplicand = multiplicand
    }
    
}

// MARK: - ExpressionType

extension MultiplicationExpression: ExpressionType {
    
    public typealias Result = MultiplicationExpressionResult<LeftExpression.Result, RightExpression.Result>
    
    public func evaluate() -> Result {
        let muliplierResult = multiplier.evaluate()
        let muliplierValue = muliplierResult.value
        
        // Negation is handled in the result
        let multiplicandResultCount = abs(muliplierValue)
        let multiplicandResult = (0..<multiplicandResultCount).map { _ in self.multiplicand.evaluate() }
        
        return Result(multiplierResult: muliplierResult, multiplicandResults: multiplicandResult)
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        return multiplier.probabilityMass * multiplicand.probabilityMass
    }
    
}

// MARK: - Equatable

public func == <L, R>(lhs: MultiplicationExpression<L, R>, rhs: MultiplicationExpression<L, R>) -> Bool {
    return lhs.multiplier == rhs.multiplier && lhs.multiplicand == rhs.multiplicand
}

// MARK: - Operators

public func * <L: protocol<ExpressionType, Equatable>, R: protocol<ExpressionType, Equatable>>(lhs: L, rhs: R)-> MultiplicationExpression<L, R> {
    return MultiplicationExpression(lhs, rhs)
}

public func * <R: protocol<ExpressionType, Equatable>>(lhs: Int, rhs: R)-> MultiplicationExpression<Constant, R> {
    return MultiplicationExpression(Constant(lhs), rhs)
}

public func * <L: protocol<ExpressionType, Equatable>>(lhs: L, rhs: Int)-> MultiplicationExpression<L, Constant> {
    return MultiplicationExpression(lhs, Constant(rhs))
}
