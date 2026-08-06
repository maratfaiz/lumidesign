// swift-tools-version: 5.9

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Lumi",
    platforms: [.iOS(.v17)],
    products: [
        .iOSApplication(
            name: "Lumi",
            targets: ["AppModule"],
            bundleIdentifier: "com.lumi.app",
            displayVersion: "1.0",
            bundleVersion: "1",
            supportedDeviceFamilies: [.phone],
            supportedInterfaceOrientations: [.portrait]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "Sources"
        )
    ]
)
