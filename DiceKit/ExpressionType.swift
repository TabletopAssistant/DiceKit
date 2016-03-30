//
//  ExpressionType.swift
//  DiceKit
//
//  Created by Brentley Jones on 7/18/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

import Foundation

public protocol ExpressionType: ProbabilisticExpressionType {
    
    associatedtype Result : ExpressionResultType, Equatable
    
    func evaluate() -> Result
    
}
