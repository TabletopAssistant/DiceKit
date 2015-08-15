//
//  ExpressionResultCollectionProducer.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/12/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public protocol ExpressionCollectionProducer {
    
    typealias Result: ExpressionResultCollectionProducer, Equatable
    
    func evaluate() -> Result
    
}

public protocol ExpressionResultCollectionProducer {
    
    typealias ResultCollectionElement: ExpressionResultType, Comparable
    
    var resultCollection: [ResultCollectionElement] { get }
    
}
