//
//  DieTests.swift
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
class Die_Test: XCTestCase {
}

// MARK: - init() tests
extension Die_Test {
    
    /// Tests that a die can have no sides.
    ///
    /// Needed because real dice have at least two sides, but we support this to
    /// play nicely with dice math reduction.
    func test_init_shouldSucceedWith0Sides() {
        let sides = 0
        
        let die = try! Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    /// Tests that a die can have one sides.
    ///
    /// Needed because real dice have at least two sides, but we support this to
    /// play nicely with dice math reduction.
    func test_init_shouldSucceedWith1Side() {
        let sides = 1
        
        let die = try! Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    func test_init_shouldSucceedWithFewSides() {
        let sides = 6
        
        let die = try! Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    /// Tests that a die can have odd number of sides.
    ///
    /// Needed because real dice don't have an odd number of sides, but we support it.
    func test_init_shouldSucceedWithOddSides() {
        let sides = 3
        
        let die = try! Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    func test_init_shouldSucceedWithManySides() {
        let sides = Int.max
        
        let die = try! Die(sides: sides)
        
        expect(die.sides) == sides
    }
    
    /// Tests that a die cannot have a negative number of sides.
    ///
    /// We could support this, but it would cover up an error case that the
    /// client would most likely want to know about.
    func test_init_shouldFailWithNegativeSides() {
        let sides = -1
        
        do {
            let _ = try Die(sides: sides)
            
            fail("Initialization succeeded")
        } catch DieError.NegativeSides {
            // pass
        } catch {
            fail("Unknown error \(error)")
        }
    }
    
}

// MARK: - roll() tests
extension Die_Test {
    
    func test_roll_shouldUseRoller() {
        var rollerCalledCount = 0
        let stubResult = 3
        Die.roller = { sides in
            ++rollerCalledCount
            return stubResult
        }
        let die = try! Die(sides: 6)
        
        let result = die.roll()
        
        expect(rollerCalledCount) == 1
        expect(result) == stubResult
    }
    
    func test_roll_shouldPassInSidesToRoller() {
        var sidesPassedIn: Int?
        Die.roller = { sides in
            sidesPassedIn = sides
            return 0
        }
        let sides = 7
        let die = try! Die(sides: sides)
        
        die.roll()
        
        expect(sidesPassedIn) == sides
    }
    
    func test_roll_shouldCallRollerOnlyOnceForEachCall() {
        var rollerCalledCount: UInt32 = 0
        Die.roller = { sides in
            ++rollerCalledCount
            return 0
        }
        let die = try! Die(sides: 3)
        
        let timesRolled = arc4random_uniform(UInt32(96)) + 5 // 5 to 100
        for _ in 0..<timesRolled {
            die.roll()
        }
        
        expect(rollerCalledCount) == timesRolled
    }
    
}

// MARK: - defaultRoller tests
extension Die_Test {

    func test_RollerType_shouldReturn0For0Sides() {
        expect(Die.defaultRoller(sides: 0)) == 0
    }
    
    func test_RollerType_shouldReturn1For1Side() {
        expect(Die.defaultRoller(sides: 1)) == 1
    }
    
    func test_RollerType_shouldReturnWithinRangeForSidesGreaterThan1() {
        property["RollerType generates values within range of 1...sides"] = forAll { (sides: Int) in
            guard sides > 1 else { return true }
            
            let result = Die.defaultRoller(sides: sides)
            
            return result > 0 && result <= sides
        }
    }
    
    func test_RollerType_shouldWorkForManySides() {
        expect(Die.defaultRoller(sides: Int.max)).toNot(raiseException())
    }
    
}
