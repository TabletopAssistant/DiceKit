//
//  Die.Roll.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

extension Die {

    /// The result of rolling a `Die`.
    public struct Roll: Equatable {
        
        public let die: Die
        public let value: Int
        
        public let successfulness = Successfulness.Undetermined
        
        public init(die: Die, value: Int) {
            self.die = die
            self.value = value
        }
    }
    
}

// MARK: - ExpressionResultType

extension Die.Roll: ExpressionResultType {
    // Already conforms because of `value` and `successful`
}

// MARK: - CustomStringConvertible

extension Die.Roll: CustomStringConvertible {
    
    public var description: String {
        get {
            return "\(value)|\(die.sides)"
        }
    }
    
}

// MARK: - CustomDebugStringConvertible

extension Die.Roll: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(String(reflecting: die)).Roll(\(value))"
    }
    
}

// MARK: - Equatable

public func == (lhs: Die.Roll, rhs: Die.Roll) -> Bool {
    return lhs.die == rhs.die && lhs.value == rhs.value
}
