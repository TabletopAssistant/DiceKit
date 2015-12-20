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
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkReflexive { AdditionExpressionResult(a, b) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkSymmetric { AdditionExpressionResult(a, b) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkTransitive { AdditionExpressionResult(a, b) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant, m: Constant, n: Constant) in
            
            return (!(a == m && b == n) && !(a == n && b == m)) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { AdditionExpressionResult(a, b) },
                    { AdditionExpressionResult(m, n) }
                )
            }
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

// MARK: - CustomDebugStringConvertible
extension AdditionExpressionResult_Tests {
    
    func test_CustomDebugStringConvertible() {
        let expression = d(10) + 5
        let evaluation = expression.evaluate()
        let expected = "\(String(reflecting: Die.Roll(die: d(10), value: evaluation.leftAddendResult.value))) + \(String(reflecting: c(5)))"
        
        let result = String(reflecting: evaluation)
        
        expect(result) == expected
    }
    
}

// Mark: - CustomStringConvertible
extension AdditionExpressionResult_Tests {
    
    func test_CustomStringConvertible() {
        let expression = d(10) + 5
        let evaluation = expression.evaluate()
        let expected = "\(Die.Roll(die: d(10), value: evaluation.leftAddendResult.value)) + \(c(5))"
        
        let result = String(evaluation)
        
        expect(result) == expected
    }
    
}
