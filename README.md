# HabitTracker – iOS (SwiftUI + VIPER/Clean Swift)

> **v0.1 – İlk sürüm**  
> Bu repo, turuncu/siyah marka temalı, animasyonlu bir **alışkanlık takip** uygulamasının ilk versiyonudur.  
> Iteratif geliştiriyorum — ilerleyen sürümlerde UI/UX iyileştirmeleri, yeni animasyonlar ve ek modüller gelecek.

---

## İçindekiler
- [Özellikler](#özellikler)
- [Teknoloji Yığını](#teknoloji-yığını)
- [Mimari](#mimari)
- [Klasör Yapısı](#klasör-yapısı)
- [Kurulum & Çalıştırma](#kurulum--çalıştırma)
- [Testler](#testler)
- [Ekran Görüntüleri](#ekran-görüntüleri)
- [Yol Haritası](#yol-haritası)
- [Lisans](#lisans)
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

## Teknoloji Yığını
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
