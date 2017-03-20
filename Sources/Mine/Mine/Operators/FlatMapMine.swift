public typealias FlatMapMineTransformation<Mine: MineType, Mineral> = (Mine.Mineral) -> Rail<Mineral>

fileprivate final class FlatMapMine<Mine: MineType, Mineral>: MineType {
  typealias Transformation = FlatMapMineTransformation<Mine, Mineral>
  let transform: Transformation
  let mine: Mine

  init(mine: Mine, transform: @escaping Transformation) {
    self.mine = mine
    self.transform = transform
  }

  func mine(_ ore: Mine.Ore) -> Rail<Mineral> {
    return mine.mine(ore)
      .map { $0.flatMap(transform: self.transform) }
  }
}

public extension MineType {
  public func flatMap<Gold>(transform: @escaping FlatMapMineTransformation<Self, Gold>) -> Mine<Self.Ore, Gold> {
    return FlatMapMine(mine: self, transform: transform).asMine()
  }

  public func flatMap<Gold>(transform: @escaping (Mineral) -> Lore<Mineral>) -> Mine<Self.Ore, Gold> {
    return FlatMapMine(mine: self, transform: { .of(transform($0)) }).asMine()
  }

  // flatMap(to: Rail)
  // flatMap(to: Lore)
}
