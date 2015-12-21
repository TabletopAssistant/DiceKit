//
//  MaximizationExpression_Tests.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `MaximizationExpression` type
class MaximizationExpression_Tests: XCTestCase {
    
}

// MARK: - CustomDebugStringConvertible
extension MaximizationExpression_Tests {
    
    func test_CustomDebugStringConvertible() {
        let innerExpression = d(8) + 2
        let expression = MaximizationExpression(innerExpression)
        
        let expected = "max(\(String(reflecting: innerExpression)))"
        
        let result = String(reflecting: expression)
        
        expect(result) == expected
    }
}

// MARK: - CustomStringConvertible
extension MaximizationExpression_Tests {
    
    func test_CustomStringConvertible() {
        let innerExpression = d(20) + d(4)
        let expression = MaximizationExpression(innerExpression)
        let expected = "max(\(innerExpression))"
        
        let result = String(expression)
        
        expect(result) == expected
    }
}

// MARK: - Equatable
extension MaximizationExpression_Tests {

    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkReflexive { MaximizationExpression(a) }
        }
    }

    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkSymmetric { MaximizationExpression(a) }
        }
    }

    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: Die) in

            return EquatableTestUtilities.checkTransitive { MaximizationExpression(a) }
        }
    }

    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Die, b: Die) in

            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { MaximizationExpression(a) },
                    { MaximizationExpression(b) }
                )
            }
        }
    }
}

// MARK: - ExpressionType
extension MaximizationExpression_Tests {

    func test_evaluate_shouldCreateResultCorrectly() {
        property("create results") <- forAll {
            (a: Die) in

            let expression = MaximizationExpression(a)

            let result = expression.evaluate()

            return result.baseProbabilityMass == a.probabilityMass
        }
    }

    func test_probabilityMass_shouldReturnCorrect() {
        property("probability mass") <- forAll {
            (a: Die) in

            let freqDist: FrequencyDistribution<ExpressionResultValue>
            if let maximumOutcome = a.probabilityMass.maximumOutcome() {
                freqDist = FrequencyDistribution([maximumOutcome: 1])
            } else {
                freqDist = .additiveIdentity
            }

            let expectedProbMass = ProbabilityMass(freqDist)
            let expression = MaximizationExpression(a)

            let probMass = expression.probabilityMass

            return probMass == expectedProbMass
        }
    }
}
