//
//  SubtractionExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Jonathan Hoffman on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `SubtractionExpressionResult` type
class SubtractionExpressionResult_Tests: XCTestCase {
    
}

// MARK: - Equatable
extension SubtractionExpressionResult_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkReflexive { SubtractionExpressionResult(a, b) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkSymmetric { SubtractionExpressionResult(a, b) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Constant, b: Constant) in
            
            return EquatableTestUtilities.checkTransitive { SubtractionExpressionResult(a, b) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant, m: Constant, n: Constant) in
            
            return (!(a == m && b == n) && !(a == n && b == m)) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { SubtractionExpressionResult(a, b) },
                    { SubtractionExpressionResult(m, n) }
                )
            }
        }
    }
    
    func test_shouldBeAnticommutative() {
        property("Anticommutative") <- forAll {
            (a: Constant, b: Constant) in
            
            return (a != b) ==> {
                let x = SubtractionExpression(a, b).evaluate()
                let y = SubtractionExpression(b, a).evaluate()
                
                let testNoncommutative = x != y
                let testAnticommutative = x.value == -y.value
                
                return testNoncommutative && testAnticommutative
            }
        }
    }
    
}

// MARK: - ExpressionResultType
extension SubtractionExpressionResult_Tests {
    
    func test_value_shouldSubtractSubtrahendFromMinuend() {
        property("Subtract subtrahend from minuend") <- forAll {
            (a: Int16, b: Int16) in
            
            let minuend = Int(a)
            let subtrahend = Int(b)
            
            let expectedValue = minuend - subtrahend
            
            let result = SubtractionExpressionResult(c(minuend), c(subtrahend))
            
            let value = result.value
            
            return value == expectedValue
        }
    }

    func test_successfulness_shouldSubtractSuccessfulnesses() {
        let possibleSuccessfulessnesses: [Successfulness] = [.Undetermined, .Success, .Fail]
        for lhsSuccessfulness in possibleSuccessfulessnesses {
            for rhsSuccessfulness in possibleSuccessfulessnesses {
                // Arrange
                let expectedSuccessfulness = lhsSuccessfulness - rhsSuccessfulness // Tested already, so can use

                let lhsMock = MockExpressionResult()
                lhsMock.stubSuccessfulness = lhsSuccessfulness
                let rhsMock = MockExpressionResult()
                rhsMock.stubSuccessfulness = rhsSuccessfulness

                let result = SubtractionExpressionResult(lhsMock, rhsMock)

                // Act
                let successfulness = result.successfulness

                // Assert
                expect(successfulness) == expectedSuccessfulness
            }
        }
    }
    
}

// MARK: - CustomDebugStringConvertible
extension SubtractionExpressionResult_Tests {
    
    func test_CustomDebuStringConvertible() {
        let expression = d(10) - 5
        let evaluation = expression.evaluate()
        let expected = "Die(10).Roll(\(evaluation.minuendResult.value)) - Constant(5)"
        
        let result = String(reflecting: evaluation)
        
        expect(result) == expected
    }
    
}

// Mark: - CustomStringConvertible
extension SubtractionExpressionResult_Tests {
    
    func test_CustomStringConvertible() {
        let expression = d(10) - 5
        let evaluation = expression.evaluate()
        let expected = "\(evaluation.minuendResult.value)|10 - 5"
        
        let result = String(evaluation)
        
        expect(result) == expected
    }
    
}
