//: # DiceKit
//:
//: DiceKit is a Swift framework for expressing and evaluating [dice notation](https://en.wikipedia.org/wiki/Dice_notation) (e.g., `d20`, `4d6+4`, `3d8×10+2`), which is commonly used in tabletop role-playing games.

//: ## Importing
//:
//: To use DiceKit you need to import the `DiceKit` module in your files.
//:
//: > **Note:**
//: > If the import below is failing with `No such module 'DiceKit'`, then you need to make sure to open the playground in a workspace that has the DiceKit project in it, build the DiceKit scheme, and then possibly execute the playground again. ([Apple Help](https://developer.apple.com/library/ios/recipes/Playground_Help/Chapters/ImportingaFrameworkIntoaPlayground.html))
import DiceKit


//: ## Dice
//:
//: The `Die` type is used to represent an n-sided die. It defaults to 6 sides.
let d6 = Die()
let d4 = Die(sides: 4)

//: Rolling a die will produce a `Die.Roll`, which represents the result of the roll.
let d6Result = d6.roll()
let d4Result = d4.roll()

//: It holds the numeric result of the roll in the `value` property.
let d6Value = d6Result.value
let d4Value = d4Result.value

//: It also holds the `Die` that was used to produce it in the `die` property.
//: This associates the value to the type of die that produced it.
d6Result.die == d6
d4Result.die == Die(sides: 4)


//: Now that we have a grasp on single dice, let's explore [expressions](Expressions), which allows for combining dice and constants with various operations such as multiplication and addition.
//:
//: ---
//:
//: [Next](@next)
