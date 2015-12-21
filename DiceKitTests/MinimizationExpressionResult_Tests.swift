//
//  MinimizationExpressionResult_Tests.swift
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

/// Tests the `MinimizationExpressionResult` type
class MinimizationExpressionResult_Tests: XCTestCase {
    
}

// MARK: - CustomDebugStringConvertible
extension MinimizationExpressionResult_Tests {

    func test_CustomDebugStringConvertible() {
        let innerExpression = d(8) + 2
        let expression = MinimizationExpression(innerExpression)
        let evaluation = expression.evaluate()
        let stringlyArray = innerExpression.probabilityMass.orderedOutcomes.map { String(reflecting: $0) }.joinWithSeparator(", ")
        let expected = "min([\(stringlyArray)])"

        let result = String(reflecting: evaluation)

        expect(result) == expected
    }
}

// MARK: - CustomStringConvertible
extension MinimizationExpressionResult_Tests {

    func test_CustomStringConvertible() {
        let innerExpression = d(20) + d(4)
        let expression = MinimizationExpression(innerExpression)
        let evaluation = expression.evaluate()
        let stringlyArray = innerExpression.probabilityMass.orderedOutcomes.map { String($0) }.joinWithSeparator(", ")
        let expected = "min([\(stringlyArray)])"

        let result = String(evaluation)

        expect(result) == expected
    }
}

// MARK: - Equatable
extension MinimizationExpressionResult_Tests {

    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkReflexive { MinimizationExpressionResult<Die.Result>(a.probabilityMass) }
        }
    }

    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkSymmetric { MinimizationExpressionResult<Die.Result>(a.probabilityMass) }
        }
    }

    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkTransitive { MinimizationExpressionResult<Die.Result>(a.probabilityMass) }
        }
    }

    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Die, b: Die) in

            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { MinimizationExpressionResult<Die.Result>(a.probabilityMass) },
                    { MinimizationExpressionResult<Die.Result>(b.probabilityMass) }
                )
            }
        }
    }
}

// MARK: - ExpressionResultType
extension MinimizationExpressionResult_Tests {
    
    func test_shouldReturnMinimumForZeroSidedDie() {
        let expression = MinimizationExpression(d(0))
        let result = expression.evaluate()
        
        expect(result.resultValue) == 0
    }
    
    func test_shouldReturnMinimum() {
        let expression = MinimizationExpression(d(8))
        let result = expression.evaluate()
        
        expect(result.resultValue) == 1
    }
    
    func test_shouldReturnMinimumForAddition() {
        let expression = MinimizationExpression(d(8) + 4)
        let result = expression.evaluate()
        
        expect(result.resultValue) == 5
    }
    
    func test_shouldReturnMinimumForMultiply() {
        let expression = MinimizationExpression(d(8) * 4)
        let result = expression.evaluate()
        
        expect(result.resultValue) == 4
    }
}
