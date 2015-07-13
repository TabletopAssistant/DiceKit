//
//  Int+Random.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/12/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

// Originally from http://stackoverflow.com/a/25129039

func arc4random <T: IntegerLiteralConvertible> (type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, Int(sizeof(T)))
    return r
}

extension UInt64 {
    /// - Precondition: `lower < upper`
    static func random(lower lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        let u = upper - lower
        var r = arc4random(UInt64)
        
        let m: UInt64
        if u > UInt64(Int64.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m {
            r = arc4random(UInt64)
        }
        
        return (r % u) + lower
    }
}

extension Int64 {
    /// - Precondition: `lower < upper`
    static func random(lower lower: Int64 = min, upper: Int64 = max) -> Int64 {
        let (s, overflow) = Int64.subtractWithOverflow(upper, lower)
        let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
        let r = UInt64.random(upper: u)
        
        let ret: Int64
        if r > UInt64(Int64.max)  {
            ret = Int64(r - (UInt64(~lower) + 1))
        } else {
            ret = Int64(r) + lower
        }
        
        return ret
    }
}

extension UInt32 {
    /// - Precondition: `lower < upper`
    static func random(lower lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        return arc4random_uniform(upper - lower) + lower
    }
}

extension Int32 {
    /// - Precondition: `lower < upper`
    static func random(lower lower: Int32 = min, upper: Int32 = max) -> Int32 {
        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
        return Int32(Int64(r) + Int64(lower))
    }
}

extension UInt {
    /// - Precondition: `lower < upper`
    static func random(lower lower: UInt = min, upper: UInt = max) -> UInt {
        #if arch(i386) || arch(arm) // 32-bit
            return UInt(UInt32.random(lower: UInt32(lower), upper: UInt32(upper)))
        #else // 64-bit
            return UInt(UInt64.random(lower: UInt64(lower), upper: UInt64(upper)))
        #endif
    }
}

extension Int {
    /// - Precondition: `lower < upper`
    static func random(lower lower: Int = min, upper: Int = max) -> Int {
        #if arch(i386) || arch(arm) // 32-bit
            return Int(Int32.random(lower: Int32(lower), upper: Int32(upper)))
        #else // 64-bit
            return Int(Int64.random(lower: Int64(lower), upper: Int64(upper)))
        #endif
    }
}
