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

## İlk kurulum
İçerik veritabanı depoda yoktur, kaynak veriden üretilir. Klonladıktan sonra ve `tool/content/` değiştiğinde bir kez çalıştırın:
```sh
flutter pub get
dart run tool/content/build_content_db.dart   # → assets/db/content.sqlite
```

## Kur'an içerik verisi (F0-03)
| Dosya | Görev |
|---|---|
| `tool/content/fetch_sources.dart` | Ham veriyi Quran.com API'den indirir → `tool/content/sources/quran_com/` (depoda). Yalnızca kaynak güncellenirken çalıştırılır. |
| `tool/content/build_content_db.dart` | Ham veriden salt okunur `assets/db/content.sqlite` üretir ve veriyi doğrular. |
| `lib/features/quran/data/content_database.dart` | Drift şeması ve `kContentVersion`. Şema veya veri değişince sürüm artırılır. |

Kaynaklar, lisanslar ve bilinen veri durumları: `../VERI_KAYNAKLARI.md`.
Drift şeması değişince: `dart run build_runner build`.

## Çalıştırma
```sh
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor prod -t lib/main_prod.dart
```
iOS'ta flavor şemaları henüz yok; yalnızca `-t` ile hedef seçilir: `flutter run -t lib/main_dev.dart`.

**VS Code:** depo kökünü açın; Çalıştır ve Hata Ayıkla panelinde `dev`, `prod`, `prod (release)` profilleri hazırdır.

## Testler
| Klasör | Tür | Çalıştırma |
|---|---|---|
| `test/` | Birim ve widget testleri; klasör yapısı `lib/` ile aynıdır | `flutter test` |
| `integration_test/` | Gerçek cihazda/emülatörde uçtan uca testler | `flutter test integration_test --flavor dev` |

Ortak test yardımcıları `test/helpers/` altındadır.

## Kontroller (CI ile aynı)
```sh
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze --fatal-infos
flutter test --coverage
```

## CI (GitHub Actions)
- `.github/workflows/ci.yml`: biçim, analiz, test (kapsam özeti ve `lcov.info` çıktısı) ve iki flavor için Android derlemesi. **Her commit'te çalışmaz**: haftalık (pazartesi), PR açıldığında ve elle (Actions → CI → Run workflow). Push öncesi yukarıdaki kontrolleri yerelde çalıştırın.
- `.github/workflows/ios.yml`: iOS derlemesi ve simülatörde açılış testi. Haftalık (pazartesi) ve elle (Actions → iOS → Run workflow) çalışır.
