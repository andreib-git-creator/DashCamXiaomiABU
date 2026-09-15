import SwiftUI
import UIKit

// Previzualizare opțională, în-app: dacă descoperi o adresă HTTP de tip
// "snapshot" (o poză statică) pe cameră, o poți seta în Setări și acest
// ecran o va reîmprospăta automat, ca o imitație rudimentară de flux live
// (câțiva fps), direct în aplicație, fără VLC. E un bonus — sursa reală
// de video fluid rămâne VLC prin RTSP (vezi butoanele din Acasă/Parcare).
struct SnapshotLiveView: View {
    let urlString: String
    let refreshInterval: Double

    @State private var image: UIImage?
    @State private var lastError: String?
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color.black
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                VStack(spacing: 8) {
                    ProgressView()
                        .tint(.white)
                    if let lastError {
                        Text(lastError)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear { start() }
        .onDisappear { stop() }
    }

    private func start() {
        stop()
        fetch()
        timer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { _ in
            fetch()
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func fetch() {
        guard let url = URL(string: urlString) else {
            lastError = "Adresă invalidă."
            return
        }
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 2

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    self.lastError = "Nu se poate conecta: \(error.localizedDescription)"
                }
                return
            }
            guard let data, let uiImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.lastError = "Răspuns primit, dar nu e o imagine validă."
                }
                return
            }
            DispatchQueue.main.async {
                self.image = uiImage
                self.lastError = nil
            }
        }.resume()
    }
}
