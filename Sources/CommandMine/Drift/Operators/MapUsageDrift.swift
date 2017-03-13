public typealias MapUsageDriftTransformation<Drift: Shaft> = (Lore<Drift.Mineral>.Usage) -> Rail<Drift.Mineral>.Usage

fileprivate final class MapUsageDrift<Drift: Shaft>: Shaft {
  typealias Transformation = MapUsageDriftTransformation<Drift>
  let transform: Transformation
  let drift: Drift

  init(drift: Drift, transform: @escaping Transformation) {
    self.drift = drift
    self.transform = transform
  }

  func mine(_ ore: Drift.Ore) -> Rail<Drift.Mineral> {
    return drift.mine(ore)
      .map { $0.mapUsage(transform: self.transform) }
  }
}

public extension Shaft {
  public func mapUsage(transform: @escaping MapUsageDriftTransformation<Self>) -> Drift<Self.Ore, Self.Mineral> {
    return MapUsageDrift(drift: self, transform: transform).asDrift()
  }
}
