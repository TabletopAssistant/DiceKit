//: ## Successfulness
//: 
//: Often in tabletop play outcomes of various expressions have certain meaning. A game might have you roll a die and add modifiers to the result, and if the overall result is greater than a certain number then that is called a "hit." An example exrpression would be d20+5. But a roll of 20 on the d20 might also be called a hit, even if the result of 25 isn't higher than the target number. DiceKit uses a successfulness system to support these scenarios.

import DiceKit

//: First let's introduce the `Successfulness` type. This is a type that stores a number of successes and failures.
var successfulness = Successfulness(successes: 0, failures: 1)

//: Oops, looks like that result is actually a failure. Instead of specifying the successes and failures that way, you can use the alternative Integer Literal init. This lets you pass one integer, and get a `Successfulness` object with that many successes if the integer is positive, or if it's negative that many failures * -1. 
var integerLiteralInit = Successfulness(integerLiteral: -1)
successfulness == integerLiteralInit

//: This type can hold multiple successes *and* failures. This allows it to support larger expressions that have multiple conditions for success or failure. How to use and implement that feature is largely up to you, but DiceKit does have some logic to keep in mind out of the box. We've already seen how it is equatable above. You can also compare two successfulness objects:
var succeedy = Successfulness(successes: 3, failures: 2)
var faily = Successfulness(successes: 1, failures: 3)
succeedy > faily

//: The comparison looks at the difference between successes and failures (# of successes - # of failures). If both results have the same difference between successes and failures, the one with more overall successes is considered greater than the other. That means that if faily gets a handout it can actually be considered greater than succeedy.
var freebie = Successfulness(successes: 3, failures: 0)
faily = faily + freebie
succeedy > faily

//: Not so great now, are you succeedy? Oh, by the way, Successfulness supports integer addition, subtraction, multiplication and modulo operations. Successfulness objects also have let properties for successes and failures.
faily.successes
faily.failures

//: Finally, you can't have fewer than 0 successes or failures, but there is a public property that tracks that for arithmetic purposes. 
var negativeSuccess = Successfulness(successes: -5, failures: 7)
negativeSuccess.rawSuccesses
negativeSuccess.rawFailures


//: [Previous](@previous)
