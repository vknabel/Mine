public typealias FlatMapUsageDriftTransformation<Drift: Shaft> = (Lore<Drift.Mineral>.Usage) -> Rail<Drift.Mineral>

fileprivate final class FlatMapUsageDrift<Drift: Shaft>: Shaft {
  typealias Transformation = FlatMapUsageDriftTransformation<Drift>
  let transform: Transformation
  let drift: Drift

  init(drift: Drift, transform: @escaping Transformation) {
    self.drift = drift
    self.transform = transform
  }

  func mine(_ ore: Drift.Ore) -> Rail<Drift.Mineral> {
    return drift.mine(ore)
      .map { $0.flatMapUsage(transform: self.transform) }
  }
}

public extension Shaft {
  public func flatMapUsage(transform: @escaping FlatMapUsageDriftTransformation<Self>) -> Drift<Self.Ore, Self.Mineral> {
    return FlatMapUsageDrift(drift: self, transform: transform).asDrift()
  }
}
