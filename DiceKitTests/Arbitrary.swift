//
//  Arbitrary.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/6/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import SwiftCheck
import DiceKit

extension Constant: Arbitrary {
    
    public static func create(x : Int) -> Constant {
        return Constant(x)
    }
    
    public static var arbitrary : Gen<Constant> {
        return Constant.create <^> Int.arbitrary
    }
}
