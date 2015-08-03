//
//  AdditionExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct AdditionExpressionResult<LeftAddendResult: protocol<ExpressionResultType, Equatable>, RightAddendResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let leftAddendResult: LeftAddendResult
    public let rightAddendResult: RightAddendResult
    
    public init(_ leftAddendResult: LeftAddendResult, _ rightAddendResult: RightAddendResult) {
        self.leftAddendResult = leftAddendResult
        self.rightAddendResult = rightAddendResult
    }
    
}

// MARK: - Equatable

public func == <L, R>(lhs: AdditionExpressionResult<L,R>, rhs: AdditionExpressionResult<L,R>) -> Bool {
    return lhs.leftAddendResult == rhs.leftAddendResult && lhs.rightAddendResult == rhs.rightAddendResult
}

// MARK: - ExpressionResultType

extension AdditionExpressionResult: ExpressionResultType {
    
    public var value: Int {
        return leftAddendResult.value + rightAddendResult.value
    }
    
}
