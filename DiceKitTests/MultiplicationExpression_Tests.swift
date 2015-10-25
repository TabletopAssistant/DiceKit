//
//  MultiplicationExpression_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `MultiplicationExpression` type
class MultiplicationExpression_Tests: XCTestCase {
    
}

// MARK: - Initialization
extension MultiplicationExpression_Tests {
    
    // TODO: init
    
}

// MARK: - Equatable
extension MultiplicationExpression_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkReflexive { MultiplicationExpression(a, b) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkSymmetric { MultiplicationExpression(a, b) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkTransitive { MultiplicationExpression(a, b) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant, m: Constant, n: Constant) in
            
            // Only check one set of parameters since not commutitive
            return (a != m || b != n) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { MultiplicationExpression(a, b) },
                    { MultiplicationExpression(m, n) }
                )
            }
        }
    }
    
    func test_shouldBeAnticommutative() {
        property("anticommutative") <- forAll {
            (a: Constant, b: Constant) in
            
            return (a != b) ==> {
                let x = MultiplicationExpression(a, b)
                let y = MultiplicationExpression(b, a)
                
                return x != y
            }
        }
    }

}

// MARK: - ExpressionType
extension MultiplicationExpression_Tests {
    
    func test_evaluate_shouldCreateResultCorrectly() {
        property("evaluate") <- forAll {
            (a: ArrayOf<Constant>) in
        
            let multiplicandResults = a.getArray
            let expectedMultiplicandResults = multiplicandResults
            let leftExpression = c(expectedMultiplicandResults.count)
            let expectedMultiplierResult = leftExpression
            let mockRightExpression = MockExpression()
            mockRightExpression.stubResulter = { multiplicandResults[mockRightExpression.evaluateCalled] }
            let expression = MultiplicationExpression(leftExpression, mockRightExpression)
            
            let result = expression.evaluate()
            
            let testMultiplierResult = result.multiplierResult == expectedMultiplierResult
            let testMultiplicandResults = result.multiplicandResults == expectedMultiplicandResults
            
            return testMultiplierResult && testMultiplicandResults
        }
    }
    
    func test_probabilityMass_shouldReturnCorrect() {
        property("probability mass") <- forAll {
            (a: Constant, b: Constant) in
            
            let expectedProbMass = a.probabilityMass.product(b.probabilityMass)
            let expression = MultiplicationExpression(a, b)
            
            let probMass = expression.probabilityMass
            
            return probMass == expectedProbMass
        }
    }

}

// MARK: - Operators
extension MultiplicationExpression_Tests {
    
    func test_operator_shouldWorkWithIntAndExpression() {
        property("Int * Expression and Expression * Int returns correct MultiplicationExpression") <- forAll {
            (a: Int, die: Die) in
            
            let expectedExpression1 = MultiplicationExpression(c(a), die)
            let expectedExpression2 = MultiplicationExpression(die, c(a))
            
            let expression1 = a * die
            let expression2 = die * a
        
            let test1 = (expression1 == expectedExpression1)
            let test2 = (expression2 == expectedExpression2)
            return test1 && test2
        }
    }
    
    func test_operator_shouldWorkWithExpressionAndExpression() {
        property("Expression * Expression returns correct MultiplicationExpression") <- forAll {
            (a: Die, b: Die) in
            
            let expectedExpression = MultiplicationExpression(a, b)
            
            let expression = a * b
        
            return expression == expectedExpression
        }
    }
    
}

// MARK: - CustomDebugStringConvertible
extension MultiplicationExpression_Tests {
    
    func test_CustomDebugStringConvertible() {
        let expression = 2 * d(10)
        let expected = "(Constant(2) * Die(10))"
        
        let result = String(reflecting: expression)
        
        expect(result) == expected
    }
    
}

// MARK: - CustomStringConvertible
extension MultiplicationExpression_Tests {
    
    func test_CustomStringConvertible() {
        let expression = 2 * d(10)
        let expected = "2d10"
        
        let result = String(expression)
        
        expect(result) == expected
    }
    
}
