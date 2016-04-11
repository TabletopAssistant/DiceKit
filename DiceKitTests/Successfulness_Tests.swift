//
//  Successfulness_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 10/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

class Successfulness_Tests: XCTestCase {
}

// MARK: - Initialization
extension Successfulness_Tests {
    func test_init() {
        property("init") <- forAll {
            (successes: Int, failures: Int) in

            let successfulness = Successfulness(successes: successes, failures: failures)

            let successesTest = successfulness.rawSuccesses == successes
            let failuresTest = successfulness.rawFailures == failures

            return successesTest && failuresTest
        }
    }

    func test_init_integerLiteral() {
        property("init integerLiteral") <- forAll {
            (x: Int) in

            let expectedSuccessed = x > 0 ? x : 0
            let expectedFailures = x < 0 ? -x : 0

            let successfulness = Successfulness(integerLiteral: x)

            let successesTest = successfulness.successes == expectedSuccessed
            let failuresTest = successfulness.failures == expectedFailures

            return successesTest && failuresTest
        }
    }
}

// MARK: - CustomDebugStringConvertible
extension Successfulness_Tests {
    func test_CustomDebugStringConvertible() {
        let successfulness = Successfulness(successes: 6, failures: 4)
        let expected = "Successfulness(rawSuccesses: 6, rawFailures: 4)"

        let result = String(reflecting: successfulness)

        expect(result) == expected
    }
}

// MARK: - CustomStringConvertible
extension Successfulness_Tests {
    func test_CustomStringConvertible_onlySuccesses() {
        let successfulness = Successfulness(successes: 6, failures: 0)
        let expected = "(6 Successes)"

        let result = String(successfulness)

        expect(result) == expected
    }

    func test_CustomStringConvertible_onlyFailures() {
        let successfulness = Successfulness(successes: 0, failures: 4)
        let expected = "(4 Failures)"

        let result = String(successfulness)

        expect(result) == expected
    }

    func test_CustomStringConvertible_bothSuccessesAndFailures() {
        let successfulness = Successfulness(successes: 6, failures: 4)
        let expected = "(6 Successes and 4 Failures)"

        let result = String(successfulness)

        expect(result) == expected
    }

    func test_CustomStringConvertible_noSuccessesOoFailures() {
        let successfulness = Successfulness(successes: 0, failures: 0)
        let expected = "(0 Successes)"

        let result = String(successfulness)

        expect(result) == expected
    }
}

// MARK: - Equatable
extension Successfulness_Tests {
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (x: Int, y: Int) in

            return EquatableTestUtilities.checkReflexive { Successfulness(successes: x, failures: y) }
        }
    }

    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (x: Int, y: Int) in

            return EquatableTestUtilities.checkSymmetric { Successfulness(successes: x, failures: y) }
        }
    }

    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (x: Int, y: Int) in

            return EquatableTestUtilities.checkTransitive { Successfulness(successes: x, failures: y) }
        }
    }

    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int, b: Int, c: Int, d: Int) in

            return (a != c || b != d) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { Successfulness(successes: a, failures: b) },
                    { Successfulness(successes: c, failures: d) }
                )
            }
        }
    }
}

// MARK: - Comparable
extension Successfulness_Tests {
    func test_operator_lessThan() {
        // Higher combinded (successes - failures) wins
        expect(Successfulness(successes: 10, failures: 9)) < Successfulness(successes: 9, failures: 7)

        // Otherwise higher successes/lower failures wins
        expect(Successfulness(successes: 10, failures: 9)) < Successfulness(successes: 11, failures: 10)
    }
}

// MARK: - Hashable
extension Successfulness_Tests {
    func test_hashValue() {
        property("x == y then x.hashValue == y.hashValue") <- forAll {
            (x: Int, y: Int) in

            let a = Successfulness(successes: x, failures: y)
            let b = Successfulness(successes: x, failures: y)

            return a.hashValue == b.hashValue
        }
    }
}

// MARK: - AdditiveType, InvertibleAdditiveType, MultiplicativeType, InvertibleMultiplicativeType
extension Successfulness_Tests {
    func test_additiveIdentity() {
        property("x + 0 == x == 0 + x") <- forAll {
            (x: Int, y: Int) in

            let a = Successfulness(successes: x, failures: y)

            let a1 = a + .additiveIdentity
            let a2 = .additiveIdentity + a

            return a == a1 && a == a2
        }
    }

    func test_multiplicativeIdentity() {
        property("x * 1 == x == 1 * x") <- forAll {
            (x: Int, y: Int) in

            let a = Successfulness(successes: x, failures: y)

            let a1 = a * .multiplicativeIdentity
            let a2 = .multiplicativeIdentity * a

            return a == a1 && a == a2
        }
    }

    func test_operator_add() {
        let x = Successfulness(successes: 3, failures: 1)
        let y = Successfulness(successes: -1, failures: 4)
        let expected = Successfulness(successes: 2, failures: 5)

        let z = x + y

        expect(z) == expected
    }

    func test_operator_subtract() {
        let x = Successfulness(successes: 3, failures: 1)
        let y = Successfulness(successes: -1, failures: 4)
        let expected = Successfulness(successes: 4, failures: -3)

        let z = x - y

        expect(z) == expected
    }

    func test_operator_multiply() {
        let x = Successfulness(successes: 3, failures: 1)
        let y = Successfulness(successes: -1, failures: 4)
        let expected = Successfulness(successes: -3, failures: 4)

        let z = x * y

        expect(z) == expected
    }

    func test_operator_divide() {
        let x = Successfulness(successes: 3, failures: 1)
        let y = Successfulness(successes: -1, failures: 4)
        let expected = Successfulness(successes: -3, failures: 0)

        let z = x / y

        expect(z) == expected
    }

    func test_operator_remainder() {
        let x = Successfulness(successes: 3, failures: 1)
        let y = Successfulness(successes: -1, failures: 4)
        let expected = Successfulness(successes: 0, failures: 1)

        let z = x % y

        expect(z) == expected
    }
}

// MARK: - FrequencyDistributionOutcomeType
extension Successfulness_Tests {
    func test_multiplierEquivalent() {
        property("multiplierEquivalent") <- forAll {
            (x: Int, y: Int) in

            let successfulness = Successfulness(successes: x, failures: y)
            let multiplierEquivalent = max(0,x) - max(0,y)

            return successfulness.multiplierEquivalent == multiplierEquivalent
        }
    }
}
