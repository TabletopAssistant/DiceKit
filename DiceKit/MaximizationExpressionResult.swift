//
//  MaximizationExpressionResult.swift
//  DiceKit
//
//  Created by Logan Johnson on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public struct MaximizationExpressionResult<BaseExpressionResult: protocol<ExpressionResultType, Equatable>>: Equatable {

    // TODO: Have this type be based on BaseExpressionResult
    public let baseProbabilityMass: ExpressionProbabilityMass
    
    public init(_ baseProbabilityMass: ExpressionProbabilityMass) {
        self.baseProbabilityMass = baseProbabilityMass
    }
}

// MARK: - CustomStringConvertible

extension MaximizationExpressionResult: CustomStringConvertible {
    
    public var description: String {
        let stringlyArray = baseProbabilityMass.orderedOutcomes.map { String($0) }.joinWithSeparator(", ")
        return "max([\(stringlyArray)])"
    }
}

// MARK: - CustomDebugStringConvertible

extension MaximizationExpressionResult: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        let stringlyArray = baseProbabilityMass.orderedOutcomes.map { String(reflecting: $0) }.joinWithSeparator(", ")
        return "max([\(stringlyArray)])"
    }
}

// MARK: - Equatable

public func == <L>(lhs: MaximizationExpressionResult<L>, rhs: MaximizationExpressionResult<L>) -> Bool {
    return lhs.baseProbabilityMass == rhs.baseProbabilityMass
}

// MARK: - ExpressionResultType

extension MaximizationExpressionResult: ExpressionResultType {

    public var resultValue: ExpressionResultValue {
        return baseProbabilityMass.maximumOutcome() ?? 0
    }
}
