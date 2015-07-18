//
//  Die.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/12/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

/// Errors that `Die` can produce.
public enum DieError: ErrorType {
    
    /// A negative number of sides was provided.
    case NegativeSides
    
}

/**
An imaginary die with `0` to `Int.max` sides. Default of 6 sides. 
*/
public struct Die: Equatable {
    
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
    
    /**
    A type that "rolls" an imaginary die with `sides` number of sides and returns the result.
    
    Passing a value less than `0` for `sides` is undefined.
    
    - returns: `0` when `sides = 0`. `1...sides` when `sides > 0`.
    */
    public typealias RollerType = (sides: Int) -> Int
    
    public static let defaultRoller: RollerType = {
        sides in
        return sides < 1 ? 0 : Int.random(lower: 0, upper: sides) + 1
    }
    public static var roller = defaultRoller // I don't like this as part of the API... not sure if there is a better way though
    
    public let sides: Int
    
    public init(sides: Int = 6) throws {
        guard sides >= 0 else { throw DieError.NegativeSides }
        
        self.sides = sides
    }
    
    /**
    Rolls the die and returns the result as a `Die.Roll`.
    
    - returns: A `Die.Roll` initiated with `self` and the value determined by
        `Die.roller` by passing in `self.sides` for `sides`.
    */
    public func roll() -> Roll {
        let result = Die.roller(sides: sides)
        return Roll(die: self, value: result)
    }
    
}

// MARK: - Equatable
public func ==(lhs: Die, rhs: Die) -> Bool {
    return lhs.sides == rhs.sides
}

public func ==(lhs: Die.Roll, rhs: Die.Roll) -> Bool {
    return lhs.die == rhs.die && lhs.value == rhs.value
}
