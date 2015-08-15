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
    
    /// - Warning: If two keys are mapped to the same key, the last one evaluated will be used. Use conflictTransform variant to provide a different behavior.
    func mapKeys<NewKey>(@noescape transform: (Key, Value) -> NewKey) -> [NewKey:Value] {
        var newDictionary: [NewKey:Value] = [:]
        
        for (key, value) in self {
            let newKey = transform(key, value)
            newDictionary[newKey] = value
        }
        
        return newDictionary
    }
    
    func mapKeys<NewKey>(@noescape conflictTransform: (NewKey, Value, Value) -> Value, @noescape transform: (Key, Value) -> NewKey) -> [NewKey:Value] {
        var newDictionary: [NewKey:Value] = [:]
        
        for (key, var value) in self {
            let newKey = transform(key, value)
            if let existingValue = newDictionary[newKey] {
                value = conflictTransform(newKey, existingValue, value)
            }
            newDictionary[newKey] = value
        }
        
        return newDictionary
    }
    
    /// - Warning: If two keys are mapped to the same key, the last one evaluated will be used. Use conflictTransform variant to provide a different behavior.
    func map<NewKey>(@noescape transform: (Key, Value) -> (NewKey, Value)) -> [NewKey:Value] {
        var newDictionary: [NewKey:Value] = [:]
        
        for (key, value) in self {
            let (newKey, newValue) = transform(key, value)
            newDictionary[newKey] = newValue
        }
        
        return newDictionary
    }
    
    func map<NewKey>(@noescape conflictTransform: (NewKey, Value, Value) -> Value, @noescape transform: (Key, Value) -> (NewKey, Value)) -> [NewKey:Value] {
        var newDictionary: [NewKey:Value] = [:]
        
        for (key, value) in self {
            var (newKey, newValue) = transform(key, value)
            if let existingValue = newDictionary[newKey] {
                newValue = conflictTransform(newKey, existingValue, newValue)
            }
            newDictionary[newKey] = newValue
        }
        
        return newDictionary
    }
    
}
