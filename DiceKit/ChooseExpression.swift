//
//  ChooseExpression.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/12/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public enum ChooseExpressionOperation {
    case Pick
    case Drop
}

public enum ChooseExpressionDirection {
    case Highest
    case Lowest
}

public struct ChooseExpression<BaseExpression: protocol<ExpressionCollectionProducer, Equatable>>: Equatable {
    
    public let base: BaseExpression
    public let operation: ChooseExpressionOperation
    public let direction: ChooseExpressionDirection
    public let count: Int
    
    public init(_ base: BaseExpression, _ operation: ChooseExpressionOperation, _ direction: ChooseExpressionDirection, _ count: Int) {
        self.base = base
        self.operation = operation
        self.direction = direction
        self.count = count
    }
    
}

// MARK: - Equatable

public func == <B>(lhs: ChooseExpression<B>, rhs: ChooseExpression<B>) -> Bool {
    return lhs.base == rhs.base
        && lhs.operation == rhs.operation
        && lhs.direction == rhs.direction
        && lhs.count == rhs.count
}

// MARK: - ExpressionCollectionProducer

extension ChooseExpression: ExpressionCollectionProducer {
    
    public typealias Result = ChooseExpressionResult<BaseExpression.Result>
    
    public func evaluate() -> Result {
        return ChooseExpressionResult(base.evaluate(), operation, direction, count)
    }
    
}





// TEMP

public struct DropLowest: FrequencyDistributionOutcomeType, CustomStringConvertible {
    
    let dropCanidate1: Int?
    let dropCanidate2: Int?
    let summed: Int
    
    public static let additiveIdentity: DropLowest = 0
    
    public init(_ summed: Int, dropCanidate1: Int? = nil, dropCanidate2: Int? = nil) {
        self.summed = summed
        self.dropCanidate1 = dropCanidate1
        self.dropCanidate2 = dropCanidate2
    }
    
    public init(integerLiteral value: Int) {
        self.init(value)
    }
    
    public var multiplierEquivalent: Int {
        return totalEquivalent
    }
    
    public var hashValue: Int {
        return summed.hashValue + (dropCanidate1?.hashValue ?? 0) + (dropCanidate2?.hashValue ?? 0)
    }
    
    public var description: String {
        guard dropCanidate1 != nil || dropCanidate2 != nil else {
            return "\(summed)"
        }
        
        let dropCanidate1String: String
        if let dropCanidate1 = dropCanidate1 {
            dropCanidate1String = "\(dropCanidate1)"
        } else {
            dropCanidate1String = "-"
        }
        
        let dropCanidate2String: String
        if let dropCanidate2 = dropCanidate2 {
            dropCanidate2String = "\(dropCanidate2)"
        } else {
            dropCanidate2String = "-"
        }
        
        return "(\(dropCanidate1String),\(dropCanidate2String))+\(summed)"
    }
    
    public var totalEquivalent: Int {
        return (max(dropCanidate1, dropCanidate2) ?? 0) + summed
    }
    
}

func max (lhs: Int?, _ rhs: Int?) -> Int? {
    return lhs < rhs ? rhs : lhs
}

public func < (lhs: DropLowest, rhs: DropLowest) -> Bool {
    return lhs.totalEquivalent < rhs.totalEquivalent
}

public prefix func - (x: DropLowest) -> DropLowest {
    return DropLowest(-x.summed, dropCanidate1: x.dropCanidate1.flatMap({ -$0 }), dropCanidate2: x.dropCanidate2.flatMap({ -$0 }))
}

public func + (rhs: DropLowest, lhs: DropLowest) -> DropLowest {
    // TODO: Commutitive
    
    let rhsSummed = rhs.summed
    var dropCanidate1 = lhs.dropCanidate1
    var dropCanidate2 = lhs.dropCanidate2
    
    var summed = lhs.summed
    switch (dropCanidate1, dropCanidate2) {
    case let (dc1?, dc2?):
        if rhsSummed < dc1 {
            summed += dc1
            dropCanidate1 = rhsSummed
            
            // Enforce dropCanidate1 >= dropCanidate2
            if rhsSummed < dc2 {
                dropCanidate2 = rhsSummed
                dropCanidate1 = dc2
            }
        } else if rhsSummed < dc2 {
            summed += dc2
            dropCanidate2 = rhsSummed
        } else {
            summed += rhsSummed
        }
    case (nil, nil):
        // Enforce dropCanidate1 >= dropCanidate2
        if summed < rhsSummed {
            dropCanidate1 = rhsSummed
            dropCanidate2 = summed
        } else {
            dropCanidate1 = summed
            dropCanidate2 = rhsSummed
        }
        summed = 0
    case (nil, _):
        dropCanidate1 = rhsSummed
    case (_, _): // dropCanidate2 == nil
        // Enforce dropCanidate1 >= dropCanidate2
        if dropCanidate1 < rhsSummed {
            dropCanidate2 = dropCanidate1
            dropCanidate1 = rhsSummed
        } else {
            dropCanidate2 = rhsSummed
        }
    }
    
    return DropLowest(summed, dropCanidate1: dropCanidate1, dropCanidate2: dropCanidate2)
}

public func - (lhs: DropLowest, rhs: DropLowest) -> DropLowest {
    return lhs + -rhs
}

public func == (lhs: DropLowest, rhs: DropLowest) -> Bool {
    return lhs.summed == rhs.summed
        && lhs.dropCanidate1 == rhs.dropCanidate1
        && lhs.dropCanidate2 == rhs.dropCanidate2
}




public struct DropLowest2: FrequencyDistributionOutcomeType, CustomStringConvertible {
    
    let orderedChoices: OrderedArray<Int>
    
    public static let additiveIdentity: DropLowest2 = 0
    
    public init(_ orderedChoices: OrderedArray<Int>) {
        self.orderedChoices = orderedChoices
    }
    
    public init(integerLiteral value: Int) {
        self.init(OrderedArray([value]))
    }
    
    public var multiplierEquivalent: Int {
        return totalEquivalent
    }
    
    public var hashValue: Int {
        // DJB Hash Function
        var hash = 5381
        
        for x in orderedChoices.array {
            hash = ((hash << 5) &+ hash) &+ Int(x)
        }
        
        return hash
    }
    
    public var description: String {
        guard orderedChoices.array.count > 0 else {
            return "\(orderedChoices.array.first)"
        }
        
        return "\(orderedChoices)"
    }
    
    public var totalEquivalent: Int {
        return orderedChoices.array.suffixFrom(1).reduce(0, combine: +)
    }
    
}

public func < (lhs: DropLowest2, rhs: DropLowest2) -> Bool {
    return lhs.totalEquivalent < rhs.totalEquivalent
}

public prefix func - (x: DropLowest2) -> DropLowest2 {
    let negagtedChoices = x.orderedChoices.array.map(-)
    return DropLowest2(OrderedArray(negagtedChoices))
}

public func + (lhs: DropLowest2, rhs: DropLowest2) -> DropLowest2 {
    var newChoices = lhs.orderedChoices
    newChoices.insert(rhs.orderedChoices)
    return DropLowest2(newChoices)
}

public func - (lhs: DropLowest2, rhs: DropLowest2) -> DropLowest2 {
    return lhs + -rhs
}

public func == (lhs: DropLowest2, rhs: DropLowest2) -> Bool {
    return lhs.orderedChoices == rhs.orderedChoices
}

