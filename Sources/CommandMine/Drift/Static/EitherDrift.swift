public extension Shaft {
  public static func either<LeftDrift: Shaft, RightDrift: Shaft>(
    left: LeftDrift,
    right: RightDrift
  ) -> Drift<LeftDrift.Ore, LeftDrift.Mineral>
    where LeftDrift.Ore == RightDrift.Ore, LeftDrift.Mineral == RightDrift.Mineral {
    return left.flatMapError(to: right)
  }
}
