public typealias MapDriftTransformation<Drift: MineType, Mineral> = (Drift.Mineral) -> Mineral

fileprivate final class MapDrift<Drift: MineType, Mineral>: MineType {
  typealias Transformation = MapDriftTransformation<Drift, Mineral>
  let transform: Transformation
  let drift: Drift

  init(drift: Drift, transform: @escaping Transformation) {
    self.drift = drift
    self.transform = transform
  }

  func mine(_ ore: Drift.Ore) -> Rail<Mineral> {
    return drift.mine(ore)
      .map { $0.map(transform: self.transform) }
  }
}

extension MineType {
  func map<Gold>(transform: @escaping MapDriftTransformation<Self, Gold>) -> Drift<Ore, Gold> {
    return MapDrift(drift: self, transform: transform).asDrift()
  }
}
