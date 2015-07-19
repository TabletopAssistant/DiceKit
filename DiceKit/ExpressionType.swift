//
//  ExpressionType.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public protocol ExpressionType {
    
    typealias Result : ExpressionResultType, Equatable
    
    func evaluate() -> Result
    
    // TODO: Introduce this bad boy someday
//    /// Returns `true` if both `ExpressionType`s are algebraically equivalent.
//    func equals(that: ExpressionType) -> Bool
    
}

// MARK: - Standard Library extensions

extension Int: ExpressionType {
    
    typealias Result = Int
    
    public func evaluate() -> Int {
        return self
    }
    
}
