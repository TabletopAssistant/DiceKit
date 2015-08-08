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
            (a: Constant) in
            
            return EquatableTestUtilities.checkReflexive { NegationExpression(a) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Constant) in
            
            return EquatableTestUtilities.checkSymmetric { NegationExpression(a) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Constant) in
            
            return EquatableTestUtilities.checkTransitive { NegationExpression(a) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant) in
            
            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { NegationExpression(a) },
                    { NegationExpression(b) }
                )
            }
        }
    }
    
}

// MARK: - ExpressionType
extension NegationExpression_Tests {
    
    func test_evaluate_shouldCreateResultCorrectly() {
        property("create results") <- forAll {
            (a: Constant) in
            
            let expression = NegationExpression(a)
            
            let result = expression.evaluate()
            
            return result.base == a
        }
    }
    
    func test_probabilityMass_shouldReturnCorrect() {
        property("probability mass") <- forAll {
            (a: Constant) in
            
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
            (m: Constant, n: Constant, o: Die) in
            
            let baseExpression = m + n * o
            let expectedExpression = NegationExpression(baseExpression)
            
            let expression = -baseExpression
            
            return expression == expectedExpression
        }
    }
    
}
