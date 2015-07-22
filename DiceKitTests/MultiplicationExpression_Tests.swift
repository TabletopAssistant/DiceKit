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
        property["reflexive"] = forAll {
            (a: Int, b: Int) in
            
            let x = MultiplicationExpression(a, b)
            
            return x == x
        }
    }
    
    func test_shouldBeSymmetric() {
        property["symmetric"] = forAll {
            (a: Int, b: Int) in
            
            let x = MultiplicationExpression(a, b)
            let y = MultiplicationExpression(a, b)
            
            return x == y && y == x
        }
    }
    
    func test_shouldBeTransitive() {
        property["transitive"] = forAll {
            (a: Int, b: Int) in
            
            let x = MultiplicationExpression(a, b)
            let y = MultiplicationExpression(a, b)
            let z = MultiplicationExpression(a, b)
            
            return x == y && y == z && x == z
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property["non-equal"] = forAll {
            (a: Int, b: Int, c: Int, d: Int) in
            
            // Check only this case since it's not commutative
            guard !(a == c && b == d) else { return true }
            
            let x = MultiplicationExpression(a, b)
            let y = MultiplicationExpression(c, d)
            
            return x != y
        }
    }
    
    func test_shouldBeAnticommutative() {
        property["anticommutative"] = forAll {
            (a: Int, b: Int) in
            
            guard a != b else { return true }
            
            let x = MultiplicationExpression(a, b)
            let y = MultiplicationExpression(b, a)
            
            return x != y
        }
    }

}

// MARK: - ExpressionType
extension MultiplicationExpression_Tests {
    
    class MockExpression: ExpressionType, Equatable {
        typealias Result = Int
        
        var evaluateCalled = 0
        var stubResulter: () -> Int = { 0 }
        
        func evaluate() -> Int {
            let result = stubResulter()
            ++evaluateCalled
            return result
        }
    }
    
    // TODO: Make a SwiftCheck
    func test_evaluate_shouldCreateResultCorrectly() {
        let multiplicandResults = [8, 4, 2, -7, 1, 9, 3, 3, -3, 4, 5]
        let expectedMultiplicandResults = multiplicandResults
        let leftExpression = expectedMultiplicandResults.count
        let expectedMultiplierResult = leftExpression
        let mockRightExpression = MockExpression()
        mockRightExpression.stubResulter = { multiplicandResults[mockRightExpression.evaluateCalled] }
        let expression = MultiplicationExpression(leftExpression, mockRightExpression)
        
        let result = expression.evaluate()
        
        expect(result.multiplierResult) == expectedMultiplierResult
        expect(result.multiplicandResults) == expectedMultiplicandResults
    }
    
}

func ==(lhs: MultiplicationExpression_Tests.MockExpression, rhs: MultiplicationExpression_Tests.MockExpression) -> Bool {
    return lhs === rhs
}
