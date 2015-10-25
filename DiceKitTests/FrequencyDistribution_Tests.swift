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
    
    let operationFixture1 = FrequencyDistribution([1: 2.0, 4: 3.0, 11: 1.0])
    let operationFixture2 = FrequencyDistribution([1: 1.5, 2: 7.0])
    let operationFixture3 = FrequencyDistribution([1: 6])

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
    
    func test_init_shouldFilterZeroFrequencies() {
        let inputFrequenciesPerOutcome = [1: 1.0, 2: 0.0, 3: 1.23]
        let expected = [1: 1.0, 3: 1.23]
        
        let result = FrequencyDistribution(inputFrequenciesPerOutcome).frequenciesPerOutcome
        
        expect(result) == expected
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

// MARK: - OutcomeWithSuccessfulnessType
extension FrequencyDistribution_Tests {
    
    func test_subscript_outcomeWithSuccessfulness_shouldReturnDiscreteFrequencyForSuccessOrFail() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let desiredOutcome = S(7, .Fail)
        let expectedFrequency = frequenciesPerOutcome[desiredOutcome]!
        
        let frequency = freqDist[outcomeWithSuccessfulness: desiredOutcome]
        
        expect(frequency) == expectedFrequency
    }
    
    func test_subscript_outcomeWithSuccessfulness_shouldReturnSummedFrequencyForUndetermined() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let expectedFrequency7 = 6.0
        let expectedFrequency5 = 1.5
        let expectedFrequency4 = 1.0
        
        let frequency7 = freqDist[outcomeWithSuccessfulness: S(7, .Undetermined)]
        let frequency5 = freqDist[outcomeWithSuccessfulness: S(5, .Undetermined)]
        let frequency4 = freqDist[outcomeWithSuccessfulness: S(4, .Undetermined)]
        
        expect(frequency7) == expectedFrequency7
        expect(frequency5) == expectedFrequency5
        expect(frequency4) == expectedFrequency4
    }
    
    func test_subscript_outcomeWithSuccessfulness_shouldReturnNilForInvalidOutcome() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        
        let frequency = freqDist[outcomeWithSuccessfulness: S(77, .Undetermined)]
        
        expect(frequency).to(beNil())
    }
    
    func test_valuesWithoutSuccessfulness() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            7: 6.0,
            6: 2.5,
            5: 1.5,
            4: 1.0,
        ]
        
        let valuesWithoutSuccessfulness = freqDist.valuesWithoutSuccessfulness()
        
        expect(valuesWithoutSuccessfulness.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_successfulnessWithoutValues() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0,
            S(7, .Fail): 2.0,
            S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let expectedFrequenciesPerOutcome: FrequencyDistribution<Successfulness>.FrequenciesPerOutcome = [
            .Success: 4.0,
            .Undetermined: 3.5,
            .Fail: 3.5,
        ]
        
        let successfulnessWithoutValues = freqDist.successfulnessWithoutValues()
        
        expect(successfulnessWithoutValues.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_mapSuccessfulness() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0,
            S(7, .Fail): 2.0,
            S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let map = { (outcome: S) -> Successfulness in
            // If odd outcome, then .Fail, otherwise .Success
            outcome.outcome % 2 == 1 ? .Fail : .Success
        }
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Fail): 6.0,
            S(6, .Success): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        
        let mappedSuccessfulness = freqDist.mapSuccessfulness(map)
        
        expect(mappedSuccessfulness.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_setSuccessfulness() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let compareFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(1, .Success): 2.0,
            S(2, .Fail): 0.5,
        ]
        let freqDist = FrequencyDistribution(frequenciesPerOutcome)
        let compareFreqDist = FrequencyDistribution(compareFrequenciesPerOutcome)
        let comparison = { (lhs: S, rhs: S) in
            (lhs.outcome + rhs.outcome) % 2 == 0
        }
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Fail): 13.0, S(7, .Success): 1.5, S(7, .Undetermined): 0.5,
            S(6, .Fail): 1.25, S(6, .Undetermined): 5.0,
            S(5, .Fail): 3.75,
            S(4, .Success): 2.0, S(4, .Fail): 0.5,
        ]
        
        let setSuccessfulness = freqDist.setSuccessfulness(.Fail, comparedWith: compareFreqDist, passingComparison: comparison)
        
        expect(setSuccessfulness.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
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
        let delta = 2e-15 // 64-bit. What about 32-bit?
        let outcome = 1.0
        let x = FrequencyDistribution([1: outcome])
        let y = FrequencyDistribution([1: outcome, 2: outcome])
        
        let areApproxEqual = x.approximatelyEqual(y, delta: delta)
        
        expect(areApproxEqual) == false
    }
    
    func test_approximatelyEqual_shouldEqualForSame() {
        let delta = 2e-15 // 64-bit. What about 32-bit?
        let xOutcome = 1.0
        let yOutcome = 1.0
        let x = FrequencyDistribution([1: xOutcome])
        let y = FrequencyDistribution([1: yOutcome])
        
        let areApproxEqual = x.approximatelyEqual(y, delta: delta)
        
        expect(areApproxEqual) == true
    }
    
    func test_approximatelyEqual_shouldEqualWithinDelta() {
        let delta = 2e-15 // 64-bit. What about 32-bit?
        let xOutcome = 1.0
        let yOutcome = 1.0 + delta - delta/10
        let x = FrequencyDistribution([1: xOutcome])
        let y = FrequencyDistribution([1: yOutcome])
        
        let areApproxEqual = x.approximatelyEqual(y, delta: delta)
        
        expect(areApproxEqual) == true
    }
    
    func test_approximatelyEqual_shouldNotEqualOutsideDelta() {
        let delta = 2e-15 // 64-bit. What about 32-bit?
        let xOutcome = 1.0
        let yOutcome = 1.0 + delta + delta/10
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
    
    func test_minimumOutcome_shouldReturnMinimumOutcomeWithOutcomes() {
        let x = operationFixture1
        let expectedMinimumOutcome = 1
        
        let min = x.minimumOutcome()
        
        expect(min) == expectedMinimumOutcome
    }
    
    func test_maximumOutcome_shouldReturnMaximumOutcomeWithOutcomes() {
        let x = operationFixture1
        let expectedMaximumOutcome = 11
        
        let max = x.maximumOutcome()
        
        expect(max) == expectedMaximumOutcome
    }
    
    func test_singleOutcomeDistribution_shouldHaveEqualMinimumMaximumOutcomes() {
        let x = operationFixture3
        
        let min = x.minimumOutcome()
        let max = x.maximumOutcome()
        
        expect(min) == max
    }
    
    func test_filterZeroFrequencies() {
        let delta: Double = ProbabilityMassConfig.probabilityEqualityDelta
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 2:0.0, 3:100.0, 4:(delta * 0.9), 5: -42.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1.0, 3:100.0, 5: -42.0]
        
        let result = FrequencyDistribution(frequenciesPerOutcome).filterZeroFrequencies(delta)
        
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
    
    func test_addSuccessfulness() {
        /*
        S F  +    U F
        1 4     0.5 1
        
        S   U F
        1 0.5 5
        */
        typealias S = Successfulness
        
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 1.0, S.Fail: 4.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Undetermined: 0.5, S.Fail: 1.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 1.0, S.Undetermined: 0.5, S.Fail: 5.0]
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

    func test_subtractSuccessfulness() {
        // Successfulness is different from normal types. So subtraction isn't always the opposite of addition.
        // This is because 1 + 1 = 1, and reversing that, 1 - 1 = 0, not 1.
        /*
        S F  -    U F
        1 4     0.5 1

        S   U  F
        1 -0.5 3
        */
        typealias S = Successfulness

        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 1.0, S.Fail: 4.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Undetermined: 0.5, S.Fail: 1.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 1.0, S.Undetermined: -0.5, S.Fail: 3.0]
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution(yFrequenciesPerOutcome)

        let z = x.subtract(y)

        expect(z.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
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
    
    func test_multiplySuccessfulness() {
        /*
        S F  *    S F
        1 4     0.5 1
        
          S U F
        0.5 3 4
        */
        typealias S = Successfulness
        
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 1.0, S.Fail: 4.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 0.5, S.Fail: 1.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 0.5, S.Undetermined: 3.0, S.Fail: 4.0]
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution(yFrequenciesPerOutcome)
        let expected = FrequencyDistribution(expectedFrequenciesPerOutcome)
        
        let z = x.multiply(y)
        
        expect(z) == expected
    }
    
    func test_multiply_shouldNotChangeWithMultiplicativeIdentity() {
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1: 1.0, 2: 4.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = xFrequenciesPerOutcome
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution<Int>.multiplicativeIdentity
        
        let z = x.multiply(y)
        
        expect(z.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_multiplySuccessfulness_shouldNotChangeWithMultiplicativeIdentity() {
        typealias S = Successfulness
        
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 1.0, S.Fail: 4.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = xFrequenciesPerOutcome
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution<S>.multiplicativeIdentity
        
        let z = x.multiply(y)
        
        expect(z.frequenciesPerOutcome) == expectedFrequenciesPerOutcome
    }
    
    func test_divide() {
        //Does the reverse of multiply
        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:3.0, 2:2.0, 6:1.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 7:1.0]
        let zFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [3:6.0, 4:10.0, 5:4.0, 8:5.0, 9:4.0, 13:1.0]
        let z = FrequencyDistribution(zFrequenciesPerOutcome)
        let y = FrequencyDistribution(yFrequenciesPerOutcome)
        let expected = FrequencyDistribution(xFrequenciesPerOutcome)
        
        let x = z.divide(y)
        
        expect(x) == expected
    }

    func test_divideSuccessfulness() {
        // Successfulness is different from normal types. So division isn't always the opposite of multiplication.
        // This is because 1 + 1 = 1, and reversing that, 1 - 1 = 0, not 1.
        /*
        S F  /    S F
        1 4     0.5 1

         S U F
        -1 3 4
        */
        typealias S = Successfulness

        let xFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 1.0, S.Fail: 4.0]
        let yFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: 0.5, S.Fail: 1.0]
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [S.Success: -1.0, S.Undetermined: 4.0]
        let x = FrequencyDistribution(xFrequenciesPerOutcome)
        let y = FrequencyDistribution(yFrequenciesPerOutcome)
        let expected = FrequencyDistribution(expectedFrequenciesPerOutcome)

        let z = x.divide(y)

        expect(z) == expected
    }

    func test_power_shouldReturnMultiplicativeIdentityFor0() {
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 6:1.0]
        let expected = FrequencyDistribution<Int>.multiplicativeIdentity
        let x = FrequencyDistribution(frequenciesPerOutcome)
        
        let freqDist = x.power(0)
        
        expect(freqDist) == expected
    }
    
    func test_power_shouldReturnSelfForMultiplicativeIdentity() {
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [2:2.0, 3:2.0, 6:1.0]
        let x = FrequencyDistribution(frequenciesPerOutcome)
        let expected = x
        
        let freqDist = x.power(Int.multiplicativeIdentity)
        
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
