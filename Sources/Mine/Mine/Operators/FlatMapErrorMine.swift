public typealias FlatMapErrorMineTransformation<Ore, Mineral> = (Lore<Mineral>.Error) -> Rail<Mineral>

fileprivate final class FlatMapErrorMine<Ore, Mineral>: MineType {
  typealias Transformation = FlatMapErrorMineTransformation<Ore, Mineral>
  let transform: Transformation
  let mine: Mine<Ore, Mineral>

  init<SomeMine: MineType>(mine: SomeMine, transform: @escaping Transformation) where SomeMine.Ore == Ore, SomeMine.Mineral == Mineral {
    self.mine = mine.asMine()
    self.transform = transform
  }

  func mine(_ ore: Ore) -> Rail<Mineral> {
    return mine.mine(ore)
      .flatMap { $0.flatMapError(transform: self.transform) }
  }
}

public extension MineType {
  public func flatMapError(transform: @escaping FlatMapErrorMineTransformation<Ore, Mineral>) -> Mine<Ore, Mineral> {
    return FlatMapErrorMine(mine: self, transform: transform).asMine()
  }

  public func flatMapError<AnyMine: MineType>(to mine: AnyMine) -> Mine<Ore, Mineral>
  where AnyMine.Ore == Ore, AnyMine.Mineral == Mineral {
    return Mine { ore in
      self.mine(ore)
        .flatMap {
          $0.flatMapError { _ in mine.mine(ore) }
      }
    }
  }
}
