//
//  MultiplicationExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct MultiplicationExpressionResult<MultiplierResult: protocol<ExpressionResultType, Equatable>, MultiplicandResult: protocol<ExpressionResultType, Equatable>>: ExpressionResultType, Equatable {
    
    public let multiplierResult: MultiplierResult
    public let multiplicandResults: [MultiplicandResult]
    public let negateMultiplicandResults: Bool
    
    public var value: Int {
        let values = multiplicandResults.map { $0.value }
        
        if negateMultiplicandResults {
            return values.reduce(0, combine: -)
        } else {
            return values.reduce(0, combine: +)
        }
    }
    
    public init(multiplierResult: MultiplierResult, multiplicandResults: [MultiplicandResult]) {
        assert(abs(multiplierResult.value) == multiplicandResults.count)
        
        self.multiplierResult = multiplierResult
        self.multiplicandResults = multiplicandResults
        self.negateMultiplicandResults = multiplierResult.value < 0
    }
    
}

// MARK: - Equatable

public func == <M, R>(lhs: MultiplicationExpressionResult<M,R>, rhs: MultiplicationExpressionResult<M,R>) -> Bool {
    return lhs.multiplierResult == rhs.multiplierResult && lhs.multiplicandResults == rhs.multiplicandResults
}
