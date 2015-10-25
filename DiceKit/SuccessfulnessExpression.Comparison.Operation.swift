//
//  SuccessfulnessExpression.Comparison.Operation.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/6/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

// Only not nested in `SuccessfulnessExpressionComparison` because its generic
public enum SuccessfulnessExpressionComparisonOperation {
    public typealias Closure = (Int, Int) -> Bool
    
    case Equal
    case NotEqual
    case LessThan
    case LessThanOrEqual
    case GreaterThan
    case GreaterThanOrEqual
    
    public var closure: Closure {
        switch self {
        case .Equal:
            return { $0 == $1 }
        case .NotEqual:
            return { $0 != $1 }
        case .LessThan:
            return { $0 < $1 }
        case .LessThanOrEqual:
            return { $0 <= $1 }
        case .GreaterThan:
            return { $0 > $1 }
        case .GreaterThanOrEqual:
            return { $0 >= $1 }
        }
    }
}
