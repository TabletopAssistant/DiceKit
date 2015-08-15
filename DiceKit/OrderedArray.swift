//
//  OrderedArray.swift
//  DiceKit
//
//  Created by Brentley Jones on 8/15/15.
//  Copyright © 2015 Brentley Jones. All rights reserved.
//

public struct OrderedArray<Element: Comparable>: Equatable {
    
    // Ordered from smallest to largest
    private var orderedArray: Array<Element>
    
    public init(_ elements: Array<Element>) {
        orderedArray = elements.sort()
    }
    
    // Inserts into the array, maintaining order of the elements
    public mutating func insert(x: Element) {
        var insertIndex = orderedArray.endIndex
        for (index, element) in orderedArray.enumerate() {
            if x <= element {
                insertIndex = index
                break
            }
        }
        
        if insertIndex == array.endIndex {
            orderedArray.append(x)
        } else {
            orderedArray.insert(x, atIndex: insertIndex)
        }
    }
    
    public mutating func insert(other: OrderedArray) {
        var newOrderedArray: [Element] = []
        
        var selfIndex = orderedArray.startIndex
        var otherIndex = other.orderedArray.startIndex
        while selfIndex != orderedArray.endIndex && otherIndex != other.orderedArray.endIndex {
            let selfElement = orderedArray[selfIndex]
            let otherElement = other.orderedArray[otherIndex]
            
            if selfElement <= otherElement {
                newOrderedArray.append(selfElement)
                selfIndex = selfIndex.successor()
            } else {
                newOrderedArray.append(otherElement)
                otherIndex = otherIndex.successor()
            }
        }
        
        // One of the arrays has ended
        if otherIndex != other.orderedArray.endIndex {
            newOrderedArray.extend(other.orderedArray.suffixFrom(otherIndex))
        } else if selfIndex != orderedArray.endIndex {
            newOrderedArray.extend(orderedArray.suffixFrom(selfIndex))
        }
        
        orderedArray = newOrderedArray
    }
    
    public var array: Array<Element> {
        return orderedArray
    }
    
}

public func == <E>(lhs: OrderedArray<E>, rhs: OrderedArray<E>) -> Bool {
    return lhs.orderedArray == rhs.orderedArray
}

extension OrderedArray: ArrayLiteralConvertible {
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}

extension OrderedArray: CustomStringConvertible {
    public var description: String {
        return orderedArray.description
    }
}
