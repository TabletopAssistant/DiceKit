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

// MARK: - Equatable
extension AdditionExpression_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Int, b: Int) in
            
            let a = c(a)
            let b = c(b)
            
            let x = AdditionExpression(a, b)
            
            return x == x
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Int, b: Int) in
            
            let a = c(a)
            let b = c(b)
            
            let x = AdditionExpression(a, b)
            let y = AdditionExpression(a, b)
            
            return x == y && y == x
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Int, b: Int) in
            
            let a = c(a)
            let b = c(b)
            
            let x = AdditionExpression(a, b)
            let y = AdditionExpression(a, b)
            let z = AdditionExpression(a, b)
            
            return x == y && y == z && x == z
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int, b: Int, m: Int, n: Int) in
            
            // Check both cases since it's commutative
            guard !(a == m && b == n || a == n && b == m) else { return true }
            
            let a = c(a)
            let b = c(b)
            let m = c(m)
            let n = c(n)
            
            let x = AdditionExpression(a, b)
            let y = AdditionExpression(m, n)
            
            return x != y
        }
    }
    
    func test_shouldBeCommutative() {
        property("commutative") <- forAll {
            (a: Int, b: Int) in
            
            guard a != b else { return true }
            
            let a = c(a)
            let b = c(b)
            
            let x = AdditionExpression(a, b)
            let y = AdditionExpression(b, a)
            
            return x == y
        }
    }
    
}

// MARK: - ExpressionType
extension AdditionExpression_Tests {
    
    func test_evaluate_shouldCreateResultCorrectly() {
        property("create results") <- forAll {
            (a: Int, b: Int) in
            
            let a = c(a)
            let b = c(b)
            
            let expression = AdditionExpression(a, b)
            
            let result = expression.evaluate()
            
            return result.leftAddendResult == a && result.rightAddendResult == b
        }
    }
    
}

// MARK: - Operators
extension AdditionExpression_Tests {
    
    func test_operator_shouldWorkWithIntAndDie() {
        property("Constant + Die returns correct AdditionExpression") <- forAll {
            (a: Int, b: Int) in
            
            let constant = c(a)
            let die = d(b)
            let expectedExpression1 = AdditionExpression(constant, die)
            let expectedExpression2 = AdditionExpression(die, constant)
            
            let expression1 = constant + die
            let expression2 = die + constant
            
            let test1 = (expression1 == expectedExpression1)
            let test2 = (expression2 == expectedExpression2)
            
            return test1 && test2
        }
    }
    
    func test_operator_shouldWorkWithDieAndDie() {
        property("Die + Die returns correct AdditionExpresson") <- forAll {
            (a: Int, b: Int) in
            
            let leftDie = d(a)
            let rightDie = d(b)
            let expectedExpression = AdditionExpression(leftDie, rightDie)
            
            let expression = leftDie + rightDie
        
            return expression == expectedExpression
        }
    }
    
    func test_operator_shouldWorkWithMultiplicationExpressions() {
        property("MultiplicationExpression + Constant returns correct AdditionExpression") <- forAll {
            (m: Int, n: Int, o: Int) in
            
            let leftExpression = c(m) * d(n)
            let rightExpression = c(o)
            let expectedExpression = AdditionExpression(leftExpression, rightExpression)
            
            let expression = leftExpression + rightExpression
        
            return expression == expectedExpression
        }
    }
    
}
