public final class Mine<Ore, Mineral>: MineType {
  public typealias MineShaft = (Ore) -> Rail<Mineral>

  private let mineShaft: MineShaft

  public init(fromMineShaft mineShaft: @escaping MineShaft) {
    self.mineShaft = mineShaft
  }

  public func mine(_ ore: Ore) -> Rail<Mineral> {
    return mineShaft(ore)
  }
}
