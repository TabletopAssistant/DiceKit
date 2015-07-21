<img src="Logo/PNG/Header@2x.png" width="128" height="128" title="DiceKit Logo" />

DiceKit
=======

[![Build Status](https://www.bitrise.io/app/bba3ae57e91a2417.svg?token=xykKCgO1PqORibgpZeeYrw&branch=master)](https://www.bitrise.io/app/bba3ae57e91a2417)
![Supported platforms](https://img.shields.io/badge/platforms-iOS%20%2B%20OS%20X%20%2B%20watchOS-blue.svg)
[![Latest release](https://img.shields.io/github/release/tabletopassistant/dicekit.svg)](https://github.com/TabletopAssistant/DiceKit/releases)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)

DiceKit is a Swift framework for expressing and evaluating [dice notation][Dice Notation] (e.g., `d20`, `4d6+4`, `3d8×10+2`), which is commonly used in tabletop role-playing games.

[Dice Notation]: https://en.wikipedia.org/wiki/Dice_notation

## Features

- [x] Roll dies with arbitrary number of sides (e.g., `d2`, `d7`, `d6538`)
- [ ] Roll multiple of the same die (e.g., `3d6`) – [#3](https://github.com/TabletopAssistant/DiceKit/issues/3)
- [ ] Add dice rolls (e.g., `1d8 + 3d4`) – [#7](https://github.com/TabletopAssistant/DiceKit/issues/7)
- [ ] Add constants to rolls (e.g., `2d6 + 3`, `1d12 + 1d6 per level`) – [#6](https://github.com/TabletopAssistant/DiceKit/issues/6)
- [ ] Parse expressions from strings – [#8](https://github.com/TabletopAssistant/DiceKit/issues/8)
- [ ] Detect expressions in strings – [#9](https://github.com/TabletopAssistant/DiceKit/issues/9)
- [x] Comprehensive unit test coverage

## Requirements

- iOS 7.0+ / Mac OS X 10.9+ / watchOS 2.0+
- Xcode 7 Beta 3 (Swift 2.0)

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

See [CONTRIBUTING.md](CONTRIBUTING) for more details. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/TabletopAssistant/DiceKit/graphs/contributors

This project adheres to the [Open Code of Conduct][code-of-conduct]. By participating, you are expected to honor this code.
[code-of-conduct]: http://todogroup.org/opencodeofconduct/#DiceKit/opensource@brentleyjones.com

## Contact

Brentley Jones, [@brentleyjones](https://twitter.com/brentleyjones)

## License

DiceKit is published under the [Apache 2.0 license](LICENSE).
