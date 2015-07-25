//
//  Constant.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct Constant: Equatable {
    
    public let value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
    
}

// MARK: - Convenience Init

public func c(value: Int) -> Constant {
    return Constant(value)
}

// MARK: - Equatable

public func == (lhs: Constant, rhs: Constant) -> Bool {
    return lhs.value == rhs.value
}

// MARK: - IntegerLiteralConvertible

extension Constant: IntegerLiteralConvertible {
    
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.value = value
    }
    
}

// MARK: - ExpressionType

extension Constant: ExpressionType {
    
    public typealias Result = Constant
    
    public func evaluate() -> Result {
        return self
    }
    
    public var probabilityMass: ProbabilityMass {
        return ProbabilityMass(value)
    }
    
}

// MARK: - ExpressionResultType

extension Constant: ExpressionResultType {
     // Already conforms because of `value`
}
