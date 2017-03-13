<p align="center">
    <img src="Assets/Logo.png" width="480" max-width="90%" alt="Mine" />
</p>

Command mine is a swift library for parsing command line arguments. It is designed to support asynchronous implementations of CLIS, that may even be used inside frameworks.

## Definitions
CommandMine is about extracting minerals out of your ore.

```swift
let goldmine = Mine<Gold>() // declare your mine
 .drift( // One way to get to your gold
  named: "init",
  digging drift: Drift, // Prepares your Shaft
  to shaft: execute // your actual program
 )
```

### Terminology

| Name     | Type        | Description                                                                     |
|----------|-------------|---------------------------------------------------------------------------------|
| Ore      | -           | The arguments passed to your program.                                           |
| Mineral  | -           | The desired mineral of your mine.                                               |
| Lore     | -           | An event wrapper around minerals.                                               |
| Rail     | `Rail`      | Transports your filled Lores. A simple typealias for *Observables* of *Lores*.  |
| Shaft    | `ShaftType` | A protocol describing factories of *Rails*.                                     |
| Drift    | `Drift`     | A concrete Shaft. Usually parses raw ore (`[String]`) into minerals.            |
| Mine     | `Mine`      | Your program. Is a Shaft.                                                       |
| Elevator | `Elevator`  | The fastest connection to the outside. A Rx wrapper around print and read line. |

### Elevator
The idea behind the elevator is to make your CLI embeddable as library without any changes.
```swift
let ele = Elevator<String, String>()
ele.onNext(.error("")) //.success("")

Elevator.
```

## Reusability
CommandMine tries to keep your CLIs independent from STDIO and may be used asynchronously.

Additionally it is important to keep parts of your code reusable and replaceable: your CLI may evolve.

### Framework Support
When it comes to internal or higher level tooling, frameworks suite better than plain CLIs as it eliminates the need to deal with another binary in your path, that your users need to install and keep up to date. Instead it will be compiled within your own target.

In order to split your project into a framework and CLI, you just declare your mine and drifts in `YourMine`, everything else in `YourShaft` and in your executable's `main.swift` you just start your mine.

> *Hint:* you can create this project layout with `mine init`.

```swift
import YourMine
yourMine.runMain()
```

So `YourShaft`  will be good for everyone who either wants to provide a complete new CLI using your logic, or for non CLIs.
At first exporting your mine and drifts into `YourMine` seems awkward, but it may actually help others to embed your project as a subcommand (after all Mines are just complex Shafts) or to just reuse one drift.
