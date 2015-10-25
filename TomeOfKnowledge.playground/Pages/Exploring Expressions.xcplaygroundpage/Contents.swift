//: ## Exploring Expressions
//: 
//: Our expressions are more robust than what is needed for typical tabletop play. In fact, our generic expression system is capable of modeling expressions that would otherwise be considered too cumbersome or complex to physically roll. In order to help developers understand what their expressions actually represent, we have added various tools to make working with expressions as easy as possible.
import DiceKit

//: Lets start with the negative-sided die.
let negativeDie = d(-12)

//: A die with negative sides by default has results in the range `-sides...-1` (but you can assign different rollers to `Die.roller`). We have two ways to represent an expression as a string.
//: * `normalString` is the string returned from `negativeDie.description`. Our descriptions are intended to be readable and closely match regular dice notation. This also happens to be the text that playgrounds display to the right.
//: * `verboseString` is what is returned from `negativeDie.debugDescription`. These strings tend to do less to make the result readable, and are intended to show exactly what types are used.
let normalString = String(negativeDie)
let verboseString = String(reflecting: negativeDie)

//: When we look at the `description` of a die roll, we seperate the rolled value from the total number of sides with a |. So a d6 that rolled a 3 would be written as 3|6. Or with our special negative die:
let negativeResult = negativeDie.roll()

//: Multiplication expressions are particularly interesting to look at. We will make one multiplication expression and see what happens when we make a third multiplication expression from the first one and a die.
let oneD2 = 1 * d(2)
let d3 = d(3)

//: `oneD2` is of the type `MultiplicationExpression<Constant, Die>` because it is made by multiplying a `Consant` (the expression type `Int` is converted to) by a `Die`.
oneD2 is MultiplicationExpression<Constant, Die>

//: We can make a new multiplication expression with these two expressions. This expression works like a "normal" multiplication expression, but the multiplier is 1 half the time, and 2 the other half of the time.
let oneD2d3 = oneD2 * d3

//: When we `evaluate()` a multiplication expression, we can see what each side of the expression evaluated to. First, an easy case. This result type has a `.multiplierResult` and  `.multiplicandResults`. The multiplier is always 2, because it is a constant. The multiplicand is evaluated and summed n number of times to give the result, where n is the multiplier result. We seperate the multiplier and multiplicand with the symbol `*>` in the description, which says that the result of the left hand side is the length of the right hand side.
let twoD20 = 2 * d(20)
let twoD20result = twoD20.evaluate()

//: Now lets evaluate our compound multiplication expression. The leftmost term is the multiplier for 1d2. It must always be 1. The middle term is either a 1|2 or a 2|2, depending on what the d2 rolled. Finally, the rightmost term is either a single d3 roll or the sum of two d3 rolls, depending on what the d2 rolled.
let oneD2d3result = oneD2d3.evaluate()

//: The result of the expression is always the sum of the rightmost term.
let value = oneD2d3result.resultValue

//: Try making more expressions in this playground. There is no limitation on what expression types you can put together to make a new expression. If your expression gets too complicated to easily tell its type, use the `dump()` function to investigate it in the console window.
let whatIsThisExpression = d3 * (d(20) - 2)
dump(whatIsThisExpression) //Check out the debug area for a handy expression tree! :)


//: [Previous](@previous)
//: [Next](@next)
