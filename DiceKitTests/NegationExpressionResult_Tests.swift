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
            (a: Int) in
            
            let a = c(a)
            
            return EquatableTestUtilities.checkReflexive { NegationExpressionResult(a) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Int) in
            
            let a = c(a)
            
            return EquatableTestUtilities.checkSymmetric { NegationExpressionResult(a) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Int) in
            
            let a = c(a)
            
            return EquatableTestUtilities.checkTransitive { NegationExpressionResult(a) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int, b: Int) in
            
            guard a != b else { return true }
            
            let a = c(a)
            let b = c(b)
            
            return EquatableTestUtilities.checkNotEquate(
                { NegationExpressionResult(a) },
                { NegationExpressionResult(b) }
            )
        }
    }
    
}

// MARK: - ExpressionResultType
extension NegationExpressionResult_Tests {
    
    func test_value_shouldNegateTheBaseResult() {
        property("negate the base result") <- forAll {
            (a: Int) in
            
            let expectedValue = -a
            let result = NegationExpressionResult(c(a))
            
            let value = result.value
            
            return value == expectedValue
        }
    }
    
}
