public typealias MapDriftTransformation<Drift: Shaft, Mineral> = (Drift.Mineral) -> Mineral

fileprivate final class MapDrift<Drift: Shaft, Mineral>: Shaft {
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

extension Shaft {
  func map<Gold>(transform: @escaping MapDriftTransformation<Self, Gold>) -> Drift<Ore, Gold> {
    return MapDrift(drift: self, transform: transform).asDrift()
  }
}
