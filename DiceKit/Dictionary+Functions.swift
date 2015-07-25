//
//  Dictionary+Functions.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/19/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func mapValues(@noescape transform: (Key, Value) -> Value) -> [Key:Value] {
        var newDictionary: [Key:Value] = [:]
        
        for (key, value) in self {
            newDictionary[key] = transform(key, value)
        }
        
        return newDictionary
    }
    
    /// - Warning: If two values are mapped to the same key, the last one evaluated will be used
    func mapKeys(@noescape transform: (Key, Value) -> Key) -> [Key:Value] {
        var newDictionary: [Key:Value] = [:]
        
        for (key, value) in self {
            let newKey = transform(key, value)
            newDictionary[newKey] = value
        }
        
        return newDictionary
    }
    
    /// - Warning: If two values are mapped to the same key, the last one evaluated will be used
    func map(@noescape transform: (Key, Value) -> (Key, Value)) -> [Key:Value] {
        var newDictionary: [Key:Value] = [:]
        
        for (key, value) in self {
            let (newKey, newValue) = transform(key, value)
            newDictionary[newKey] = newValue
        }
        
        return newDictionary
    }
    
}
