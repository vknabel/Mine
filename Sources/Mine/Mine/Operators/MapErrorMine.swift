public typealias MapErrorMineTransformation<SomeMine: MineType> = (Lore<SomeMine.Mineral>.Error) -> Lore<SomeMine.Mineral>.Error

fileprivate final class MapErrorMine<SomeMine: MineType>: MineType {
  typealias Transformation = MapErrorMineTransformation<SomeMine>
  let transform: Transformation
  let mine: SomeMine

  init(mine: SomeMine, transform: @escaping Transformation) {
    self.mine = mine
    self.transform = transform
  }

  func mine(_ ore: SomeMine.Ore) -> Rail<SomeMine.Mineral> {
    return mine.mine(ore)
      .map { $0.mapError(transform: self.transform) }
  }
}

public extension MineType {
  public func mapError(transform: @escaping MapErrorMineTransformation<Self>) -> Mine<Self.Ore, Self.Mineral> {
    return MapErrorMine(mine: self, transform: transform).asMine()
  }
}
