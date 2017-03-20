public extension MineType {
  public static func either<LeftMine: MineType, RightMine: MineType>(
    left: LeftMine,
    right: RightMine
  ) -> Mine<LeftMine.Ore, LeftMine.Mineral>
    where LeftMine.Ore == RightMine.Ore, LeftMine.Mineral == RightMine.Mineral {
    return left.flatMapError(to: right)
  }
}
