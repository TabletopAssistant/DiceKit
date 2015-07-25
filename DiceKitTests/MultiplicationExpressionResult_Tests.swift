//
//  MultiplicationExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `MultiplicationExpressionResult` type
class MultiplicationExpressionResult_Tests: XCTestCase {
    
}

// MARK: - Equatable
extension MultiplicationExpressionResult_Tests {
    
    func equatableFixture(a: UInt, _ b: UInt) -> (multiplierResult: Int, multiplicandResults: [Int]) {
        let multiplierResult = Int(a % 101)
        let multiplicandRange = UInt32(b % 101)
        let multiplicandResults = (0..<multiplierResult).map { _ in Int(arc4random_uniform(multiplicandRange)) }
        
        return (multiplierResult, multiplicandResults)
    }
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (a: UInt, b: UInt) in
            
            let fixture = self.equatableFixture(a, b)
            
            let x = MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            
            return x == x
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (a: UInt, b: UInt) in
            
            let fixture = self.equatableFixture(a, b)
            
            let x = MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            let y = MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            
            return x == y && y == x
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (a: UInt, b: UInt) in
            
            let fixture = self.equatableFixture(a, b)
            
            let x = MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            let y = MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            let z = MultiplicationExpressionResult(multiplierResult: fixture.multiplierResult, multiplicandResults: fixture.multiplicandResults)
            
            return x == y && y == z && x == z
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: UInt, b: UInt, c: UInt, d: UInt) in
            
            guard a != c else { return true }
            
            let xFixture = self.equatableFixture(a, b)
            let yFixture = self.equatableFixture(c, d)
            
            let x = MultiplicationExpressionResult(multiplierResult: xFixture.multiplierResult, multiplicandResults: xFixture.multiplicandResults)
            let y = MultiplicationExpressionResult(multiplierResult: yFixture.multiplierResult, multiplicandResults: yFixture.multiplicandResults)
            
            return x != y
        }
    }
    
}

// MARK: - ExpressionResultType
extension MultiplicationExpressionResult_Tests {
    
    // TODO: Make this a SwiftCheck test
    func test_value_shouldSumTheMultiplicandResultsForPositiveMultiplier() {
        let multiplierResult = Int(arc4random_uniform(11)) // 0...10
        let multiplicandCount = abs(multiplierResult)
        let multiplicandResults = (0..<multiplicandCount).map { _ in Int(arc4random_uniform(100)) + 1 }
        let expectedValue = multiplicandResults.reduce(0, combine: +)
        let result = MultiplicationExpressionResult(multiplierResult: multiplierResult, multiplicandResults: multiplicandResults)
        
        let value = result.value
        
        expect(value) == expectedValue
    }
    
    // TODO: Make this a SwiftCheck test
    func test_value_shouldNegateTheMultiplicandResultsForNegativeMultiplier() {
        let multiplierResult = -Int(arc4random_uniform(10)) - 1 // -1...10
        let multiplicandCount = abs(multiplierResult)
        let multiplicandResults = (0..<multiplicandCount).map { _ in Int(arc4random_uniform(100)) + 1 }
        let expectedValue = multiplicandResults.reduce(0, combine: -)
        let result = MultiplicationExpressionResult(multiplierResult: multiplierResult, multiplicandResults: multiplicandResults)
        
        let value = result.value
        
        expect(value) == expectedValue
    }
    
}
