//
//  ChooseExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/12/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public struct ChooseExpressionResult<BaseResult: protocol<ExpressionResultCollectionProducer, Equatable>>: Equatable {
    
    public let base: BaseResult
    public let operation: ChooseExpressionOperation
    public let direction: ChooseExpressionDirection
    public let count: Int
    
    public init(_ base: BaseResult, _ operation: ChooseExpressionOperation, _ direction: ChooseExpressionDirection, _ count: Int) {
        self.base = base
        self.operation = operation
        self.direction = direction
        self.count = count
    }
    
}

// MARK: - Equatable

public func == <R>(lhs: ChooseExpressionResult<R>, rhs: ChooseExpressionResult<R>) -> Bool {
    return lhs.base == rhs.base
        && lhs.operation == rhs.operation
        && lhs.direction == rhs.direction
        && lhs.count == rhs.count
}

// MARK: - ExpressionResultCollectionProducer

extension ChooseExpressionResult: ExpressionResultCollectionProducer {
    
    public var resultCollection: [BaseResult.ResultCollectionElement] {
        let baseResultCollection = base.resultCollection
        let sortedIndexedResults = baseResultCollection.enumerate().sort {
            if $0.1 == $1.1 {
                return $0.0 < $1.0
            } else {
                return $0.1 < $1.1
            }
        }
        
        let remainingIndexedResults: ArraySlice<(index: Int, element: ResultCollectionElement)>
        switch (operation, direction) {
        case (.Pick, .Highest):
            remainingIndexedResults = sortedIndexedResults.suffix(count)
        case (.Pick, .Lowest):
            remainingIndexedResults = sortedIndexedResults.prefix(count)
        case (.Drop, .Highest):
            let invertedCount = max(0, sortedIndexedResults.count-count)
            remainingIndexedResults = sortedIndexedResults.prefixUpTo(invertedCount)
        case (.Drop, .Lowest):
            remainingIndexedResults = sortedIndexedResults.suffixFrom(count)
        }
        
        let unsortedRemainingResults = remainingIndexedResults
            .sort { $0.0 < $1.0 }.map { $0.1 }
        
        return unsortedRemainingResults
    }
    
}
