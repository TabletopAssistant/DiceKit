//
//  Die_Tests.swift
//  DiceKitTests
//
//  Created by Brentley Jones on 7/12/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `Die` type
class Die_Tests: XCTestCase {
    
    #if arch(i386) || arch(arm) // 32-bit
        typealias PositiveSidesType = UInt16
    #else // 64-bit
        typealias PositiveSidesType = UInt32
    #endif
    
    override func setUp() {
        Die.roller = Die.defaultRoller
    }
    
    override func tearDown() {
        Die.roller = Die.defaultRoller
    }
    
}

// MARK: - init() tests
extension Die_Tests {
    
    /// Tests that a die can have no sides.
    ///
    /// Needed because real dice have at least two sides, but we support this to
    /// play nicely with dice math reduction.
    func test_init_shouldSucceedWith0Sides() {
        let sides = 0
        
        let die = Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    /// Tests that a die can have one sides.
    ///
    /// Needed because real dice have at least two sides, but we support this to
    /// play nicely with dice math reduction.
    func test_init_shouldSucceedWith1Side() {
        let sides = 1
        
        let die = Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    func test_init_shouldSucceedWithFewSides() {
        let sides = 6
        
        let die = Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    /// Tests that a die can have odd number of sides.
    ///
    /// Needed because real dice don't have an odd number of sides,
    /// but we support it.
    func test_init_shouldSucceedWithOddSides() {
        let sides = 3
        
        let die = Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    func test_init_shouldSucceedWithManySides() {
        let sides = Int.max
        
        let die = Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    /// Tests that a die can have a negative number of sides.
    ///
    /// Needed because real dice don't have a negative number of sides,
    /// but we support it.
    func test_init_shouldSucceedWithNegativeSides() {
        let sides = -1
        
        let die = Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    /// Tests that a die will have a default number of sides
    ///
    /// This can be set via a static property.
    func test_init_shouldHaveDefaultNumberOfSides() {
        let die = Die()
        
        expect(die.sides) == Die.defaultSides
    }
    
    /// Tests the convenience function d(sides)
    func test_d_shouldReturnDie() {
        property("Returns correct die") <- forAll {
            (a: Int) in
            
            let dieFunction = d(a)
            let dieInit = Die(sides: a)
            
            return dieFunction == dieInit
        }
    }
    
    /// Tests that d() returns a Die with the default number of sides
    func test_d_shoulDefaultToCorrectNumberOfSides() {
        let defaultD = d()
        let defaultDie = Die()
        
        expect(defaultD) == defaultDie
    }
    
}

// MARK: - Equatatable
extension Die_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (i: PositiveSidesType) in
            
            let sides = Int(i)
            
            return EquatableTestUtilities.checkReflexive { Die(sides: sides) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (i: PositiveSidesType) in
            
            let sides = Int(i)
            
            return EquatableTestUtilities.checkSymmetric { Die(sides: sides) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (i: PositiveSidesType) in
            
            let sides = Int(i)
            
            return EquatableTestUtilities.checkTransitive { Die(sides: sides) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: PositiveSidesType, b: PositiveSidesType) in
            
            guard a != b else { return true }
            
            return EquatableTestUtilities.checkNotEquate(
                { Die(sides: Int(a)) },
                { Die(sides: Int(b)) }
            )
        }
    }
    
}

// MARK: - roll() tests
extension Die_Tests {
    
    func test_roll_shouldUseRoller() {
        var rollerCalledCount = 0
        let stubResult = 3
        Die.roller = { sides in
            ++rollerCalledCount
            return stubResult
        }
        let die = Die(sides: 6)
        
        let roll = die.roll()
        
        expect(rollerCalledCount) == 1
        expect(roll.value) == stubResult
    }
    
    func test_roll_shouldPassInSidesToRoller() {
        var sidesPassedIn: Int?
        Die.roller = { sides in
            sidesPassedIn = sides
            return 0
        }
        let sides = 7
        let die = Die(sides: sides)
        
        die.roll()
        
        expect(sidesPassedIn) == sides
    }
    
    func test_roll_shouldCallRollerOnlyOnceForEachCall() {
        var rollerCalledCount: UInt32 = 0
        Die.roller = { sides in
            ++rollerCalledCount
            return 0
        }
        let die = Die(sides: 3)
        
        let timesRolled = arc4random_uniform(UInt32(96)) + 5 // 5 to 100
        for _ in 0..<timesRolled {
            die.roll()
        }
        
        expect(rollerCalledCount) == timesRolled
    }
    
    func test_roll_shouldCreateRollProperly() {
        let stubResult = 6
        Die.roller = { sides in
            return stubResult
        }
        let die = Die(sides: 8)
        let expectedRoll = Die.Roll(die: die, value: stubResult)
        
        let roll = die.roll()
        
        expect(roll) == expectedRoll
    }
    
}

// MARK: - RollerType tests
extension Die_Tests {
    
    // MARK: - Utility test methods
    
    func common_RollerType_shouldReturn0For0Sides(rollerType: Die.RollerType) {
        expect(rollerType(sides: 0)) == 0
    }
    
    func common_RollerType_shouldReturn1For1Side(rollerType: Die.RollerType) {
        expect(rollerType(sides: 1)) == 1
    }
    
    func common_RollerType_shouldReturnNeg1ForNeg1Side(rollerType: Die.RollerType) {
        expect(rollerType(sides: -1)) == -1
    }
    
    func common_RollerType_shouldReturnWithinPositiveRangeForSidesGreaterThan1(rollerType: Die.RollerType) {
        property("generates values within range of 1...sides") <- forAll {
            (i: PositiveSidesType) in
            
            guard i > 1 else { return true }
            
            let sides = Int(i)
            
            let result = rollerType(sides: sides)
            
            return result > 0 && result <= sides
        }
    }
    
    func common_RollerType_shouldReturnWithinNegativeRangeForSidesLessThan0(rollerType: Die.RollerType) {
        property("generates values within range of sides..<0") <- forAll {
            (i: PositiveSidesType) in
            
            guard i > 1 else { return true }
            
            let sides = -Int(i)
            
            let result = rollerType(sides: sides)
            
            return result < 0 && result >= sides
        }
    }
    
    func common_RollerType_shouldReturnWithinRangeForSides(rollerType: Die.RollerType) {
        property("generates values within range of -sides...sides") <- forAll {
            (i: PositiveSidesType) in
            
            let sides = Int(i)
            
            let result = rollerType(sides: sides)
            
            return (-sides...sides).contains(result)
        }
    }
    
    func common_RollerType_shouldReturn0ForSidesLessThan0(rollerType: Die.RollerType) {
        property("generates 0 for -sides") <- forAll {
            (i: PositiveSidesType) in
            
            guard i > 0 else { return true }
            
            let sides = -Int(i)
            
            let result = rollerType(sides: sides)
            
            return result == 0
        }
    }
    
    func common_RollerType_shouldWorkForManySides(rollerType: Die.RollerType) {
        expect(rollerType(sides: Int.max)).toNot(raiseException())
        expect(rollerType(sides: Int.min)).toNot(raiseException())
    }

    // MARK: - defaultRoller
    func test_RollerType_defaultRoller_shouldReturn0For0Sides() {
        common_RollerType_shouldReturn0For0Sides(Die.defaultRoller)
    }
    
    func test_RollerType_defaultRoller_shouldReturn1For1Side() {
        common_RollerType_shouldReturn1For1Side(Die.defaultRoller)
    }
    
    func test_RollerType_defaultRoller_shouldReturnNeg1ForNeg1Side() {
        common_RollerType_shouldReturnNeg1ForNeg1Side(Die.defaultRoller)
    }
    
    func test_RollerType_defaultRoller_shouldReturnWithinPositiveRangeForSidesGreaterThan1() {
        common_RollerType_shouldReturnWithinPositiveRangeForSidesGreaterThan1(Die.defaultRoller)
    }
    
    func test_RollerType_defaultRoller_shouldReturnWithinNegativeRangeForSidesLessThan0() {
        common_RollerType_shouldReturnWithinNegativeRangeForSidesLessThan0(Die.defaultRoller)
    }
    
    func test_RollerType_defaultRoller_shouldWorkForManySides() {
        common_RollerType_shouldWorkForManySides(Die.defaultRoller)
    }
    
    // MARK: - unsignedRoller
    func test_RollerType_unsignedRoller_shouldReturn0For0Sides() {
        common_RollerType_shouldReturn0For0Sides(Die.unsignedRoller)
    }
    
    func test_RollerType_unsignedRoller_shouldReturn1For1Side() {
        common_RollerType_shouldReturn1For1Side(Die.unsignedRoller)
    }
    
    func test_RollerType_unsignedRoller_shouldReturnWithinPositiveRangeForSidesGreaterThan1() {
        common_RollerType_shouldReturnWithinPositiveRangeForSidesGreaterThan1(Die.unsignedRoller)
    }
    
    func test_RollerType_unsignedRoller_shouldReturn0ForSidesLessThan0() {
        common_RollerType_shouldReturn0ForSidesLessThan0(Die.unsignedRoller)
    }
    
    func test_RollerType_unsignedRoller_shouldWorkForManySides() {
        common_RollerType_shouldWorkForManySides(Die.unsignedRoller)
    }
    
    // MARK: - signedClosedRoller
    func test_RollerType_signedClosedRoller_shouldReturn0For0Sides() {
        common_RollerType_shouldReturn0For0Sides(Die.signedClosedRoller)
    }
    
    func test_RollerType_signedClosedRoller_shouldReturn1For1Side() {
        common_RollerType_shouldReturn1For1Side(Die.signedClosedRoller)
    }
    
    func test_RollerType_signedClosedRoller_shouldReturnNeg1ForNeg1Side() {
        common_RollerType_shouldReturnNeg1ForNeg1Side(Die.signedClosedRoller)
    }
    
    func test_RollerType_signedClosedRoller_shouldReturnWithinPositiveRangeForSidesGreaterThan1() {
        common_RollerType_shouldReturnWithinPositiveRangeForSidesGreaterThan1(Die.signedClosedRoller)
    }
    
    func test_RollerType_signedClosedRoller_shouldReturnWithinNegativeRangeForSidesLessThan0() {
        common_RollerType_shouldReturnWithinNegativeRangeForSidesLessThan0(Die.signedClosedRoller)
    }
    
    func test_RollerType_signedClosedRoller_shouldWorkForManySides() {
        common_RollerType_shouldWorkForManySides(Die.signedClosedRoller)
    }
    
    // MARK: - signedOpenRoller
    func test_RollerType_signedOpenRoller_shouldReturnWithinOpenRangeForSides() {
        common_RollerType_shouldReturnWithinPositiveRangeForSidesGreaterThan1(Die.signedClosedRoller)
    }
    
    func test_RollerType_signedOpenRoller_shouldWorkForManySides() {
        common_RollerType_shouldWorkForManySides(Die.signedOpenRoller)
    }
    
}

// MARK: - ExpressionType
extension Die_Tests {
    
    /// Tests that `Die` uses `roll()` to evaluate itself.
    func test_evaluate_shouldRollToDetermineResult() {
        let stubbedRoll = 4
        var rollerCalledCount = 0
        Die.roller = { sides in
            ++rollerCalledCount
            return stubbedRoll
        }
        let die = Die()
        
        let result = die.evaluate()
        
        expect(rollerCalledCount) == 1
        expect(result.value) == stubbedRoll
    }
    
    func test_probabilityMass_shouldReturnCorrect() {
        property("probability mass") <- forAll {
            (sides: Int) in
            
            // Arrange
            let inverseSides = -sides
            
            let die = Die(sides: sides)
            let inverseDie = Die(sides: inverseSides)
            
            // Act
            let probMass = die.probabilityMass
            let inverseProbMass = inverseDie.probabilityMass
            
            // Assert
            guard sides != 0 else {
                return probMass == ProbabilityMass.zero
            }
            
            let outcomePerValue = 1.0/ProbabilityMass.Probability(abs(sides))
            let range = sides < 0 ? sides...1 : 1...sides
            let inverseRange = inverseSides < 0 ? inverseSides...1 : 1...inverseSides
            
            for value in range {
                if probMass[value]! != outcomePerValue {
                    return false
                }
            }
            for value in inverseRange {
                if inverseProbMass[value]! != outcomePerValue {
                    return false
                }
            }
            return true
        }
    }
    
}
