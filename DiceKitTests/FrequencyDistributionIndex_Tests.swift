//
//  FrequencyDistributionIndex_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/2/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

@testable import DiceKit

/// Tests the `FrequencyDistributionIndex` type
class FrequencyDistributionIndex_Tests: XCTestCase {
    
    typealias SwiftCheckOrderedOutcome = SetOf<FrequencyDistribution.Outcome>
    
}

// MARK: - init() tests
extension FrequencyDistributionIndex_Tests {
    
    func test_init_shouldSucceed() {
        property("init") <- forAll {
            (a: SwiftCheckOrderedOutcome) in
            
            let a = a.getSet
            
            let expectedIndex = Int(arc4random_uniform(UInt32(a.count)))
            let expectedOrderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes(a)
            
            let freqDistIndex = FrequencyDistributionIndex(index: expectedIndex, orderedOutcomes: expectedOrderedOutcomes)
            
            let testIndex = freqDistIndex.index == expectedIndex
            let testOrderedOutcomes = freqDistIndex.orderedOutcomes == expectedOrderedOutcomes
            
            return testIndex && testOrderedOutcomes
        }
    }
    
}

// MARK: - Equatable
extension FrequencyDistributionIndex_Tests {
    
    // TODO: Equatable
    
}

// MARK: - ForwardIndexType
extension FrequencyDistributionIndex_Tests {
    
    func test_startIndex_shouldBeSetupCorrectly() {
        property("startIndex") <- forAll {
            (a: SetOf<FrequencyDistribution.Outcome>) in
            
            let a = a.getSet
            
            let expectedIndex = 0
            let expectedOrderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes(a)
            
            let startIndex = FrequencyDistributionIndex.startIndex(expectedOrderedOutcomes)
            
            let testIndex = startIndex.index == expectedIndex
            let testOrderedOutcomes = startIndex.orderedOutcomes == expectedOrderedOutcomes
            
            return testIndex && testOrderedOutcomes
        }
    }
    
    func test_endIndex_shouldBeSetupCorrectly() {
        property("endIndex") <- forAll {
            (a: SetOf<FrequencyDistribution.Outcome>) in
            
            let a = a.getSet
            
            let expectedOrderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes(a)
            let expectedIndex = expectedOrderedOutcomes.count
        
            let endIndex = FrequencyDistributionIndex.endIndex(expectedOrderedOutcomes)
            
            let testIndex = endIndex.index == expectedIndex
            let testOrderedOutcomes = endIndex.orderedOutcomes == expectedOrderedOutcomes
            
            return testIndex && testOrderedOutcomes
        }
    }
    
    func test_value_shouldReturnValueForValidIndex() {
        property("value with valid index") <- forAll {
            (a: SetOf<FrequencyDistribution.Outcome>) in
            
            let a = a.getSet
            
            return (a.count > 0) ==> {
                let index = Int(arc4random_uniform(UInt32(a.count)))
                let orderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes(a)
                let freqDistIndex = FrequencyDistributionIndex(index: index, orderedOutcomes: orderedOutcomes)
                let expectedValue = orderedOutcomes[index]
                
                let value = freqDistIndex.value
                
                return value == expectedValue
            }
        }
    }
    
    func test_value_shouldReturnNilForInvalidIndex() {
        property("value with invalid index") <- forAll {
            (a: SetOf<FrequencyDistribution.Outcome>) in
            
            let a = a.getSet
            
            let orderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes(a)
            let index = orderedOutcomes.count
            let freqDistIndex = FrequencyDistributionIndex(index: index, orderedOutcomes: orderedOutcomes)
            
            let value = freqDistIndex.value
        
            return value == nil
        }
    }
    
    func test_successor_shouldReturnValidIndexWhenMoreRemain() {
        let index = 0
        let orderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes([3, 6])
        let freqDistIndex = FrequencyDistributionIndex(index: index, orderedOutcomes: orderedOutcomes)
        let expectedFreqDistIndex = FrequencyDistributionIndex(index: index + 1, orderedOutcomes: orderedOutcomes)
        
        let successor = freqDistIndex.successor()
        
        expect(successor) == expectedFreqDistIndex
    }
    
    func test_successor_shouldReturnEndIndexWhenNoMoreRemain() {
        let index = 1
        let orderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes([3, 6])
        let freqDistIndex = FrequencyDistributionIndex(index: index, orderedOutcomes: orderedOutcomes)
        let expectedFreqDistIndex = FrequencyDistributionIndex.endIndex(orderedOutcomes)
        
        let successor = freqDistIndex.successor()
        
        expect(successor) == expectedFreqDistIndex
    }
    
    func test_successor_shouldReturnEndIndexWhenAtEndIndex() {
        let orderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes([3, 6])
        let freqDistIndex = FrequencyDistributionIndex.endIndex(orderedOutcomes)
        let expectedFreqDistIndex = FrequencyDistributionIndex.endIndex(orderedOutcomes)
        
        let successor = freqDistIndex.successor()
        
        expect(successor) == expectedFreqDistIndex
    }
    
}
