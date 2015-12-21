//
//  Constant_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/8/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

class Constant_Tests: XCTestCase {
    
}

// MARK: - Initialization
extension Constant_Tests {
    
    func test_init() {
        property("init") <- forAll {
            (i: ExpressionResultValue) in
            
            let expectedValue = i
            
            let constant = Constant(expectedValue)
            
            return constant.value == expectedValue
        }
    }
    
    func test_init_shouldBeIntegerLiteralConvertible() {
        let expectedConstant = Constant(7)
        
        let constant: Constant = 7
        
        expect(expectedConstant) == constant
    }
    
}

// MARK: - Equatable
extension Constant_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (i: ExpressionResultValue) in
            
            return EquatableTestUtilities.checkReflexive { Constant(i) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (i: ExpressionResultValue) in
            
            return EquatableTestUtilities.checkSymmetric { Constant(i) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (i: ExpressionResultValue) in
            
            return EquatableTestUtilities.checkTransitive { Constant(i) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: ExpressionResultValue, b: ExpressionResultValue) in
            
            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { Constant(a) },
                    { Constant(b) }
                )
            }
        }
    }
    
}

// MARK: - ExpressionResultType
extension Constant_Tests {

    func test_resultValue() {
        property("resultValue") <- forAll {
            (x: ExpressionResultValue) in

            let result = Constant(x)
            let expectedValue = result.value

            let value = result.resultValue

            return value == expectedValue
        }
    }
    
}
