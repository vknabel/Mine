public typealias MapUsageMineTransformation<Mine: MineType> = (Lore<Mine.Mineral>.Usage) -> Rail<Mine.Mineral>.Usage

fileprivate final class MapUsageMine<Mine: MineType>: MineType {
  typealias Transformation = MapUsageMineTransformation<Mine>
  let transform: Transformation
  let mine: Mine

  init(mine: Mine, transform: @escaping Transformation) {
    self.mine = mine
    self.transform = transform
  }

  func mine(_ ore: Mine.Ore) -> Rail<Mine.Mineral> {
    return mine.mine(ore)
      .map { $0.mapUsage(transform: self.transform) }
  }
}

public extension MineType {
  public func mapUsage(transform: @escaping MapUsageMineTransformation<Self>) -> Mine<Self.Ore, Self.Mineral> {
    return MapUsageMine(mine: self, transform: transform).asMine()
  }
}
