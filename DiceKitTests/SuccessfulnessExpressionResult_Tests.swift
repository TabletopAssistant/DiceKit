//
//  SuccessfulnessExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/7/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

class SuccessfulnessExpressionResult_Tests: XCTestCase {
    
}

// MARK: - Initialization
extension SuccessfulnessExpressionResult_Tests {
    
    func test_init_shouldAllowBothComparisonsToBeNonNil() {
        let expectedBaseExpression = c(1)
        let successOperation = SuccessfulnessExpressionComparisonOperation.Equal
        let failOperation = SuccessfulnessExpressionComparisonOperation.GreaterThan
        let expectedSuccessComparison = SuccessfulnessExpressionResultComparison(successOperation, c(4))
        let expectedFailComparison = SuccessfulnessExpressionResultComparison(failOperation, c(-8))
        
        let expression = SuccessfulnessExpressionResult(expectedBaseExpression, successComparison: expectedSuccessComparison, failComparison: expectedFailComparison)
        
        expect(expression.base) == expectedBaseExpression
        expect(expression.successComparison) == expectedSuccessComparison
        expect(expression.failComparison) == expectedFailComparison
    }
    
    func test_init_shouldAllowSuccessComparisonToBeNil() {
        let expectedBaseExpression = c(567)
        let failOperation = SuccessfulnessExpressionComparisonOperation.LessThanOrEqual
        let expectedFailComparison = SuccessfulnessExpressionResultComparison(failOperation, c(77))
        
        let expression = SuccessfulnessExpressionResult(expectedBaseExpression, successComparison: nil, failComparison: expectedFailComparison)
        
        expect(expression.base) == expectedBaseExpression
        expect(expression.successComparison).to(beNil())
        expect(expression.failComparison) == expectedFailComparison
    }
    
    func test_init_shouldAllowFailComparisonToBeNil() {
        let expectedBaseExpression = c(-7)
        let successOperation = SuccessfulnessExpressionComparisonOperation.NotEqual
        let expectedSuccessComparison = SuccessfulnessExpressionResultComparison(successOperation, c(8665))
        
        let expression = SuccessfulnessExpressionResult(expectedBaseExpression, successComparison: expectedSuccessComparison, failComparison: nil)
        
        expect(expression.base) == expectedBaseExpression
        expect(expression.successComparison) == expectedSuccessComparison
        expect(expression.failComparison).to(beNil())
    }
    
}

// MARK: - Equatable
extension SuccessfulnessExpressionResult_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (x: Constant, y: Constant, z: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            let successComparison = SuccessfulnessExpressionResultComparison(m, y)
            let failComparison = SuccessfulnessExpressionResultComparison(n, z)
            
            return EquatableTestUtilities.checkReflexive {
                SuccessfulnessExpressionResult(x, successComparison: successComparison, failComparison: failComparison)
            }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (x: Constant, y: Constant, z: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            let successComparison = SuccessfulnessExpressionResultComparison(m, y)
            let failComparison = SuccessfulnessExpressionResultComparison(n, z)
            
            return EquatableTestUtilities.checkSymmetric {
                SuccessfulnessExpressionResult(x, successComparison: successComparison, failComparison: failComparison)
            }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (x: Constant, y: Constant, z: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            let successComparison = SuccessfulnessExpressionResultComparison(m, y)
            let failComparison = SuccessfulnessExpressionResultComparison(n, z)
            
            return EquatableTestUtilities.checkTransitive {
                SuccessfulnessExpressionResult(x, successComparison: successComparison, failComparison: failComparison)
            }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant, c: Constant, d: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            let comparison1 = SuccessfulnessExpressionResultComparison(m, c)
            let comparison2 = SuccessfulnessExpressionResultComparison(n, d)
            
            return !(a == b && c == d) ==> {
                return EquatableTestUtilities.checkNotEquate(
                    { SuccessfulnessExpressionResult(a, successComparison: comparison1, failComparison: comparison2) },
                    { SuccessfulnessExpressionResult(b, successComparison: comparison2, failComparison: comparison1) }
                )
            }
        }
    }
    
}

// MARK: - ExpressionResultType
extension SuccessfulnessExpressionResult_Tests {
    
    func test_value_shouldPassthrough() {
        let baseResult = c(6)
        let successComparisonResult = SuccessfulnessExpressionResultComparison(.NotEqual, c(-3))
        let failComparisonResult = SuccessfulnessExpressionResultComparison(.GreaterThanOrEqual, c(7))
        
        let result = SuccessfulnessExpressionResult(baseResult, successComparison: successComparisonResult, failComparison: failComparisonResult)
        
        expect(result.value) == baseResult.value
    }
    
    func test_successfulness_shouldUseSuccessFirst() {
        let baseResult = c(8)
        let successComparisonResult = SuccessfulnessExpressionResultComparison(.Equal, baseResult)
        let failComparisonResult = SuccessfulnessExpressionResultComparison(.Equal, baseResult)
        let expectedSuccessfulness = Successfulness.Success
        
        let result = SuccessfulnessExpressionResult(baseResult, successComparison: successComparisonResult, failComparison: failComparisonResult)
        
        expect(result.successfulness) == expectedSuccessfulness
    }
    
    func test_successfulness_shouldUseSuccessEvenWhenNoFail() {
        let baseResult = c(9)
        let successComparisonResult = SuccessfulnessExpressionResultComparison(.Equal, baseResult)
        let expectedSuccessfulness = Successfulness.Success
        
        let result = SuccessfulnessExpressionResult(baseResult, successComparison: successComparisonResult, failComparison: nil)
        
        expect(result.successfulness) == expectedSuccessfulness
    }
    
    func test_successfulness_shouldUseFailEvenWhenNoSuccess() {
        let baseResult = c(14)
        let failComparisonResult = SuccessfulnessExpressionResultComparison(.Equal, baseResult)
        let expectedSuccessfulness = Successfulness.Fail
        let result = SuccessfulnessExpressionResult(baseResult, successComparison: nil, failComparison: failComparisonResult)
        
        let successfulness = result.successfulness
        
        expect(successfulness) == expectedSuccessfulness
    }
    
    func test_successfulness_shouldPassThroughExistingSuccessOrFail() {
        // Arrange
        let expectedSuccessfulness = Successfulness.Success
        
        let baseResult = c(5)
        let mockExpressionResult = MockExpressionResult()
        mockExpressionResult.stubValue = baseResult.value
        mockExpressionResult.stubSuccessfulness = expectedSuccessfulness
        
        let failComparisonResult = SuccessfulnessExpressionResultComparison(.Equal, baseResult)
        let result = SuccessfulnessExpressionResult(mockExpressionResult, successComparison: nil, failComparison: failComparisonResult)
        
        // Act
        let successfulness = result.successfulness
        
        // Assert
        expect(successfulness) == expectedSuccessfulness
    }
    
    func test_successfulness_shouldPassThroughWhenNeitherSuccessOrFail() {
        // Arrange
        let expectedSuccessfulness = Successfulness.Undetermined
        
        let baseResult = c(5)
        let mockExpressionResult = MockExpressionResult()
        mockExpressionResult.stubValue = baseResult.value
        mockExpressionResult.stubSuccessfulness = expectedSuccessfulness
        
        let successComparisonResult = SuccessfulnessExpressionResultComparison(.LessThan, baseResult)
        let failComparisonResult = SuccessfulnessExpressionResultComparison(.GreaterThan, baseResult)
        let result = SuccessfulnessExpressionResult(mockExpressionResult, successComparison: successComparisonResult, failComparison: failComparisonResult)
        
        // Act
        let successfulness = result.successfulness
        
        // Assert
        expect(successfulness) == expectedSuccessfulness
    }
    
}
