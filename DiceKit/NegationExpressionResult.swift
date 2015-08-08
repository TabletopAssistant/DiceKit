//
//  NegationExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct NegationExpressionResult<BaseResult: protocol<ExpressionResultType, Equatable>>: Equatable {
    
    public let base: BaseResult
    
    public init(_ base: BaseResult) {
        self.base = base
    }
    
}

// MARK: - Equatable

public func == <B>(lhs: NegationExpressionResult<B>, rhs: NegationExpressionResult<B>) -> Bool {
    return lhs.base == rhs.base
}

// MARK: - ExpressionResultType

extension NegationExpressionResult: ExpressionResultType {
    
    public var value: Int {
        return -base.value
    }
    
}
