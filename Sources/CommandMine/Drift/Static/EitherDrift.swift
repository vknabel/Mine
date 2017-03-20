public extension MineType {
  public static func either<LeftDrift: MineType, RightDrift: MineType>(
    left: LeftDrift,
    right: RightDrift
  ) -> Drift<LeftDrift.Ore, LeftDrift.Mineral>
    where LeftDrift.Ore == RightDrift.Ore, LeftDrift.Mineral == RightDrift.Mineral {
    return left.flatMapError(to: right)
  }
}
