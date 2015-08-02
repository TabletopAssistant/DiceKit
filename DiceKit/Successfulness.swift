//
//  Successfulness.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/2/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public enum Successfulness: Int, Comparable {
    case Fail = -1
    case Undetermined = 0
    case Success = 1

    /// Used to represent past the last value for ForwardIndexType.
    /// - Warning: Don't use this value, as it will not produce valid results.
    case Invalid

    public static let startIndex = Successfulness.Fail
    public static let endIndex = Successfulness.Invalid
    
    public static func combineSuccessfulnesses<C: CollectionType where C.Generator.Element == Successfulness>(successes: C) -> Successfulness {
        guard successes.count > 0 else {
            return .Undetermined
        }
        
        let hasSuccess = successes.indexOf(.Success) != nil
        let hasFail = successes.indexOf(.Fail) != nil
        
        switch (hasSuccess, hasFail) {
        case (true, true), (false, false):
            return .Undetermined
        case (true, false):
            return .Success
        case (false, true):
            return .Fail
        }
    }
}

// MARK: - CustomStringConvertible

extension Successfulness: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .Undetermined:
            return "Undetermined"
        case .Success:
            return "Success"
        case .Fail:
            return "Fail"

        case .Invalid:
            return "Invalid"
        }
    }
    
}

// MARK: - CustomPlaygroundQuickLookable

extension Successfulness: CustomPlaygroundQuickLookable {
    
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        return PlaygroundQuickLook.Int(Int64(rawValue))
    }
    
}

// MARK: - Comparable

public func < (lhs: Successfulness, rhs: Successfulness) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

// MARK: - FrequencyDistributionOutcomeType

extension Successfulness: FrequencyDistributionOutcomeType {
    
    // MARK: FrequencyDistributionValueType
    
    public static let additiveIdentity = Successfulness.Undetermined
    public static let multiplicativeIdentity = Successfulness.Success
    public var multiplierEquivalent: Int {
        return rawValue
    }
    
    // MARK: IntegerLiteralConvertible
    
    public init(integerLiteral value: Int) {
        let normalizedValue: Int
        if (value > 0) {
            normalizedValue = 1
        } else if (value < 0) {
            normalizedValue = -1
        } else {
            normalizedValue = 0
        }
        
        self = Successfulness(rawValue: normalizedValue)!
    }

    // MARK: ForwardIndexType

    public func successor() -> Successfulness {
        guard self != Successfulness.endIndex else {
            return Successfulness.endIndex
        }

        return Successfulness(rawValue: rawValue + 1)!
    }
    
}

// MARK: - ArithmeticType

public func + (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let rawValue = lhs.rawValue + rhs.rawValue
    return Successfulness(integerLiteral: rawValue)
}

public func - (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let rawValue = lhs.rawValue - rhs.rawValue
    return Successfulness(integerLiteral: rawValue)
}

public func * (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let rawValue = lhs.rawValue * rhs.rawValue
    return Successfulness(integerLiteral: rawValue)
}

public func / (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let rawValue = lhs.rawValue / rhs.rawValue
    return Successfulness(integerLiteral: rawValue)
}

public func % (lhs: Successfulness, rhs: Successfulness) -> Successfulness {
    let rawValue = lhs.rawValue % rhs.rawValue
    return Successfulness(integerLiteral: rawValue)
}
