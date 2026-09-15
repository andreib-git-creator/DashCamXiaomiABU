import SwiftUI
import Combine

final class CameraSettings: ObservableObject {
    @Published var frontStreamURL: String {
        didSet { UserDefaults.standard.set(frontStreamURL, forKey: Keys.front) }
    }
    @Published var rearStreamURL: String {
        didSet { UserDefaults.standard.set(rearStreamURL, forKey: Keys.rear) }
    }
    @Published var snapshotURL: String {
        didSet { UserDefaults.standard.set(snapshotURL, forKey: Keys.snapshot) }
    }
    @Published var refreshInterval: Double {
        didSet { UserDefaults.standard.set(refreshInterval, forKey: Keys.refresh) }
    }

    private enum Keys {
        static let front = "frontStreamURL"
        static let rear = "rearStreamURL"
        static let snapshot = "snapshotURL"
        static let refresh = "refreshInterval"
    }

    init() {
        let defaults = UserDefaults.standard
        self.frontStreamURL = defaults.string(forKey: Keys.front) ?? "rtsp://192.168.1.1/liveRTSP/av4/track1"
        self.rearStreamURL = defaults.string(forKey: Keys.rear) ?? "rtsp://192.168.1.1/liveRTSP/av4/track2"
        self.snapshotURL = defaults.string(forKey: Keys.snapshot) ?? ""
        self.refreshInterval = defaults.object(forKey: Keys.refresh) as? Double ?? 0.4
    }
}

struct StreamCandidate: Identifiable {
    let id = UUID()
    let label: String
    let url: String
    let source: String
}

enum KnownCandidates {
    // Adrese RTSP culese din surse publice pentru ALTE modele 70mai.
    // Niciuna NU e confirmată oficial pentru A800S — routerul tău (192.168.1.1)
    // diferă de cel din sursele de mai jos, deci trebuie testate una câte una.
    static let list: [StreamCandidate] = [
        StreamCandidate(
            label: "70mai 1S — canal unic",
            url: "rtsp://192.72.1.1/liveRTSP/av4",
            source: "alu.dog — Reverse engineering the 70mai app"
        ),
        StreamCandidate(
            label: "70mai M300 — canal unic",
            url: "rtsp://192.168.0.1:554/livestream/12",
            source: "DashCamTalk forum — 70mai Pro RTSP stream & photo capture"
        ),
        StreamCandidate(
            label: "A800S (router 192.168.1.1) — ghicit, tipar 1S",
            url: "rtsp://192.168.1.1/liveRTSP/av4/track1",
            source: "Neconfirmat — extrapolare după tiparul 1S"
        ),
        StreamCandidate(
            label: "A800S (router 192.168.1.1) — ghicit, canal spate",
            url: "rtsp://192.168.1.1/liveRTSP/av4/track2",
            source: "Neconfirmat — extrapolare după tiparul 1S"
        ),
        StreamCandidate(
            label: "A800S — ghicit, tipar M300",
            url: "rtsp://192.168.1.1:554/livestream/11",
            source: "Neconfirmat — extrapolare după tiparul M300"
        )
    ]
}
