# quran_app

Kur'an okuma, hafızlık ve günlük eğitim uygulaması (Flutter).
Gereksinimler: `../Proje_Gereksinimleri.md` · Yol haritası: `../Yol_Haritasi.md` · Faz planları: `../Fazlar/`

## Gereksinimler
- Flutter (stable) — `flutter --version`
- Android Studio + Android SDK (cmdline-tools dahil), minSdk 24
- iOS derlemesi macOS gerektirir (iOS 15+); bu proje CI'daki macOS makinesiyle derlenir.

## Ortamlar (flavor)
| Flavor | Giriş noktası | Paket adı | Servisler |
|---|---|---|---|
| `dev` | `lib/main_dev.dart` | `com.example.quranapp.dev` | Sahte (Fake…) |
| `prod` | `lib/main_prod.dart` | `com.example.quranapp` | Gerçek |

> Paket adı geçicidir; ilk mağaza yüklemesinden önce kalıcı adla değiştirilir.

## Çalıştırma
```sh
flutter pub get
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor prod -t lib/main_prod.dart
```
iOS'ta flavor şemaları henüz yok; yalnızca `-t` ile hedef seçilir: `flutter run -t lib/main_dev.dart`.

**VS Code:** depo kökünü açın; Çalıştır ve Hata Ayıkla panelinde `dev`, `prod`, `prod (release)` profilleri hazırdır.

## Kontroller
```sh
dart format .
flutter analyze
flutter test
```
