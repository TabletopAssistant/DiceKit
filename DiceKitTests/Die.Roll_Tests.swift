//
//  Die_Roll_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/8/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `Die.Roll` type
class Die_Roll_Tests: XCTestCase {
    
}

// MARK: - Initialization
extension Die_Roll_Tests {
    
    func test_init() {
        property("init") <- forAll {
            (d: Die, i: Int) in
            
            let expectedDie = d
            let expectedValue = i
            
            let roll = Die.Roll(die: expectedDie, value: expectedValue)
            
            let testDie = roll.die == expectedDie
            let testvalue = roll.value == expectedValue
            
            return testDie && testvalue
        }
    }
    
}

// MARK: - Equatable
extension Die_Roll_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (d: Die) in
            
            return forAll(d.arbitraryRollValue) {
                (i: Int) in
                
                EquatableTestUtilities.checkReflexive { Die.Roll(die: d, value: i) }
            }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (d: Die) in
            
            return forAll(d.arbitraryRollValue) {
                (i: Int) in
                
                EquatableTestUtilities.checkSymmetric { Die.Roll(die: d, value: i) }
            }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (d: Die) in
            
            return forAll(d.arbitraryRollValue) {
                (i: Int) in
                
                EquatableTestUtilities.checkTransitive { Die.Roll(die: d, value: i) }
            }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (d1: Die, d2: Die) in
            
            return (d1 != d2) ==> {
                forAll(d1.arbitraryRollValue) { (i: Int) in forAll(d2.arbitraryRollValue) {
                    (j: Int) in
                    
                    EquatableTestUtilities.checkNotEquate(
                        { Die.Roll(die: d1, value: i) },
                        { Die.Roll(die: d2, value: j) }
                    )
                }}
            }
        }
    }
    
}

// MARK: - CustomDebugStringConvertible
extension Die_Roll_Tests {

    func test_customDebugStringConvertible() {
        let die = d(4)
        let roll = die.roll()
        let expectedResult = "\(String(reflecting: d(4))).Roll(\(roll.value))"

        let result = String(reflecting: roll)

        expect(result) == expectedResult
    }

}

//MARK: - CustomString Convertible
extension Die_Roll_Tests {

    func test_customStringConvertible() {
        let die = d(6)
        let roll = die.roll()
        let val = roll.value
        let expected = "\(val)|6"

        let result = String(roll)

        expect(result) == expected
    }

}

// MARK: - ExpressionResultType
extension Die_Roll_Tests {

    func test_resultValue() {
        property("resultValue") <- forAll {
            (x: Int) in

            let result = Die.Roll(die: Die(sides: x), value: x)
            let expectedValue = ExpressionResultValue(integerLiteral: result.value)

            let value = result.resultValue

            return value == expectedValue
        }
    }

}
