//
//  FrequencyDistribution_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `FrequencyDistribution` type
class FrequencyDistribution_Tests: XCTestCase {
    
    typealias SwiftCheckFrequenciesPerOutcome = DictionaryOf<FrequencyDistribution<Int>.Outcome, FrequencyDistribution<Int>.Frequency>

}

// MARK: - init() tests
extension FrequencyDistribution_Tests {
    
    func test_init_shouldSucceedWithFrequenciesPerOutcome() {
        property("init") <- forAll {
            (a: SwiftCheckFrequenciesPerOutcome) in
            
            let a = a.getDictionary
            
            let freqDist = FrequencyDistribution(a)
            
            return freqDist.frequenciesPerOutcome == a
        }
    }
    
}

// MARK: - Equatable
extension FrequencyDistribution_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: SwiftCheckFrequenciesPerOutcome) in
            
            let a = a.getDictionary
            
            return EquatableTestUtilities.checkReflexive { FrequencyDistribution(a) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: SwiftCheckFrequenciesPerOutcome) in
            
            let a = a.getDictionary
            
            return EquatableTestUtilities.checkSymmetric { FrequencyDistribution(a) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: SwiftCheckFrequenciesPerOutcome) in
            
            let a = a.getDictionary
            
            return EquatableTestUtilities.checkTransitive { FrequencyDistribution(a) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: SwiftCheckFrequenciesPerOutcome, b: SwiftCheckFrequenciesPerOutcome) in
            
            let a = a.getDictionary
            let b = b.getDictionary
            
            return (a != b) ==> {
                return EquatableTestUtilities.checkNotEquate(
                    { FrequencyDistribution(a) },
                    { FrequencyDistribution(b) }
                )
            }
        }
    }
    
}

// MARK: - Indexable
extension FrequencyDistribution_Tests {
    
    func test_indexable_forIn() {
        // TODO: SwiftCheck
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1, 2:1, 3:4, 6:1]
        let expectedElements: [FrequencyDistribution<Int>._Element] = [(1, 1), (2, 1), (3, 4), (6, 1)]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        
        var elements: [FrequencyDistribution<Int>._Element] = []
        for element in freqDist {
            elements.append(element)
        }
        
        for (index, element) in elements.enumerate() {
            let expectedElement = expectedElements[index]
            expect(element.0) == expectedElement.0
            expect(element.1) == expectedElement.1
        }
    }
    
    func test_indexForOutcome_shouldReturnIndexForValidOutcome() {
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1, 2:1, 3:4, 5:1]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let expectedStartIndex = freqDist.startIndex

        let startIndex = freqDist.indexForOutcome(1)
        let otherIndex = freqDist.indexForOutcome(5)
        
        expect(startIndex) == expectedStartIndex
        expect(otherIndex).toNot(beNil())
    }
    
    func test_indexForOutcome_shouldReturnNilForInvalidOutcome() {
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1, 2:1, 3:4, 5:1]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        
        let index = freqDist.indexForOutcome(77)
        
        expect(index).to(beNil())
    }
    
}

// MARK: - Foundational Operations
extension FrequencyDistribution_Tests {
    
    func test_mapOutcomes() {
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            7: 3.0,
            6: 2.5,
            5: 1.5,
            4: 1.0,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            3: 5.5,
            2: 2.5,
        ] // /2
        
        let mappedOutcomes = freqDist.mapOutcomes { $0 / 2 }
        
        expect(mappedOutcomes.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_mapFrequencies() {
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            7: 3.0,
            6: 2.5,
            5: 1.5,
            4: 1.0,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            7: 6.0,
            6: 5.0,
            5: 3.0,
            4: 2.0,
        ] // *2
        
        let mappedFrequencies = freqDist.mapFrequencies { $0 * 2 }
        
        expect(mappedFrequencies.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
}

// MARK: - Primitive Operations
extension FrequencyDistribution_Tests {
    
    func test_subscript() {
        // TODO: SwiftCheck
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let value = 3
        let expectedOutcome = frequenciesPerOutcome[value]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        
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
    
    func test_negateOutcomes() {
        // TODO: SwiftCheck
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [-1:1.0, -2:1.0, -3:4.0, -4:1.0]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        
        let negated = freqDist.negateOutcomes()
        
        expect(negated.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_shiftValues() {
        // TODO: SwiftCheck
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [4:1.0, 5:1.0, 6:4.0, 7:1.0]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        
        let shifted = freqDist.shiftOutcomes(3)
        
        expect(shifted.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_scaleOutcomes() {
        // TODO: SwiftCheck
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.5, 2:1.5, 3:6.0, 4:1.5]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        
        let scaled = freqDist.scaleFrequencies(1.5)
        
        expect(scaled.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_normalizeFrequencies() {
        // TODO: SwiftCheck
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0/7.0, 2:1.0/7.0, 3:4.0/7.0, 4:1.0/7.0]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        
        let normalized = freqDist.normalizeFrequencies()
        
        expect(normalized.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_removeZeroes() {
        let delta: Double = ProbabilityMassConfig.probabilityEqualityDelta
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:0.0, 3:100.0, 4:(delta * 0.9)]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 3:100.0]
        
        let result = FrequencyDistribution(frequenciesPerOutcome).removeZeroes(delta)
        
        expect(result.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
}

// MARK: - Advanced Operations
extension FrequencyDistribution_Tests {
    
    func test_add() {
        // TODO: SwiftCheck
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [4:6.0, 7:1.0, 8:0.5, 22:3.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:1.0, 3:4.0, 4:7.0, 7:1.0, 8:0.5, 22:3.0]
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution(yFrequenciesPerOutcome)
        
        let z = x.add(y)
        
        expect(z.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_subtract() {
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:1.0, 3:4.0, 4:1.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [4:6.0, 7:1.0, 8:0.5, 22:3.0]
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution(yFrequenciesPerOutcome)
        let z = x.add(y)
        
        // x + y - y = x
        let result = z.subtract(y)
        
        expect(result.frequenciesPerOutcome) == x.frequenciesPerOutcome
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
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:3.0, 2:2.0, 6:1.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 7:1.0]
        let zFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [3:6.0, 4:10.0, 5:4.0, 8:5.0, 9:4.0, 13:1.0]
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution(yFrequenciesPerOutcome)
        let expected = FrequencyDistribution(zFrequenciesPerOutcome)
        
        let z = x.multiply(y)
        
        expect(z) == expected
    }
    
    func test_power_shouldReturnMultiplicativeIdentityFor0() {
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 6:1.0]
        let expected = FrequencyDistribution<Int>.multiplicativeIdentity
        let x = FrequencyDistribution(frequenciesPerOutcome)
        
        let freqDist = x.power(0)
        
        expect(freqDist) == expected
    }
    
    func test_power_shouldReturnSelfFor1() {
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 6:1.0]
        let x = FrequencyDistribution(frequenciesPerOutcome)
        let expected = x
        
        let freqDist = x.power(1)
        
        expect(freqDist) == expected
    }
    
    func test_power_shouldReturnCorrectlyForGreaterThan1() {
        // TODO: SwiftCheck
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 6:1.0]
        let power = 5
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
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
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 6:1.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 7:1.0]
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution(yFrequenciesPerOutcome)
        let expected = xFrequenciesPerOutcome.reduce(FrequencyDistribution<Int>.additiveIdentity) {
            let (outcome, frequency) = $1
            let addend = y.power(outcome).normalizeFrequencies().scaleFrequencies(frequency)
            return $0.add(addend)
        }
        
        let z = x.power(y)
        
        expect(z) == expected
    }
    
}
