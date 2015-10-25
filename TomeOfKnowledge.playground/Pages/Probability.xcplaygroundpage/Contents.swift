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

//: Also, probabilityMass has minimumOutcome/maximumOutcome to calculate the lowest and highest possible outcome from a given expression.
let expression = d(2) * d(8) + 3
let max = expression.probabilityMass.maximumOutcome()
let min = expression.probabilityMass.minimumOutcome()

//: Finally, let's really test the system with an odd expression, like `(1d3)d6`. That expression means 1/3 of the time we have `1d6`, `2d6`, or `3d6`. With an equal chance of each one it will be like the frequencies of each are "added" together:
let awesomeExpression = d(3) * d(6)
let awesomeExpressionProbailityMass = awesomeExpression.probabilityMass

for (value, probability) in awesomeExpressionProbailityMass {
    value
    probability
}




let successfulD6 = ProbabilityMass<OutcomeWithSuccessfulness>(FrequencyDistribution([1: 1, 2: 1, 3: 1, 4: 1, 5: 1, OutcomeWithSuccessfulness(6, .Success): 1]))
for (value, probability) in successfulD6 {
    value.successfulness
    value
    probability
}

let failureD6 = ProbabilityMass<OutcomeWithSuccessfulness>(FrequencyDistribution([OutcomeWithSuccessfulness(1, .Fail): 1, 2: 1, 3: 1, 4: 1, 5: 1, 6: 1]))
for (value, probability) in failureD6 {
    value.successfulness
    value
    probability
}

let mixedSuccessD6 = successfulD6 && failureD6
for (value, probability) in mixedSuccessD6 {
    value.successfulness
    value
    probability
}

let prob = mixedSuccessD6[outcomeWithSuccessfulness: OutcomeWithSuccessfulness(4)]

for (value, probability) in mixedSuccessD6.valuesWithoutSuccessfulness() {
    value
    probability
}

for (successfulness, probability) in mixedSuccessD6.successfulnessWithoutValues() {
    successfulness
    probability
}


//: [Previous](@previous)
