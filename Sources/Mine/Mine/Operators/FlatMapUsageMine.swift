public typealias FlatMapUsageMineTransformation<Mine: MineType> = (Lore<Mine.Mineral>.Usage) -> Rail<Mine.Mineral>

fileprivate final class FlatMapUsageMine<Mine: MineType>: MineType {
  typealias Transformation = FlatMapUsageMineTransformation<Mine>
  let transform: Transformation
  let mine: Mine

  init(mine: Mine, transform: @escaping Transformation) {
    self.mine = mine
    self.transform = transform
  }

  func mine(_ ore: Mine.Ore) -> Rail<Mine.Mineral> {
    return mine.mine(ore)
      .map { $0.flatMapUsage(transform: self.transform) }
  }
}

public extension MineType {
  public func flatMapUsage(transform: @escaping FlatMapUsageMineTransformation<Self>) -> Mine<Self.Ore, Self.Mineral> {
    return FlatMapUsageMine(mine: self, transform: transform).asMine()
  }
}
