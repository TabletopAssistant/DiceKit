//
//  SuccessfulnessMappedExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 12/20/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

@testable import DiceKit

/// Tests the `SuccessfulnessMappedExpressionResult` type
class SuccessfulnessMappedExpressionResult_Tests: XCTestCase {

    static let successfulnessMappingFixture1: SuccessfulnessMappedExpression.SuccessfulnessMapping = {
        if $0.outcome % 2 == 0 {
            return Successfulness(successes: 1, failures: 0)
        } else {
            return $0.successfulness
        }
    }
    static let successfulnessMappingFixture2: SuccessfulnessMappedExpression.SuccessfulnessMapping = {
        if $0.outcome % 2 == 1 {
            return Successfulness(successes: 0, failures: 1)
        } else {
            return $0.successfulness
        }
    }

    static let outcomeMappingFixture1: SuccessfulnessMappedExpressionResult.OutcomeMapping = {
        ExpressionResultValue($0.outcome, successfulness: successfulnessMappingFixture1($0))
    }
    static let outcomeMappingFixture2: SuccessfulnessMappedExpressionResult.OutcomeMapping = {
        ExpressionResultValue($0.outcome, successfulness: successfulnessMappingFixture2($0))
    }
}

// MARK: - CustomDebugStringConvertible
extension SuccessfulnessMappedExpressionResult_Tests {

    func test_CustomDebugStringConvertible() {
        let innerExpression = d(8) + 2
        let successfulnessMapping = SuccessfulnessMappedExpressionResult_Tests.successfulnessMappingFixture1
        let expression = SuccessfulnessMappedExpression(innerExpression, successfulnessMapping: successfulnessMapping)
        let evaluation = expression.evaluate()
        let expected = "successfulnessMapped(\(String(reflecting: evaluation.base)))"

        let result = String(reflecting: evaluation)

        expect(result) == expected
    }
}

// MARK: - CustomStringConvertible
extension SuccessfulnessMappedExpressionResult_Tests {

    func test_CustomStringConvertible() {
        let innerExpression = d(20) + d(4)
        let successfulnessMapping = SuccessfulnessMappedExpressionResult_Tests.successfulnessMappingFixture2
        let expression = SuccessfulnessMappedExpression(innerExpression, successfulnessMapping: successfulnessMapping)
        let evaluation = expression.evaluate()
        let expected = "successfulnessMapped(\(evaluation.base))"

        let result = String(evaluation)

        expect(result) == expected
    }
}

// MARK: - Equatable
extension SuccessfulnessMappedExpressionResult_Tests {

    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Constant) in

            let outcomeMapping = SuccessfulnessMappedExpressionResult_Tests.outcomeMappingFixture1

            return EquatableTestUtilities.checkReflexive { SuccessfulnessMappedExpressionResult(a, outcomeMapping: outcomeMapping) }
        }
    }

    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Constant) in

            let outcomeMapping = SuccessfulnessMappedExpressionResult_Tests.outcomeMappingFixture2

            return EquatableTestUtilities.checkSymmetric { SuccessfulnessMappedExpressionResult(a, outcomeMapping: outcomeMapping) }
        }
    }

    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Constant) in

            let outcomeMapping = SuccessfulnessMappedExpressionResult_Tests.outcomeMappingFixture2

            return EquatableTestUtilities.checkTransitive { SuccessfulnessMappedExpressionResult(a, outcomeMapping: outcomeMapping) }
        }
    }

    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Constant, b: Constant) in

            let outcomeMapping1 = SuccessfulnessMappedExpressionResult_Tests.outcomeMappingFixture1
            let outcomeMapping2 = SuccessfulnessMappedExpressionResult_Tests.outcomeMappingFixture2

            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { SuccessfulnessMappedExpressionResult(a, outcomeMapping: outcomeMapping1) },
                    { SuccessfulnessMappedExpressionResult(b, outcomeMapping: outcomeMapping2) }
                )
            }
        }
    }
}

// MARK: - ExpressionResultType
extension SuccessfulnessMappedExpressionResult_Tests {

    func test_resultValue() {
        property("resultValue") <- forAll {
            (a: Constant) in
            let outcomeMapping = SuccessfulnessMappedExpressionResult_Tests.outcomeMappingFixture2
            let result = SuccessfulnessMappedExpressionResult(a, outcomeMapping: outcomeMapping)
            let expectedValue = outcomeMapping(result.base.resultValue)
            
            return result.resultValue == expectedValue
        }
    }
}
