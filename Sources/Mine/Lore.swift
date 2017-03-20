/// An event wrapper around `Mineral`s.
public enum Lore<Mineral> {
  public typealias Usage = String
  public typealias Error = Swift.Error

  // success
  case success(Mineral)
  // usage
  case usage(Usage)
  // error
  case error(Error)
}

public extension Lore {
  public func map<Gold>(transform: @escaping (Mineral) -> Gold) -> Lore<Gold> {
    switch self {
    case let .success(intermediate):
      return .success(transform(intermediate))
    case let .usage(instructions):
      return .usage(instructions)
    case let .error(cause):
      return .error(cause)
    }
  }

  public func mapError(transform: @escaping (Error) -> Error) -> Lore<Mineral> {
    switch self {
    case let .success(intermediate):
      return .success(intermediate)
    case let .usage(instructions):
      return .usage(instructions)
    case let .error(cause):
      return .error(transform(cause))
    }
  }

  public func mapUsage(transform: @escaping (Usage) -> Usage) -> Lore<Mineral> {
    switch self {
    case let .success(intermediate):
      return .success(intermediate)
    case let .usage(instructions):
      return .usage(transform(instructions))
    case let .error(cause):
      return .error(cause)
    }
  }

  public func flatMap<Gold>(transform: @escaping (Mineral) -> Lore<Gold>) -> Lore<Gold> {
    switch self {
    case let .success(intermediate):
      return transform(intermediate)
    case let .usage(instructions):
      return .usage(instructions)
    case let .error(cause):
      return .error(cause)
    }
  }

  public func flatMap<Gold>(transform: @escaping (Mineral) -> Rail<Gold>) -> Rail<Gold> {
    switch self {
    case let .success(intermediate):
      return transform(intermediate)
    case let .usage(instructions):
      return .of(.usage(instructions))
    case let .error(cause):
      return .of(.error(cause))
    }
  }

  public func flatMapUsage(transform: @escaping (Usage) -> Lore<Mineral>) -> Lore<Mineral> {
    switch self {
    case let .success(intermediate):
      return .success(intermediate)
    case let .usage(instructions):
      return transform(instructions)
    case let .error(cause):
      return .error(cause)
    }
  }

  public func flatMapUsage(transform: @escaping (Usage) -> Rail<Mineral>) -> Rail<Mineral> {
    switch self {
    case let .success(intermediate):
      return .of(.success(intermediate))
    case let .usage(instructions):
      return transform(instructions)
    case let .error(cause):
      return .of(.error(cause))
    }
  }

  public func flatMapError(transform: @escaping (Error) -> Lore<Mineral>) -> Lore<Mineral> {
    switch self {
    case let .success(intermediate):
      return .success(intermediate)
    case let .usage(instructions):
      return .usage(instructions)
    case let .error(cause):
      return transform(cause)
    }
  }

  public func flatMapError(transform: @escaping (Error) -> Rail<Mineral>) -> Rail<Mineral> {
    switch self {
    case let .success(intermediate):
      return .of(.success(intermediate))
    case let .usage(instructions):
      return .of(.usage(instructions))
    case let .error(cause):
      return transform(cause)
    }
  }
}
