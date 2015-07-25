//
//  AdditionExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `AdditionExpressionResult` type
class AdditionExpressionResult_Tests: XCTestCase {
    
}

// MARK: - Equatable
extension AdditionExpressionResult_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Int16, b: Int16) in
            
            let a = Int(a)
            let b = Int(b)
            
            let x = AdditionExpressionResult(a, b)
            
            return x == x
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Int16, b: Int16) in
            
            let a = Int(a)
            let b = Int(b)
            
            let x = AdditionExpressionResult(a, b)
            let y = AdditionExpressionResult(a, b)
            
            return x == y && y == x
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Int16, b: Int16) in
            
            let a = Int(a)
            let b = Int(b)
            
            let x = AdditionExpressionResult(a, b)
            let y = AdditionExpressionResult(a, b)
            let z = AdditionExpressionResult(a, b)
            
            return x == y && y == z && x == z
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int16, b: Int16, c: Int16, d: Int16) in
            
            guard !(a == c && b == d) && !(a == d && b == c) else { return true }
            
            let a = Int(a)
            let b = Int(b)
            let c = Int(c)
            let d = Int(d)
            
            let x = AdditionExpressionResult(a, b)
            let y = AdditionExpressionResult(c, d)
            
            return x != y
        }
    }
    
}

// MARK: - ExpressionResultType
extension AdditionExpressionResult_Tests {
    
    func test_value_shouldAddTheAddends() {
        property("add the addends") <- forAll {
            (a: Int16, b: Int16) in
            
            let a = Int(a)
            let b = Int(b)
            
            let expectedValue = a + b
            let result = AdditionExpressionResult(a, b)
            
            let value = result.value
            
            return value == expectedValue
        }
    }
    
}
