//: ## Expressions
//:
//: Similar to programming expressions you can create expressions in DiceKit that represent the combination of other expressions. Anything that conforms to `ExpressionResultType` is an expression, which means that `Die` and `Int` are also expressions (which is useful, otherwise they would be pretty worthless).
//:
import DiceKit

//: Let's start with creating an expression that represents `2d20+8`:
let expression = AdditionExpression(MultiplicationExpression(c(2), Die(sides: 20)), c(8))

//: Wow! That's a little verbose. Luckily there are several operators for convenience. Here is an equivalent expression:
let expression2 = 2 * d(20) + 8
expression == expression2

//: Unlike in programming, an expression isn't evaluated by automatically. An expression holds the blueprint for how to determine a result. To evaluate the expression and get a result call `evaluate()` on it. The returned type will conform to `ExpressionResultType`, the exact type being the associated `ExpressionType.Result` type of the expression.
let result = expression.evaluate()

//: Just like `Die.Roll` (because it's the `ExpressionResultType` for `Die`) the result is in the `value` property.
let value = result.value



let fourD6DropLowest = ChooseExpression(4 * d(6), .Drop, .Lowest, 1)
let fourD6DropLowestResult = fourD6DropLowest.evaluate()
let baseResult = fourD6DropLowestResult.base.resultCollection
let droppedResult = fourD6DropLowestResult.resultCollection

//: [Previous](@previous)
//: [Next](@next)
