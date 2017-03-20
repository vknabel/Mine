public typealias FlatMapErrorMineTransformation<Mine: MineType> = (Lore<Mine.Mineral>.Error) -> Rail<Mine.Mineral>

fileprivate final class FlatMapErrorMine<Mine: MineType>: MineType {
  typealias Transformation = FlatMapErrorMineTransformation<Mine>
  let transform: Transformation
  let mine: Mine

  init(mine: Mine, transform: @escaping Transformation) {
    self.mine = mine
    self.transform = transform
  }

  func mine(_ ore: Mine.Ore) -> Rail<Mine.Mineral> {
    return mine.mine(ore)
      .map { $0.flatMapError(transform: self.transform) }
  }
}

public extension MineType {
  public func flatMapError(transform: @escaping FlatMapErrorMineTransformation<Self>) -> Mine<Self.Ore, Self.Mineral> {
    return FlatMapErrorMine(mine: self, transform: transform).asMine()
  }

  public func flatMapError<AnyMine: MineType>(to mine: AnyMine) -> Mine<Ore, Mineral>
  where AnyMine.Ore == Ore, AnyMine.Mineral == Mineral {
    return Mine { ore in
      self.flatMapError { _ in mine.mine(ore) }
    }
  }
}
