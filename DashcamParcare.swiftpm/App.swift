import SwiftUI

@main
struct DashcamParcareApp: App {
    @StateObject private var settings = CameraSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
