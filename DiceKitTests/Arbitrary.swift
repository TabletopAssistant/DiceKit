//
//  Arbitrary.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/6/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import SwiftCheck
import DiceKit

public extension CollectionType where Index.Distance: protocol<Arbitrary, IntegerType> {
    
    /// Generates an arbitrary index within 0..<count
    public var arbitraryIndex : Gen<Index.Distance> {
        return Index.Distance.arbitrary.resize(Int(self.count.toIntMax())).suchThat { $0 >= 0 }
    }
    
}

extension Constant: Arbitrary {
    
    public static func create(x : Int) -> Constant {
        return Constant(x)
    }
    
    public static var arbitrary : Gen<Constant> {
        return Constant.create <^> Int.arbitrary
    }
}

extension Die: Arbitrary {
    
    public static func create(x : Int) -> Die {
        return Die(sides: x)
    }
    
    public static var arbitrary : Gen<Die> {
        return Die.create <^> Int.arbitrary
    }
}

extension FrequencyDistribution: Arbitrary {
    
    public static func create(x : FrequenciesPerOutcome) -> FrequencyDistribution {
        return FrequencyDistribution(x)
    }
    
    public static var arbitrary : Gen<FrequencyDistribution> {
        return FrequencyDistribution.create <^> Dictionary<Outcome, Frequency>.arbitrary
    }
    
}
