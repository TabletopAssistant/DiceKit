//
//  MaximizationExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

import XCTest
import Nimble
import SwiftCheck

@testable import DiceKit

/// Tests the `MaximizationExpressionResult` type
class MaximizationExpressionResult_Tests: XCTestCase {
    
}

// MARK: - CustomDebugStringConvertible
extension MaximizationExpressionResult_Tests {

    func test_CustomDebugStringConvertible() {
        let innerExpression = d(8) + 2
        let expression = MaximizationExpression(innerExpression)
        let evaluation = expression.evaluate()
        let stringlyArray = innerExpression.probabilityMass.orderedOutcomes.map { String(reflecting: $0) }.joinWithSeparator(", ")
        let expected = "max([\(stringlyArray)])"

        let result = String(reflecting: evaluation)

        expect(result) == expected
    }
}

// MARK: - CustomStringConvertible
extension MaximizationExpressionResult_Tests {

    func test_CustomStringConvertible() {
        let innerExpression = d(20) + d(4)
        let expression = MaximizationExpression(innerExpression)
        let evaluation = expression.evaluate()
        let stringlyArray = innerExpression.probabilityMass.orderedOutcomes.map { String($0) }.joinWithSeparator(", ")
        let expected = "max([\(stringlyArray)])"

        let result = String(evaluation)

        expect(result) == expected
    }
}

// MARK: - Equatable
extension MaximizationExpressionResult_Tests {

    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkReflexive { MaximizationExpressionResult<Die.Result>(a.probabilityMass) }
        }
    }

    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkSymmetric { MaximizationExpressionResult<Die.Result>(a.probabilityMass) }
        }
    }

    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkTransitive { MaximizationExpressionResult<Die.Result>(a.probabilityMass) }
        }
    }

    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Die, b: Die) in

            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { MaximizationExpressionResult<Die.Result>(a.probabilityMass) },
                    { MaximizationExpressionResult<Die.Result>(b.probabilityMass) }
                )
            }
        }
    }
}

// MARK: - ExpressionResultType
extension MaximizationExpressionResult_Tests {
    
    func test_shouldReturnMaximumForZeroSidedDie() {
        let expression = MaximizationExpression(d(0))
        let result = expression.evaluate()
        
        expect(result.resultValue) == 0
    }
    
    func test_shouldReturnMaximumForSingleDie() {
        let expression = MaximizationExpression(d(8))
        let result = expression.evaluate()
        
        expect(result.resultValue) == 8
    }
    
    func test_shouldReturnMaximumForAddition() {
        let expression = MaximizationExpression(d(8) + 4)
        let result = expression.evaluate()
        
        expect(result.resultValue) == 12
    }
    
    func test_shouldReturnMaximumForMultiply() {
        let expression = MaximizationExpression(d(8) * 4)
        let result = expression.evaluate()
        
        expect(result.resultValue) == 32
    }
}
