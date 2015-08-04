//
//  NegationExpression_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `NegationExpression` type
class NegationExpression_Tests: XCTestCase {
    
}

// MARK: - Equatable
extension NegationExpression_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Int) in
            
            let a = c(a)
            
            let x = NegationExpression(a)
            
            return x == x
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Int) in
            
            let a = c(a)
            
            let x = NegationExpression(a)
            let y = NegationExpression(a)
            
            return x == y && y == x
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Int) in
            
            let a = c(a)
            
            let x = NegationExpression(a)
            let y = NegationExpression(a)
            let z = NegationExpression(a)
            
            return x == y && y == z && x == z
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int, b: Int) in
            
            guard a != b else { return true }
            
            let a = c(a)
            let b = c(b)
            
            let x = NegationExpression(a)
            let y = NegationExpression(b)
            
            return x != y
        }
    }
    
}

// MARK: - ExpressionType
extension NegationExpression_Tests {
    
    func test_evaluate_shouldCreateResultCorrectly() {
        property("create results") <- forAll {
            (a: Int) in
            
            let a = c(a)
            let expression = NegationExpression(a)
            
            let result = expression.evaluate()
            
            return result.baseResult == a
        }
    }
    
    func test_probabilityMass_shouldReturnCorrect() {
        property("probability mass") <- forAll {
            (a: Int) in
            
            let a = c(a)
            
            let expectedProbMass = a.probabilityMass.negate()
            let expression = NegationExpression(a)
            
            let probMass = expression.probabilityMass
            
            return probMass == expectedProbMass
        }
    }
    
}

// MARK: - Operators
extension NegationExpression_Tests {
    
    func test_operator_shouldWorkOnExpression() {
        property("-Expression should make correct NegationExpression") <- forAll {
            (m: Int, n: Int, o: Int) in
            
            let baseExpression = c(m) + c(n) * d(o)
            let expectedExpression = NegationExpression(baseExpression)
            
            let expression = -baseExpression
            
            return expression == expectedExpression
        }
    }
    
}
