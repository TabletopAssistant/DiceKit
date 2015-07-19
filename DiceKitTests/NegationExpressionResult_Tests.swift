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
        property["reflexive"] = forAll {
            (a: Int) in
            
            let x = NegationExpressionResult(a)
            
            return x == x
        }
    }
    
    func test_shouldBeSymmetric() {
        property["symmetric"] = forAll {
            (a: Int) in
            
            let x = NegationExpressionResult(a)
            let y = NegationExpressionResult(a)
            
            return x == y && y == x
        }
    }
    
    func test_shouldBeTransitive() {
        property["transitive"] = forAll {
            (a: Int) in
            
            let x = NegationExpressionResult(a)
            let y = NegationExpressionResult(a)
            let z = NegationExpressionResult(a)
            
            return x == y && y == z && x == z
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property["non-equal"] = forAll {
            (a: Int, b: Int) in
            
            guard a != b else { return true }
            
            let x = NegationExpressionResult(a)
            let y = NegationExpressionResult(b)
            
            return x != y
        }
    }
    
}

// MARK: - ExpressionResultType
extension NegationExpressionResult_Tests {
    
    func test_value_shouldNegateTheBaseResult() {
        property["negate the base result"] = forAll {
            (a: Int) in
            
            let expectedValue = -a
            let result = NegationExpressionResult(a)
            
            let value = result.value
            
            return value == expectedValue
        }
    }
    
}
