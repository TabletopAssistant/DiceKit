//
//  AdditionExpression_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `AdditionExpression` type
class AdditionExpression_Tests: XCTestCase {
    
}

// MARK: - Initialization
extension AdditionExpression_Tests {
    
    // TODO: init
    
}

// MARK: - Equatable
extension AdditionExpression_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkReflexive { AdditionExpression(a, b) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkSymmetric { AdditionExpression(a, b) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkTransitive { AdditionExpression(a, b) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant, m: Constant, n: Constant) in
            
            // Check both cases since it's commutative
            return !(a == m && b == n || a == n && b == m) ==> {
                return EquatableTestUtilities.checkNotEquate(
                    { AdditionExpression(a, b) },
                    { AdditionExpression(m, n) }
                )
            }
        }
    }
    
    func test_shouldBeCommutative() {
        property("commutative") <- forAll {
            (a: Constant, b: Constant) in
            
            return (a != b) ==> {
                let x = AdditionExpression(a, b)
                let y = AdditionExpression(b, a)
                
                return x == y
            }
        }
    }
    
}

// MARK: - ExpressionType
extension AdditionExpression_Tests {
    
    func test_evaluate_shouldCreateResultCorrectly() {
        property("create results") <- forAll {
            (a: Constant, b: Constant) in
            
            let expression = AdditionExpression(a, b)
            
            let result = expression.evaluate()
            
            return result.leftAddendResult == a && result.rightAddendResult == b
        }
    }
    
    func test_probabilityMass_shouldReturnCorrect() {
        property("probability mass") <- forAll {
            (a: Constant, b: Constant) in
            
            let expectedProbMass = a.probabilityMass.and(b.probabilityMass)
            let expression = AdditionExpression(a, b)
            
            let probMass = expression.probabilityMass
            
            return probMass == expectedProbMass
        }
    }
    
}

// MARK: - Operators
extension AdditionExpression_Tests {
    
    func test_operator_shouldWorkWithIntAndExpression() {
        property("Int + Expression and Expression + Int returns correct AdditionExpression") <- forAll {
            (a: Int, b: Int) in
            
            let die = d(b)
            let expectedExpression1 = AdditionExpression(c(a), die)
            let expectedExpression2 = AdditionExpression(die, c(a))
            
            let expression1 = a + die
            let expression2 = die + a
            
            let test1 = (expression1 == expectedExpression1)
            let test2 = (expression2 == expectedExpression2)
            
            return test1 && test2
        }
    }
    
    func test_operator_shouldWorkWithExpressionAndExpression() {
        property("Expression + Expression returns correct AdditionExpresson") <- forAll {
            (a: Int, b: Int) in
            
            let leftDie = d(a)
            let rightDie = d(b)
            let expectedExpression = AdditionExpression(leftDie, rightDie)
            
            let expression = leftDie + rightDie
        
            return expression == expectedExpression
        }
    }
    
}

// MARK: - CustomDebugStringConvertible
extension AdditionExpression_Tests {
    
    func test_CustomDebugStringConvertible() {
        let expression = d(8) + 2
        let expected = "Die(8) + Constant(2)"
        
        let result = String(reflecting: expression)
        
        expect(result) == expected
    }
    
}

// MARK: - CustomStringConvertible
extension AdditionExpression_Tests {
    
    func test_CustomStringConvertible() {
        let expression = d(20) + d(4)
        let expected = "d20 + d4"
        
        let result = String(expression)
        
        expect(result) == expected
    }
    
}
