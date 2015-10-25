//
//  SuccessfulnessExpression_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/6/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

class SuccessfulnessExpression_Tests: XCTestCase {

}

// MARK: - Initialization
extension SuccessfulnessExpression_Tests {
    
    func test_init_shouldAllowBothComparisonsToBeNonNil() {
        let expectedBaseExpression = c(1)
        let successOperation = SuccessfulnessExpressionComparisonOperation.Equal
        let failOperation = SuccessfulnessExpressionComparisonOperation.GreaterThan
        let expectedSuccessComparison = SuccessfulnessExpressionComparison(successOperation, c(4))
        let expectedFailComparison = SuccessfulnessExpressionComparison(failOperation, c(-8))
        
        let expression = SuccessfulnessExpression(expectedBaseExpression, successComparison: expectedSuccessComparison, failComparison: expectedFailComparison)
        
        expect(expression.base) == expectedBaseExpression
        expect(expression.successComparison) == expectedSuccessComparison
        expect(expression.failComparison) == expectedFailComparison
    }
    
    func test_init_shouldAllowSuccessComparisonsToBeNil() {
        let expectedBaseExpression = c(567)
        let failOperation = SuccessfulnessExpressionComparisonOperation.LessThanOrEqual
        let expectedFailComparison = SuccessfulnessExpressionComparison(failOperation, c(77))
        
        let expression = SuccessfulnessExpression(expectedBaseExpression, successComparison: nil, failComparison: expectedFailComparison)
        
        expect(expression.base) == expectedBaseExpression
        expect(expression.successComparison).to(beNil())
        expect(expression.failComparison) == expectedFailComparison
    }
    
    func test_init_shouldAllowFailComparisonsToBeNil() {
        let expectedBaseExpression = c(-7)
        let successOperation = SuccessfulnessExpressionComparisonOperation.NotEqual
        let expectedSuccessComparison = SuccessfulnessExpressionComparison(successOperation, c(8665))
        
        let expression = SuccessfulnessExpression(expectedBaseExpression, successComparison: expectedSuccessComparison, failComparison: nil)
        
        expect(expression.base) == expectedBaseExpression
        expect(expression.successComparison) == expectedSuccessComparison
        expect(expression.failComparison).to(beNil())
    }
    
}

// MARK: - Equatable
extension SuccessfulnessExpression_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (x: Constant, y: Constant, z: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            let successComparison = SuccessfulnessExpressionComparison(m, y)
            let failComparison = SuccessfulnessExpressionComparison(n, z)
            
            return EquatableTestUtilities.checkReflexive {
                SuccessfulnessExpression(x, successComparison: successComparison, failComparison: failComparison)
            }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (x: Constant, y: Constant, z: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            let successComparison = SuccessfulnessExpressionComparison(m, y)
            let failComparison = SuccessfulnessExpressionComparison(n, z)
            
            return EquatableTestUtilities.checkSymmetric {
                SuccessfulnessExpression(x, successComparison: successComparison, failComparison: failComparison)
            }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (x: Constant, y: Constant, z: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            let successComparison = SuccessfulnessExpressionComparison(m, y)
            let failComparison = SuccessfulnessExpressionComparison(n, z)
            
            return EquatableTestUtilities.checkTransitive {
                SuccessfulnessExpression(x, successComparison: successComparison, failComparison: failComparison)
            }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant, c: Constant, d: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            let comparison1 = SuccessfulnessExpressionComparison(m, c)
            let comparison2 = SuccessfulnessExpressionComparison(n, d)
            
            return !(a == b && c == d) ==> {
                return EquatableTestUtilities.checkNotEquate(
                    { SuccessfulnessExpression(a, successComparison: comparison1, failComparison: comparison2) },
                    { SuccessfulnessExpression(b, successComparison: comparison2, failComparison: comparison1) }
                )
            }
        }
    }
    
}

// MARK: - ExpressionType
extension SuccessfulnessExpression_Tests {
    
    func test_evaluate_shouldCreateResultCorrectly() {
        property("create results") <- forAll {
            (x: Constant, y: Constant, z: Constant, m: SuccessfulnessExpressionComparisonOperation, n: SuccessfulnessExpressionComparisonOperation) in
            
            // Arrange
            let expectedSuccessOperation = m
            let expectedFailOperation = n
            let successComparison = SuccessfulnessExpressionComparison(m, y)
            let failComparison = SuccessfulnessExpressionComparison(n, z)
            
            let expression = SuccessfulnessExpression(x, successComparison: successComparison, failComparison: failComparison)
            
            // Act
            let result = expression.evaluate()
            
            // Assert
            let testBaseResult = result.base.value == x.value
            let testSuccessComparisonResult = result.successComparison?.comparedWith.value == y.value
            let testFailComparisonResult = result.failComparison?.comparedWith.value == z.value
            let testSuccessComparisonResultOperation = result.successComparison?.operation == expectedSuccessOperation
            let testFailComparisonResultOperation = result.failComparison?.operation == expectedFailOperation
            
            return testBaseResult
                && testSuccessComparisonResult
                && testFailComparisonResult
                && testSuccessComparisonResultOperation
                && testFailComparisonResultOperation
        }
    }
    
    func test_probabilityMass_shouldApplySuccessfulnessToUndetermined() {
        let constantValue = 1
        let succesfulness = Successfulness.Success
        let baseProbabilityMass = ExpressionProbabilityMass(FrequencyDistribution([OutcomeWithSuccessfulness(constantValue, .Undetermined): 1.0]))
        let expectedProbabilityMass = ExpressionProbabilityMass(FrequencyDistribution([OutcomeWithSuccessfulness(constantValue, succesfulness): 1.0]))
        let mockBaseExpression = MockExpression()
        mockBaseExpression.stubProbabilityMass = baseProbabilityMass
        let expression = SuccessfulnessExpression(mockBaseExpression, successComparison: SuccessfulnessExpressionComparison(.Equal, c(constantValue)), failComparison: nil)
        
        let probabilityMass = expression.probabilityMass
        
        expect(probabilityMass) == expectedProbabilityMass
    }
    
    func test_probabilityMass_shouldNotApplySuccessfulnessToNotUndetermined() {
        let constantValue = 1
        let succesfulness = Successfulness.Success
        let baseProbabilityMass = ExpressionProbabilityMass(FrequencyDistribution([OutcomeWithSuccessfulness(constantValue, succesfulness): 1.0]))
        let expectedProbabilityMass = baseProbabilityMass
        let mockBaseExpression = MockExpression()
        mockBaseExpression.stubProbabilityMass = baseProbabilityMass
        let expression = SuccessfulnessExpression(mockBaseExpression, successComparison: nil, failComparison:  SuccessfulnessExpressionComparison(.Equal, c(constantValue)))
        
        let probabilityMass = expression.probabilityMass
        
        expect(probabilityMass) == expectedProbabilityMass
    }
    
}
