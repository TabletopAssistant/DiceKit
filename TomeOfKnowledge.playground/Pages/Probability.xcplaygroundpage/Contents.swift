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







var lastTimestamp = NSDate()


// DL(1d7 + 1d7 + 1d7 + 1d7)
var slowBiggerDLFrequenciesPerOutcome = FrequencyDistribution<Int>.FrequenciesPerOutcome()
for i in 1...7 {
    for j in 1...7 {
        for k in 1...7 {
            for l in 1...7 {
                let remainingAfterDropped = OrderedArray([i, j, k, l]).array.suffixFrom(1)
                let summedAfterDropped = remainingAfterDropped.reduce(0, combine: +)
                let existingFrequency = slowBiggerDLFrequenciesPerOutcome[summedAfterDropped] ?? 0
                slowBiggerDLFrequenciesPerOutcome[summedAfterDropped] = 1 + existingFrequency
            }
        }
    }
}

let slowBiggerDLFreqDist = FrequencyDistribution(slowBiggerDLFrequenciesPerOutcome).normalizeFrequencies()

print("Time: \(NSDate().timeIntervalSinceDate(lastTimestamp))")
//print("Slow:   \(slowBiggerDLFreqDist)")


typealias DL1 = DropLowest

let d2DL1FreqDist = FrequencyDistribution<DL1>([1: 1.0, 2: 1.0])
let d3DL1FreqDist = FrequencyDistribution<DL1>([1: 1.0, 2: 1.0, 3: 1.0])
let d4DL1FreqDist = FrequencyDistribution<DL1>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0])
let d5DL1FreqDist = FrequencyDistribution<DL1>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0])
let d6DL1FreqDist = FrequencyDistribution<DL1>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0])
let d7DL1FreqDist = FrequencyDistribution<DL1>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0, 7: 1.0])

lastTimestamp = NSDate()

let intermediateFasterBiggerDL1FreqDist = d7DL1FreqDist.multiply(d7DL1FreqDist).multiply(d7DL1FreqDist).multiply(d7DL1FreqDist)

let fasterBiggerDL1FreqDist = intermediateFasterBiggerDL1FreqDist.normalizeFrequencies().mapOutcomes {
    $0.totalEquivalent
}

print("Drop 1 Time: \(NSDate().timeIntervalSinceDate(lastTimestamp))")

fasterBiggerDL1FreqDist.approximatelyEqual(slowBiggerDLFreqDist, delta: ProbabilityMassConfig.defaultProbabilityEqualityDelta)



typealias DL2 = DropLowest2

let d2DL2FreqDist = FrequencyDistribution<DL2>([1: 1.0, 2: 1.0])
let d3DL2FreqDist = FrequencyDistribution<DL2>([1: 1.0, 2: 1.0, 3: 1.0])
let d4DL2FreqDist = FrequencyDistribution<DL2>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0])
let d5DL2FreqDist = FrequencyDistribution<DL2>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0])
let d6DL2FreqDist = FrequencyDistribution<DL2>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0])
let d7DL2FreqDist = FrequencyDistribution<DL2>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0, 7: 1.0])

lastTimestamp = NSDate()

let intermediateFasterBiggerDL2FreqDist = d7DL2FreqDist.multiply(d7DL2FreqDist).multiply(d7DL2FreqDist).multiply(d7DL2FreqDist)

let fasterBiggerDL2FreqDist = intermediateFasterBiggerDL2FreqDist.normalizeFrequencies().mapOutcomes {
    $0.totalEquivalent
}

print("Drop n Time: \(NSDate().timeIntervalSinceDate(lastTimestamp))")

fasterBiggerDL2FreqDist.approximatelyEqual(slowBiggerDLFreqDist, delta: ProbabilityMassConfig.defaultProbabilityEqualityDelta)




let d3FreqDist = FrequencyDistribution<Int>([1: 1.0, 2: 1.0, 3: 1.0])
let d4FreqDist = FrequencyDistribution<Int>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0])
let d5FreqDist = FrequencyDistribution<Int>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0])
let d6FreqDist = FrequencyDistribution<Int>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0])
let d7FreqDist = FrequencyDistribution<Int>([1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0, 7: 1.0])


lastTimestamp = NSDate()

let normalFaster = d7FreqDist.multiply(d7FreqDist).multiply(d7FreqDist).multiply(d7FreqDist)

print("Add    Time: \(NSDate().timeIntervalSinceDate(lastTimestamp))")
//print("Normal: \(fasterBiggerDLFreqDist)")


let mappedNormalFaster = normalFaster.mapOutcomes {
    $0
}


print("Interm 1: \(intermediateFasterBiggerDL1FreqDist)")
print("Interm 2: \(intermediateFasterBiggerDL2FreqDist)")

//: [Previous](@previous)
