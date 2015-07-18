//
//  Die.Roll.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

extension Die {
    /**
    The result of rolling a `Die`.
    */
    public struct Roll: Equatable {
        
        public let die: Die
        public let value: Int
        
        public init(die: Die, value: Int) {
            self.die = die
            self.value = value
        }
    }
}

// MARK: - Equatable
public func ==(lhs: Die.Roll, rhs: Die.Roll) -> Bool {
    return lhs.die == rhs.die && lhs.value == rhs.value
}
