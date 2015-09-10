<img src="Logo/PNG/Header@2x.png" width="128" height="128" title="DiceKit Logo" />

DiceKit
=======

[![Build Status](https://www.bitrise.io/app/bba3ae57e91a2417.svg?token=xykKCgO1PqORibgpZeeYrw&branch=master)](https://www.bitrise.io/app/bba3ae57e91a2417)
![Supported platforms](https://img.shields.io/badge/platforms-iOS%20%2B%20OS%20X%20%2B%20tvOS%20%2B%20watchOS-blue.svg)
[![Latest release](https://img.shields.io/github/release/tabletopassistant/dicekit.svg)](https://github.com/TabletopAssistant/DiceKit/releases)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

DiceKit is a Swift framework for expressing and evaluating [dice notation][Dice Notation] (e.g., `d20`, `4d6+4`, `3d8×10+2`), which is commonly used in tabletop role-playing games.

[Dice Notation]: https://en.wikipedia.org/wiki/Dice_notation

## Features

- [x] Roll dice with arbitrary number of sides (e.g., `d2`, `d7`, `d6538`)
- [x] Evaluate simple dice expressions, including addition, multiplication, and negation operations (e.g. `2d20 + 6(1d5 + 8)`)
- [ ] Evaluate complicated dice expressions, including division, dropping dice, and exploding dice – [#27](https://github.com/TabletopAssistant/DiceKit/issues/27), [#28](https://github.com/TabletopAssistant/DiceKit/issues/28), [#33](https://github.com/TabletopAssistant/DiceKit/issues/33)
- [x] Determine the probability distribution of an expression
- [ ] Determine if an expression result meets success criteria  – [#59](https://github.com/TabletopAssistant/DiceKit/issues/59)
- [ ] Determine the probability distribution of meeting a success criteria (e.g. chance of rolling higher than 16 on `1d20 + 8`, but a natural `1` being an auto failure and a natural `20` being an auto success) – [#4](https://github.com/TabletopAssistant/DiceKit/issues/4)
- [ ] Parse expressions from strings – [#8](https://github.com/TabletopAssistant/DiceKit/issues/8)
- [ ] Detect expressions in strings – [#9](https://github.com/TabletopAssistant/DiceKit/issues/9)
- [x] Comprehensive unit test coverage

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 7

## Usage

### Dice

```swift
// Create dice with an arbitrary number of sides
let d6 = d()
let d11 = d(11)

// Roll them to get results
let result = d11.roll()
let value = result.value

// The rolls are `Die.Roll` instead of just a value
// They store which die the value is associated with
let rollWasFromD11 = result.die == d(11) // true
```

### Expressions

```swift
// Create expressions such as `2d20 + 8`
let expression = 2 * d(20) + 8

// Evaluate to get results
let result = expression.evaluate()
let value = result.value
```

### Probability

```swift
// With any expression...
let expression = 2 * d(6)

// you can get the probability mass
let probabilityMass = expression.probabilityMass
// [2: 0.0277777777777778,
//  3: 0.0555555555555556,
//  4: 0.0833333333333333,
//  5: 0.111111111111111,
//  6: 0.138888888888889,
//  7: 0.166666666666667,
//  8: 0.138888888888889,
//  9: 0.111111111111111,
//  10: 0.0833333333333333,
//  11: 0.0555555555555556,
//  12: 0.0277777777777778]
```

### And More

See the [Tome of Knowledge (playground)](TomeOfKnowledge.playground) for in-depth usage.

## Installation

### Carthage

Add the following line to your **Cartfile**:

```ruby
github "TabletopAssistant/DiceKit"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

[Carthage]: https://github.com/Carthage/Carthage

### Manually

1. Add **DiceKit.xcodeproj** to your project's workspace.
2. Build the **DiceKit** scheme. This is needed to get the proper path for the next steps.
3. Link your target with **DiceKit.framework**:

  - **iOS:** Drag **DiceKit.framework** from the **DiceKit/Products** group to the “Linked Frameworks and Libraries” section of your target’s “General” settings.

  - **OS X:** Drag **DiceKit.framework** from the **DiceKit/Products** group to the “Embedded Binaries” section of your target’s “General” settings.

4. Select the **DiceKit.framework** that is now in your project (most likely in your **Frameworks** group). In the “File Inspector” change the “Location” to “Relative to Build Products”.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details. Thank you, [contributors]!

[contributors]: https://github.com/TabletopAssistant/DiceKit/graphs/contributors

This project adheres to the [Open Code of Conduct][code-of-conduct]. By participating, you are expected to honor this code.
[code-of-conduct]: http://todogroup.org/opencodeofconduct/#DiceKit/opensource@brentleyjones.com

## Contact

Brentley Jones, [@brentleyjones](https://twitter.com/brentleyjones)

## License

DiceKit is published under the [Apache 2.0 license](LICENSE).
