public typealias MapMineTransformation<Mine: MineType, Mineral> = (Mine.Mineral) -> Mineral

fileprivate final class MapMine<Mine: MineType, Mineral>: MineType {
  typealias Transformation = MapMineTransformation<Mine, Mineral>
  let transform: Transformation
  let mine: Mine

  init(mine: Mine, transform: @escaping Transformation) {
    self.mine = mine
    self.transform = transform
  }

  func mine(_ ore: Mine.Ore) -> Rail<Mineral> {
    return mine.mine(ore)
      .map { $0.map(transform: self.transform) }
  }
}

extension MineType {
  func map<Gold>(transform: @escaping MapMineTransformation<Self, Gold>) -> Mine<Ore, Gold> {
    return MapMine(mine: self, transform: transform).asMine()
  }
}
