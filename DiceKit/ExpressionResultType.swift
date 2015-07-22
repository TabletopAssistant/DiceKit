//
//  ExpressionResult.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public protocol ExpressionResultType {
    
    var value: Int { get }
    
}

// MARK: - Standard Library extensions

extension Int: ExpressionResultType {
    
    public var value: Int {
        return self
    }
    
}
