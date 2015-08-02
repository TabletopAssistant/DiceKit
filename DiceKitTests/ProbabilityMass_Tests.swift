//
//  ProbabilityMass_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `ProbabilityMass` type
class ProbabilityMass_Tests: XCTestCase {
    
    typealias SwiftCheckFrequencyDistribution = FrequencyDistributionOf<Int>
    
    let operationFixture1 = ProbabilityMass(FrequencyDistribution([1: 2.0, 4: 3.0, 11: 1.0]))
    let operationFixture2 = ProbabilityMass(FrequencyDistribution([1: 1.5, 2: 7.0]))
    let operationFixture3 = ProbabilityMass(FrequencyDistribution([1: 6]))

}

// MARK: - init() tests
extension ProbabilityMass_Tests {
    
    func test_init_shouldNormalizeFrequencyDistribution() {
        property("init with frequency distribution") <- forAll {
            (a: SwiftCheckFrequencyDistribution) in
            
            let a = a.getFrequencyDistribution
            
            let expectedFreqDist = a.normalizeFrequencies()
            
            let probMass = ProbabilityMass(a)
            
            return probMass.frequencyDistribution == expectedFreqDist
        }
    }
    
    func test_init_shouldWorkWithConstant() {
        property("init with constant") <- forAll {
            (a: Int) in
        
            let expectedFreqDist = FrequencyDistribution([a: 1.0])
            
            let probMass = ProbabilityMass(a)
            
            return probMass.frequencyDistribution == expectedFreqDist
        }
    }
    
}

// MARK: - Equatable
extension ProbabilityMass_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: SwiftCheckFrequencyDistribution) in
            
            let a = a.getFrequencyDistribution
            
            return EquatableTestUtilities.checkReflexive { ProbabilityMass(a) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: SwiftCheckFrequencyDistribution) in
            
            let a = a.getFrequencyDistribution
            
            return EquatableTestUtilities.checkSymmetric { ProbabilityMass(a) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: SwiftCheckFrequencyDistribution) in
            
            let a = a.getFrequencyDistribution
            
            return EquatableTestUtilities.checkTransitive { ProbabilityMass(a) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: SwiftCheckFrequencyDistribution, b: SwiftCheckFrequencyDistribution) in
            
            let a = a.getFrequencyDistribution
            let b = b.getFrequencyDistribution
            
            return !(a.normalizeFrequencies().approximatelyEqual(b.normalizeFrequencies(), delta: ProbabilityMassConfig.defaultProbabilityEqualityDelta) ) ==> {
                return EquatableTestUtilities.checkNotEquate(
                    { ProbabilityMass(a) },
                    { ProbabilityMass(b) }
                )
            }
        }
    }
    
}


// MARK: - Indexable
extension ProbabilityMass_Tests {
    
    func test_indexable_forIn() {
        // TODO: SwiftCheck
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1, 2:1, 3:4, 6:1]
        let expectedElements: [ProbabilityMass<Int>._Element] = [(1, 1/7), (2, 1/7), (3, 4/7), (6, 1/7)]
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        
        var elements: [ProbabilityMass<Int>._Element] = []
        for element in probMass {
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
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        let expectedStartIndex = probMass.startIndex
        
        let startIndex = probMass.indexForOutcome(1)
        let otherIndex = probMass.indexForOutcome(5)
        
        expect(startIndex) == expectedStartIndex
        expect(otherIndex).toNot(beNil())
    }
    
    func test_indexForOutcome_shouldReturnNilForInvalidOutcome() {
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [1:1, 2:1, 3:4, 5:1]
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        
        let index = probMass.indexForOutcome(77)
        
        expect(index).to(beNil())
    }
    
}

// MARK: - ApproximatelyEquatable
extension ProbabilityMass_Tests {
    
    func test_approximatelyEqualOperator_shouldUseDelta() {
        let delta = ProbabilityMassConfig.defaultProbabilityEqualityDelta
        let probability = 0.5
        let insideDeltaProbability = probability + delta/10
        let outsideDeltaProbability = probability + delta
        let x = ProbabilityMass(FrequencyDistribution([1: probability, 2: 1.0-probability]))
        let insideDelta = ProbabilityMass(FrequencyDistribution([1: insideDeltaProbability, 2: 1.0-insideDeltaProbability]))
        let outsideDelta = ProbabilityMass(FrequencyDistribution([1: outsideDeltaProbability, 2: 1.0-outsideDeltaProbability]))
        
        let correctlyInside = x ≈ insideDelta
        let correctlyOutside = !(x ≈ outsideDelta)
        
        expect(correctlyInside) == true
        expect(correctlyOutside) == true
    }
    
}

// MARK: - OutcomeWithSuccessfulnessType
extension ProbabilityMass_Tests {
    
    func test_subscript_outcomeWithSuccessfulness_shouldReturnDiscreteFrequencyForSuccessOrFail() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        let desiredOutcome = S(7, .Fail)
        let expectedFrequency = 2.0/11.0
        
        let probability = probMass[outcomeWithSuccessfulness: desiredOutcome]
        
        expect(probability) == expectedFrequency
    }
    
    func test_subscript_outcomeWithSuccessfulness_shouldReturnSummedFrequencyForUndetermined() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        let expectedProbability7 = 6.0/11.0
        let expectedProbability5 = 1.5/11.0
        let expectedProbability4 = 1.0/11.0
        
        let probability7 = probMass[outcomeWithSuccessfulness: S(7, .Undetermined)]
        let probability5 = probMass[outcomeWithSuccessfulness: S(5, .Undetermined)]
        let probability4 = probMass[outcomeWithSuccessfulness: S(4, .Undetermined)]
        
        expect(probability7) == expectedProbability7
        expect(probability5) == expectedProbability5
        expect(probability4) == expectedProbability4
    }
    
    func test_subscript_outcomeWithSuccessfulness_shouldReturnNilForInvalidOutcome() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        
        let probability = probMass[outcomeWithSuccessfulness: S(77, .Undetermined)]
        
        expect(probability).to(beNil())
    }
    
    func test_valuesWithoutSuccessfulness() {
        typealias S = OutcomeWithSuccessfulness
        
        let frequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Success): 3.0, S(7, .Fail): 2.0, S(7, .Undetermined): 1.0,
            S(6, .Undetermined): 2.5,
            S(5, .Fail): 1.5,
            S(4, .Success): 1.0,
        ]
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            7: 6.0,
            6: 2.5,
            5: 1.5,
            4: 1.0,
        ]
        let expectedProbabilityMass = ProbabilityMass(FrequencyDistribution(expectedFrequenciesPerOutcome))
        
        let valuesWithoutSuccessfulness = probMass.valuesWithoutSuccessfulness()
        
        expect(valuesWithoutSuccessfulness) == expectedProbabilityMass
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
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        let expectedFrequenciesPerOutcome: FrequencyDistribution<Successfulness>.FrequenciesPerOutcome = [
            .Success: 4.0,
            .Undetermined: 3.5,
            .Fail: 3.5,
        ]
        let expectedProbabilityMass = ProbabilityMass(FrequencyDistribution(expectedFrequenciesPerOutcome))
        
        let successfulnessWithoutValues = probMass.successfulnessWithoutValues()
        
        expect(successfulnessWithoutValues) == expectedProbabilityMass
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
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
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
        let expectedProbabilityMass = ProbabilityMass(FrequencyDistribution(expectedFrequenciesPerOutcome))
        
        let mappedSuccessfulness = probMass.mapSuccessfulness(map)
        
        expect(mappedSuccessfulness) == expectedProbabilityMass
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
        let probMass = ProbabilityMass(FrequencyDistribution(frequenciesPerOutcome))
        let compareProbMass = ProbabilityMass(FrequencyDistribution(compareFrequenciesPerOutcome))
        let comparison = { (lhs: S, rhs: S) in
            (lhs.outcome + rhs.outcome) % 2 == 0
        }
        let expectedFrequenciesPerOutcome: FrequencyDistribution.FrequenciesPerOutcome = [
            S(7, .Fail): 13.0, S(7, .Success): 1.5, S(7, .Undetermined): 0.5,
            S(6, .Fail): 1.25, S(6, .Undetermined): 5.0,
            S(5, .Fail): 3.75,
            S(4, .Success): 2.0, S(4, .Fail): 0.5,
        ]
        let expectedProbabilityMass = ProbabilityMass(FrequencyDistribution(expectedFrequenciesPerOutcome))
        
        let setSuccessfulness = probMass.setSuccessfulness(.Fail, comparedWith: compareProbMass, passingComparison: comparison)
        
        expect(setSuccessfulness ≈ expectedProbabilityMass) == true
    }
    
}

// MARK: - Operations
extension ProbabilityMass_Tests {
    
    func test_subscript() {
        let x = operationFixture2
        // TODO: Make these things enumerable
        let expectedProbabilities = x.frequencyDistribution.frequenciesPerOutcome.map {
            (outcome, frequency) in x.frequencyDistribution[outcome]!
        }
        
        let probabilities = x.frequencyDistribution.frequenciesPerOutcome.map {
            (outcome, frequency) in x[outcome]!
        }
        
        expect(probabilities) == expectedProbabilities
    }
    
    func test_negate_shouldNegateValuesOfFrequencyDistibution() {
        let x = operationFixture2
        let expectedFreqDist = x.frequencyDistribution.negateOutcomes().normalizeFrequencies()
        
        let probMass = x.negate()
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
    }
    
    func test_xor_shouldAddFrequencyDistributions() {
        let x = operationFixture1
        let y = operationFixture1
        let expectedFreqDist = x.frequencyDistribution.add(y.frequencyDistribution).normalizeFrequencies()
        
        let probMass = x.xor(y)
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
    }
    
    func test_and_shouldMultiplyFrequencyDistributions() {
        let x = operationFixture1
        let y = operationFixture1
        let expectedFreqDist = x.frequencyDistribution.multiply(y.frequencyDistribution).normalizeFrequencies()
        
        let probMass = x.and(y)
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
    }
    
    func test_not_shouldDivideFrequencyDistributions() {
        let x = operationFixture1
        let y = operationFixture2
        let z = x.and(y)
        
        let probMass = z.not(y)
        
        expect(probMass) == x
    }
    
    func test_product_shouldPowerFrequerncyDistributions() {
        let x = operationFixture1
        let y = operationFixture1
        let expectedFreqDist = x.frequencyDistribution.power(y.frequencyDistribution).normalizeFrequencies()
        
        let probMass = x.product(y)
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
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
    
}

// MARK: - Operators
extension ProbabilityMass_Tests {
    
    func test_negateOperator_callsNegate() {
        let x = operationFixture1
        let expectedProbMass = x.negate()
        
        let probMass = -x
        
        expect(probMass) == expectedProbMass
    }
    
    func test_xorOperator_callsXor() {
        let x = operationFixture1
        let y = operationFixture2
        let expectedProbMass = x.xor(y)
        
        let probMass = x ^^ y
        
        expect(probMass) == expectedProbMass
    }
    
    func test_andOperator_callsAnd() {
        let x = operationFixture1
        let y = operationFixture2
        let expectedProbMass = x.and(y)
        
        let probMass = x && y
        
        expect(probMass) == expectedProbMass
    }
    
    func test_notOperator_callsNot() {
        let x = operationFixture1
        let y = operationFixture2
        let expectedProbMass = x.not(y)
        
        let probMass = x !&& y
        
        expect(probMass) == expectedProbMass
    }
    
    func test_productOperator_callsProduct() {
        let x = operationFixture1
        let y = operationFixture2
        let expectedProbMass = x.product(y)
        
        let probMass = x * y
        
        expect(probMass) == expectedProbMass
    }
    
}
