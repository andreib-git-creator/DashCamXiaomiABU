import SwiftUI

// Ecran dedicat, cât mai simplu, pentru parcarea cu spatele: un singur
// buton mare care deschide direct fluxul camerei din spate în VLC.
// Fără oglindire și fără ghidaje suprapuse — doar imagine live, conform
// cerinței.
struct ParkingView: View {
    @EnvironmentObject var settings: CameraSettings
    @State private var showInstallAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                .font(.system(size: 90))
                .foregroundStyle(.red)

            Text("Parcare cu spatele")
                .font(.largeTitle.bold())

            Text("Apasă butonul pentru imaginea live din spate")
                .foregroundStyle(.secondary)

            Button {
                if VLCLauncher.isInstalled() {
                    VLCLauncher.open(streamURLString: settings.rearStreamURL)
                } else {
                    showInstallAlert = true
                }
            } label: {
                Text("Deschide camera spate")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal)

            Spacer()

            Text("Sfat iPad: folosește Split View — ține aplicația asta deschisă pe jumătate de ecran și VLC pe cealaltă jumătate, ca să nu comuți între ele.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .alert("VLC nu pare instalat", isPresented: $showInstallAlert) {
            Button("Instalează din App Store") { VLCLauncher.openAppStore() }
            Button("Anulează", role: .cancel) {}
        } message: {
            Text("Ai nevoie de aplicația gratuită VLC ca să redai fluxul video RTSP de la cameră.")
        }
    }
}
