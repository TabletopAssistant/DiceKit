//
//  FrequencyDistributionIndex.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/1/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public struct FrequencyDistributionIndex: ForwardIndexType {
    
    typealias OrderedValues = [FrequencyDistribution.Outcome]
    
    let index: Int
    let orderedOutcomes: OrderedValues
    
    static func startIndex(orderedOutcomes: OrderedValues) -> FrequencyDistributionIndex {
        return FrequencyDistributionIndex(index: 0, orderedOutcomes: orderedOutcomes)
    }
    
    static func endIndex(orderedOutcomes: OrderedValues) -> FrequencyDistributionIndex {
        return FrequencyDistributionIndex(index: orderedOutcomes.count, orderedOutcomes: orderedOutcomes)
    }
    
    init(index: Int, orderedOutcomes: OrderedValues) {
        self.index = index
        self.orderedOutcomes = orderedOutcomes
    }
    
    var value: FrequencyDistribution.Outcome? {
        guard index >= 0 && index < orderedOutcomes.count else {
            return nil
        }
        
        return orderedOutcomes[index]
    }
    
    public func successor() -> FrequencyDistributionIndex {
        let count = orderedOutcomes.count
        guard index < count else {
            return FrequencyDistributionIndex(index: count, orderedOutcomes: orderedOutcomes)
        }
        
        return FrequencyDistributionIndex(index: index + 1, orderedOutcomes: orderedOutcomes)
    }
    
}

// MARK: - Equatable

public func == (lhs: FrequencyDistributionIndex, rhs: FrequencyDistributionIndex) -> Bool {
    return lhs.index == rhs.index && lhs.orderedOutcomes == rhs.orderedOutcomes
}
