//
//  MaximizationExpression_Tests.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

import XCTest
import Nimble
import SwiftCheck

import DiceKit

/// Tests the `MaximizationExpression` type
class MaximizationExpression_Tests: XCTestCase {
    
}

// MARK: - CustomDebugStringConvertible
extension MinimizationExpression_Tests {
    
    func test_MaximizationExpression_CustomDebugStringConvertible() {
        let expression = MaximizationExpression(d(8) + 2)
        
        let expected = "max(Die(8) + Constant(2))"
        
        let result = String(reflecting: expression)
        
        expect(result) == expected
    }
    
}

// MARK: - CustomStringConvertible
extension MinimizationExpression_Tests {
    
    func test_MaximizationExpression_CustomStringConvertible() {
        let expression = MaximizationExpression(d(20) + d(4))
        let expected = "max(d20 + d4)"
        
        let result = String(expression)
        
        expect(result) == expected
    }
    
}
