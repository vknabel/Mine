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
  func asDrift() -> Drift<Ore, Mineral>
}

public extension MineType {
  func asDrift() -> Drift<Ore, Mineral> {
    return Drift(fromMineShaft: self.mine)
  }
}

public struct Mine<Gold>: MineType {
  public typealias Ore = [String]
  public typealias Mineral = Gold

  public func mine(_ ore: Ore) -> Rail<Mineral> {
    return .empty()
  }

  // () -> Never
  // (Ore) -> Never
}

public struct Elevator<Ore, Mineral> { // no mine but subject
  // Observer<Lore<Mineral>>
  // Rail<Ore>
}

// MARK: Defaults

/*
# Drifts: (Most are @testable and internal)
- `ExhaustiveDrift` ores must be empty, or EmptyDrift
- `PositionalDrift` ores.first must be given drift, or FirstDrift
- `FlagDrift` ores.first(where: { $0.startsWith("-") }) without "-"
- `OptionDrift` ores.first(where: { $0.startsWith("--") }) without "--"
- `EitherDrift` tries first drift, on usage error second
- `MatchDrift`
- `FirstMatchDrift`
- `MapDrift` ✅
- `FlatMapDrift` ✅
*/
