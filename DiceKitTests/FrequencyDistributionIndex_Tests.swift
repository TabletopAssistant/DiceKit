//
//  FrequencyDistributionIndex_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/2/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble

@testable import DiceKit

/// Tests the `FrequencyDistributionIndex` type
class FrequencyDistributionIndex_Tests: XCTestCase {
    
}

// MARK: - init() tests
extension FrequencyDistributionIndex_Tests {
    
    func test_init_shouldSucceed() {
        // TODO: SwiftCheck
        let expectedIndex = 3
        let expectedOrderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes([3, 6, 8, 9, 11, 12, 45])
        
        let freqDistIndex = FrequencyDistributionIndex(index: expectedIndex, orderedOutcomes: expectedOrderedOutcomes)
        
        expect(freqDistIndex.index) == expectedIndex
        expect(freqDistIndex.orderedOutcomes) == expectedOrderedOutcomes
    }
    
}

// MARK: - Equatable
extension FrequencyDistributionIndex_Tests {
    
    // TODO: Equatable
    
}

// MARK: - ForwardIndexType
extension FrequencyDistributionIndex_Tests {
    
    func test_startIndex_shouldBeSetupCorrectly() {
        // TODO: SwiftCheck
        let expectedIndex = 0
        let expectedOrderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes([4, 6, 8, 10, 11, 12, 33, 43])
        
        let startIndex = FrequencyDistributionIndex.startIndex(expectedOrderedOutcomes)
        
        expect(startIndex.index) == expectedIndex
        expect(startIndex.orderedOutcomes) == expectedOrderedOutcomes
    }
    
    func test_endIndex_shouldBeSetupCorrectly() {
        // TODO: SwiftCheck
        let expectedOrderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes([4, 6, 8, 10, 11, 14, 34])
        let expectedIndex = expectedOrderedOutcomes.count
        
        let endIndex = FrequencyDistributionIndex.endIndex(expectedOrderedOutcomes)
        
        expect(endIndex.index) == expectedIndex
        expect(endIndex.orderedOutcomes) == expectedOrderedOutcomes
    }
    
    func test_value_shouldReturnValueForValidIndex() {
        // TODO: SwiftCheck
        let index = 2
        let orderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes([3, 6, 8, 9, 11, 12, 45])
        let freqDistIndex = FrequencyDistributionIndex(index: index, orderedOutcomes: orderedOutcomes)
        let expectedValue = orderedOutcomes[index]
        
        let value = freqDistIndex.value
        
        expect(value) == expectedValue
    }
    
    func test_value_shouldReturnNilForInvalidIndex() {
        // TODO: SwiftCheck
        let orderedOutcomes = FrequencyDistributionIndex.OrderedOutcomes([3, 6, 8, 9, 11, 12, 45])
        let index = orderedOutcomes.count
        let freqDistIndex = FrequencyDistributionIndex(index: index, orderedOutcomes: orderedOutcomes)
        
        let value = freqDistIndex.value
        
        expect(value).to(beNil())
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
