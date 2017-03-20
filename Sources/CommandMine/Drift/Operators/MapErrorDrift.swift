public typealias MapErrorDriftTransformation<Drift: MineType> = (Lore<Drift.Mineral>.Error) -> Rail<Drift.Mineral>.Error

fileprivate final class MapErrorDrift<Drift: MineType>: MineType {
  typealias Transformation = MapErrorDriftTransformation<Drift>
  let transform: Transformation
  let drift: Drift

  init(drift: Drift, transform: @escaping Transformation) {
    self.drift = drift
    self.transform = transform
  }

  func mine(_ ore: Drift.Ore) -> Rail<Drift.Mineral> {
    return drift.mine(ore)
      .map { $0.mapError(transform: self.transform) }
  }
}

public extension MineType {
  public func mapError(transform: @escaping MapErrorDriftTransformation<Self>) -> Drift<Self.Ore, Self.Mineral> {
    return MapErrorDrift(drift: self, transform: transform).asDrift()
  }
}
