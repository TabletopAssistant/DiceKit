//
//  EquatableTestUtilities.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/6/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

// enum simply for scoping
enum EquatableTestUtilities {
    
    static func checkReflexive<T: Equatable>(initializedType: () -> T) -> Bool {
        let x = initializedType()
            
        return x == x
    }
    
    static func checkSymmetric<T: Equatable>(initializedType: () -> T) -> Bool {
        let x = initializedType()
        let y = initializedType()
        
        return x == y && y == x
    }
    
    static func checkTransitive<T: Equatable>(initializedType: () -> T) -> Bool {
        let x = initializedType()
        let y = initializedType()
        let z = initializedType()
        
        return x == y && y == z && x == z
    }
    
    static func checkNotEquate<T: Equatable>(initializedType: () -> T, _ differentNotEqualInitializedType: () -> T) -> Bool {
        let x = initializedType()
        let y = differentNotEqualInitializedType()
        
        return x != y
    }

    
}
