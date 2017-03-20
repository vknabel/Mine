import RxSwift
import Foundation

extension Observable {
  static func lazy(_ element: @escaping @autoclosure () -> Element) -> Observable {
    return .deferred {
      .of(element())
    }
  }
}

/// Transports `Lore`s containing your `Mineral`.
public typealias Rail<Mineral> = Observable<Lore<Mineral>>

/// Describes factories of `Rail`s.
public protocol MineType {
  associatedtype Ore
  associatedtype Mineral

  // (Ore) -> Rail<Mineral>
  func mine(_ ore: Ore) -> Rail<Mineral>
  func asMine() -> Mine<Ore, Mineral>
}

public extension MineType {
  func asMine() -> Mine<Ore, Mineral> {
    return Mine(fromMineShaft: self.mine)
  }
}

public struct Elevator<Ore, Mineral> { // no mine but subject
  // Observer<Lore<Mineral>>
  // Rail<Ore>
}

// MARK: Defaults

/*
# Mines: (Most are @testable and internal)
- `ExhaustiveMine` ores must be empty, or EmptyMine
- `PositionalMine` ores.first must be given Mine, or FirstMine
- `FlagMine` ores.first(where: { $0.startsWith("-") }) without "-"
- `OptionMine` ores.first(where: { $0.startsWith("--") }) without "--"
- `EitherMine` tries first Mine, on usage error second
- `MatchMine`
- `FirstMatchMine`
- `MapMine` ✅
- `FlatMapMine` ✅
*/
