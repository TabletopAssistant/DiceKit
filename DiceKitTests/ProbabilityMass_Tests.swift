//
//  ProbabilityMass_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble

import DiceKit

/// Tests the `ProbabilityMass` type
class ProbabilityMass_Tests: XCTestCase {
    
    let operationFixture1 = ProbabilityMass(FrequencyDistribution([1: 2.0, 4: 3.0, 11: 1.0]))
    let operationFixture2 = ProbabilityMass(FrequencyDistribution([1: 1.5, 2: 7.0]))

}

// MARK: - init() tests
extension ProbabilityMass_Tests {
    
    func test_init_shouldNormalizeFrequencyDistribution() {
        let freqDist = FrequencyDistribution([1: 1.0, 2: 6.0, 6: 3.0])
        let expectedFreqDist = freqDist.normalizeOutcomes()
        
        let probMass = ProbabilityMass(freqDist)
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
    }
    
    func test_init_shouldWorkWithConstant() {
        let constant = 8
        let expectedFreqDist = FrequencyDistribution([constant: 1.0])
        
        let probMass = ProbabilityMass(constant)
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
    }
    
}

// MARK: - Equatable
extension ProbabilityMass_Tests {
    
    // TODO: Equatable
    
}

// MARK: - ApproximatelyEquatable
extension ProbabilityMass_Tests {
    
    func test_approximatelyEqualOperator_shouldUseDelta() {
        let delta = ProbabilityMass.defaultProbabilityEqualityDelta
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
        let expectedProbabilities = x.frequencyDistribution.outcomesPerValue.map {
            (value, outcome) in x.frequencyDistribution[value]!
        }
        
        let probabilities = x.frequencyDistribution.outcomesPerValue.map {
            (value, outcome) in x[value]!
        }
        
        expect(probabilities) == expectedProbabilities
    }
    
    func test_negate_shouldNegateValuesOfFrequencyDistibution() {
        let x = operationFixture2
        let expectedFreqDist = x.frequencyDistribution.negateValues().normalizeOutcomes()
        
        let probMass = x.negate()
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
    }
    
    func test_xor_shouldAddFrequencyDistributions() {
        let x = operationFixture1
        let y = operationFixture1
        let expectedFreqDist = x.frequencyDistribution.add(y.frequencyDistribution).normalizeOutcomes()
        
        let probMass = x.xor(y)
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
    }
    
    func test_and_shouldMultiplyFrequencyDistributions() {
        let x = operationFixture1
        let y = operationFixture1
        let expectedFreqDist = x.frequencyDistribution.multiply(y.frequencyDistribution).normalizeOutcomes()
        
        let probMass = x.and(y)
        
        expect(probMass.frequencyDistribution) == expectedFreqDist
    }
    
    func test_product_shouldPowerFrequerncyDistributions() {
        let x = operationFixture1
        let y = operationFixture1
        let expectedFreqDist = x.frequencyDistribution.power(y.frequencyDistribution).normalizeOutcomes()
        
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
    
    func test_productOperator_callsProduct() {
        let x = operationFixture1
        let y = operationFixture2
        let expectedProbMass = x.product(y)
        
        let probMass = x * y
        
        expect(probMass) == expectedProbMass
    }
    
}
