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
