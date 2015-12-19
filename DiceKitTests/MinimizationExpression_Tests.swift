//
//  MinimizationExpression_Tests.swift
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

/// Tests the `MinimizationExpression` type
class MinimizationExpression_Tests: XCTestCase {
        
}

// MARK: - CustomDebugStringConvertible
extension MinimizationExpression_Tests {
    
    func test_MinimizationExpression_CustomDebugStringConvertible() {
        let innerExpression = d(8) + 2
        let expression = MinimizationExpression(innerExpression)

        let expected = "min(\(String(reflecting: innerExpression)))"
        
        let result = String(reflecting: expression)
        
        expect(result) == expected
    }
    
}

// MARK: - CustomStringConvertible
extension MinimizationExpression_Tests {
    
    func test_MinimizationExpression_CustomStringConvertible() {
        let innerExpression = d(20) + d(4)
        let expression = MinimizationExpression(innerExpression)
        let expected = "min(\(innerExpression))"
        
        let result = String(expression)
        
        expect(result) == expected
    }
    
}
