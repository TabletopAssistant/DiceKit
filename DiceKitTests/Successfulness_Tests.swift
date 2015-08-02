//
//  Successfulness_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/8/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

class Successfulness_Tests: XCTestCase {
    
}

// MARK: - Initialization
extension Successfulness_Tests {
    
    func test_init_shouldBeIntegerLiteralConvertible() {
        let undecidedLiteral: Successfulness = 0
        let successLiteral1: Successfulness = 1
        let successLiteral2: Successfulness = 45456
        let failLiteral1: Successfulness = -1
        let failLiteral2: Successfulness = -6567
        
        expect(undecidedLiteral) == Successfulness.Undetermined
        expect(successLiteral1) == Successfulness.Success
        expect(successLiteral2) == Successfulness.Success
        expect(failLiteral1) == Successfulness.Fail
        expect(failLiteral2) == Successfulness.Fail
    }
    
}

// MARK: - CustomPlaygroundQuickLookable
extension Successfulness_Tests {
    
    func test_customPlaygroundQuickLook() {
        switch Successfulness.Undetermined.customPlaygroundQuickLook() {
        case PlaygroundQuickLook.Int(0): break
        default: fail()
        }
        
        switch Successfulness.Fail.customPlaygroundQuickLook() {
        case PlaygroundQuickLook.Int(-1): break
        default: fail()
        }
        
        switch Successfulness.Success.customPlaygroundQuickLook() {
        case PlaygroundQuickLook.Int(1): break
        default: fail()
        }
    }
    
}

// MARK: - Comparable
extension Successfulness_Tests {
    
    func test_operator_lessThan() {
        expect(Successfulness.Fail) < Successfulness.Success
        expect(Successfulness.Fail) < Successfulness.Undetermined
        expect(Successfulness.Undetermined) > Successfulness.Fail
        expect(Successfulness.Undetermined) < Successfulness.Success
        expect(Successfulness.Success) > Successfulness.Undetermined
        expect(Successfulness.Success) > Successfulness.Fail
    }
    
}

// MARK: - Custom Logic
extension Successfulness_Tests {
    
    func test_combineSuccessfulnesses_shouldPickCorrectlyForMany() {
        property("combine successfulness") <- forAll {
            (a: ArrayOf<Successfulness>) in
            
            let a = a.getArray
            
            let expectedSuccessfulness: Successfulness
            switch (a.contains(.Success), a.contains(.Fail)) {
            case (true, false):
                expectedSuccessfulness = .Success
            case (false, true):
                expectedSuccessfulness = .Fail
            case (false, false):
                expectedSuccessfulness = .Undetermined
            case (true, true): // Conflict
                expectedSuccessfulness = .Undetermined
            }
            
            let successfulness = Successfulness.combineSuccessfulnesses(a)
            
            return successfulness == expectedSuccessfulness
        }
    }
    
}

// MARK: - AdditiveType, InvertibleAdditiveType, MultiplicativeType, InvertibleMultiplicativeType
extension Successfulness_Tests {
    
    func test_operator_add() {
        let possibleSuccessfulessnesses: [Successfulness] = [.Undetermined, .Success, .Fail]
        for lhsSuccessfulness in possibleSuccessfulessnesses {
            for rhsSuccessfulness in possibleSuccessfulessnesses {
                let expectedSuccessfulness: Successfulness
                switch (lhsSuccessfulness, rhsSuccessfulness) {
                case let (lhs, rhs) where lhs == rhs:
                    expectedSuccessfulness = lhs
                case let (.Undetermined, rhs):
                    expectedSuccessfulness = rhs
                case let (lhs, .Undetermined):
                    expectedSuccessfulness = lhs
                default: // In conflict
                    expectedSuccessfulness = .Undetermined
                }
                
                let successfulness = lhsSuccessfulness + rhsSuccessfulness
                
                expect(successfulness) == expectedSuccessfulness
            }
        }
    }
    
    func test_operator_subtract() {
        let possibleSuccessfulessnesses: [Successfulness] = [.Undetermined, .Success, .Fail]
        for lhsSuccessfulness in possibleSuccessfulessnesses {
            for rhsSuccessfulness in possibleSuccessfulessnesses {
                let expectedSuccessfulness: Successfulness
                switch (lhsSuccessfulness, rhsSuccessfulness) {
                case let (lhs, rhs) where lhs == rhs:
                    expectedSuccessfulness = .Undetermined
                case let (.Undetermined, rhs):
                    expectedSuccessfulness = -rhs
                case let (lhs, _): // Conflict 1 - -1 == 2 == 1
                    expectedSuccessfulness = lhs
                }
                
                let successfulness = lhsSuccessfulness - rhsSuccessfulness
                
                expect(successfulness) == expectedSuccessfulness
            }
        }
    }
    
    func test_operator_multiply() {
        let possibleSuccessfulessnesses: [Successfulness] = [.Undetermined, .Success, .Fail]
        for lhsSuccessfulness in possibleSuccessfulessnesses {
            for rhsSuccessfulness in possibleSuccessfulessnesses {
                let expectedSuccessfulness: Successfulness
                switch (lhsSuccessfulness, rhsSuccessfulness) {
                case (.Fail, .Fail):
                    expectedSuccessfulness = .Success
                case (.Success, .Success):
                    expectedSuccessfulness = .Success
                case (.Success, .Fail), (.Fail, .Success):
                    expectedSuccessfulness = .Fail
                default: // .Undetermined on either side
                    expectedSuccessfulness = .Undetermined
                }
                
                let successfulness = lhsSuccessfulness * rhsSuccessfulness
                
                expect(successfulness) == expectedSuccessfulness
            }
        }
    }
    
    func test_operator_divide() {
        let possibleSuccessfulessnesses: [Successfulness] = [.Undetermined, .Success, .Fail]
        for lhsSuccessfulness in possibleSuccessfulessnesses {
            for rhsSuccessfulness in possibleSuccessfulessnesses {
                let expectedSuccessfulness: Successfulness
                switch (lhsSuccessfulness, rhsSuccessfulness) {
                case (.Fail, .Fail):
                    expectedSuccessfulness = .Success
                case (.Success, .Success):
                    expectedSuccessfulness = .Success
                case (.Success, .Fail), (.Fail, .Success):
                    expectedSuccessfulness = .Fail
                case (_, .Undetermined):
                    continue // Divide by zero
                default: // .Undetermined on left size
                    expectedSuccessfulness = .Undetermined
                }
                
                let successfulness = lhsSuccessfulness / rhsSuccessfulness
                
                expect(successfulness) == expectedSuccessfulness
            }
        }
    }
    
    func test_operator_remainder() {
        let possibleSuccessfulessnesses: [Successfulness] = [.Undetermined, .Success, .Fail]
        for lhsSuccessfulness in possibleSuccessfulessnesses {
            for rhsSuccessfulness in possibleSuccessfulessnesses {
                let expectedSuccessfulness: Successfulness
                switch (lhsSuccessfulness, rhsSuccessfulness) {
                case (_, .Undetermined):
                    continue // Divide by zero
                default: // Dealing with 1's, so they all become undetermined
                    expectedSuccessfulness = .Undetermined
                }
                
                let successfulness = lhsSuccessfulness % rhsSuccessfulness
                
                expect(successfulness) == expectedSuccessfulness
            }
        }
    }
    
}

// MARK: - FrequencyDistributionValueType
extension Successfulness_Tests {
    
    func test_identities() {
        expect(Successfulness.additiveIdentity) == Successfulness.Undetermined
        expect(Successfulness.multiplicativeIdentity) == Successfulness.Success
    }
    
    func test_multiplierEquivalent() {
        expect(Successfulness.Undetermined.multiplierEquivalent) == 0
        expect(Successfulness.Success.multiplierEquivalent) == 1
        expect(Successfulness.Fail.multiplierEquivalent) == -1
    }
    
}
