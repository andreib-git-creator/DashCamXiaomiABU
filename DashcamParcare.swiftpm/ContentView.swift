import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Acasă", systemImage: "house.fill") }

            ParkingView()
                .tabItem { Label("Parcare", systemImage: "arrow.triangle.2.circlepath.camera.fill") }

            DiscoveryView()
                .tabItem { Label("Descoperă adresă", systemImage: "wifi.router.fill") }

            SettingsView()
                .tabItem { Label("Setări", systemImage: "gearshape.fill") }
        }
    }
}
