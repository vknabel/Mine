public typealias FlatMapErrorDriftTransformation<Drift: MineType> = (Lore<Drift.Mineral>.Error) -> Rail<Drift.Mineral>

fileprivate final class FlatMapErrorDrift<Drift: MineType>: MineType {
  typealias Transformation = FlatMapErrorDriftTransformation<Drift>
  let transform: Transformation
  let drift: Drift

  init(drift: Drift, transform: @escaping Transformation) {
    self.drift = drift
    self.transform = transform
  }

  func mine(_ ore: Drift.Ore) -> Rail<Drift.Mineral> {
    return drift.mine(ore)
      .map { $0.flatMapError(transform: self.transform) }
  }
}

public extension MineType {
  public func flatMapError(transform: @escaping FlatMapErrorDriftTransformation<Self>) -> Drift<Self.Ore, Self.Mineral> {
    return FlatMapErrorDrift(drift: self, transform: transform).asDrift()
  }

  public func flatMapError<AnyDrift: MineType>(to drift: AnyDrift) -> Drift<Ore, Mineral>
  where AnyDrift.Ore == Ore, AnyDrift.Mineral == Mineral {
    return Drift { ore in
      self.flatMapError { _ in drift.mine(ore) }
    }
  }
}
