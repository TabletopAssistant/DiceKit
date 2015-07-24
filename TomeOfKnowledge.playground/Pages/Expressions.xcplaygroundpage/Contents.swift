//: ## Expressions
//:
//: Similar to programming expressions you can create expressions in DiceKit that represent the combination of other expressions. Anything that conforms to `ExpressionResultType` is an expression, which means that `Die` and `Int` are also expressions (which is useful, otherwise they would be pretty worthless).
//:
//: > **Note:**
//: > Expressions are currently a little rough around the edges. In the 0.2 release we plan on cleaning them up.
import DiceKit

//: Let's start with creating an expression that represents `2d20+8`:
let expression = AdditionExpression(MultiplicationExpression(2, Die(sides: 20)), 8)

//: Unlike in programming, an expression isn't evaliuated by automatically. An expression holds the blueprint for how to determine a result. To evaluate the expression and get a result call `evaluate()` on it. The returned type will conform to `ExpressionResultType`, the exact type being the associated `ExpressionType.Result` type of the expression.
let result = expression.evaluate()

//: Just like `Die.Roll` (because it's the `ExpressionResultType` for `Die`) the result is in the `value` property.
let value = result.value


//: [Previous](@previous)
