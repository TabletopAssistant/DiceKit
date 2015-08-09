//
//  ArithmeticType.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/9/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public protocol AdditiveType {
    
    static var additiveIdentity: Self { get }
    
    /// Add `lhs` and `rhs`, returning a result and trapping in case of
    /// arithmetic overflow (except in -Ounchecked builds).
    func +(lhs: Self, rhs: Self) -> Self
    
}

public protocol InvertibleAdditiveType: AdditiveType, SignedNumberType {
    
    /// Return the result of negating `x`. The additive inverse.
    prefix func -(x: Self) -> Self
    
    /// Subtract `lhs` and `rhs`, returning a result and trapping in case of
    /// arithmetic overflow (except in -Ounchecked builds).
    func -(lhs: Self, rhs: Self) -> Self
    
}

public protocol MultiplicativeType: InvertibleAdditiveType {
    
    static var multiplicativeIdentity: Self { get }
    
    /// Multiply `lhs` and `rhs`, returning a result and trapping in case of
    /// arithmetic overflow (except in -Ounchecked builds).
    func *(lhs: Self, rhs: Self) -> Self
    
}

public protocol InvertibleMultiplicativeType: MultiplicativeType {
    
    /// Divide `lhs` and `rhs`, returning a result and trapping in case of
    /// arithmetic overflow (except in -Ounchecked builds).
    func /(lhs: Self, rhs: Self) -> Self
    
    /// Divide `lhs` and `rhs`, returning the remainder and trapping in case of
    /// arithmetic overflow (except in -Ounchecked builds).
    func %(lhs: Self, rhs: Self) -> Self
    
}

public protocol ArithmeticType: InvertibleAdditiveType, InvertibleMultiplicativeType {
    
}
