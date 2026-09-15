import SwiftUI

struct HomeView: View {
    @EnvironmentObject var settings: CameraSettings
    @State private var showInstallAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Conectează-te mai întâi la Wi-Fi-ul camerei (70mai_A800S_2.4G_57f6), apoi apasă un buton.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                cameraButton(
                    title: "Cameră spate — Parcare",
                    subtitle: "Vezi imaginea live din spate",
                    systemImage: "arrow.triangle.2.circlepath.camera.fill",
                    color: .red,
                    url: settings.rearStreamURL
                )
                .padding(.top, 4)

                cameraButton(
                    title: "Cameră față",
                    subtitle: "Vezi imaginea live din față",
                    systemImage: "camera.fill",
                    color: .blue,
                    url: settings.frontStreamURL
                )

                Button {
                    launch(settings.frontStreamURL)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        launch(settings.rearStreamURL)
                    }
                } label: {
                    Label("Deschide ambele (față apoi spate)", systemImage: "rectangle.split.2x1.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Spacer()

                Text("Video-ul se redă în aplicația VLC (gratuită, VideoLAN) — aplicația asta doar deschide fluxul RTSP corect.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .navigationTitle("DashCam Parcare")
            .alert("VLC nu pare instalat", isPresented: $showInstallAlert) {
                Button("Instalează din App Store") { VLCLauncher.openAppStore() }
                Button("Anulează", role: .cancel) {}
            } message: {
                Text("Ai nevoie de aplicația gratuită VLC ca să redai fluxul video RTSP de la cameră.")
            }
        }
    }

    @ViewBuilder
    private func cameraButton(title: String, subtitle: String, systemImage: String, color: Color, url: String) -> some View {
        Button {
            launch(url)
        } label: {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .font(.system(size: 34))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.title2).bold()
                    Text(subtitle).font(.caption).opacity(0.85)
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 90)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    private func launch(_ url: String) {
        if VLCLauncher.isInstalled() {
            VLCLauncher.open(streamURLString: url)
        } else {
            showInstallAlert = true
        }
    }
}
