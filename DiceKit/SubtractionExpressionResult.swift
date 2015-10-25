//
//  SubtractionExpressionResult.swift
//  DiceKit
//
//  Created by Developer on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct SubtractionExpressionResult<MinuendResult: protocol<ExpressionResultType, Equatable>, SubtrahendResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let minuendResult: MinuendResult
    public let subtrahendResult: SubtrahendResult
    
    public init(_ minuendResult: MinuendResult, _ subtrahendResult: SubtrahendResult) {
        self.minuendResult = minuendResult
        self.subtrahendResult = subtrahendResult
    }
    
}

// MARK: - CustomStringConvertible

extension SubtractionExpressionResult: CustomStringConvertible {
    
    public var description: String {
        return "\(minuendResult) - \(subtrahendResult)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension SubtractionExpressionResult: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(String(reflecting: minuendResult)) - \(String(reflecting: subtrahendResult))"
    }
    
}

// MARK: - Equatable

public func == <L, R>(lhs: SubtractionExpressionResult<L,R>, rhs: SubtractionExpressionResult<L,R>) -> Bool {
    return lhs.minuendResult == rhs.minuendResult && lhs.subtrahendResult == rhs.subtrahendResult
}

// MARK: - ExpressionResultType

extension SubtractionExpressionResult: ExpressionResultType {
    
    public var value: Int {
        return minuendResult.value - subtrahendResult.value
    }

    public var successfulness: Successfulness {
        return minuendResult.successfulness - subtrahendResult.successfulness
    }
    
}

