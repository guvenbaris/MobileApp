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
| `tool/content/fetch_sources.dart` | Quran.com ve Tanzil verisini indirir → `tool/content/sources/` (depoda). Yalnızca kaynak güncellenirken çalıştırılır. |
| `tool/content/build_content_db.dart` | Ham veriden salt okunur `assets/db/content.sqlite` üretir ve veriyi doğrular. |
| `lib/features/quran/data/content_database.dart` | Drift şeması ve `kContentVersion`. Şema veya veri değişince sürüm artırılır. |
| `tool/content/sources/qul/` | Medine 1421H düzeni ve QCF V2 glifleri (QUL). Elle indirilir (hesap gerekir); değiştirilmeden saklanır. |
| `tool/content/check_line_widths.dart` | Düzeni sayfa fontlarıyla doğrular: `dart run tool/content/check_line_widths.dart <font_klasörü>`. Fontlar depoda olmadığı için yerelde, düzen değiştiğinde çalıştırılır. |
| `tool/content/sources/tanzil/` | Bağımsız test referansı (Tanzil); uygulamaya girmez. `fetch_sources.dart tanzil` ile güncellenir. |
| `tool/content/reference/checksums.json` | Doğrulanmış içeriğin sure başına SHA-256 değerleri (T-01). Yalnızca veri bilerek değiştirilip incelendikten sonra `dart run tool/content/update_checksums.dart` ile güncellenir. |
| `test/content/` | T-01 (metin bütünlüğü) ve T-02 (sayfa düzeni, cüz/hizb/rubu'/secde) testleri |

Kaynaklar, lisanslar ve bilinen veri durumları: `../VERI_KAYNAKLARI.md`.

**Kur'an fontu:** `assets/fonts/DigitalKhattV2.otf` (DigitalKhatt New Madina, SIL OFL 1.1; lisans metni `assets/fonts/DigitalKhatt-OFL.txt`, fontla birlikte dağıtılmalı). Ekranda gösterilen metin DigitalKhatt kelime metnidir; harfleri ve durak işaretleri T-01'de KFGQPC metniyle denetlenir.
Drift şeması değişince: `dart run build_runner build`.

## Mushaf düzeni paketleri (F1-03, TK-13)
Uygulamayla yalnız Medine 1421H düzeni gelir. Diğer düzenler **düzen paketi** olarak eklenir: içerik veritabanıyla aynı şemada, tek bir düzenin `mushaf_layouts` ve `layout_*` satırlarını taşıyan bir SQLite dosyası (`content_meta`: `packageId`, `packageKind = layout`, `packageVersion`, `wordsHash`).
- Paket, glifleri kelimelere `words.id` ile bağlar. Bu yüzden yalnızca aynı **kelime parmak izini** (`wordsHash`) taşıyan içerik veritabanıyla kabul edilir. Kelimeler değişirse paket yeniden üretilir.
- Kurulu paketler `<uygulama destek klasörü>/packages/layout/` altındadır ve kullanıcı veritabanındaki `installed_packages` tablosunda kayıtlıdır. Açılışta açılamayan paket atlanır; uygulama yerleşik düzenle devam eder.
- İndirme altyapısı F1-11'de gelecek. O zamana kadar **yalnızca `dev` sürümünde** paketi cihaza bırakarak deneyebilirsiniz. Paket bir sonraki açılışta kurulur ve klasörden silinir:
  ```sh
  adb shell mkdir -p /sdcard/Android/data/com.example.quranapp.dev/files/packages_inbox
  adb push build/packages/madani_1405_v1.sqlite /sdcard/Android/data/com.example.quranapp.dev/files/packages_inbox/
  ```
  Ardından uygulamayı kapatıp açın ve okuma ekranında ⚙ → Mushaf düzeni'nden seçin. (Git Bash'te komutların önüne `MSYS_NO_PATHCONV=1` yazın; yoksa `/sdcard` yolu Windows yoluna çevrilir. PowerShell'de gerekmez.)
- Medine 1405H paketi (yalnızca geliştirme; lisans AK-11): QUL dosyaları `tool/content/sources/qul/` altındayken `dart run tool/content/build_layout_package.dart` → `build/packages/madani_1405_v1.sqlite`.
- Paket yapısını T-02 denetler: `build/packages/*.sqlite` altındaki her paket için `flutter test test/content/t02_layout_packages_test.dart`.

## Kurallar
Mimari, kod ve test kuralları depo kökündeki `CLAUDE.md`'dedir; veri ve lisans envanteri `VERI_KAYNAKLARI.md`'de. Uygulama içi lisans sayfası: Ayarlar → Lisanslar (DigitalKhatt OFL, Tanzil telif notu, paket lisansları).

## Arayüz metinleri ve diller (F0-07)
- Metinler `lib/l10n/app_tr.arb` (şablon), `app_ar.arb`, `app_en.arb` dosyalarındadır. Yeni metin önce `app_tr.arb`'ye, sonra diğer iki dosyaya aynı anahtarla eklenir.
- Kod `flutter pub get` sırasında (veya `flutter gen-l10n` ile) `lib/l10n/generated/` altına üretilir; ekranda `context.l10n.anahtar` ile kullanılır.
- Sayılar `context.formatInt(n)`, konumlar (`2:255`) `context.formatDigits(ref)` ile yazılır; böylece seçilen rakam sistemine uyar.
- `test/l10n/` testleri: arayüz kodunda gömülü metin olmadığını ve üç ARB dosyasının aynı anahtarlara sahip olduğunu denetler. Çevrilmemesi gereken bir metin (ör. mushaftaki Arapça sure başlığı) için satıra `// l10n-ignore: gerekçe` yazılır.

## Tema ve bileşenler (F0-08)
- Renkler yalnızca `lib/core/theme/app_palette.dart`'ta (açık, sepya, koyu); ekranlarda `context.palette.<rol>` ile okunur, renk kodu yazılmaz.
- Bileşen görünümleri `buildAppTheme` (`app_theme.dart`) içinde; ortak bileşenler `lib/core/widgets/` (`AppButton`, `AppListItem`, `EmptyState`, `ErrorState`, `LoadingState`).
- `test/core/theme/contrast_test.dart` her paleti WCAG AA'ya göre denetler; yeni renk veya tema eklenince kendiliğinden kapsar.

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
| `integration_test/` | Gerçek cihazda/emülatörde uçtan uca testler. `perf_test.dart` yalnızca `flutter drive --profile` ile çalışır (aşağıda) | `flutter test integration_test/app_launch_test.dart --flavor dev` |

Ortak test yardımcıları `test/helpers/` altındadır. Arayüz testlerinde geri tuşu için `tester.pageBack()` yerine `tapBack(tester)` kullanılır (`pageBack` İngilizce "Back" ipucunu arar).

## Ölçüm ve kontrol araçları (F1-00)
| Ne | Komut | Çıktı |
|---|---|---|
| Basılı nüsha karşılaştırma paketi (7 sayfa PNG + kontrol çizelgesi) | PowerShell: `$env:PAGE_SHEET=1; flutter test test/manual/page_sheet_test.dart` | `build/page_check/` |
| Soğuk açılış (gerçek cihaz, profile) | `dart run tool/perf/startup.dart <cihaz_kimliği>` | konsol + `build/perf_startup.json` |
| Sayfa yükleme ve kaydırma kare süreleri (gerçek cihaz, profile) | `flutter drive --profile --no-dds --flavor dev --driver=test_driver/perf_driver.dart --target=integration_test/perf_test.dart -d <cihaz_kimliği>` | konsol + `build/perf_result.json` |
| Çeviri gözden geçirme tablosu | `dart run tool/l10n/export_review_sheet.dart` | `build/l10n_review.csv` |

Cihaz kimliği `flutter devices` çıktısındadır. Performans sayıları yalnızca **gerçek telefonda** anlamlıdır; emülatörün grafik birimi yazılımla taklit edilir.

## Kontroller (CI ile aynı)
```sh
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze --fatal-infos
flutter test --coverage
```

## CI (GitHub Actions)
- `.github/workflows/ci.yml`: biçim, analiz, test (kapsam özeti ve `lcov.info` çıktısı) ve iki flavor için Android derlemesi. **Her commit'te çalışmaz**: haftalık (pazartesi), PR açıldığında ve elle (Actions → CI → Run workflow). Push öncesi yukarıdaki kontrolleri yerelde çalıştırın.
- `.github/workflows/ios.yml`: iOS derlemesi ve simülatörde açılış testi. Haftalık (pazartesi) ve elle (Actions → iOS → Run workflow) çalışır.
