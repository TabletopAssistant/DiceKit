//
//  NegationExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct NegationExpressionResult<BaseResult: protocol<ExpressionResultType, Equatable>>: ExpressionResultType, Equatable {
    
    public let baseResult: BaseResult
    
    public var value: Int {
        return -baseResult.value
    }
    
    public init(_ baseResult: BaseResult) {
        self.baseResult = baseResult
    }
    
}

// MARK: - Equatable

public func == <B>(lhs: NegationExpressionResult<B>, rhs: NegationExpressionResult<B>) -> Bool {
    return lhs.baseResult == rhs.baseResult
}
