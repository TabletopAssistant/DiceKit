//: ## Probability
//:
//: All expressions, which includes single values such as `Die` and `Constant`, have a [probability mass](https://en.wikipedia.org/wiki/Probability_mass_function) in DiceKit. Anhything tnhat conforms to the `ProbabilisticExpressionType` protocol can produce a `ProbabilityMass`. This allows you to determine how probable it is to get each outcome of an expression.
import DiceKit

//: Let's start with creating an expression that represents `1d6`:
let d6 = d(6)

//: We know that for this expression the probability of each outcome is equal, `1/6`. The `probabilityMass` property confirms this.
let d6ProbabilityMass = d6.probabilityMass

for (value, probability) in d6ProbabilityMass {
    value
    probability
}

//: How about a more complicated expresssion, but one that we still know the answer to? I think '3d6` will fit that bill, which has a nice bell curve shape:
let threeD6 = 3 * d(6)
let threeD6ProbabilityMass = threeD6.probabilityMass

for (value, probability) in threeD6ProbabilityMass {
    value
    probability
}

//: Finally, let's really test the system with an odd expression, like `(1d3)d6`. That expression means 1/3 of the time we have `1d6`, `2d6`, or `3d6`. With an equal chance of each one it will be like the frequencies of each are "added" together:
let awesomeExpression = d(3) * d(6)
let awesomeExpressionProbailityMass = awesomeExpression.probabilityMass

for (value, probability) in awesomeExpressionProbailityMass {
    value
    probability
}

//: ### Ranges
//:
//: <Something about ranges>
for (value, probability) in awesomeExpressionProbailityMass[Int.min...8] {
    value
    probability
}

for (value, probability) in threeD6ProbabilityMass[7..<Int.max] {
    value
    probability
}


//: [Previous](@previous)
