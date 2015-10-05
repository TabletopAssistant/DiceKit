//
//  MinimizationExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/25/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `MinimizationExpressionResult` type
class MinimizationExpressionResult_Tests: XCTestCase {
    
}

// MARK: - ExpressionResultType
extension MinimizationExpressionResult_Tests {
    
    func test_and_shouldReturnMinimumForZeroSidedDie() {
        let expression = MinimizationExpression(d(0))
        let result = expression.evaluate()
        
        expect(result.value) == 0
    }
    
    func test_and_shouldReturnMinimum() {
        let expression = MinimizationExpression(d(8))
        let result = expression.evaluate()
        
        expect(result.value) == 1
    }
    
    func test_and_shouldReturnMinimumForAddition() {
        let expression = MinimizationExpression(d(8) + 4)
        let result = expression.evaluate()
        
        expect(result.value) == 5
    }
    
    func test_and_shouldReturnMinimumForMultiply() {
        let expression = MinimizationExpression(d(8) * 4)
        let result = expression.evaluate()
        
        expect(result.value) == 4
    }
    
}
