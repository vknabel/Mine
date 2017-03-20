import PackageDescription

let package = Package(
  name: "Mine",
  dependencies: [
    .Package(url: "https://github.com/ReactiveX/RxSwift.git", majorVersion: 3, minor: 2),
    // Dependency injection.
    .Package(url: "https://github.com/vknabel/EasyInject.git", "1.1.0"),

    // Testing library.
    .Package(url: "https://github.com/vknabel/Taps.git", "0.2.3")
  ]
)
