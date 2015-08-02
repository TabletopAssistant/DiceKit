//
//  OutcomeWithSuccessfulness_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/8/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

class OutcomeWithSuccessfulness_Tests: XCTestCase {
    
}

// MARK: - Initialization
extension OutcomeWithSuccessfulness_Tests {
    
    func test_init() {
        let expectedOutcome = 57
        let expectedSuccessfulness = Successfulness.Fail
        
        let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(expectedOutcome, expectedSuccessfulness)
        
        expect(outcomeWithSuccessfulness.outcome) == expectedOutcome
        expect(outcomeWithSuccessfulness.successfulness) == expectedSuccessfulness
    }
    
    func test_init_shouldDefaultSuccessfulnessToUndecided() {
        let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(57)
        
        expect(outcomeWithSuccessfulness.successfulness) == Successfulness.Undetermined
    }
    
    func test_init_shouldBeIntegerLiteralConvertible() {
        let zeroLiteral: OutcomeWithSuccessfulness = 0
        let otherLiteral: OutcomeWithSuccessfulness = 564
        
        expect(zeroLiteral) == OutcomeWithSuccessfulness(0)
        expect(otherLiteral) == OutcomeWithSuccessfulness(564)
    }
    
}

// MARK: - Equatable
extension OutcomeWithSuccessfulness_Tests {
    
    func test_shouldBeReflexive() {
        property("reflexive") <- forAll {
            (i: Int, s: Successfulness) in
            
            return EquatableTestUtilities.checkReflexive { OutcomeWithSuccessfulness(i, s) }
        }
    }
    
    func test_shouldBeSymmetric() {
        property("symmetric") <- forAll {
            (i: Int, s: Successfulness) in
            
            return EquatableTestUtilities.checkSymmetric { OutcomeWithSuccessfulness(i, s) }
        }
    }
    
    func test_shouldBeTransitive() {
        property("transitive") <- forAll {
            (i: Int, s: Successfulness) in
            
            return EquatableTestUtilities.checkTransitive { OutcomeWithSuccessfulness(i, s) }
        }
    }
    
    func test_shouldBeAbleToNotEquate() {
        property("non-equal") <- forAll {
            (i: Int, j: Int, s1: Successfulness, s2: Successfulness) in
            
            return (i != j && s1 != s2) ==> {
                EquatableTestUtilities.checkNotEquate(
                    { OutcomeWithSuccessfulness(i, s1) },
                    { OutcomeWithSuccessfulness(j, s2) }
                )
            }
        }
    }
    
}

// MARK: - CustomPlaygroundQuickLookable
extension OutcomeWithSuccessfulness_Tests {
    
    func test_customPlaygroundQuickLook() {
        let s = OutcomeWithSuccessfulness(58, .Success)
        
        switch s.customPlaygroundQuickLook() {
        case let PlaygroundQuickLook.Int(outcome):
            expect(outcome) == Int64(s.outcome)
        default:
            fail()
        }
    }
    
}

// MARK: - Comparable
extension OutcomeWithSuccessfulness_Tests {
    
    func test_operator_lessThan() {
        property("less than") <- forAll {
            (a: OutcomeWithSuccessfulness, b: OutcomeWithSuccessfulness) in
            
            let expectedLessThan: Bool
            if a.outcome == b.outcome {
                expectedLessThan = a.successfulness < b.successfulness
            } else {
                expectedLessThan = a.outcome < b.outcome
            }
            
            let lessThan = a < b
            
            return lessThan == expectedLessThan
        }
    }
    
}

// MARK: - IntegerArithmeticType
extension OutcomeWithSuccessfulness_Tests {
    
    func test_addWithOverflow() {
        property("add") <- forAll {
            (a: OutcomeWithSuccessfulness, b: OutcomeWithSuccessfulness) in
            
            let (expectedOutcome, expectedOverflow) = Int.addWithOverflow(a.outcome, b.outcome)
            let expectedSuccessfulness = a.successfulness + b.successfulness
            
            let (outcome, overflow) = OutcomeWithSuccessfulness.addWithOverflow(a, b)
            
            let testOutcome = outcome.outcome == expectedOutcome
            let testSuccessfulness = outcome.successfulness == expectedSuccessfulness
            let testOverflow = overflow == expectedOverflow
            
            return testOutcome && testSuccessfulness && testOverflow
        }
    }
    
    func test_subtractWithOverflow() {
        property("subtract") <- forAll {
            (a: OutcomeWithSuccessfulness, b: OutcomeWithSuccessfulness) in
            
            let (expectedOutcome, expectedOverflow) = Int.subtractWithOverflow(a.outcome, b.outcome)
            let expectedSuccessfulness = a.successfulness - b.successfulness
            
            let (outcome, overflow) = OutcomeWithSuccessfulness.subtractWithOverflow(a, b)
            
            let testOutcome = outcome.outcome == expectedOutcome
            let testSuccessfulness = outcome.successfulness == expectedSuccessfulness
            let testOverflow = overflow == expectedOverflow
            
            return testOutcome && testSuccessfulness && testOverflow
        }
    }
    
    func test_multiplyWithOverflow() {
        property("multiply") <- forAll {
            (a: OutcomeWithSuccessfulness, b: OutcomeWithSuccessfulness) in
            
            let (expectedOutcome, expectedOverflow) = Int.multiplyWithOverflow(a.outcome, b.outcome)
            let expectedSuccessfulness = a.successfulness * b.successfulness
            
            let (outcome, overflow) = OutcomeWithSuccessfulness.multiplyWithOverflow(a, b)
            
            let testOutcome = outcome.outcome == expectedOutcome
            let testSuccessfulness = outcome.successfulness == expectedSuccessfulness
            let testOverflow = overflow == expectedOverflow
            
            return testOutcome && testSuccessfulness && testOverflow
        }
    }
    
    func test_divideWithOverflow() {
        property("divide") <- forAll {
            (a: OutcomeWithSuccessfulness, b: OutcomeWithSuccessfulness) in
            
            return (b.outcome != 0 && b.successfulness != .Undetermined) ==> {
                let (expectedOutcome, expectedOverflow) = Int.divideWithOverflow(a.outcome, b.outcome)
                let expectedSuccessfulness = a.successfulness / b.successfulness
                
                let (outcome, overflow) = OutcomeWithSuccessfulness.divideWithOverflow(a, b)
                
                let testOutcome = outcome.outcome == expectedOutcome
                let testSuccessfulness = outcome.successfulness == expectedSuccessfulness
                let testOverflow = overflow == expectedOverflow
                
                return testOutcome && testSuccessfulness && testOverflow
            }
        }
    }
    
    func test_remainderWithOverflow() {
        property("remainder") <- forAll {
            (a: OutcomeWithSuccessfulness, b: OutcomeWithSuccessfulness) in
            
            return (b.outcome != 0 && b.successfulness != .Undetermined) ==> {
                let (expectedOutcome, expectedOverflow) = Int.remainderWithOverflow(a.outcome, b.outcome)
                let expectedSuccessfulness = a.successfulness % b.successfulness
                
                let (outcome, overflow) = OutcomeWithSuccessfulness.remainderWithOverflow(a, b)
                
                let testOutcome = outcome.outcome == expectedOutcome
                let testSuccessfulness = outcome.successfulness == expectedSuccessfulness
                let testOverflow = overflow == expectedOverflow
                
                return testOutcome && testSuccessfulness && testOverflow
            }
        }
    }
    
    func test_toIntMax() {
        let baseOutcome = 56
        let outcomeWithSuccessfulness = OutcomeWithSuccessfulness(baseOutcome, .Fail)
        let expectedOutcomeIntMax = IntMax(baseOutcome)
        
        let outcomeIntMax = outcomeWithSuccessfulness.toIntMax()
        
        expect(outcomeIntMax) == expectedOutcomeIntMax
    }
    
}

// MARK: - FrequencyDistributionValueType
extension OutcomeWithSuccessfulness_Tests {
    
    func test_multiplicativeIdentity() {
        expect(OutcomeWithSuccessfulness.multiplicativeIdentity) == OutcomeWithSuccessfulness(1)
    }
    
    func test_multiplierEquivalent() {
        let s = OutcomeWithSuccessfulness(84, .Fail)
        
        expect(s.multiplierEquivalent) == s.outcome
    }
    
}
