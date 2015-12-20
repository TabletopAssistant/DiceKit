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
            (i: Int) in
            
            return EquatableTestUtilities.checkReflexive { Die(sides: i) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (i: Int) in
            
            return EquatableTestUtilities.checkSymmetric { Die(sides: i) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (i: Int) in
            
            return EquatableTestUtilities.checkTransitive { Die(sides: i) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int, b: Int) in
            
            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { Die(sides: a) },
                    { Die(sides: b) }
                )
            }
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
            (i: Int) in
            
            return (i > 1) ==> {
                let result = rollerType(sides: i)
                
                return result > 0 && result <= i
            }
        }
    }
    
    func common_RollerType_shouldReturnWithinNegativeRangeForSidesLessThan0(rollerType: Die.RollerType) {
        property("generates values within range of sides..<0") <- forAll {
            (i: Int) in
            
            return (i < -1) ==> {
                let result = rollerType(sides: i)
                
                return result < 0 && result >= i
            }
        }
    }
    
    func common_RollerType_shouldReturnWithinRangeForSides(rollerType: Die.RollerType) {
        property("generates values within range of -sides...sides") <- forAll {
            (i: Int) in
            
            // Int.min has one more value than Int.max, making this crash when negating it
            return (i >= 0) ==> {
                let result = rollerType(sides: i)
                
                return (-i...i).contains(result)
            }
        }
    }
    
    func common_RollerType_shouldReturn0ForSidesLessThan0(rollerType: Die.RollerType) {
        property("generates 0 for -sides") <- forAll {
            (i: Int) in
            
            return (i < 0) ==> {
                let result = rollerType(sides: i)
                
                return result == 0
            }
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
        common_RollerType_shouldReturnWithinRangeForSides(Die.signedOpenRoller)
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
            let die = Die(sides: sides)
            
            // Act
            let probMass = die.probabilityMass
            
            // Assert
            guard sides != 0 else {
                return probMass == ProbabilityMass.zero
            }
            
            typealias PM = ExpressionProbabilityMass
            
            let outcomePerValue = 1.0/PM.Probability(abs(sides))
            let range = sides < 0 ? sides...(-1) : 1...sides
            
            for value in range {
                let outcome = ExpressionProbabilityMass.Outcome(value)
                if probMass[outcome] != outcomePerValue {
                    return false
                }
            }
            return true
        }
    }
    
}

// MARK: - CustomDebugStringConvertible
extension Die_Tests {
    
    func test_die_customDebugStringConvertible() {
        let die = d(6)
        let expected = "Die(6)"
        
        let result = String(reflecting: die)
        
        expect(result) == expected
    }
    
}

//MARK: - CustomString Convertible
extension Die_Tests {
    
    func test_die_customStringConvertible() {
        let die = d(6)
        let expected = "d6"
        
        let result = String(die)
        
        expect(result) == expected
    }
    
}

//MARK: - ProbabilityMass for negative sided die
extension Die_Tests {
    
    func test_die_negativeSidedProbabilityMass() {
        let die = d(-2)
        let expectedProbabilityMass = ExpressionProbabilityMass(FrequencyDistribution([-2: 0.5, -1: 0.5]))
        
        expect(die.probabilityMass) == expectedProbabilityMass
    }
    
}
