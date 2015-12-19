//
//  SubtractionExpression_Tests.swift
//  DiceKit
//
//  Created by Jonathan Hoffman on 8/14/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `SubtractionExpression` type
class SubtractionExpression_Tests: XCTestCase {
    
}

// MARK: - Equatable
extension SubtractionExpression_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkReflexive { SubtractionExpression(a, b) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkSymmetric { SubtractionExpression(a, b) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkTransitive { SubtractionExpression(a, b) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant, m: Constant, n: Constant) in
            
            return !(a == m && b == n) ==> {
                return EquatableTestUtilities.checkNotEquate(
                    { SubtractionExpression(a, b) },
                    { SubtractionExpression(m, n) }
                )
            }
        }
    }
    
    func test_shouldBeNoncommutative() {
        property("Noncommutative") <- forAll {
            (a: Constant, b: Constant) in
            
            return a != b ==> {
                
                let x = SubtractionExpression(a, b)
                let y = SubtractionExpression(b, a)
                
                return x != y
            }
        }
    }
    
}

// MARK: - ExpressionType
extension SubtractionExpression_Tests {
    
    func test_evaluate_shouldCreateResultCorrectly() {
        property("create results") <- forAll {
            (a: Constant, b: Constant) in
            
            let expression = SubtractionExpression(a, b)
            
            let result = expression.evaluate()
            
            return result.minuendResult == a && result.subtrahendResult == b
        }
    }
    
    func test_probabilityMass_shouldReturnCorrect() {
        property("probability mass") <- forAll {
            (a: Constant, b: Constant) in
            
            let negB = -b
            let expectedProbMass = a.probabilityMass.and(negB.probabilityMass)
            let expression = SubtractionExpression(a, b)
            
            let probMass = expression.probabilityMass
            
            return probMass == expectedProbMass
        }
    }
    
}

// MARK: - Operators
extension SubtractionExpression_Tests {
    
    func test_operator_shouldWorkWithIntAndExpression() {
        property("Int - Expression and Expression - Int returns correct SubtractionExpression") <- forAll {
            (a: Int, b: Int) in
            
            let die = d(b)
            let expectedExpression1 = SubtractionExpression(c(a), die)
            let expectedExpression2 = SubtractionExpression(die, c(a))
            
            let expression1 = a - die
            let expression2 = die - a
            
            let test1 = (expression1 == expectedExpression1)
            let test2 = (expression2 == expectedExpression2)
            
            return test1 && test2
        }
    }
    
    func test_operator_shouldWorkWithExpressionAndExpression() {
        property("Expression - Expression returns correct SubtractionExpresson") <- forAll {
            (a: Int, b: Int) in
            
            let leftDie = d(a)
            let rightDie = d(b)
            let expectedExpression = SubtractionExpression(leftDie, rightDie)
            
            let expression = leftDie - rightDie
            
            return expression == expectedExpression
        }
    }
    
}

// MARK: - CustomDebugStringConvertible
extension SubtractionExpression_Tests {
    
    func test_CustomDebugStringConvertible() {
        let expression = d(8) - 2
        let expected = "\(String(reflecting: d(8))) - \(String(reflecting: c(2)))"
        
        let result = String(reflecting: expression)
        
        expect(result) == expected
    }
    
}

// MARK: - CustomStringConvertible
extension SubtractionExpression_Tests {
    
    func test_CustomStringConvertible() {
        let expression = d(20) - d(4)
        let expected = "\(d(20)) - \(d(4))"
        
        let result = String(expression)
        
        expect(result) == expected
    }
    
}
