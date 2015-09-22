//
//  Dictionary+Functions_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble

@testable import DiceKit

class Dictionary_Functions_Tests: XCTestCase {

    func test_mapValues() {
        let original = [1: 6, 2: 4, 7: 9,  64: 5]
        let expected = [1: 8, 2: 6, 7: 11, 64: 7] // +2
        
        let mappedValues = original.mapValues {
            (key, value) in value + 2
        }
        
        expect(mappedValues) == expected
    }
    
    func test_mapKeys() {
        let original = [ 1: 6,  2: 4, 7: 9, 64: 5]
        let expected = [-2: 6, -1: 4, 4: 9, 61: 5] // -3
        
        let mappedKeys = original.mapKeys {
            (key, value) in key - 3
        }
        
        expect(mappedKeys) == expected
    }
    
    func test_mapKeysWithConflictResolution() {
        let original = [2: 6, 3: 4, 7: 9, 64: 5]
        let expected = [1: 10, 3: 9, 32: 5] // /2
        
        let mappedValues = original.mapKeys ({ $1 + $2}) {
            (key, value) in key / 2
        }
        
        expect(mappedValues) == expected
    }
    
    func test_map() {
        let original = [1: 6, 2:  4, 7: 9, 64: 5]
        let expected = [2: 1, 3: -1, 8: 4, 65: 0] // +1 keys, -5 values
        
        let mapped = original.map {
            (key, value) in (key + 1, value - 5)
        }
        
        expect(mapped) == expected
    }
    
    func test_mapWithConflictResolution() {
        let original = [2: 6, 3: 4, 7: 9, 64: 5]
        let expected = [1: 0, 3: 4, 32: 0] // /2 keys, -5 values
        
        let mapped = original.map ({ $1 + $2 }) {
            (key, value) in (key/2, value - 5)
        }
        
        expect(mapped) == expected
    }

    func test_filterValues() {
        let original = [1: 10, 2: -4, 3: 99, 4: -200]
        let expected = [1: 10, 3: 99]
        
        let filtered = original.filterValues { $0 > 5 }
        
        expect(filtered) == expected
    }
    
    func test_filterKeys() {
        let original = [-2: 24, -1: -9, 0: 42, 1: 9000, 2: -10]
        let expected = [-2: 24, -1: -9]
        
        let filtered = original.filterKeys {$0 < 0}
        
        expect(filtered) == expected
    }
    
    func test_filterDict() {
        let original = [-2: 20, -1: 10, 0: 42, 1: 612, 2: -666]
        let expected = [-2: 20, 1: 612]
        
        let filtered = original.filter {$0 == -2 || $1 == 612}
        
        expect(filtered) == expected
    }
}
