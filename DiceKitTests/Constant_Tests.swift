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
            (i: Int) in
            
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
            (i: Int) in
            
            return EquatableTestUtilities.checkReflexive { Constant(i) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (i: Int) in
            
            return EquatableTestUtilities.checkSymmetric { Constant(i) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (i: Int) in
            
            return EquatableTestUtilities.checkTransitive { Constant(i) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (a: Int, b: Int) in
            
            return (a != b) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { Constant(a) },
                    { Constant(b) }
                )
            }
        }
    }
    
//    func test_equatable() {
//        property("equtatable") <- forAll {
//            (a: Int, b: Int) in
//            
//            let reflexive = EquatableTestUtilities.checkReflexive { Constant(a) } <?> "reflexive"
//            let symmetric = EquatableTestUtilities.checkSymmetric { Constant(a) } <?> "symmetric"
//            let transitive = EquatableTestUtilities.checkTransitive { Constant(a) } <?> "transitive"
//            let notEquate = (a != b) ==> {
//                EquatableTestUtilities.checkNotEquate(
//                    { Constant(a) },
//                    { arc4random() % 2 == 1 ? Constant(b) : Constant(a) }
//                )
//            }() <?> "not-equate"
//            
//            return reflexive.whenFail { print("reflexive fail") } ^&&^ symmetric.whenFail { print("symmetric fail") } ^&&^ transitive.whenFail { print("transitive fail") } ^&&^ notEquate.withCallback(Callback.AfterFinalFailure(kind: .NotCounterexample, f: { (st, res) in
//                print(res.stamp)
//            }))
//        }
//    }
    
}

// MARK: - ExpressionResultType
extension Constant_Tests {
    
    func test_successfulness_shouldBeUndetermined() {
        let constant = c(84)
        
        expect(constant.successfulness) == Successfulness.Undetermined
    }
    
}
