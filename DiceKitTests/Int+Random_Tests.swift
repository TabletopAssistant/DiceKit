//
//  Int+Random_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/13/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

@testable import DiceKit

// TODO: Use generics to consolidate the tests
class Int_Random_Tests: XCTestCase {
    
    func test_UInt64_randomExtremes() {
        _ = UInt64.random(lower: UInt64.min, upper: UInt64.max)
    }
    
    func test_UInt64_randomModuloBiasCoverage() {
        for _ in 0..<50 {
            _ = UInt64.random(lower: UInt64.max/2, upper: UInt64.max)
        }
        for _ in 0..<50 {
            _ = UInt64.random(lower: UInt64.min, upper: UInt64.max/2)
        }
    }
    
    func test_UInt64_random() {
        property("random(lower:upper:) generates values for all valid inputs") <- forAll {
            (a: UInt64, b: UInt64) in
            
            guard a != b else { return true }
            
            let lower = min(a, b)
            let upper = max(a, b)
            _ = UInt64.random(lower: lower, upper: upper)
            
            return true
        }
    }
    
    func test_Int64_randomExtremes() {
        _ = Int64.random(lower: Int64.min, upper: Int64.max)
    }
    
    func test_Int64_random() {
        property("random(lower:upper:) generates values for all valid inputs") <- forAll {
            (a: Int64, b: Int64) in
            
            guard a != b else { return true }
            
            let lower = min(a, b)
            let upper = max(a, b)
            _ = Int64.random(lower: lower, upper: upper)
            
            return true
        }
    }
    
    func test_UInt32_randomExtremes() {
        _ = UInt32.random(lower: UInt32.min, upper: UInt32.max)
    }
    
    func test_UInt32_random() {
        property("random(lower:upper:) generates values for all valid inputs") <- forAll {
            (a: UInt32, b: UInt32) in
            
            guard a != b else { return true }
            
            let lower = min(a, b)
            let upper = max(a, b)
            _ = UInt32.random(lower: lower, upper: upper)
            
            return true
        }
    }
    
    func test_Int32_randomExtremes() {
        _ = Int32.random(lower: Int32.min, upper: Int32.max)
    }
    
    func test_Int32_random() {
        property("random(lower:upper:) generates values for all valid inputs") <- forAll {
            (a: Int32, b: Int32) in
            
            guard a != b else { return true }
            
            let lower = min(a, b)
            let upper = max(a, b)
            _ = Int32.random(lower: lower, upper: upper)
            
            return true
        }
    }
    
    func test_UInt_randomExtremes() {
        _ = UInt.random(lower: UInt.min, upper: UInt.max)
    }
    
    func test_UInt_random() {
        property("random(lower:upper:) generates values for all valid inputs") <- forAll {
            (a: UInt, b: UInt) in
            
            guard a != b else { return true }
            
            let lower = min(a, b)
            let upper = max(a, b)
            _ = UInt.random(lower: lower, upper: upper)
            
            return true
        }
    }
    
    func test_Int_randomExtremes() {
        _ = Int.random(lower: Int.min, upper: Int.max)
    }
    
    func test_Int_random() {
        property("random(lower:upper:) generates values for all valid inputs") <- forAll {
            (a: Int, b: Int) in
            
            guard a != b else { return true }
            
            let lower = min(a, b)
            let upper = max(a, b)
            _ = Int.random(lower: lower, upper: upper)
            
            return true
        }
    }
    
}
