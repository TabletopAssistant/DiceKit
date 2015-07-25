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
            
            let a = c(Int(a))
            let b = c(Int(b))
            
            let x = AdditionExpressionResult(a, b)
            
            return x == x
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Int16, b: Int16) in
            
            let a = c(Int(a))
            let b = c(Int(b))
            
            let x = AdditionExpressionResult(a, b)
            let y = AdditionExpressionResult(a, b)
            
            return x == y && y == x
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Int16, b: Int16) in
            
            let a = c(Int(a))
            let b = c(Int(b))
            
            let x = AdditionExpressionResult(a, b)
            let y = AdditionExpressionResult(a, b)
            let z = AdditionExpressionResult(a, b)
            
            return x == y && y == z && x == z
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int16, b: Int16, m: Int16, n: Int16) in
            
            guard !(a == m && b == n) && !(a == n && b == m) else { return true }
            
            let a = c(Int(a))
            let b = c(Int(b))
            let m = c(Int(m))
            let n = c(Int(n))
            
            let x = AdditionExpressionResult(a, b)
            let y = AdditionExpressionResult(m, n)
            
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
            
            let result = AdditionExpressionResult(c(a), c(b))
            
            let value = result.value
            
            return value == expectedValue
        }
    }
    
}
