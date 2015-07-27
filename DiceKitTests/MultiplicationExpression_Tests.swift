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
            (a: Int, b: Int) in
            
            let a = c(a)
            let b = c(b)
            
            let x = MultiplicationExpression(a, b)
            
            return x == x
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Int, b: Int) in
            
            let a = c(a)
            let b = c(b)
            
            let x = MultiplicationExpression(a, b)
            let y = MultiplicationExpression(a, b)
            
            return x == y && y == x
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Int, b: Int) in
            
            let a = c(a)
            let b = c(b)
            
            let x = MultiplicationExpression(a, b)
            let y = MultiplicationExpression(a, b)
            let z = MultiplicationExpression(a, b)
            
            return x == y && y == z && x == z
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int, b: Int, m: Int, n: Int) in
            
            // Check only this case since it's not commutative
            guard !(a == m && b == n) else { return true }
            
            let a = c(a)
            let b = c(b)
            let m = c(m)
            let n = c(n)
            
            let x = MultiplicationExpression(a, b)
            let y = MultiplicationExpression(m, n)
            
            return x != y
        }
    }
    
    func test_shouldBeAnticommutative() {
        property("anticommutative") <- forAll {
            (a: Int, b: Int) in
            
            guard a != b else { return true }
            
            let a = c(a)
            let b = c(b)
            
            let x = MultiplicationExpression(a, b)
            let y = MultiplicationExpression(b, a)
            
            return x != y
        }
    }

}

// MARK: - ExpressionType
extension MultiplicationExpression_Tests {
    
    class MockExpression: ExpressionType, Equatable {
        typealias Result = Constant
        
        var evaluateCalled = 0
        var stubResulter: () -> Result = { 0 }
        
        func evaluate() -> Result {
            let result = stubResulter()
            ++evaluateCalled
            return result
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
    
    func test_operator_shouldWorkWithIntAndDie() {
        property("Int * Die returns correct MultiplicationExpression") <- forAll {
            (a: Int, b: Int) in
            
            let constant = c(a)
            let die = d(b)
            let expectedExpression1 = MultiplicationExpression(constant, die)
            let expectedExpression2 = MultiplicationExpression(die, constant)
            
            let expression1 = constant * die
            let expression2 = die * constant
        
            let test1 = (expression1 == expectedExpression1)
            let test2 = (expression2 == expectedExpression2)
            return test1 && test2
        }
    }
    
    func test_operator_shouldWorkWithDieAndDie() {
        property("Die * Die returns correct MultiplicationExpression") <- forAll {
            (a: Int, b: Int) in
            
            let leftDie = d(a)
            let rightDie = d(b)
            let expectedExpression = MultiplicationExpression(leftDie, rightDie)
            
            let expression = leftDie * rightDie
        
            return expression == expectedExpression
        }
    }
    
}

func == (lhs: MultiplicationExpression_Tests.MockExpression, rhs: MultiplicationExpression_Tests.MockExpression) -> Bool {
    return lhs === rhs
}
