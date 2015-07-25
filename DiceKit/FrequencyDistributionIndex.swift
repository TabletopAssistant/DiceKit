//
//  FrequencyDistributionIndex.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/1/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public struct FrequencyDistributionIndex: ForwardIndexType {
    
    typealias OrderedValues = [FrequencyDistribution.Value]
    
    private let index: Int
    private let orderedValues: OrderedValues
    
    static func startIndex(orderedValues: OrderedValues) -> FrequencyDistributionIndex {
        return FrequencyDistributionIndex(index: 0, orderedValues: orderedValues)
    }
    
    static func endIndex(orderedValues: OrderedValues) -> FrequencyDistributionIndex {
        return FrequencyDistributionIndex(index: orderedValues.count, orderedValues: orderedValues)
    }
    
    init(index: Int, orderedValues: OrderedValues) {
        self.index = index
        self.orderedValues = orderedValues
    }
    
    var value: FrequencyDistribution.Value? {
        guard index < orderedValues.count else {
            return nil
        }
        
        return orderedValues[index]
    }
    
    public func successor() -> FrequencyDistributionIndex {
        let count = orderedValues.count
        guard index < count else {
            return FrequencyDistributionIndex(index: count, orderedValues: orderedValues)
        }
        
        return FrequencyDistributionIndex(index: index + 1, orderedValues: orderedValues)
    }
    
}

// MARK: - Equatable

public func == (lhs: FrequencyDistributionIndex, rhs: FrequencyDistributionIndex) -> Bool {
    return lhs.index == rhs.index && lhs.orderedValues == rhs.orderedValues
}
