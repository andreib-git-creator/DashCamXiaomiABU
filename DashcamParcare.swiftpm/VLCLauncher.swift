import SwiftUI
import UIKit

enum VLCLauncher {
    // Vezi README: VLC pentru iOS (App Store, gratuit, VideoLAN) redă nativ
    // fluxuri RTSP — folosim schema lui de URL "vlc://<url original>" ca să
    // pornim direct redarea, fără să scriem propriul decodor video.
    static let appStoreURL = URL(string: "https://apps.apple.com/app/vlc-media-player/id650377962")!

    static func isInstalled() -> Bool {
        guard let url = URL(string: "vlc://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    static func open(streamURLString: String) {
        guard !streamURLString.isEmpty,
              let deepLink = URL(string: "vlc://\(streamURLString)") else { return }
        UIApplication.shared.open(deepLink)
    }

    static func openAppStore() {
        UIApplication.shared.open(appStoreURL)
    }
}
