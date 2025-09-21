# HabitTracker – iOS (SwiftUI + VIPER/Clean Swift)

> **v0.1 – İlk sürüm**  
> Bu repo, turuncu/siyah marka temalı, animasyonlu bir **alışkanlık takip** uygulamasının ilk versiyonudur.  
> Iteratif geliştiriyorum — ilerleyen sürümlerde UI/UX iyileştirmeleri, yeni animasyonlar ve ek modüller gelecek.

---

## İçindekiler
- [Özellikler](#özellikler)
- [Teknolojiler](#teknolojiler)
- [Mimari](#mimari)
- [Klasör Yapısı](#klasör-yapısı)
- [Ekran Görüntüleri](#ekran-görüntüleri)
- [Yol Haritası](#yol-haritası)
- [English Summary](#english-summary)

---

## Özellikler
- **Dashboard**
  - Dairesel **progress ring** (UIKit + CoreAnimation)
  - %100 olduğunda **confetti** animasyonu + **glow** efekti
  - Günlük motivasyon sözü
- **Habit Cards**
  - Her alışkanlık için **cam efektli kart** tasarımı
  - **Custom toggle** (bounce + haptic feedback)
  - İkon animasyonları (örn. `drop`, `book`, `dumbbell`)
- **Insights**
  - Haftalık ilerleme: **custom bar chart** (UIKit + CoreAnimation)
  - Aylık trend: **Swift Charts** (+ Combine)
- **Tema**
  - **Turuncu/Siyah** marka teması (degrade arkaplan, neon vurgular)
  - Splash (giriş) animasyonu + marka yazımı
- **Veri Kalıcılığı**
  - **Core Data** ile yerel depolama
- **WidgetKit (opsiyonel)**
  - Ana ekranda progress ring + motivasyon sözü (App Groups eklenince canlı veri)
- **Testler**
  - Unit test örnekleri (alışkanlık ekleme/silme/tamamlama, ilerleme hesaplama)

---

## Teknolojiler
- **Swift 5.10**, **iOS 17+**, **Xcode 15+**
- **SwiftUI** (UI), **VIPER/Clean Swift (VIP)** mimarisi
- **UIKit + CoreAnimation** (özel animasyonlar ve grafikler)
- **Swift Charts** (Aylık trend)
- **Core Data** (Persistence)
- **WidgetKit** (opsiyonel)
- **XCTest** (Unit test)

---

## Mimari
- **VIP (Clean Swift / VIPER-hybrid):**
  - **Interactor** – iş mantığı ve use-case’ler
  - **Presenter** – ViewModel sunumu / state
  - **Router** – ekran bileşenlerini bağlama (SwiftUI entry point’leri)
- **SwiftUI View’lar** hafif tutuldu; durum `@ObservedObject` Presenter’lardan gelir.
- **UIKit köprüleri** `UIViewRepresentable` ile (Progress ring, Bar chart, Confetti).

---

## Klasör Yapısı
HabitTracker/
├── App/
│ ├── HabitTrackerApp.swift # Root & TabView
│ └── SplashView.swift # AnimatedBrand + Splash
├── Core/
│ ├── Persistence/
│ │ ├── PersistenceController.swift
│ │ └── HabitRepository.swift
│ └── Utils/
│ ├── Theme.swift # Orange/Black theme
│ ├── Haptics.swift
│ ├── Animations/
│ │ ├── ProgressRingView.swift
│ │ ├── ConfettiView.swift
│ │ ├── BouncyToggleStyle.swift
│ │ └── BarChartUIKitView.swift
│ └── Extensions/
│ ├── Date+Ext.swift
│ └── Array+Safe.swift
├── Modules/
│ ├── Dashboard/
│ ├── HabitList/
│ └── Insights/
├── Widgets/ (opsiyonel)
└── Tests/
├── HabitRepositoryTests.swift
└── HabitUseCaseTests.swift

## Yol Haritası
- App Groups ile Widget’ın canlı veriyi okuması
- Çoklu dil (Localizable.strings)
- Lottie efektleri (ikon/splash/konfetti varyasyonları)
- iCloud Sync (Core Data + CloudKit)
- Erişilebilirlik (Dynamic Type, VoiceOver etiketleri)
- UI/UX cila (mikro animasyonlar, boş durum ekranları)

## English Summary
v0.1 – First release
A bold habit tracker with an orange/black brand theme, custom animations, and a VIPER/Clean Swift-inspired architecture. More updates and UI/UX polish are planned.
Features
Dashboard: Circular progress ring (UIKit+CoreAnimation), confetti + glow at 100%, daily quote
Habit Cards: Glassmorphism cards, custom toggle (bounce + haptics), animated icons
Insights: Weekly custom bar chart (UIKit+CoreAnimation), Monthly trend via Swift Charts
Theme: Orange/Black brand theme, splash animation & logo lettering
Persistence: Core Data
WidgetKit (optional): Home screen progress ring + quote (live data with App Groups)
Tests: Unit tests (add/delete/complete, progress calc)
