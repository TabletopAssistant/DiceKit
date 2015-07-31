//
//  NegationExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `NegationExpressionResult` type
class NegationExpressionResult_Tests: XCTestCase {
    
}

// MARK: - Equatable
extension NegationExpressionResult_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Constant) in
            
            return EquatableTestUtilities.checkReflexive { NegationExpressionResult(a) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Constant) in
            
            return EquatableTestUtilities.checkSymmetric { NegationExpressionResult(a) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Constant) in
            
            return EquatableTestUtilities.checkTransitive { NegationExpressionResult(a) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant) in
            
            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { NegationExpressionResult(a) },
                    { NegationExpressionResult(b) }
                )
            }
        }
    }
    
}

// MARK: - ExpressionResultType
extension NegationExpressionResult_Tests {
    
    func test_value_shouldNegateTheBaseResult() {
        property("negate the base result") <- forAll {
            (a: Constant) in
            
            let expectedValue = -a.value
            let result = NegationExpressionResult(a)
            
            let value = result.value
            
            return value == expectedValue
        }
    }
    
}

// MARK: - CustomDebugStringConvertible
extension NegationExpressionResult_Tests {
    
    func test_customDebugStringConvertible() {
        let expression = -(d(8))
        let evaluation = expression.evaluate()
        let expected = "-Die(8).Roll(\(evaluation.base.value))"
        
        let result = String(reflecting: evaluation)
        
        expect(result) == expected
    }
    
}

// MARK: - CustomStringConvertible
extension NegationExpressionResult_Tests {
    
    func test_customStringConvertible() {
        let expression = -(d(8))
        let evaluation = expression.evaluate()
        let expected = "-\(evaluation.base)"
        
        let result = String(evaluation)
        
        expect(result) == expected
    }
    
}
