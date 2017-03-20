public typealias FlatMapUsageMineTransformation<Ore, Mineral> = (Lore<Mineral>.Usage) -> Rail<Mineral>

fileprivate final class FlatMapUsageMine<Ore, Mineral>: MineType {
  typealias Transformation = FlatMapUsageMineTransformation<Ore, Mineral>
  let transform: Transformation
  let mine: Mine<Ore, Mineral>

  init<SomeMine: MineType>(mine: SomeMine, transform: @escaping Transformation) where SomeMine.Ore == Ore, SomeMine.Mineral == Mineral{
    self.mine = mine.asMine()
    self.transform = transform
  }

  func mine(_ ore: Ore) -> Rail<Mineral> {
    return mine.mine(ore)
      .flatMap { $0.flatMapUsage(transform: self.transform) }
  }
}

public extension MineType {
  public func flatMapUsage(transform: @escaping FlatMapUsageMineTransformation<Ore, Mineral>) -> Mine<Self.Ore, Self.Mineral> {
    return FlatMapUsageMine(mine: self, transform: transform).asMine()
  }
}
