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
    
    public static var arbitrary : Gen<Die> {
        return Die.init <^> Int.arbitrary
    }
}

extension Die {
    
    /// Generates an arbitrary roll within sides
    public var arbitraryRollValue : Gen<Int> {
        guard sides != 0 else {
            return Gen.pure(0)
        }
        
        func createRollValue(i : Int) -> Int {
            if sides < 0 {
                return -abs(i) + 1
            } else {
                return abs(i) + 1
            }
        }
        
        return createRollValue <^> Int.arbitrary.resize(abs(self.sides))
    }
    
}

extension FrequencyDistribution where OutcomeType: Arbitrary {
    
    public static func create(x : FrequenciesPerOutcome) -> FrequencyDistribution {
        return FrequencyDistribution(x)
    }
    
    public static var arbitrary : Gen<FrequencyDistribution> {
        return FrequencyDistribution.create <^> Dictionary<Outcome, Frequency>.arbitrary
    }
    
    public static func shrink(f : FrequencyDistribution) -> [FrequencyDistribution] {
        let shrunkFrequenciesPerOutcome = FrequenciesPerOutcome.shrink(f.frequenciesPerOutcome)
        
        return shrunkFrequenciesPerOutcome.map { FrequencyDistribution($0) }
    }
    
}

public struct FrequencyDistributionOf<Outcome : protocol<FrequencyDistributionOutcomeType, Arbitrary>> : Arbitrary, CustomStringConvertible {
    public let getFrequencyDistribution : FrequencyDistribution<Outcome>
    
    public init(_ frequencyDistribution : FrequencyDistribution<Outcome>) {
        self.getFrequencyDistribution = frequencyDistribution
    }
    
    public var description : String {
        return "\(self.getFrequencyDistribution)"
    }
    
    public static var arbitrary : Gen<FrequencyDistributionOf<Outcome>> {
        return FrequencyDistributionOf.init <^> FrequencyDistribution<Outcome>.arbitrary
    }
    
    public static func shrink(bl : FrequencyDistributionOf<Outcome>) -> [FrequencyDistributionOf<Outcome>] {
        return FrequencyDistribution<Outcome>.shrink(bl.getFrequencyDistribution).map(FrequencyDistributionOf.init)
    }
}

extension Successfulness: Arbitrary {
    
    public static func create(x : Int) -> Successfulness {
        switch abs(x) % 3 {
        case 0:
            return .Undetermined
        case 1:
            return .Success
        case 2:
            return .Fail
            
        default: // Not possible
            return .Undetermined
        }
    }
    
    public static var arbitrary : Gen<Successfulness> {
        return Successfulness.create <^> Int.arbitrary.resize(3)
    }
    
}

extension OutcomeWithSuccessfulness: Arbitrary {
    
    public static func create(outcome : Int)(successfulness: Successfulness) -> OutcomeWithSuccessfulness {
        return OutcomeWithSuccessfulness(outcome, successfulness)
    }
    
    public static var arbitrary : Gen<OutcomeWithSuccessfulness> {
        return OutcomeWithSuccessfulness.create <^> Int.arbitrary <*> Successfulness.arbitrary
    }
    
}
