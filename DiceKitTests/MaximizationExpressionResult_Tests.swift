//
//  MaximizationExpressionResult_Tests.swift
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

/// Tests the `MaximizationExpressionResult` type
class MaximizationExpressionResult_Tests: XCTestCase {
    
}

// MARK: - ExpressionResultType
extension MaximizationExpressionResult_Tests {
    
    func test_and_shouldReturnMaximumForZeroSidedDie() {
        let expression = MaximizationExpression(d(0))
        let result = expression.evaluate()
        
        expect(result.resultValue) == 0
    }
    
    func test_and_shouldReturnMaximumForSingleDie() {
        let expression = MaximizationExpression(d(8))
        let result = expression.evaluate()
        
        expect(result.resultValue) == 8
    }
    
    func test_and_shouldReturnMaximumForAddition() {
        let expression = MaximizationExpression(d(8) + 4)
        let result = expression.evaluate()
        
        expect(result.resultValue) == 12
    }
    
    func test_and_shouldReturnMaximumForMultiply() {
        let expression = MaximizationExpression(d(8) * 4)
        let result = expression.evaluate()
        
        expect(result.resultValue) == 32
    }
    
}
