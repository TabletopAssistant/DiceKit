//
//  ProbabilisticExpressionType.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/26/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public typealias ExpressionProbabilityMass = ProbabilityMass<Int>

public protocol ProbabilisticExpressionType {
    
    var probabilityMass: ExpressionProbabilityMass { get }
    
    /// Returns `true` if both `ProbabilisticExpressionType`s have approximately
    /// same chance for each respective outcome.
    func equivalent(that: ProbabilisticExpressionType) -> Bool
    
}

// MARK: - Protocol Defaults

extension ProbabilisticExpressionType {
    
    public func equivalent(x: ProbabilisticExpressionType) -> Bool {
        return self.probabilityMass ≈ x.probabilityMass
    }
    
}
