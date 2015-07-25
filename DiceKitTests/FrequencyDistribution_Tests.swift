//
//  FrequencyDistribution_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble

import DiceKit

/// Tests the `FrequencyDistribution` type
class FrequencyDistribution_Tests: XCTestCase {

}

// MARK: - init() tests
extension FrequencyDistribution_Tests {
    
    func test_init_shouldSucceedWithOutcomesPerValue() {
        // TODO: SwiftCheck
        let outcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1, 2:1, 3:4, 4:1]
        
        let freqDist = FrequencyDistribution(outcomesPerValue)
        
        expect(freqDist.outcomesPerValue) == outcomesPerValue
    }
    
}

// MARK: - Equatable
extension FrequencyDistribution_Tests {
    
    // TODO: Equatable
    
}

// MARK: - Primitive Operations
extension FrequencyDistribution_Tests {
    
    func test_subscript() {
        // TODO: SwiftCheck
        let outcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let value = 3
        let expectedOutcome = outcomesPerValue[value]
        let freqDist = FrequencyDistribution(outcomesPerValue)
        
        let outcome = freqDist[value]
        
        expect(outcome) == expectedOutcome
    }
    
    func test_approximatelyEqual_shouldNotEqualForDifferentNumberOfValues() {
        let delta = 1e-16 // 64-bit. What about 32-bit?
        let outcome = 0.0
        let x = FrequencyDistribution([1: outcome])
        let y = FrequencyDistribution([1: outcome, 2: outcome])
        
        let areApproxEqual = x.approximatelyEqual(y, delta: delta)
        
        expect(areApproxEqual) == false
    }
    
    func test_approximatelyEqual_shouldEqualForSame() {
        let delta = 1e-16 // 64-bit. What about 32-bit?
        let xOutcome = 0.0
        let yOutcome = 0.0
        let x = FrequencyDistribution([1: xOutcome])
        let y = FrequencyDistribution([1: yOutcome])
        
        let areApproxEqual = x.approximatelyEqual(y, delta: delta)
        
        expect(areApproxEqual) == true
    }
    
    func test_approximatelyEqual_shouldEqualWithinDelta() {
        let delta = 1e-16 // 64-bit. What about 32-bit?
        let xOutcome = 0.0
        let yOutcome = 0.0 + delta - delta/10
        let x = FrequencyDistribution([1: xOutcome])
        let y = FrequencyDistribution([1: yOutcome])
        
        let areApproxEqual = x.approximatelyEqual(y, delta: delta)
        
        expect(areApproxEqual) == true
    }
    
    func test_approximatelyEqual_shouldNotEqualOutsideDelta() {
        let delta = 1e-16 // 64-bit. What about 32-bit?
        let xOutcome = 0.0
        let yOutcome = 0.0 + delta + delta/10
        let x = FrequencyDistribution([1: xOutcome])
        let y = FrequencyDistribution([1: yOutcome])
        
        let areApproxEqual = x.approximatelyEqual(y, delta: delta)
        
        expect(areApproxEqual) != true
    }
    
    func test_negateValues() {
        // TODO: SwiftCheck
        let outcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let expectedOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [-1:1.0, -2:1.0, -3:4.0, -4:1.0]
        let freqDist = FrequencyDistribution(outcomesPerValue)
        
        let negated = freqDist.negateValues()
        
        expect(negated.outcomesPerValue) == expectedOutcomesPerValue
    }
    
    func test_shiftValues() {
        // TODO: SwiftCheck
        let outcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let expectedOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [4:1.0, 5:1.0, 6:4.0, 7:1.0]
        let freqDist = FrequencyDistribution(outcomesPerValue)
        
        let shifted = freqDist.shiftValues(3)
        
        expect(shifted.outcomesPerValue) == expectedOutcomesPerValue
    }
    
    func test_scaleOutcomes() {
        // TODO: SwiftCheck
        let outcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let expectedOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.5, 2:1.5, 3:6.0, 4:1.5]
        let freqDist = FrequencyDistribution(outcomesPerValue)
        
        let scaled = freqDist.scaleOutcomes(1.5)
        
        expect(scaled.outcomesPerValue) == expectedOutcomesPerValue
    }
    
    func test_normalizeOutcomes() {
        // TODO: SwiftCheck
        let outcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let expectedOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.0/7.0, 2:1.0/7.0, 3:4.0/7.0, 4:1.0/7.0]
        let freqDist = FrequencyDistribution(outcomesPerValue)
        
        let normalized = freqDist.normalizeOutcomes()
        
        expect(normalized.outcomesPerValue) == expectedOutcomesPerValue
    }
    
}

// MARK: - Advanced Operations
extension FrequencyDistribution_Tests {
    
    func test_add() {
        // TODO: SwiftCheck
        let xOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let yOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [4:6.0, 7:1.0, 8:0.5, 22:3.0]
        let expectedOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:1.0, 2:1.0, 3:4.0, 4:7.0, 7:1.0, 8:0.5, 22:3.0]
        let x = FrequencyDistribution(xOutcomesPerValue)
        let y = FrequencyDistribution(yOutcomesPerValue)
        
        let z = x.add(y)
        
        expect(z.outcomesPerValue) == expectedOutcomesPerValue
    }
    
    func test_multiply() {
        // TODO: SwiftCheck
        /*
        1 2 6  *  2 3 7
        3 2 1     2 2 1
        
        =
        
        3 4 8  +  4 5 9  +  8 9 13
        6 6 3     4 4 2     2 2  1
        
        =
        
        3  4 5 8 9 13
        6 10 4 5 4  1
        */
        let xOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [1:3.0, 2:2.0, 6:1.0]
        let yOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [2:2.0, 3:2.0, 7:1.0]
        let zOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [3:6.0, 4:10.0, 5:4.0, 8:5.0, 9:4.0, 13:1.0]
        let x = FrequencyDistribution(xOutcomesPerValue)
        let y = FrequencyDistribution(yOutcomesPerValue)
        let expected = FrequencyDistribution(zOutcomesPerValue)
        
        let z = x.multiply(y)
        
        expect(z) == expected
    }
    
    func test_power_shouldReturnMultiplicativeIdentityFor0() {
        let outcomesPerValue: FrequencyDistribution.OutcomesPerValue = [2:2.0, 3:2.0, 6:1.0]
        let expected = FrequencyDistribution.multiplicativeIdentity
        let x = FrequencyDistribution(outcomesPerValue)
        
        let freqDist = x.power(0)
        
        expect(freqDist) == expected
    }
    
    func test_power_shouldReturnSelfFor1() {
        let outcomesPerValue: FrequencyDistribution.OutcomesPerValue = [2:2.0, 3:2.0, 6:1.0]
        let x = FrequencyDistribution(outcomesPerValue)
        let expected = x
        
        let freqDist = x.power(1)
        
        expect(freqDist) == expected
    }
    
    func test_power_shouldReturnCorrectlyForGreaterThan1() {
        // TODO: SwiftCheck
        let xOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [2:2.0, 3:2.0, 6:1.0]
        let power = 5
        let x = FrequencyDistribution(xOutcomesPerValue)
        let expected = (1..<power).reduce(x) {
            (acc, _) in acc.multiply(x)
        }
        
        let z = x.power(power)
        
        expect(z) == expected
    }
    
    // TODO: Test negative powers (when we know what that means)
    func todo_test_power_shouldReturnCorrectlyForLessThan0() {
    }
    
    func test_powerMultiply() {
        let xOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [2:2.0, 3:2.0, 6:1.0]
        let yOutcomesPerValue: FrequencyDistribution.OutcomesPerValue = [2:2.0, 3:2.0, 7:1.0]
        let x = FrequencyDistribution(xOutcomesPerValue)
        let y = FrequencyDistribution(yOutcomesPerValue)
        let expected = xOutcomesPerValue.reduce(FrequencyDistribution.additiveIdentity) {
            let (value, outcome) = $1
            let addend = y.power(value).normalizeOutcomes().scaleOutcomes(outcome)
            return $0.add(addend)
        }
        
        let z = x.power(y)
        
        expect(z) == expected
    }
    
}
