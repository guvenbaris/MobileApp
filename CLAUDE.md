# CLAUDE.md

Bu dosya projede çalışan herkes (insan ya da yapay zekâ) içindir: mimari, kararlar, kod ve test kuralları. Ayrıntı ve gerekçeler bağlantılı dokümanlardadır; burada yalnızca **uyulması gerekenler** ve **nereye bakılacağı** yazar.

## Proje
Flutter ile Kur'an okuma, hafızlık ve (ileride) ücretli günlük eğitim uygulaması. Uygulama klasörü `quran_app/`, Dart paket adı `quran_app`. Uygulama adı henüz kararlaştırılmadı (AK-04); geçici görünen ad "Kur'an". Geçici paket kimliği `com.example.quranapp`; ilk mağaza yüklemesinden önce değişecek, kişisel ad kullanılmayacak.

**Dil:** Dokümanlar, kod yorumları ve test adları Türkçe. Kod adları (sınıf, değişken, dosya) İngilizce. Commit mesajları İngilizce.

## Dokümanlar
| Dosya | Ne için |
|---|---|
| `Proje_Gereksinimleri.md` | Ne yapılacak: ilkeler, yasaklar, gereksinim kodları (M1-01…, NF-…, MK-…, İÇ-…, T-…), açık kararlar (AK-xx) |
| `Yol_Haritasi.md` | Fazlar ve durumları; faz geçiş kuralları |
| `Fazlar/Faz_N.md` | Fazın iş paketleri ve kutucukları. Faz dosyası yalnızca o faza başlarken yazılır (`Faz_0.md` şablondur). |
| `Fazlar/Faz_N_Notlar.md` | Her iş paketinde ne yapıldığı, neden, dosyalar, bilinen sorunlar; sonda "Genel durum ve bekleyen kararlar" |
| `Ekran_Tasarimi.md` | Tüm fazların ekranları (E-01…E-29), bilgi mimarisi, etkileşim kuralları, bileşen kataloğu. Yeni ekran yazılmadan önce ilgili E-xx bölümü okunur; tasarım değişirse belge güncellenir. |
| `VERI_KAYNAKLARI.md` | Veri ve lisans envanteri: her kaynak, indirilen dosya, veritabanı alanı ve lisans yükümlülüğü |
| `quran_app/README.md` | Kurulum, çalıştırma, komutlar |

**Çalışma düzeni:**
- Yeni oturumda önce yürüyen fazın dosyası (`Fazlar/Faz_N.md`, kutucuklar), notları (`Faz_N_Notlar.md`, son bölüm) ve `VERI_KAYNAKLARI.md` okunur. Faz 0 kapandı (29.10.2026); yürüyen faz **Faz 1**.
- Her iş paketi bitince:
  - faz dosyasındaki kutucuklar işaretlenir,
  - notlar dosyasına bölüm eklenir ve genel durum tablosu güncellenir,
  - karar değiştiyse ilgili dokümanın değişiklik geçmişine yazılır.
- **Commit ve push'u kullanıcı yapar.** Adım sonunda hazır bir commit mesajı önerilir.
- Backend (ASP.NET Core) kullanıcı tarafından, veri modeli dondurulduktan sonra yazılacak. O zamana kadar mobil taraf sahte servislerle ilerler.

## Depo yapısı
```
/                      Dokümanlar, .github/workflows (ci.yml, ios.yml), .vscode
quran_app/
  lib/
    main_dev.dart, main_prod.dart   Giriş noktaları (flavor); main.dart = dev
    bootstrap.dart                  Ortak başlangıç: veritabanları, lisans kaydı, sağlayıcılar, hata yakalama
    app.dart                        MaterialApp: router, dil, tema
    core/                           Özellikten bağımsız altyapı
      config/ crash/ database/ diagnostics/ logging/ result/ routing/
      l10n/                         Dil seçimi, sayı biçimi, context.l10n
      theme/                        Palet, tema üretici, tipografi, ölçüler
      widgets/                      Ortak bileşenler (AppButton, AppListItem, durum ekranları)
    features/<özellik>/             auth, billing, lessons, me, memorize, quran, reader, settings, sync, today, user_data
      domain/                       Modeller ve arayüzler (Flutter'a bağımlı değil)
      data/                         Arayüz uygulamaları (Drift, sahte servisler)
      application/                  Riverpod sağlayıcıları, Notifier'lar, ayarlar
      presentation/                 Ekranlar ve widget'lar
    l10n/                           app_tr.arb (şablon), app_ar.arb, app_en.arb; generated/ (üretilen)
  test/                             lib/ yapısını izler; helpers/ ortak yardımcılar; content/ T-01, T-02
  integration_test/                 Cihaz/emülatör testleri
  tool/content/                     İçerik veritabanı üretimi ve kaynak veriler (uygulamaya girmez)
  assets/db/content.sqlite          Üretilen içerik veritabanı (git dışında)
  assets/fonts/                     DigitalKhatt fontu + OFL lisansı
  drift_schemas/                    Kullanıcı veritabanı şema fotoğrafları (migration testleri)
```

## Mimari
- **Feature-first + katmanlar (TK-04):** `presentation → application → domain ← data`.
  - `domain` hiçbir katmana bağımlı değildir.
  - `presentation` veriye doğrudan değil, `application`'daki sağlayıcılar üzerinden erişir.
  - `data` katmanını yalnızca aynı özelliğin `application` katmanı (sağlayıcılar) bağlar. Başka özellikler o özelliğin `domain`/`application`'ını kullanır, `data`'sını kullanmaz.
- **Durum ve bağımlılık (TK-01):** Riverpod 3, kod üretimsiz (`Provider`, `NotifierProvider`, `FutureProvider`). Sağlayıcılar .NET'teki DI kayıtlarına karşılık gelir.
  - Açılışta hazır olması gerekenler (veritabanları, kullanıcı verisi anlık görüntüsü) `bootstrap.dart`'ta açılır ve `overrideWithValue` ile verilir.
- **Servisler (MK-06):** `AuthService`, `SyncService`, `LessonRepository`, `BillingService`, `CrashReporter` arayüzdür; `Fake…` uygulamaları `dev`'de kullanılır.
  - `prod`'da gerçek uygulaması olmayan servis açıkça `UnimplementedError` verir; sessizce sahteye düşmez.
  - Gerçek servis tek satırlık sağlayıcı değişikliğiyle bağlanır.
- **Hata türleri:** veri katmanı `Result<T>` (`Ok`/`Err`) ve `AppFailure` döndürür; arayüze istisna sızdırmaz. Yakalanmamış hatalar `CrashReporter`'a gider (TK-10: sağlayıcı Faz 3'te seçilecek).
- **Yönlendirme (TK-03, TK-16):** go_router; rotalar `core/routing/app_routes.dart`. Alt sekmeler `StatefulShellRoute` (Bugün `/`, Kur'an `/quran`, Hafızlık `/memorize`, Ben `/me`); okuma (`/read?ayah=2:255` veya `?page=50`) ve ayarlar (`/settings`) sekmelerin üstünde `context.push` ile açılır.
- **Flavor (TK-07):** `dev` (paket adı `.dev` ekli, sahte servisler) ve `prod`.

## Veri
- **İki ayrı veritabanı (MK-05):**
  - **İçerik:** salt okunur, uygulamayla gelir (M16-01), her sürümde baştan üretilebilir.
  - **Kullanıcı:** kalıcı, sürümlü, senkrona hazır; asla kaybolmamalı (NF-G02).
- **İçerik veritabanı:**
  - Şema `features/quran/data/content_database.dart`.
  - Üretim: `dart run tool/content/build_content_db.dart` (kaynakları doğrular; hata varsa yarım dosya bırakmaz).
  - Şema veya veri değişince `kContentVersion` artırılır; cihazda yeni dosya kopyalanır. Migration yoktur.
  - Çoklu mushaf düzeni (M2-14): metin bir kez saklanır, her düzen ayrı `mushaf_layout` kaydı ve `layout_*` satırlarıdır.
- **Kullanıcı veritabanı:**
  - Drift, `core/database/user_database.dart`. Her kayıt `SyncedRecord` taşır: UUID, UTC `createdAt`/`updatedAt`, `deletedAt` (yumuşak silme).
  - Şema değişikliği: `currentSchemaVersion` artır → `dart run build_runner build` → `dart run drift_dev make-migrations` → `stepByStep` adımı → veri koruma testi (`test/drift/`). Ayrıntı: Faz_0_Notlar §9.3.
  - Migration öncesi otomatik yedek alınır (son 3).
- **Konum kuralı (M2-15):** kullanıcı verisinde konum her zaman `sure:ayet(:kelime)` olarak saklanır; **sayfa numarası asla saklanmaz**.
- **Ayarlar:** `settings` tablosunda anahtar → JSON; `persistSetting()` ile yazılır. Anahtarlar: `app.language`, `app.numerals`, `app.theme`, `reader.viewMode`, `reader.textScale`.

## Kur'an metni ve mushaf (en hassas kısım)
- **Kur'an metninde hiçbir harf veya işaret değiştirilmez.** Kaynakta tutarsızlık varsa veri elle düzeltilmez. Durum `VERI_KAYNAKLARI.md`'ye Q-n olarak yazılır; gerekirse gerekçeli, tek tek listelenmiş ve testle denetlenen bir düzen düzeltmesi yapılır (ör. Q-13, 254. sayfa).
- **Esas kelime bölünmesi:** KFGQPC metni (77.430 kelime). Diğer kaynaklarla eşlemeler harf iskeletiyle **otomatik** çıkarılır; elle özel durum yazılmaz.
- **Mushaf çizim yöntemi (TK-06, F0-05 kararı, 28.10.2026):**
  - Font: **yalnız DigitalKhatt New Madina** (SIL OFL), ekrandaki metin DigitalKhatt kelime metni.
  - Satırlar QUL 1421H düzeninden (604 sayfa × 15 satır). İki yana yaslı satırlarda kelimeler satıra yayılır, ortalı satırlar ortalanır.
  - Yazı boyutu, sayfanın en uzun satırı ekrana sığacak şekilde hesaplanır.
  - KFGQPC/QCF fontları izin gerektirdiği için kullanılmaz; QCF glif kodları veritabanında yedek olarak durur.
  - İleride: keşideyle yaslama; Türkiye mushaf düzeni (M2-02) için ayrı düzen verisi.
- **Sayfa ve konum:** mushaf sağdan soladır (sonraki sayfa soldan gelir); tablette yatayda çift sayfa (M2-03). Görünüm değişince okunan ayet korunur.
- **Secde:** 14 (Hanefi). 22:77'deki ۩ sayfada görünür ama secde sayılmaz.
- **Yeni veri kaynağı veya dosya indirildiğinde:** `VERI_KAYNAKLARI.md` dosya tablosuna kaynak, **indirme amacı** ve kullanım yeri (🟢 uygulama / 🔵 eşleme / 🟡 test) yazılır. Lisans kontrol listesi doldurulur (İÇ-10).
- **Lisans yükümlülükleri korunur:**
  - DigitalKhatt OFL metni pakette durur ve Ayarlar → Lisanslar'da gösterilir.
  - **Tanzil yalnızca test referansıdır**; Tanzil metninin hiçbir kısmı uygulamaya girmez (içerik sürümü 7, Faz 1 S9).
  - `test/content/license_notices_test.dart` bunları denetler.
- **Atıf izin yerine geçmez:** meal, tefsir, ses ve font gibi telifli içerik ancak yazılı izinle veya lisansı açıkça izin veriyorsa eklenir. Kaynağı yazmak tek başına yeterli değildir (İÇ-04, İÇ-05).

## Kod kuralları
- **Lint ve biçim (TK-08):**
  - `flutter_lints` + ek katı kurallar (`analysis_options.yaml`: strict-casts/inference/raw-types, tek tırnak, sondaki virgül, `directives_ordering`, `unawaited_futures`…).
  - `dart format` zorunlu. CI `flutter analyze --fatal-infos` çalıştırır; bilgi düzeyindeki uyarılar da hatadır.
- **Arayüz metni (NF-Y01):**
  - Ekrandaki her metin ARB'den gelir: `context.l10n.anahtar`.
  - Yeni anahtar önce `app_tr.arb`'ye (gerekirse `@anahtar` açıklamasıyla), sonra `app_ar.arb` ve `app_en.arb`'ye eklenir.
  - Çevrilmemesi gereken metinde (ör. mushaftaki Arapça "سُورَةُ") satıra `// l10n-ignore: gerekçe` yazılır.
  - `test/l10n/` gömülü metni ve eksik çeviriyi yakalar.
- **Sayılar (NF-Y03):** ekrandaki sayılar `context.formatInt(n)`, konumlar `context.formatDigits(ref)` ile yazılır; seçilen rakam sistemine (Batı / Doğu Arap) uyar.
- **Yön (M13-01):**
  - Arapçada arayüz sağdan soladır. Kenar boşluklarında `EdgeInsetsDirectional`, hizalamada `start`/`end` kullanılır; `left`/`right` kullanılmaz.
  - Mushaf ve Arapça metin her dilde `TextDirection.rtl`.
- **Tema (M2-08, NF-E01):**
  - Renkler yalnızca `core/theme/app_palette.dart`'ta; ekranlarda `context.palette.<rol>` kullanılır, renk kodu yazılmaz.
  - Boşluklar `AppSpacing`; bileşen görünümleri `buildAppTheme` içinde.
  - Yeni renk ya da tema kontrast testinden geçmelidir (WCAG AA).
- **Bileşenler:**
  - Düğme `AppButton`, liste satırı `AppListItem`, bölüm başlığı `AppSectionHeader`.
  - Yükleniyor / boş / hata durumları `LoadingState` / `EmptyState` / `ErrorState`.
  - Ham hata metni kullanıcıya gösterilmez.
- **Erişilebilirlik (M13-03, NF-E02, NF-E03):**
  - Her dokunulabilir öğenin adı olur: metin, `tooltip` ya da `Semantics(label:)`.
  - Dokunma alanı en az 48×48.
  - Bölüm başlıkları `header`, durum değişiklikleri `liveRegion`, süs simgeleri `ExcludeSemantics`.
  - Mushaf kelimeleri seçilebilir düğmedir.
- **Widget anahtarları:** testlerin bulduğu öğelerde `Key('ekran.öğe')` (ör. `today.continue`, `quran.surah.2`, `tab.quran`, `settings.theme.dark`, `reader.goTo`).
- **Gereksinim kodlarına atıf:** bir kuralı uygulayan kodun yorumunda gereksinim kodu yazılır (ör. `// M2-15: konum sayfadan bağımsız`). Böylece gereksinim ↔ kod izlenebilir.
- **Yorumlar:** neden'i anlatır; kodun ne yaptığını tekrar etmez.

## Test kuralları
- `flutter test` her push öncesi yerelde çalıştırılır. CI her commit'te değil: haftalık, PR'da ve elle (karar 28.10.2026).
- `test/` klasör yapısı `lib/` ile aynıdır.
- Ortak yardımcılar `test/helpers/`:
  - `localizedApp()`: tek ekranı dil ve temayla sarar.
  - `openTab()`: alt sekme açar (`today`, `quran`, `memorize`, `me`).
  - `tapBack()`: geri tuşu. `tester.pageBack()` İngilizce "Back" aradığı için Türkçe/Arapçada çalışmaz.
  - `FakeQuranRepository`, `openTestContentDatabase()`.
- İçerik testleri (`test/content/`) üretilmiş `assets/db/content.sqlite` ister; önce veritabanı üretilir.
- Uygulama düzeyindeki testlerde cihaz dili sabitlenir (`localesTestValue`); kullanıcı verisi `userDataSnapshotProvider` ile verilir.
- **Bir denetim yazıldığında bilerek bozularak denenir** ve sonuç notlara yazılır. Örnekler: hareke değiştirme (T-01), migration'ı boşaltma, gömülü metin ekleme, kontrastı düşürme.
- Kalıcılık testleri yeniden açılışı taklit eder (aynı bellek içi veritabanıyla iki `ProviderContainer`).
- Erişilebilirlik: `meetsGuideline(androidTapTargetGuideline | iOSTapTargetGuideline | textContrastGuideline | labeledTapTargetGuideline)`. Semantik eşleştirmede `isSemantics` kullanılır (`containsSemantics` kullanımdan kalktı).

## Commit mesajları
- İngilizce conventional commit: `tür(kapsam): özet`. Kapsam iş paketi veya gereksinim kodudur: `feat(F0-08): …`, `feat(M2-01): sayfa görünümü`, `fix(M2-15): …`, `test(T-01): …`, `ci(F0-09): …`, `docs(F0-10): …`.
- Gövdede madde madde ne değiştiği yazılır. Son satır, varsa, yardımcı imzasıdır.
- Commit'i kullanıcı atar.

## Teknik kararlar (özet)
| # | Konu | Karar |
|---|---|---|
| TK-01 | Durum yönetimi | Riverpod 3 (kod üretimsiz) |
| TK-02 | Yerel veritabanı | Drift (SQLite), sürümlü migration |
| TK-03 | Yönlendirme | go_router |
| TK-04 | Klasör yapısı | Feature-first + `presentation/application/domain/data` |
| TK-05 | Dil dosyaları | `gen_l10n` + ARB (TR şablon, AR, EN); cihaz dili desteklenmiyorsa İngilizce |
| TK-06 | Mushaf çizimi | DigitalKhatt (OFL) + QUL 1421H düzeni |
| TK-07 | Ortamlar | `dev` / `prod` |
| TK-08 | Kod kalitesi | `flutter_lints` + katı kurallar, `dart format`, `--fatal-infos` |
| TK-09 | CI | GitHub Actions: `ci.yml` (biçim, analiz, test, Android derleme), `ios.yml` (iOS derleme + simülatör testi) |
| TK-10 | Çökme raporlama | Faz 3'te seçilecek; şimdilik `CrashReporter` arayüzü |

Tema: tek tema (uygulama + mushaf), açık/sepya/koyu, varsayılan "Cihaz ayarı" (F0-08).

## Sık kullanılan komutlar (`quran_app/` içinde)
```sh
flutter run --flavor dev -t lib/main_dev.dart        # geliştirme sürümü
dart run tool/content/build_content_db.dart          # içerik veritabanını üret
dart run build_runner build                          # Drift kodu
dart run drift_dev make-migrations                   # kullanıcı DB şema fotoğrafı + migration testleri
flutter gen-l10n                                     # dil dosyalarından kod (pub get de üretir)
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze --fatal-infos
flutter test
flutter test integration_test/app_launch_test.dart --flavor dev   # emülatör açıkken
```
Ölçüm araçları (basılı nüsha paketi, açılış ve kaydırma performansı, çeviri tablosu): `quran_app/README.md` "Ölçüm ve kontrol araçları".
Emülatör: `Medium_Phone_API_37.0`. Yeni kurulan debug APK simgeden açılınca bir kez açılış ekranında takıldı (29.10.2026, nedeni bulunamadı; bkz. Faz_0_Notlar "Genel durum"). Sorun olursa `flutter run` kullanılır.
