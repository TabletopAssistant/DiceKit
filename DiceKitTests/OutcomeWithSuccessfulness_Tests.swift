//
//  OutcomeWithSuccessfulness_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 10/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

@testable import DiceKit

class OutcomeWithSuccessfulness_Tests: XCTestCase {
}

// MARK: - Initialization
extension OutcomeWithSuccessfulness_Tests {
    
    func test_init() {
        property("init") <- forAll {
            (outcome: Int, successfulness: Successfulness) in

            let x = OutcomeWithSuccessfulness(outcome, successfulness: successfulness)

            let outcomeTest = x.outcome == outcome
            let successfulnessTest = x.successfulness == successfulness

            return outcomeTest && successfulnessTest
        }
    }
}

// MARK: - CustomDebugStringConvertible
extension OutcomeWithSuccessfulness_Tests {
    func test_CustomDebugStringConvertible() {
        let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(14,
            successfulness: Successfulness(successes: 6, failures: 4))
        let expected = "OutcomeWithSuccessfulness(\(14), successfulness: \(String(reflecting: Successfulness(successes: 6, failures: 4))))"

        let result = String(reflecting: outcomeWithSuccessfulness)

        expect(result) == expected
    }
}

// MARK: - CustomStringConvertible
extension OutcomeWithSuccessfulness_Tests {
    func test_CustomStringConvertible_onlySuccesses() {
        let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(14,
            successfulness: Successfulness(successes: 6, failures: 0))
        let expected = "(\(outcomeWithSuccessfulness.outcome) with \(outcomeWithSuccessfulness.successfulness.rawDescription(surroundWithParentheses: false)))"

        let result = String(outcomeWithSuccessfulness)

        expect(result) == expected
    }

    func test_CustomStringConvertible_onlyFailures() {
        let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(14,
            successfulness: Successfulness(successes: 0, failures: 4))
        let expected = "(\(outcomeWithSuccessfulness.outcome) with \(outcomeWithSuccessfulness.successfulness.rawDescription(surroundWithParentheses: false)))"

        let result = String(outcomeWithSuccessfulness)

        expect(result) == expected
    }

    func test_CustomStringConvertible_bothSuccessesAndFailures() {
        let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(14,
            successfulness: Successfulness(successes: 6, failures: 4))
        let expected = "(\(outcomeWithSuccessfulness.outcome) with \(outcomeWithSuccessfulness.successfulness.rawDescription(surroundWithParentheses: false)))"

        let result = String(outcomeWithSuccessfulness)

        expect(result) == expected
    }

    func test_CustomStringConvertible_noSuccessesOoFailures() {
        let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(14,
            successfulness: Successfulness(successes: 0, failures: 0))
        let expected = "\(outcomeWithSuccessfulness.outcome)"

        let result = String(outcomeWithSuccessfulness)
        
        expect(result) == expected
    }
}

// MARK: - Equatable
extension OutcomeWithSuccessfulness_Tests {

    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (x: Int, y: Successfulness) in

            return EquatableTestUtilities.checkReflexive { OutcomeWithSuccessfulness(x, successfulness: y) }
        }
    }

    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (x: Int, y: Successfulness) in

            return EquatableTestUtilities.checkSymmetric { OutcomeWithSuccessfulness(x, successfulness: y) }
        }
    }

    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (x: Int, y: Successfulness) in

            return EquatableTestUtilities.checkTransitive { OutcomeWithSuccessfulness(x, successfulness: y) }
        }
    }

    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int, b: Successfulness, c: Int, d: Successfulness) in

            return (a != c || b != d) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { OutcomeWithSuccessfulness(a, successfulness: b) },
                    { OutcomeWithSuccessfulness(c, successfulness: d) }
                )
            }
        }
    }
}

// MARK: - Comparable
extension OutcomeWithSuccessfulness_Tests {

    func test_operator_lessThan() {
        // Higher outcomes wins
        expect(OutcomeWithSuccessfulness(9, successfulness: 14)) < OutcomeWithSuccessfulness(10, successfulness: 13)

        // Otherwise higher successfulness wins
        expect(OutcomeWithSuccessfulness(10, successfulness: 12)) < OutcomeWithSuccessfulness(10, successfulness: 13)
    }
}

// MARK: - Hashable
extension OutcomeWithSuccessfulness_Tests {

    func test_hashValue() {
        property("x == y then x.hashValue == y.hashValue") <- forAll {
            (x: Int, y: Successfulness) in

            let a = OutcomeWithSuccessfulness(x, successfulness: y)
            let b = OutcomeWithSuccessfulness(x, successfulness: y)

            return a.hashValue == b.hashValue
        }
    }
}

// MARK: - AdditiveType, InvertibleAdditiveType, MultiplicativeType, InvertibleMultiplicativeType
extension OutcomeWithSuccessfulness_Tests {

    func test_additiveIdentity() {
        property("x + 0 == x == 0 + x") <- forAll {
            (x: Int, y: Successfulness) in

            let a = OutcomeWithSuccessfulness(x, successfulness: y)

            let a1 = a + .additiveIdentity
            let a2 = .additiveIdentity + a

            return a == a1 && a == a2
        }
    }

    func test_multiplicativeIdentity() {
        property("x * 1 == x == 1 * x") <- forAll {
            (x: Int, y: Successfulness) in

            let a = OutcomeWithSuccessfulness(x, successfulness: y)

            let a1 = a * .multiplicativeIdentity
            let a2 = .multiplicativeIdentity * a

            return a == a1 && a == a2
        }
    }

    func test_operator_add() {
        let x = OutcomeWithSuccessfulness(5,
            successfulness: Successfulness(successes: 0, failures: -1))
        let y = OutcomeWithSuccessfulness(-2,
            successfulness: Successfulness(successes: 8, failures: 2))
        let expected = OutcomeWithSuccessfulness(x.outcome + y.outcome,
            successfulness: x.successfulness + y.successfulness)

        let z = x + y

        expect(z) == expected
    }

    func test_operator_subtract() {
        let x = OutcomeWithSuccessfulness(5,
            successfulness: Successfulness(successes: 0, failures: -1))
        let y = OutcomeWithSuccessfulness(-2,
            successfulness: Successfulness(successes: 8, failures: 2))
        let expected = OutcomeWithSuccessfulness(x.outcome - y.outcome,
            successfulness: x.successfulness - y.successfulness)

        let z = x - y

        expect(z) == expected
    }

    func test_operator_multiply() {
        let x = OutcomeWithSuccessfulness(5,
            successfulness: Successfulness(successes: 0, failures: -1))
        let y = OutcomeWithSuccessfulness(-2,
            successfulness: Successfulness(successes: 8, failures: 2))
        let expected = OutcomeWithSuccessfulness(x.outcome * y.outcome,
            successfulness: x.successfulness * y.successfulness)

        let z = x * y

        expect(z) == expected
    }

    func test_operator_divide() {
        let x = OutcomeWithSuccessfulness(5,
            successfulness: Successfulness(successes: 0, failures: -1))
        let y = OutcomeWithSuccessfulness(-2,
            successfulness: Successfulness(successes: 8, failures: 2))
        let expected = OutcomeWithSuccessfulness(x.outcome / y.outcome,
            successfulness: x.successfulness / y.successfulness)

        let z = x / y

        expect(z) == expected
    }

    func test_operator_remainder() {
        let x = OutcomeWithSuccessfulness(5,
            successfulness: Successfulness(successes: 0, failures: -1))
        let y = OutcomeWithSuccessfulness(-2,
            successfulness: Successfulness(successes: 8, failures: 2))
        let expected = OutcomeWithSuccessfulness(x.outcome % y.outcome,
            successfulness: x.successfulness % y.successfulness)

        let z = x % y

        expect(z) == expected
    }
}

// MARK: - FrequencyDistributionOutcomeType
extension OutcomeWithSuccessfulness_Tests {

    func test_multiplierEquivalent() {
        property("multiplierEquivalent") <- forAll {
            (x: Int, y: Successfulness) in

            let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(x, successfulness: y)
            let multiplierEquivalent = x
            
            return outcomeWithSuccessfulness.multiplierEquivalent == multiplierEquivalent
        }
    }
}
