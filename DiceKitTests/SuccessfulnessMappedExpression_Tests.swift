//
//  SuccessfulnessMappedExpression_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 12/20/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

@testable import DiceKit

class SuccessfulnessMappedExpression_Tests: XCTestCase {

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

// MARK: - Initialization
extension SuccessfulnessMappedExpression_Tests {

    func test_init() {
        property("init") <- forAll {
            (x: Constant) in

            let successfulnessMapping = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture1
            let outcomeMapping = SuccessfulnessMappedExpression_Tests.outcomeMappingFixture1
            let expectedOutcomeMap = outcomeMapping(x.resultValue)

            let expression = SuccessfulnessMappedExpression(x, successfulnessMapping: successfulnessMapping)

            let outcomeMap = expression.outcomeMapping(x.resultValue)
            let outcomeMappingCorrect = expectedOutcomeMap == outcomeMap
            let baseExpressionCorrect = x == expression.base

            return baseExpressionCorrect && outcomeMappingCorrect
        }
    }
}

// MARK: - CustomDebugStringConvertible
extension SuccessfulnessMappedExpression_Tests {

    func test_CustomDebugStringConvertible() {
        let successfulnessMapping = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture1
        let expression = SuccessfulnessMappedExpression(c(42), successfulnessMapping: successfulnessMapping)
        let expected = "successfulnessMapped(\(String(reflecting: c(42))))"

        let result = String(reflecting: expression)

        expect(result) == expected
    }
}

// MARK: - CustomStringConvertible
extension SuccessfulnessMappedExpression_Tests {

    func test_CustomStringConvertible() {
        let successfulnessMapping = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture1
        let expression = SuccessfulnessMappedExpression(c(42), successfulnessMapping: successfulnessMapping)
        let expected = "successfulnessMapped(\(c(42)))"

        let result = String(expression)

        expect(result) == expected
    }
}

// MARK: - Equatable
extension SuccessfulnessMappedExpression_Tests {

    // TODO:
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (x: Constant) in

            let successfulnessMapping = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture1

            return EquatableTestUtilities.checkReflexive {
                SuccessfulnessMappedExpression(x, successfulnessMapping: successfulnessMapping)
            }
        }
    }

    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (x: Constant) in

            let successfulnessMapping = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture1

            return EquatableTestUtilities.checkSymmetric {
                SuccessfulnessMappedExpression(x, successfulnessMapping: successfulnessMapping)
            }
        }
    }

    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (x: Constant) in

            let successfulnessMapping = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture1

            return EquatableTestUtilities.checkTransitive {
                SuccessfulnessMappedExpression(x, successfulnessMapping: successfulnessMapping)
            }
        }
    }

    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (x: Constant, y: Constant) in

            let successfulnessMapping1 = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture1
            let successfulnessMapping2 = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture2

            return (x != y) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { SuccessfulnessMappedExpression(x, successfulnessMapping: successfulnessMapping1) },
                    { SuccessfulnessMappedExpression(y, successfulnessMapping: successfulnessMapping2) }
                )
            }
        }
    }
}

// MARK: - ExpressionType
extension SuccessfulnessMappedExpression_Tests {

    func test_evaluate_shouldCreateResultCorrectly() {
        property("create results") <- forAll {
            (a: Constant) in

            let successfulnessMapping = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture1
            let expression = SuccessfulnessMappedExpression(a, successfulnessMapping: successfulnessMapping)
            let expectedOutcomeMapped = expression.outcomeMapping(a.resultValue)

            let result = expression.evaluate()

            let outcomeMapped = result.outcomeMapping(a.resultValue)
            let outcomeMappingCorrect = outcomeMapped == expectedOutcomeMapped
            let baseResultCorrect = result.base == a

            return baseResultCorrect && outcomeMappingCorrect
        }
    }

    func test_probabilityMass_shouldReturnCorrect() {
        property("probability mass") <- forAll {
            (a: Constant) in

            let successfulnessMapping = SuccessfulnessMappedExpression_Tests.successfulnessMappingFixture2
            let expression = SuccessfulnessMappedExpression(a, successfulnessMapping: successfulnessMapping)
            let expectedProbMass = a.probabilityMass.mapOutcomes(SuccessfulnessMappedExpression_Tests.outcomeMappingFixture2)

            let probMass = expression.probabilityMass

            return probMass == expectedProbMass
        }
    }
}
