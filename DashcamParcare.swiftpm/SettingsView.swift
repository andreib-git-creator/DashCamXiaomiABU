import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: CameraSettings

    var body: some View {
        NavigationStack {
            Form {
                Section("Adrese RTSP (VLC)") {
                    LabeledField(title: "Cameră față", text: $settings.frontStreamURL)
                    LabeledField(title: "Cameră spate", text: $settings.rearStreamURL)
                }

                Section("Previzualizare opțională în-app (bonus)") {
                    Text("Dacă găsești o adresă HTTP de tip \"poză curentă\" (nu RTSP), o poți pune aici pentru o previzualizare rudimentară, direct în aplicație, fără VLC.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    LabeledField(title: "URL poză (opțional)", text: $settings.snapshotURL)
                    if !settings.snapshotURL.isEmpty {
                        SnapshotLiveView(urlString: settings.snapshotURL, refreshInterval: settings.refreshInterval)
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Section {
                    Text("Router / gateway confirmat al camerei tale: 192.168.1.1 (verificat din setările Wi-Fi ale iPhone-ului).")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Setări")
        }
    }
}

private struct LabeledField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            TextField(title, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(.body, design: .monospaced))
        }
    }
}
