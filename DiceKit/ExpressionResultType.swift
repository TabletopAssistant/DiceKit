//
//  ExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public protocol ExpressionResultType {
    
    var value: Int { get }
    
}

// MARK: - Comparable

public func < <R: ExpressionResultType>(lhs: R, rhs: R) -> Bool {
    return lhs.value < rhs.value
}
