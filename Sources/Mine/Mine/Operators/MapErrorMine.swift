public typealias MapErrorMineTransformation<Mine: MineType> = (Lore<Mine.Mineral>.Error) -> Rail<Mine.Mineral>.Error

fileprivate final class MapErrorMine<Mine: MineType>: MineType {
  typealias Transformation = MapErrorMineTransformation<Mine>
  let transform: Transformation
  let mine: Mine

  init(mine: Mine, transform: @escaping Transformation) {
    self.mine = mine
    self.transform = transform
  }

  func mine(_ ore: Mine.Ore) -> Rail<Mine.Mineral> {
    return mine.mine(ore)
      .map { $0.mapError(transform: self.transform) }
  }
}

public extension MineType {
  public func mapError(transform: @escaping MapErrorMineTransformation<Self>) -> Mine<Self.Ore, Self.Mineral> {
    return MapErrorMine(mine: self, transform: transform).asMine()
  }
}
