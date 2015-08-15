//
//  ChooseExpressionResult_Tests.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/12/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import XCTest
import Nimble
import SwiftCheck

import DiceKit

class ChooseExpressionResult_Tests: XCTestCase {
    
}

// MARK: - Initialization
extension ChooseExpressionResult_Tests {
    
    // TODO: init
    
}

// MARK: - Equatable
extension ChooseExpressionResult_Tests {
    
    // TODO: Equatable
    
}

// MARK: - ExpressionResultCollectionProducer
extension ChooseExpressionResult_Tests {
    
    func test_resultsCollection() {
        // Arrange
        let baseResults = [c(5), c(1), c(-1), c(-1), c(7)]
        
        let pickHighestResult = ChooseExpressionResult(baseResults, .Pick, .Highest, 2)
        let pickLowestResult = ChooseExpressionResult(baseResults, .Pick, .Lowest, 2)
        let dropHighestResult = ChooseExpressionResult(baseResults, .Drop, .Highest, 2)
        let dropLowestResult = ChooseExpressionResult(baseResults, .Drop, .Lowest, 2)
        
        let expectedPickedHighestResults = [c(5), c(7)]
        let expectedPickedLowestResults = [c(-1), c(-1)]
        let expectedDroppedHighestResults = [c(1), c(-1), c(-1)]
        let expectedDroppedLowestResults = [c(5), c(1), c(7)]
        
        // Act
        let pickedHighestResults = pickHighestResult.resultCollection
        let pickedLowestResults = pickLowestResult.resultCollection
        let droppedHighestResults = dropHighestResult.resultCollection
        let droppedLowestResults = dropLowestResult.resultCollection
        
        // Assert
        expect(pickedHighestResults) == expectedPickedHighestResults
        expect(pickedLowestResults) == expectedPickedLowestResults
        expect(droppedHighestResults) == expectedDroppedHighestResults
        expect(droppedLowestResults) == expectedDroppedLowestResults
    }
    
}
