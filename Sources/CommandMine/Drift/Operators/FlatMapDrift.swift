public typealias FlatMapDriftTransformation<Drift: Shaft, Mineral> = (Drift.Mineral) -> Rail<Mineral>

fileprivate final class FlatMapDrift<Drift: Shaft, Mineral>: Shaft {
  typealias Transformation = FlatMapDriftTransformation<Drift, Mineral>
  let transform: Transformation
  let drift: Drift

  init(drift: Drift, transform: @escaping Transformation) {
    self.drift = drift
    self.transform = transform
  }

  func mine(_ ore: Drift.Ore) -> Rail<Mineral> {
    return drift.mine(ore)
      .map { $0.flatMap(transform: self.transform) }
  }
}

public extension Shaft {
  public func flatMap<Gold>(transform: @escaping FlatMapDriftTransformation<Self, Gold>) -> Drift<Self.Ore, Gold> {
    return FlatMapDrift(drift: self, transform: transform).asDrift()
  }

  public func flatMap<Gold>(transform: @escaping (Mineral) -> Lore<Mineral>) -> Drift<Self.Ore, Gold> {
    return FlatMapDrift(drift: self, transform: { .of(transform($0)) }).asDrift()
  }

  // flatMap(to: Rail)
  // flatMap(to: Lore)
}
