// swift-tools-version:5.3.0
import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/apple/swift-format", .branch("swift-5.3-branch"))
    ]
)
