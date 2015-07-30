//
//  ProbabilisticExpressionType_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/26/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble

import DiceKit

class ProbabilisticExpressionType_Tests: XCTestCase {

}

// MARK: - Protocol Defaults

extension ProbabilisticExpressionType_Tests {
    
    struct MockProbabilisticExpression: ProbabilisticExpressionType {
        
        var probabilityMass: ProbabilityMass
        
    }
    
    func test_equivalent_shouldUseApproximatelyEqualForProbabilityMass() {
        let probability = 0.5
        let delta = ProbabilityMass.defaultProbabilityEqualityDelta
        let insideDeltaProbability = probability + delta/10
        let outsideDeltaProbability = probability + delta
        let x = MockProbabilisticExpression(probabilityMass: ProbabilityMass(FrequencyDistribution([1: probability, 2: 1.0-probability])))
        let insideDelta = MockProbabilisticExpression(probabilityMass: ProbabilityMass(FrequencyDistribution([1: insideDeltaProbability, 2: 1.0-insideDeltaProbability])))
        let outsideDelta = MockProbabilisticExpression(probabilityMass: ProbabilityMass(FrequencyDistribution([1: outsideDeltaProbability, 2: 1.0-outsideDeltaProbability])))
        let wrongNumberOfOutcomes = MockProbabilisticExpression(probabilityMass: ProbabilityMass(FrequencyDistribution([1: probability, 2: probability, 3: probability])))
        
        let correctlyInside = x.equivalent(insideDelta)
        let correctlyOutside = !x.equivalent(outsideDelta)
        let correctlyMismatch = !x.equivalent(wrongNumberOfOutcomes)
        
        expect(correctlyInside) == true
        expect(correctlyOutside) == true
        expect(correctlyMismatch) == true
    }
    
}
