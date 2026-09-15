# DashCam Parcare — 70mai A800S (față + spate)

Aplicație SwiftUI pentru iPhone/iPad, scrisă ca **App Playground** (`.swiftpm`),
ca să poată fi compilată și instalată direct din **Swift Playgrounds pe iPad**,
fără Mac și fără Xcode.

## Ce face

- Butoane mari: **Cameră spate — Parcare**, **Cameră față**, **Ambele**.
- Deschide fluxul video **RTSP** al camerei direct în aplicația **VLC**
  (gratuită, App Store, dezvoltator VideoLAN) — video real, fluid, decodat
  de VLC, nu de o implementare proprie.
- Ecran **Descoperă adresă**: listă de adrese RTSP candidate + buton de test
  rapid în VLC, pentru că adresa exactă a A800S nu e documentată public.
- Ecran **Setări**: salvează adresele care funcționează la tine, plus o
  previzualizare opțională în-app (bonus) dacă găsești un URL de tip
  „poză curentă” pe cameră.

## De ce prin VLC și nu redare video „nativă” în aplicație

Trei constrângeri tehnice reale, verificate în timpul dezvoltării:

1. **Safari/orice pagină web nu poate reda RTSP** — `<video>` acceptă doar
   HTTP/HLS/MP4, nu protocolul RTSP. De-asta nu am făcut o aplicație web.
2. **Librăria standard pentru RTSP pe iOS (VLCKit/MobileVLCKit) nu se poate
   folosi în Swift Playgrounds** — Playgrounds nu încarcă pachete Swift cu
   framework-uri binare (`.xcframework`); e o limitare documentată, raportată
   de dezvoltatori pe forumul Apple Developer („Failed to resolve package
   graph” la orice pachet cu binary target).
3. **AVPlayer (framework-ul video nativ Apple) nu suportă RTSP.**

Singura cale rămasă, fiabilă și fără Mac, e să las decodarea video în seama
unei aplicații gata construite care ȘTIE să facă RTSP: **VLC pentru iOS**,
care suportă oficial „Open Network Stream” cu `rtsp://` (documentat pe
videolan.org). Aplicația asta e doar un „lansator" rapid către VLC, cu
adresele corecte deja completate.

## Pas 1 — instalează VLC (o singură dată)

App Store → caută „VLC media player" (VideoLAN) → Instalează. Gratuit.

## Pas 2 — găsește adresa RTSP reală a camerei tale

Routerul confirmat al camerei tale: **192.168.1.1** (Wi-Fi:
`70mai_A800S_2.4G_57f6`, parolă `19959896`).

Adresa RTSP **exactă** a A800S nu e documentată public — modelele 70mai
documentate folosesc adrese diferite:

| Model | Adresă RTSP | Sursă |
|---|---|---|
| 70mai 1S | `rtsp://192.72.1.1/liveRTSP/av4` | alu.dog — „Reverse engineering the 70mai app" |
| 70mai M300 | `rtsp://192.168.0.1:554/livestream/12` | forum DashCamTalk — „70mai Pro RTSP stream & photo capture" |
| A800S | **necunoscută**, router diferit (192.168.1.1) | — |

Ce faci:

1. Conectează iPhone/iPad la `70mai_A800S_2.4G_57f6`.
2. Deschide VLC → **Network** → **Open Network Stream**.
3. Încearcă pe rând adresele din tab-ul **Descoperă adresă** al aplicației
   (au buton „Testează în VLC" care le deschide direct).
4. Cea care arată imagine e cea bună. De obicei există două canale
   (față/spate) — le identifici vizual.
5. Adaugă-le în tab-ul **Setări** al aplicației.

Dacă niciuna nu merge: cea mai sigură metodă e să vezi ce adresă cere chiar
aplicația oficială 70mai cât timp redă imaginea live (captură de trafic
local pe rețeaua camerei) — aplicația oficială trebuie să vorbească cu
camera prin ceva, iar acel „ceva" e adresa reală.

## Pas 3 — instalează aplicația pe iPad, prin Swift Playgrounds

1. Descarcă/clonează acest repo pe iPad (prin aplicația **Files**, sau
   aplicația **GitHub**, sau **Working Copy**).
2. În **Files**, deschide folderul `DashcamParcare.swiftpm`.
3. Apasă pe el → **Open in Playgrounds** (Swift Playgrounds trebuie să fie
   deja instalat, gratuit, din App Store).
4. În Swift Playgrounds, apasă **Run** (▶). Prima dată îți cere să te
   autentifici cu Apple ID (gratuit) ca să semneze aplicația pentru
   dispozitivul tău.
5. Aplicația rulează/se instalează direct pe iPad.

**Notă:** acest pas funcționează garantat doar pe **iPad**, deoarece Swift
Playgrounds nu există pe iPhone. Ca să ajungă și pe iPhone ai nevoie fie de
un Mac cu Xcode (instalare prin cablu, cont Apple ID gratuit ajunge), fie de
un cont Apple Developer Program (99$/an) + TestFlight. Spune-mi dacă vrei să
configurez varianta TestFlight (pot pregăti un workflow GitHub Actions care
compilează automat, dar tu trebuie să faci înscrierea la Developer Program).

Pe termen scurt, **VLC singur, cu adresa RTSP salvată ca Favorit**, merge
identic pe iPhone ȘI iPad, fără nimic din pasul 3 — util imediat, chiar
înainte de a instala aplicația asta.

## Structura proiectului

```
DashcamParcare.swiftpm/
  Package.swift          — manifest App Playground (iOS, .iOSApplication)
  Info-Additions.plist   — permisiune rețea locală + excepție ATS pt. HTTP local
  App.swift              — punct de intrare
  ContentView.swift       — tab bar (Acasă / Parcare / Descoperă adresă / Setări)
  HomeView.swift          — butoanele față/spate/ambele
  ParkingView.swift       — ecran dedicat, mare, pentru camera spate
  DiscoveryView.swift     — lista de adrese candidate + test rapid
  SettingsView.swift      — salvare adrese + previzualizare opțională
  CameraSettings.swift    — persistare (UserDefaults) + lista de candidați
  SnapshotLiveView.swift  — previzualizare bonus prin polling HTTP (opțional)
  VLCLauncher.swift       — deschide VLC prin schema vlc://
```

## Limitări cunoscute

- Nu am putut testa nimic pe camera reală (mediul în care am scris codul nu
  are acces la rețeaua ta locală) — testarea adreselor RTSP se face doar de
  tine, pe teren.
- Schema `vlc://` uneori afișează un pop-up de confirmare în VLC înainte să
  pornească redarea (comportament documentat pe forumul VideoLAN) — un tap
  în plus, nu o eroare.
- Previzualizarea din Setări (SnapshotLiveView) funcționează doar dacă
  găsești o adresă HTTP separată de tip „poză curentă" pe cameră; nu e
  garantat că A800S expune așa ceva.
