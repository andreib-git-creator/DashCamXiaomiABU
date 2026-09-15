import SwiftUI
import UIKit

struct DiscoveryView: View {
    @EnvironmentObject var settings: CameraSettings
    @State private var showInstallAlert = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Adresa RTSP exactă a A800S nu e documentată public. Mai jos sunt adrese folosite de ALTE modele 70mai (surse indicate) plus câteva variante ghicite pentru routerul tău (192.168.1.1). Testează-le pe rând — apasă \"Testează în VLC\" și vezi dacă apare imagine.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Candidați") {
                    ForEach(KnownCandidates.list) { candidate in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(candidate.label).font(.subheadline.bold())
                            Text(candidate.url)
                                .font(.system(.footnote, design: .monospaced))
                                .foregroundStyle(.primary)
                            Text("Sursă: \(candidate.source)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            HStack {
                                Button("Testează în VLC") { test(candidate.url) }
                                    .buttonStyle(.borderedProminent)
                                Button("Copiază") {
                                    UIPasteboard.general.string = candidate.url
                                }
                                .buttonStyle(.bordered)
                            }
                            .font(.footnote)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Ce faci cu adresa care funcționează") {
                    Text("Du-te în tab-ul Setări și lipește adresa validă la \"Cameră față\" sau \"Cameră spate\", după ce ai identificat care e care (de obicei se disting după numărul canalului: 1 = față, 2 = spate, sau invers — verifici vizual în VLC).")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("Dacă niciun candidat nu merge") {
                    Text("Cea mai sigură metodă e să vezi ce adresă folosește chiar aplicația oficială 70mai: conectează telefonul la Wi-Fi-ul camerei, pornește un instrument de captură trafic local (ex. un proxy HTTP/RTSP pe un laptop din aceeași rețea) cât timp aplicația oficială redă imaginea live, și citești acolo adresa reală cerută.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Descoperă adresa")
            .alert("VLC nu pare instalat", isPresented: $showInstallAlert) {
                Button("Instalează din App Store") { VLCLauncher.openAppStore() }
                Button("Anulează", role: .cancel) {}
            } message: {
                Text("Ai nevoie de aplicația gratuită VLC ca să testezi fluxul RTSP.")
            }
        }
    }

    private func test(_ url: String) {
        if VLCLauncher.isInstalled() {
            VLCLauncher.open(streamURLString: url)
        } else {
            showInstallAlert = true
        }
    }
}
