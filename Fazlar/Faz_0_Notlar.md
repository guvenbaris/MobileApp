# Faz 0 Çalışma Notları

> **Amaç:** Faz 0'da her iş paketinde **ne yapıldığını, neden öyle yapıldığını, hangi dosyaların ne işe yaradığını ve bilinen sorunları** kayıt altına almak. `Faz_0.md` *ne yapılacağını* ve kutucukları tutar; bu dosya *nasıl ve neden yapıldığını* anlatır.
> **Bağlı dokümanlar:** `Faz_0.md`, `../Proje_Gereksinimleri.md`, `../VERI_KAYNAKLARI.md`, `../quran_app/README.md`
> **Kural:** Her iş paketi bittiğinde buraya bir bölüm eklenir. En yeni bölüm en üstte değil, iş sırasıyla eklenir.

## İçindekiler
1. [Geliştirme ortamı](#1-geliştirme-ortamı)
2. [F0-01 Depo ve Proje Kurulumu](#2-f0-01-depo-ve-proje-kurulumu)
3. [F0-02 Mimari İskelet](#3-f0-02-mimari-iskelet)
4. [F0-09 Test ve CI Altyapısı](#4-f0-09-test-ve-ci-altyapısı)
5. [F0-03 Kur'an Veri Hattı](#5-f0-03-kuran-veri-hattı)
6. [Genel durum ve bekleyen kararlar](#6-genel-durum-ve-bekleyen-kararlar)

---

## 1. Geliştirme ortamı
**Tarih:** 28.10.2026

| Bileşen | Durum |
|---|---|
| Flutter 3.47.8 (stable), Dart 3.13.7 | ✅ `C:\Users\HUAWEI\flutter` |
| Android Studio, Android SDK 36, NDK, CMake | ✅ İlk derlemede NDK, Platform 36 ve CMake kendiliğinden indirildi |
| Emülatör `Medium_Phone_API_37.0` | ✅ |
| Android `cmdline-tools` | ⚠️ **Eksik.** Derlemeyi engellemiyor; `flutter doctor --android-licenses` için gerekli. Kurulum: Android Studio → Settings → Languages & Frameworks → Android SDK → SDK Tools → "Android SDK Command-line Tools (latest)" |
| Visual Studio C++ bileşenleri | Gerekmiyor (yalnızca Windows masaüstü uygulaması için) |
| iOS | Mac yok; iOS derlemesi GitHub Actions macOS makinesinde yapılıyor (bkz. F0-09) |
| Editörler | VS Code (Dart + Flutter eklentileri) ve Android Studio; ikisinde de dev/prod çalıştırma profilleri hazır |

---

## 2. F0-01 Depo ve Proje Kurulumu
**Durum:** ✅ Android · ⏳ iOS açılışı GitHub'daki ilk iOS çalışmasını bekliyor

### Yapılanlar
- **Depo yapısı (S5):** Git deposu proje kökünde (`main`), Flutter projesi `quran_app/` altında. Dokümanlar depoda; yorum analizi ham verileri (`reviews/`) depo dışında. Uzak depo: GitHub (özel).
- **Paket adı (S1):** geçici `com.example.quranapp`. İlk mağaza yüklemesinden önce kalıcı adla değiştirilecek; kişisel ad kullanılmayacak.
- **Uygulama adı (S2):** geçici "Kur'an" (dev sürümünde "Kur'an Dev"). Kalıcı ad kararı ertelendi (aday: "Kur'anla Yaşamak").
- **Minimum sürümler:** Android `minSdk 24` (Android 7.0), iOS 15.0 (AK-02).
- **Flavor'lar (TK-07):**
  - Android'de `dev` ve `prod`. `dev` paket adının sonuna `.dev` ekliyor, böylece iki sürüm aynı telefona yan yana kurulabiliyor.
  - Dart tarafında iki giriş noktası: `lib/main_dev.dart` ve `lib/main_prod.dart`.
  - iOS'ta flavor için Xcode şemaları gerekiyor ve Mac olmadan eklenemedi; iOS'ta flavor `-t lib/main_dev.dart` ile çalışacak dosya seçilerek ayrılıyor.
- **Kod kalitesi (TK-08):** `flutter_lints` + ek katı kurallar (`strict-casts`, `strict-inference`, `prefer_single_quotes`, `unawaited_futures` vb.). `dart format` zorunlu.
- **Editör ayarları:**
  - Kökte `.vscode/launch.json` (dev, prod, prod release profilleri) ve `settings.json` (kaydederken biçimlendirme).
  - Android Studio için `quran_app/.idea/runConfigurations/dev.xml` ve `prod.xml`. `.idea` git dışında, yalnızca yerelde duruyor.

### Karşılaşılan sorunlar
- Android kaynak dosyalarında kesme işareti (`Kur'an`) `\'` ile kaçırılmalı; Kotlin dizesinde `"Kur\\'an"` yazılıyor.
- AGP 9'da flavor'a özel `resValue` kullanmak için `buildFeatures { resValues = true }` gerekiyor.
- Flavor eklendikten sonra flavor'sız çalıştırma ("Quran" yapılandırması) derleme hatası verir; `dev`/`prod` yapılandırmaları kullanılmalı.

---

## 3. F0-02 Mimari İskelet
**Durum:** ✅ · **Gereksinimler:** MK-06, MK-07

### Kullanılan paketler
| Paket | Görev | .NET karşılığı |
|---|---|---|
| `flutter_riverpod` 3.4 | Durum yönetimi ve bağımlılık enjeksiyonu (TK-01). Kod üretimi kullanılmıyor. | DI container (`IServiceCollection`) |
| `go_router` 18 | Sayfa yönlendirme, ileride derin bağlantı (TK-03) | ASP.NET routing |

### Klasör yapısı (TK-04: feature-first)
```
lib/
├── main_dev.dart / main_prod.dart   giriş noktaları
├── bootstrap.dart                   ortak başlangıç: veritabanı, hata yakalama, sağlayıcılar
├── app.dart                         MaterialApp.router
├── core/                            özelliklerden bağımsız ortak kod
│   ├── config/      Flavor, flavorProvider
│   ├── result/      Result<T> (Ok/Err), AppFailure türleri
│   ├── logging/     AppLogger arayüzü (print yasak)
│   ├── crash/       CrashReporter arayüzü + FakeCrashReporter
│   └── routing/     AppRoutes, appRouterProvider
└── features/<özellik>/
    ├── domain/       arayüzler ve modeller (veritabanından/sunucudan habersiz)
    ├── data/         uygulamalar (Fake…, Drift…)
    ├── application/  Riverpod sağlayıcıları
    └── presentation/ ekranlar
```

### Kararlar
- **Hata yönetimi:** beklenen hatalar istisna fırlatılarak değil `Result<T>` ile döndürülüyor (`Ok(value)` / `Err(failure)`). Hata türleri: `NetworkFailure`, `AuthFailure`, `NotFoundFailure`, `CancelledFailure`, `UnexpectedFailure`. Mesajlar geliştirici içindir; kullanıcıya gösterilecek metin hata türüne göre yerelleştirilecek.
- **Sahte servisler (MK-06):** sunucu gerektiren dört yetenek arayüz arkasında:
  - `AuthService`: hesap; e-posta, Google ve Apple ile giriş, şifre sıfırlama, hesap silme (M1).
  - `SyncService`: cihazlar arası senkron (M1-06).
  - `LessonRepository`: dersler (M9).
  - `BillingService`: abonelik ve satın alma (M11).

  Her birinin bellekte çalışan bir `Fake…` uygulaması var.
- **Prod'da güvenlik:** `prod` flavor'ında gerçek uygulaması henüz yazılmamış bir servis çağrılırsa uygulama sessizce sahte servise düşmüyor, açık bir `UnimplementedError` veriyor. Böylece mağaza sürümüne yanlışlıkla sahte ödeme ya da sahte giriş sızamaz.
- **`CrashReporter`:** gerçek sağlayıcı Faz 3'te seçilecek (TK-10). O zamana kadar iki ortamda da `FakeCrashReporter` (loglar, bellekte tutar) kullanılıyor. Yakalanmamış hatalar `bootstrap.dart`'ta ona yönlendiriliyor.
- **Arayüzlerin olgunluğu:** arayüzler iskelet düzeyinde; ayrıntıları "Veri Modeli Dondurma" kilometre taşında kesinleşecek.

### "Bitti" kanıtı
`test/features/service_providers_test.dart`: bir servis tek satırlık `overrideWith` ile başka bir uygulamayla değiştirilebiliyor.

---

## 4. F0-09 Test ve CI Altyapısı
**Durum:** ✅ yazıldı · ⏳ GitHub'da "bilerek bozulan PR kırmızıya düşüyor" denemesi bekliyor

### Test klasörleri
| Klasör | Tür | Çalıştırma |
|---|---|---|
| `test/` | Birim ve ekran (widget) testleri; yapısı `lib/` ile aynı | `flutter test` |
| `test/helpers/` | Ortak yardımcılar (test container, sahte içerik, test veritabanı) | |
| `integration_test/` | Gerçek cihazda/emülatörde uçtan uca testler | `flutter test integration_test --flavor dev` |

### GitHub Actions
| İş akışı | Ne yapar | Ne zaman çalışır |
|---|---|---|
| `.github/workflows/ci.yml` | Biçim kontrolü, `flutter analyze --fatal-infos`, testler + kapsam özeti (`lcov.info`), dev ve prod için Android APK derlemesi | **Haftalık (pazartesi 06:00 TR), PR açıldığında, elle** |
| `.github/workflows/ios.yml` | İmzasız iOS derlemesi + simülatörde açılış testi | Haftalık, elle |

### Kararlar
- **CI her commit'te çalışmıyor** (kullanıcı kararı). Push öncesi yerel kontroller (`dart format`, `flutter analyze`, `flutter test`) çalıştırılmalı; komutlar README'de.
- **iOS iş akışı:** özel repolarda macOS dakikaları 10 kat sayıldığı için seyrek çalışıyor (bir çalışma yaklaşık 100–150 dakikalık kota harcıyor).

---

## 5. F0-03 Kur'an Veri Hattı
**Durum:** ✅ · **Gereksinimler:** İÇ-01, İÇ-02, İÇ-10, MK-05, M2-14, M2-15, M16-01

### 5.1 Amaç
Uygulamanın **internetsiz** olarak bütün Kur'an verisine erişmesi:
- **Metin:** 114 sure, 6.236 ayet.
- **Kelimeler:** her kelime ayrı kayıt (kelimeye dokunma M3-03, ezber M8-02 için).
- **Meta veri:** cüz, hizb, rubu', secde, sure adları (TR/AR/EN), iniş yeri.
- **Mushaf düzeni:** hangi kelimenin hangi sayfanın hangi satırında olduğu (birebir sayfa çizimi F0-05 için).

### 5.2 Kaynak seçimi
| Kaynak | Ne sunuyor | Sonuç |
|---|---|---|
| Tanzil | Ayet metni + meta veri; lisansı açık (CC BY 3.0, değiştirmeden + atıfla) | Kelime/satır düzeni yok. **F0-04'te bağımsız kontrol metni** olarak kullanılacak |
| QUL (Tarteel) | Mushaf düzeni veritabanları | İndirmek için hesap gerekiyor; lisans sayfalarında "telif bilgisi yok" |
| **Quran.com API v4** | Ayet metni, kelime kelime metin, her kelimenin sayfa/satırı, sayfa fontu glifleri, cüz/hizb/rubu'/secde, Türkçe sure adları | ✅ **Seçildi**: girişsiz çalışıyor, hepsini tek kaynaktan veriyor |

> ⚠️ **Lisans:** Quran.com verisinin mağaza yayınında kullanımı belirsiz (asıl hak sahibi KFGQPC). Geliştirme için sorun yok; **yayından önce AK-11 ile çözülmeli**. Mimari kaynaktan bağımsız: kaynak değişirse yalnızca indirme betiği değişir.

### 5.3 Veri hattı
```
Quran.com API ──(1) fetch_sources.dart──▶ tool/content/sources/quran_com/*.json   (depoda)
                                                  │
                                  (2) build_content_db.dart
                                                  ▼
                                  assets/db/content.sqlite   (depoda değil, üretilir)
                                                  │
                                  (3) uygulama ilk açılışta cihaza kopyalar, salt okunur açar
```

**(1) `tool/content/fetch_sources.dart`: indirme**
- 604 sayfayı çeker (4 paralel istek, hata olursa 5 kez yeniden dener).
- Gereksiz alanları atıp sadeleştirilmiş JSON yazar:
  - `chapters.json`: sureler.
  - `verses.json`: ayetler ve kelimeler, yaklaşık 5,9 MB.
  - `layout_madani_1421.json`: kelime → sayfa/satır/glif, yaklaşık 2 MB.
  - `manifest.json`: kaynak ve indirme zamanı.
- **Yalnızca kaynak güncellenirken** çalıştırılır. Çıktısı depoya commit'lenir: API değişse bile veri sabit kalır ve değişiklikler git'te görünür.

**(2) `tool/content/build_content_db.dart`: veritabanı üretimi**
- JSON'dan SQLite veritabanını sıfırdan kurar.
- **Doğrular.** Aşağıdakilerden biri tutmazsa hata verir ve yarım veritabanı bırakmaz:
  - Sure, ayet ve kelime sayıları 114, 6.236 ve 77.429.
  - Her ayetin son kelimesi ayet sonu işareti.
  - Satırdaki kelimeler ardışık.
  - 604 sayfanın tamamı: ilk iki sayfa 8 satır, diğerleri 15 satır.
  - Her satırın türü kesin belirlenebiliyor.
- Üretilen veritabanı **git dışında**. Klonladıktan sonra ve `tool/content/` değiştiğinde `quran_app` içinde çalıştırılmalı:
  ```
  dart run tool/content/build_content_db.dart
  ```
  CI bu adımı kendisi yapıyor.

**(3) Uygulama tarafı: `content_database_opener.dart`**
- Veritabanı uygulama paketine **asset** olarak gömülü (M16-01).
- İlk açılışta cihaza `content_v{sürüm}.sqlite` adıyla kopyalanır. `kContentVersion` artırılınca yeni dosya kopyalanır, eskisi silinir.
- **Salt okunur** açılır (`PRAGMA query_only = ON`): uygulama Kur'an metnini yanlışlıkla bile değiştiremez.
- Kullanıcı verisi ayrı veritabanında olacak (MK-05, F0-06). İçerik veritabanı "migration" ile değil, yeniden üretilerek güncellenir; kullanıcı verisine dokunmaz.

### 5.4 Veritabanı şeması (Drift)
Drift (TK-02), EF Core'a benzer: tablolar Dart sınıflarıyla tanımlanır, sorgular tip güvenlidir. `content_database.dart`'tan `content_database.g.dart` üretilir (depoya commit'lenir). Şema değişince `dart run build_runner build` çalıştırılır.

| Tablo | İçerik | Kayıt |
|---|---|---|
| `content_meta` | İçerik sürümü, kaynak, üretim zamanı | 3 |
| `surahs` | Arapça ad, Türkçe ad, İngilizce anlam, Latin okunuş, iniş yeri ve sırası, besmele, ayet sayısı | 114 |
| `ayahs` | Sure/ayet, cüz, hizb, rubu', secde, `text_uthmani`, `text_qpc_hafs` (KFGQPC metni) | 6.236 |
| `words` | Kelimeler ve ayet sonu işaretleri: ayet, sıra, ayet sonu mu, metin | 83.665 |
| `mushaf_layouts` | Düzenler: ad, sayfa ve satır sayısı, font paketi | 1 |
| `layout_lines` | **Sayfa → satır → kelime aralığı**; satır türü (ayet/sure başlığı/besmele) | 9.046 |
| `layout_pages` | Sayfa → ilk/son ayet (ayet ↔ sayfa dönüşümü) | 604 |
| `layout_word_glyphs` | Kelime → sayfa fontu glifi (F0-05 çizimi için) | 83.665 |

**Gerekçe (M2-14, M2-15):**
- Metin **bir kez** saklanıyor; düzene bağlı her şey `layout_*` tablolarında. Türkiye mushaf düzenini eklemek **veri + font paketi** eklemek demek, kod değişikliği değil.
- Kullanıcı kayıtları sayfa numarasıyla değil `sure:ayet` ile tutulacak; sayfa `layout_pages` ile hesaplanır. Düzen değişince kullanıcı aynı ayette kalır.

### 5.5 Veride bulunanlar ve kararlar
Ayrıntıları `VERI_KAYNAKLARI.md` Q-1…Q-8'de. **Kur'an metninde hiçbir karakter değiştirilmedi.**

| # | Bulgu | Karar |
|---|---|---|
| Q-7 | 1405H baskısının (QCF V1) satır verisinde 8 sayfada açıklanamayan boş satırlar var | Yalnızca **1421H baskısı (QCF V2)** alındı; satır verisi 604 sayfada tutarlı. Uygulamadaki kimliği `madani_1421`. V1, QUL verisiyle doğrulanınca eklenebilir. |
| Q-4 | 84:21'in ayet sonu işareti 13. satırda; ayetin 3–6. kelimeleri ve 84:22 ise 14. satırda | Yalnızca **satır numarası** 14'e düzeltildi (`_lineCorrections`, gerekçesiyle). F0-05'te basılı nüshayla teyit edilecek. |
| Q-5 | Sure başlığı ve besmele satırları API'de yok | Kuralla çıkarıldı: surenin ilk satırının üstündeki 2 satır (Fatiha ve Tevbe'de 1). Sayfa başından taşarsa önceki sayfanın son satırına düşer (ör. 76/15 Nisâ başlığı, 77/1 besmele). Sonuç: 114 başlık + 112 besmele, istisna yok. |
| Q-1 | Kelime metni ile ayet metni farklı yazım sürümlerinden geliyor (3.601 ayette birleştirilince tutmuyor) | **Asıl metin ayet metni**; T-01 onunla yapılacak. Kelime metni dokunma ve arama için yardımcı veri. |
| Q-2, Q-3 | 27:26'da görünmez yön karakteri; 3 kelimede farklı kodlanmış elif | Olduğu gibi saklandı; arama yazılırken (Faz 1) normalize edilecek |
| Q-6 | Ortalı satır bilgisi yok | F0-05'te çözülecek |
| Q-8 | 14 secde (22:77 işaretsiz) | F0-04'te basılı nüshayla teyit |

### 5.6 Uygulama kodu
```
lib/features/quran/
├── domain/
│   ├── quran_models.dart          Surah, Ayah, AyahRef (düzenden bağımsız sure:ayet konumu)
│   └── quran_repository.dart      QuranRepository arayüzü
├── data/
│   ├── content_database.dart      Drift şeması, kContentVersion, kContentAssetPath
│   ├── content_database.g.dart    üretilen kod
│   ├── content_database_opener.dart  asset → cihaz, salt okunur açma
│   └── drift_quran_repository.dart   arayüzün Drift uygulaması
└── application/
    └── quran_providers.dart       contentDatabaseProvider, quranRepositoryProvider, surahsProvider
```
- **`QuranRepository`** (MK-07): sureler, tek ayet, surenin ayetleri, ayet → sayfa, sayfa → ilk ayet. Hatalar `Result` ile döner.
- **`bootstrap.dart`**: önce içerik veritabanını açar, sonra arayüzü başlatır.
- **Ana sayfa**: veritabanından gelen sure listesini gösteriyor (veri hattının görünür kanıtı). Metinler F0-07'de dil dosyalarına taşınacak.
- **`AppFailure`** artık `Exception` sınıfından türüyor (Riverpod hata akışıyla uyum).

### 5.7 Testler ve ölçümler
| Test | Kontrol |
|---|---|
| `test/features/quran/drift_quran_repository_test.dart` (8 test, gerçek veritabanı) | Sürüm eşleşmesi; 114 sure / 6.236 ayet; 2:255 → 3. cüz; 96:19 secde; Fatiha'nın 7 ayeti sıralı; 1:1 → s.1, 2:1 → s.2, 114:6 → s.604; s.604'ün ilk ayeti 112:1; olmayan kayıtta hata |
| `test/helpers/fake_quran_repository.dart` | Ekran testleri için veritabanından bağımsız sahte içerik |
| `integration_test/app_launch_test.dart` | Emülatörde gerçek asset kopyalama ve okuma; ekranda "Fâtiha" |
| Elle ölçüm | Temiz kurulumda sure listesi **≤ 2 sn**'de ekranda (NF-PF01). Entegrasyon testinin 69 sn sürmesi test ortamının debug modundan kaynaklanıyor, uygulamadan değil. |

Sonuç: 23 birim/ekran testi + 1 entegrasyon testi geçiyor, analiz temiz.

### 5.8 Boyut
İçerik veritabanı **11,6 MB** (APK'da sıkıştırılır). Hedef: uygulama en fazla 60 MB (NF-PF06). QCF V2 sayfa fontları F0-05'te eklenince toplam boyut yeniden ölçülecek; gerekirse yardımcı alanlar küçültülecek.

### 5.9 Değişen diğer dosyalar
- **`pubspec.yaml`:** yeni paketler `drift`, `sqlite3`, `path_provider`, `path`; geliştirme için `drift_dev`, `build_runner`. Asset tanımı eklendi.
- **CI iş akışları:** testlerden önce "İçerik veritabanı" üretim adımı eklendi.
- **`quran_app/.gitignore`, README:** üretilen veritabanı depo dışında tutuldu; README'ye ilk kurulum adımı yazıldı.
- **`VERI_KAYNAKLARI.md` (yeni):** kaynak envanteri ve lisans kontrol listesi (İÇ-10).

---

## 6. Genel durum ve bekleyen kararlar
**Son güncelleme:** 28.10.2026

| İş paketi | Durum |
|---|---|
| F0-01 Depo ve proje kurulumu | ✅ Android · ⏳ iOS ilk CI çalışması |
| F0-02 Mimari iskelet | ✅ |
| F0-03 Kur'an veri hattı | ✅ |
| F0-04 Metin bütünlüğü testleri (T-01, T-02) | ⬜ Sıradaki önerilen adım |
| F0-05 Mushaf sayfası çizimi (en riskli) | ⬜ |
| F0-06 Kullanıcı veritabanı | ⬜ |
| F0-07 Dil · F0-08 Tema · F0-10 `CLAUDE.md` · F0-11 Erişilebilirlik | ⬜ |
| F0-09 Test ve CI | ✅ · ⏳ kırmızıya düşme denemesi |

**Bekleyen kararlar ve işler**
- **Uygulama adı:** aday "Kur'anla Yaşamak"; karar sonraya bırakıldı (AK-04).
- **Veri ve font lisansı (AK-11):** Quran.com / KFGQPC; yayından önce yazılı izin gerekecek.
- **Android `cmdline-tools` kurulumu:** lisans onayı için.
- **GitHub'da yapılacaklar:** iOS iş akışını elle çalıştırmak; bilerek bozulmuş bir PR ile CI'ın kırmızıya düştüğünü görmek.
