public typealias FlatMapMineTransformation<Ore, Mineral, Gold> = (Mineral) -> Rail<Gold>

fileprivate final class FlatMapMine<Ore, Mineral, Gold>: MineType {
  typealias Transformation = FlatMapMineTransformation<Ore, Mineral, Gold>
  let transform: Transformation
  let mine: Mine<Ore, Mineral>

  init<SomeMine: MineType>(mine: SomeMine, transform: @escaping Transformation) where SomeMine.Ore == Ore, SomeMine.Mineral == Mineral {
    self.mine = mine.asMine()
    self.transform = transform
  }

  func mine(_ ore: Ore) -> Rail<Gold> {
    return mine.mine(ore)
      .flatMap { $0.flatMap(transform: self.transform) }
  }
}

public extension MineType {
  public func flatMap<Gold>(transform: @escaping FlatMapMineTransformation<Ore, Mineral, Gold>) -> Mine<Ore, Gold> {
    return FlatMapMine(mine: self, transform: transform).asMine()
  }

  public func flatMap<Gold>(transform: @escaping (Mineral) -> Lore<Gold>) -> Mine<Ore, Gold> {
    return FlatMapMine(mine: self, transform: { .of(transform($0)) }).asMine()
  }

  // flatMap(to: Rail)
  // flatMap(to: Lore)
}
