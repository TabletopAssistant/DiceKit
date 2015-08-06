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
    
    class MockExpression: ExpressionType, Equatable {
        
        typealias Result = Constant
        
        var evaluateCalled = 0
        var stubResulter: () -> Result = { 0 }
        var stubProbabilityMass = ProbabilityMass(0)
        
        func evaluate() -> Result {
            let result = stubResulter()
            ++evaluateCalled
            return result
        }
        
        var probabilityMass: ProbabilityMass {
            return stubProbabilityMass
        }
        
    }
    
    // TODO: Make a SwiftCheck
    func test_evaluate_shouldCreateResultCorrectly() {
        let multiplicandResults: [Constant] = [8, 4, 2, -7, 1, 9, 3, 3, -3, 4, 5]
        let expectedMultiplicandResults = multiplicandResults
        let leftExpression = c(expectedMultiplicandResults.count)
        let expectedMultiplierResult = leftExpression
        let mockRightExpression = MockExpression()
        mockRightExpression.stubResulter = { multiplicandResults[mockRightExpression.evaluateCalled] }
        let expression = MultiplicationExpression(leftExpression, mockRightExpression)
        
        let result = expression.evaluate()
        
        expect(result.multiplierResult) == expectedMultiplierResult
        expect(result.multiplicandResults) == expectedMultiplicandResults
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

func == (lhs: MultiplicationExpression_Tests.MockExpression, rhs: MultiplicationExpression_Tests.MockExpression) -> Bool {
    return lhs === rhs
}
