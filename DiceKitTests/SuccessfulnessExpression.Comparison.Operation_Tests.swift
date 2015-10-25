//
//  SuccessfulnessExpression.Comparison.Operation_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/6/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

class SuccessfulnessExpression_Comparison_Operation_Tests: XCTestCase {

    // Unit Under Test
    typealias UUT = SuccessfulnessExpressionComparisonOperation
    
}

// MARK: - Equatable
extension SuccessfulnessExpression_Comparison_Operation_Tests {
    
    // TODO: Equatable
    
}

// MARK: -
extension SuccessfulnessExpression_Comparison_Operation_Tests {
    
    func test_closure_shouldEvaluateCorrectly() {
        property("closure") <- forAll {
            (a: Int, b: Int) in
            
            let expectedEqual = (a == b)
            let expectedNotEqual = (a != b)
            let expectedLessThan = (a < b)
            let expectedLessThanOrEqual = (a <= b)
            let expectedGreaterThan = (a > b)
            let expectedGreaterThanOrEqual = (a >= b)
            
            let equal = UUT.Equal.closure(a, b)
            let notEqual = UUT.NotEqual.closure(a, b)
            let lessThan = UUT.LessThan.closure(a, b)
            let lessThanOrEqual = UUT.LessThanOrEqual.closure(a, b)
            let greaterThan = UUT.GreaterThan.closure(a, b)
            let greaterThanOrEqual = UUT.GreaterThanOrEqual.closure(a, b)
            
            let testEqual = equal == expectedEqual
            let testNotEqual = notEqual == expectedNotEqual
            let testLessThan = lessThan == expectedLessThan
            let testLessThanOrEqual = lessThanOrEqual == expectedLessThanOrEqual
            let testGreaterThan = greaterThan == expectedGreaterThan
            let testGreaterThanOrEqual = greaterThanOrEqual == expectedGreaterThanOrEqual
            
            return testEqual
                && testNotEqual
                && testLessThan
                && testLessThanOrEqual
                && testGreaterThan
                && testGreaterThanOrEqual
        }
    }

}
