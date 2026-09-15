// swift-tools-version: 5.9

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "DashcamParcare",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "DashcamParcare",
            targets: ["AppModule"],
            bundleIdentifier: "ro.andreib.dashcamparcare",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft
            ],
            additionalInfoPlistContentFilePath: "Info-Additions.plist"
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)
