//
//  Constant.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public struct Constant: Equatable {
    
    public let value: ExpressionResultValue
    
    public init(_ value: ExpressionResultValue) {
        self.value = value
    }
    
}

// MARK: - Convenience Init

public func c(value: ExpressionResultValue) -> Constant {
    return Constant(value)
}

// MARK: CustomStringConvertible

extension Constant: CustomStringConvertible {
    
    public var description: String {
        return "\(value)"
    }
    
}

// MARK: - CustomDebugStringConvertible

extension Constant: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "Constant(\(value))"
    }
    
}

// MARK: - Equatable

public func == (lhs: Constant, rhs: Constant) -> Bool {
    return lhs.value == rhs.value
}

// MARK: - IntegerLiteralConvertible

extension Constant: IntegerLiteralConvertible {
    
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.value = ExpressionResultValue(integerLiteral: value)
    }
    
}

// MARK: - ExpressionType

extension Constant: ExpressionType {
    
    public typealias Result = Constant
    
    public func evaluate() -> Result {
        return self
    }
    
    public var probabilityMass: ExpressionProbabilityMass {
        let probMassValue = value
        return ProbabilityMass(probMassValue)
    }
    
}

// MARK: - ExpressionResultType

extension Constant: ExpressionResultType {

    public var resultValue: ExpressionResultValue {
        return value
    }

}
