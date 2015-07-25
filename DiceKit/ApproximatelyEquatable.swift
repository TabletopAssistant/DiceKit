//
//  ApproximatelyEquatable.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/24/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

infix operator ≈ {
    associativity none
    precedence 130
}

public protocol ApproximatelyEquatable: Equatable {
    
    func ≈ (lhs: Self, rhs: Self) -> Bool
    
}
