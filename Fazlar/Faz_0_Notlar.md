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
6. [F0-04 Metin Bütünlüğü Testleri](#6-f0-04-metin-bütünlüğü-testleri)
7. [F0-04 Ek: QUL Doğrulaması, Esas Kelime ve Font Kararı](#7-f0-04-ek-qul-doğrulaması-esas-kelime-ve-font-kararı)
8. [F0-05 Mushaf Sayfası Çizimi (devam ediyor)](#8-f0-05-mushaf-sayfası-çizimi-devam-ediyor)
9. [Genel durum ve bekleyen kararlar](#9-genel-durum-ve-bekleyen-kararlar)

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

## 6. F0-04 Metin Bütünlüğü Testleri
**Durum:** ✅ · **Gereksinimler:** İÇ-02, T-01, T-02, Y-06

### 6.1 Amaç
Kur'an metninde **tek bir harfin veya harekenin bile** fark edilmeden değişmesini engellemek. Değişiklik nereden gelirse gelsin (kaynağın yeniden indirilmesi, betikte bir hata, bir kütüphane güncellemesi) test kırılmalı ve **yerini** göstermeli.

### 6.2 Referans: Tanzil
- Tanzil'in Osmanlı yazımlı metni ve meta verisi `tool/content/sources/tanzil/` altına **bayt bayt, değiştirilmeden** kaydedildi (lisans gereği; telif notu dosyanın içinde).
- **Uygulamaya girmez**, yalnızca testlerde kullanılır.
- İndirme `fetch_sources.dart`'a eklendi: `dart run tool/content/fetch_sources.dart tanzil`.
- **`.gitattributes` (kökte, yeni):** Windows'ta git satır sonlarını dönüştürüp dosyayı "değiştirmesin" diye kaynak klasörü dönüşümden muaf tutuldu.

### 6.3 Karşılaştırma bulguları
| Konu | Sonuç |
|---|---|
| **Ayet metni** | Quran.com'un `text_uthmani` alanı **Tanzil metninin ta kendisi**: 6.124 ayet birebir aynı. Kalan 112 farkın hepsi besmeleden: Tanzil her surenin 1. ayetinin başına besmele ekliyor. Quran.com bunu çıkarırken 110 ayetin başında bir **boşluk** bırakmış (Q-9). Boşluk kırpılınca **6.236 ayetin tamamı karakteri karakterine aynı**. |
| **Cüz** | 30 başlangıcın hepsi aynı |
| **Rubu'** | 240 başlangıcın 239'u aynı. Tek fark (106. rubu', 15:49/15:50) Tanzil'in kendi çelişkisi: metnindeki ۞ işareti 15:49'da, meta verisi 15:50 diyor. Bizim veri işaretle uyumlu (Q-11). |
| **Secde** | Metinde 15 ۩ işareti var; Quran.com meta verisi 14 secde sayıyor (22:77 yok). 14 Hanefi sayısı, 22:77 Şafii'de secde. **Fıkhi tercih; karar bekliyor** (Q-8). |
| **Sayfa** | 604 sayfanın 579'u aynı. Tanzil'in sayfaları **1405H** baskısına ait (Quran.com'un 1405H verisiyle birebir aynı olduğu doğrulandı); bizim düzen **1421H**. 25 sayfanın ilk ayeti farklı (Q-10). Bağımsız bir 1421H kaynağı olmadığı için bu 25 sayfa **henüz doğrulanmadı**. |
| **Bölünmüş ayet** | Hiçbir ayet iki sayfaya bölünmemiş (Medine mushafının bilinen özelliği; veri tutarlı) |

### 6.4 Yapılan değişiklikler
- **`build_content_db.dart`:** Q-9 boşluğu kırpılıyor (`trimLeft`). Metin karakterlerine dokunulmuyor.
- **`kContentVersion` 1 → 2:** veritabanı değiştiği için yüklü uygulamalar yeni sürümü görünce paketteki veritabanını yeniden kopyalar.

### 6.5 Testler (`test/content/`)
**`t01_quran_text_test.dart`: metin bütünlüğü (T-01)**
| Test | Kontrol |
|---|---|
| Sayılar | 114 sure, 6.236 ayet; her surenin ayet sayısı Tanzil ile aynı; 77.429 kelime + 6.236 ayet sonu işareti |
| Tanzil karşılaştırması | 6.236 ayetin her biri Tanzil metniyle (besmele çıkarılmış) **karakter karakter** aynı. Fark olursa ayeti, karakter sırasını ve iki tarafın Unicode kodunu yazar. |
| Sağlama | KFGQPC metni (`text_qpc_hafs`), kelimeler, cüz/hizb/rubu'/secde, düzen satırları ve glifler için sure başına SHA-256 değerleri `tool/content/reference/checksums.json` ile karşılaştırılır. Fark olursa hangi surede hangi alanın değiştiğini yazar. |

**`t02_mushaf_layout_test.dart`: sayfa düzeni ve bölüm sınırları (T-02)**
| Test | Kontrol |
|---|---|
| Sayfa kapsamı | 604 sayfa, boşluksuz ve örtüşmesiz tüm ayetleri kapsar; 1. sayfa 1:1 ile başlar, 604. sayfa 114:6 ile biter |
| Sayfa başı | Her sayfanın ilk ayeti Tanzil ile aynı; 25 bilinen 1421H farkı **tek tek listelenmiş** (beklenen değerleriyle). Liste dışındaki her fark ve listedeki bir değerin değişmesi testi kırar. |
| Sayfa sonu | Her sayfanın son ayeti, sonraki sayfanın ilk ayetinden hemen önce |
| Satırlar | Ayet satırları 83.665 kelimenin her birini sırayla ve bir kez kapsar |
| Başlıklar | 114 sure başlığı; besmele satırı Fatiha ve Tevbe dışındaki 112 surede |
| Cüz, hizb, rubu' | 30 cüz Tanzil ile aynı; 240 rubu' (15:49 istisnası belgeli); 60 hizb, her biri 4 rubu'; metindeki her ۞ bir rubu' başında |
| Secde | Meta veride 14, metinde 15 işaret; tek fark 22:77 |

### 6.6 Sağlama (checksum) düzeni
- **Neden gerekli:** Tanzil yalnızca `text_uthmani` için bağımsız referans. KFGQPC metni, kelimeler ve düzen için bağımsız kaynak yok. Bunlar bağımsız kontrollerden (sayılar, Tanzil, yapısal testler) geçtikten **sonra** sabitlendi. .NET'teki "snapshot/approval testing" yaklaşımına benzer.
- **Ortak kod:** hesaplama `tool/content/content_checksums.dart` içinde; hem test hem güncelleme betiği aynı kodu kullanıyor.
- **Kaynak bilerek güncellenirse** sıra şöyle:
  1. `build_content_db.dart` çalıştırılır.
  2. Testler çalıştırılır; sağlama testi değişen sureleri listeler.
  3. Farklar incelenir.
  4. `dart run tool/content/update_checksums.dart` çalıştırılır.
  5. `checksums.json`'daki git farkı commit'te gözden geçirilir.
- **Üretim deterministik:** veritabanı yeniden üretildiğinde aynı sağlama değerleri çıkıyor (üretim zamanı sağlamaya dahil değil).

### 6.7 "Bitti" kanıtı
Veritabanında bilerek iki karakter bozuldu:
- 2:255'te bir fetha dammeye çevrildi.
- 36:1'in KFGQPC metnine bir şedde eklendi.

Sonuç:
- **Tanzil testi:** `2:255: 4. karakterde fark (veritabanı U+064F, Tanzil U+064E)`.
- **Sağlama testi:** `İçerik değişmiş: Sure 2: textUthmani, Sure 36: textQpcHafs`.

Veritabanı kaynaktan yeniden üretildi; bütün testler tekrar geçti.

### 6.8 Sonuç
37 test geçiyor (bunların 15'i içerik testi), analiz temiz. CI içerik testlerini de çalıştırıyor (haftalık, PR'da, elle).

---

## 7. F0-04 Ek: QUL Doğrulaması, Esas Kelime ve Font Kararı
**Durum:** ✅ · **Gereksinimler:** İÇ-01, İÇ-02, T-01, T-02, M2-02, M2-14, M3-03, M8-02, NF-PF06, M16-01

### 7.1 Neden yapıldı
F0-04'te iki konu açık kalmıştı:
- 1421H düzenine özgü 25 sayfanın bağımsız doğrulaması (Q-10).
- Ortalı satır bilgisinin eksikliği (Q-6).

Bunlar için QUL'den (qul.tarteel.ai) üç dosya indirildi: 1421H düzeni, QCF V2 glif listesi ve 604 sayfa fontu.

### 7.2 Doğrulama bulguları
| Konu | Sonuç |
|---|---|
| Glifler | Quran.com ile QUL glifleri birebir aynı |
| Satırlar | 9.046 satırın 9.036'sı aynı; satır türleri ve sure başlıkları aynı |
| 25 sayfa (Q-10) | QUL'de de aynı → **doğrulandı** |
| Ortalı satırlar (Q-6) | QUL'den: 256 satır → **çözüldü** |
| Farklı 10 satır (5 sayfa) | **Font genişliği ölçümüyle** çözüldü (aşağıda) |

**Satır genişliği yöntemi:** QCF sayfa fontlarında iki yana yaslı her satır aynı genişliğe gelecek şekilde tasarlanmış. Yanlış satıra yazılmış bir kelime iki satırın genişliğini bozar. 8.790 satır ölçüldü:
- Normal sapma: ortanca %0,37; satırların %99'u %1,6'nın altında.
- **Quran.com:** 27, 177, 400 ve 443. sayfalarda ±%9–16 sapma → hatalı. QUL bu sayfalarda doğru.
- **254. sayfa:** iki kaynak da hatalı. En iyi uyum "بَعۡدَ" 6. satırda, "مَا" 7. satırda (+%0,5 / −%0,9). Bu, gerekçeli tek bir düzeltme olarak eklendi.
- **Sonuç düzende** 8.790 satırın tamamı %3 içinde; en büyük sapma %2,63.

### 7.3 Kelime bölünmesi sorunu ve kararı
Karşılaştırmada **beş kaynağın kelime bölünmesinin 7 yerde farklı olduğu** ortaya çıktı (tablo: `VERI_KAYNAKLARI.md` Q-12). Harfler her kaynakta aynı; fark yalnızca kelime sınırında:
- **Corpus ve Quran.com dilbilgisi birimini sayıyor:** "baʿdamā" (bağlaç), "Il-yāsīn" (özel isim) tek kelime. Aynı ifadenin esreli hali "min baʿdi mā" 27 yerde her kaynakta 2 kelime.
- **Kral Fahd'ın iki ürünü bile ayrışıyor:** Unicode metni ile mushaf fontu 4 yerde farklı bölüyor ("لَّوۡمَا", "مَالِيَ" ×2, "إِلۡ يَاسِينَ").
- **Arap yazısındaki belirsizlik:** ا ve و sonraki harfe bağlanmadığı için "لوما" ile "لو ما" basılı sayfada yalnızca boşluk genişliğiyle ayrılıyor.

**Karar (kullanıcı, 28.10.2026): esas kelime bölünmesi KFGQPC resmi metni, 77.430 kelime.** Konumlar (sure:ayet:kelime), hata işaretleri ve arama bu kelimelere bağlanır.

**Eşlemeler elle yazılmaz, veriden çıkarılır:**
- Betik üç kaynağı **harf iskeleti** üzerinden hizalar. İskelet = yalnızca temel harfler; hareke, işaret ve tatvîl atılır, elif/ye/vav aileleri tek harfe katlanır. Bu yalnızca hizalama içindir; saklanan metni etkilemez.
- Toplam harf sayısı eşit olan en küçük kelime grupları bulunur. Grup içinde bire bir, birden-çoğa veya çoktan-bire eşleme otomatik belirlenir.
- Sonuç:
  - **Corpus eşlemesi:** 7 yerde bire bir değil.
  - **Glif eşlemesi:** 4 yerde bire bir değil.
  - **İmla farkı:** 1 tane (11:13, افتريه / افتراه).
- Testler bu kümelerin dışına çıkılmadığını denetler.

### 7.4 Veri hattındaki değişiklikler
| Dosya | Değişiklik |
|---|---|
| `tool/content/sources/qul/` (yeni) | QUL düzen ve glif veritabanları, değiştirilmeden + `manifest.json` (kaynak, tarih, lisans notu). Fontlar depoda değil. |
| `fetch_sources.dart` | Quran.com'dan sayfa/satır alınmıyor; kelimelere QCF V2 glif kodu eklendi (eşleme köprüsü). `layout_madani_1421.json` silindi. Yeniden indirmede metin ve meta veri birebir aynı çıktı. |
| `build_content_db.dart` | Baştan yazıldı. Kelimeler KFGQPC metninden; Corpus ve glif eşlemeleri otomatik; düzen QUL'den; 254. sayfa düzeltmesi; besmele satırlarına sure numarası; doğrulamalar (9.046 satır, glif kapsaması, hiçbir kelime iki satıra bölünmüyor, 604 sayfa). |
| Şema (`content_database.dart`) | `words.word_text` (KFGQPC yazılışı), `words.morph_first/last` (Corpus eşlemesi). `layout_word_glyphs` yerine `layout_glyphs` (glif birimi → ilk/son kelime). `layout_lines` artık glif aralığı ve `is_centered` taşıyor. `kContentVersion` 2 → 3. |
| `check_line_widths.dart` (yeni) | Sayfa fontlarını kendisi okuyup (küçük TrueType okuyucu: `cmap`, `hmtx`) satır genişliklerini denetler; yerelde çalışır |
| `content_checksums.dart` | Yeni alanlar sağlamaya dahil. Sağlamalar yeniden sabitlendi: yalnızca 114 surenin `words` ve düzen sağlaması değişti; **metin ve meta veri sağlamaları değişmedi.** |

### 7.5 Testlerdeki değişiklikler
- **T-01:**
  - Kelime sayısı 77.430 oldu.
  - Kelimeler ayetin KFGQPC metnini birebir oluşturuyor.
  - Corpus farkı yalnızca 7 bilinen yerde, glif farkı yalnızca 4 bilinen yerde.
  - Örnek eşleme kontrolleri: "بَعۡدَ" ve "مَا" aynı Corpus kelimesine bağlanıyor; "لَّوۡمَا" iki Corpus kelimesini kapsıyor.
- **T-02:**
  - Satırlar 83.668 glifin her birini sırayla ve bir kez kapsıyor.
  - Hiçbir kelime iki satıra bölünmüyor.
  - 256 ortalı satır var; ilk iki sayfanın tamamı ortalı.
  - 254. sayfa düzeltmesi yerinde.
- **Sonuç:** 44 test geçiyor, analiz temiz, emülatörde entegrasyon testi geçiyor.

### 7.6 Font kararı (TK-06)
- **Sorun:** QCF V2 sayfa fontları 604 dosya, toplam **208 MB**. Ağırlığın tamamına yakını harf çizimleri olduğu için küçültülemiyor. Hedefimiz uygulama ≤ 60 MB (NF-PF06) ve ilk açılışta internetsiz çalışma (M16-01).
- **Karar (kullanıcı, 28.10.2026):**
  - Uygulama **tek bir Kur'an fontuyla** gelir; 604 sayfanın hepsi aynı fontla, aynı satır düzeniyle görünür.
  - **Birebir görünüm font paketi** kullanıcıya sorulur; onay verirse indirilir.
  - Paket **tamamı indikten sonra** tüm sayfalarda birlikte devreye girer. Karışık görünüm olmaz.
- **Uygulanması:** F0-05'te.

### 7.7 Yerel geliştirme notu
QUL'den indirilen dosyalar `C:\Users\HUAWEI\Desktop\GuvenBaris\Projects\qul_indirilenler` klasöründe. `check_line_widths.dart` çalıştırılırken font arşivinin açılmış hali (604 TTF) kullanılır.

---

## 8. F0-05 Mushaf Sayfası Çizimi (devam ediyor)
**Durum:** 🔨 Neredeyse tamam · **Gereksinimler:** M2-01, M2-02, M2-08, M3-03, M8-02, NF-PF02, NF-PF06, TK-06

### 8.1 Yapılanlar
| Parça | Dosya | Açıklama |
|---|---|---|
| Sayfa modeli | `lib/features/quran/domain/mushaf_page.dart` | `MushafPage` → `MushafLine` (tür, ortalı mı, kelimeler, glifler). `WordRef` = düzenden bağımsız `sure:ayet:kelime` konumu (M2-15) |
| Sayfa sorgusu | `QuranRepository.getMushafPage` (`drift_quran_repository.dart`) | Bir sayfa için 3 sorgu: satırlar, glifler, kelimeler. Emülatörde 5–10 ms. |
| Okuma ekranı | `lib/features/reader/presentation/reader_page.dart` | 604 sayfa sağdan sola (`PageView`, RTL). Üst çubukta sayfa/cüz, tema ve çizim yöntemi düğmeleri; altta seçilen kelimenin konumu. Komşu 2'şer sayfa önceden yüklenir. |
| Sayfa çizimi | `mushaf_page_view.dart` | Satır yüksekliği = sayfa/15. İki yana yaslı satırda kelimeler satıra yayılır, ortalı satırlar ortalanır. Yazı boyutu, sayfanın en uzun satırı sığacak şekilde **parça parça ölçülür** ve önbelleğe alınır. İki çizim yöntemi aynı bileşende. |
| Temalar | `mushaf_colors.dart`, `reader_settings.dart` | Açık / sepya / koyu (M2-08). Kalıcılık F0-06/F0-08'de. |
| QCF font paketi | `reader/domain/mushaf_font_pack.dart`, `reader/data/directory_mushaf_font_pack.dart` | Arayüz + cihazdaki klasörden okuyan uygulama (`qcf_v2/p{n}.ttf`). Geliştirmede fontlar emülatöre `adb push` ile kopyalandı; indirme akışı bu klasörü dolduracak. |
| Performans ölçümü | `lib/core/diagnostics/perf_probe.dart` | Yalnızca dev ortamında: kare süreleri (build/raster) ve sayfa yükleme süresi `adb logcat`'e `PERF` önekiyle yazılır. |
| Yönlendirme | `AppRoutes.readerAt(page)` | Ana sayfadaki sureye dokununca o surenin sayfası açılır. |

### 8.2 Görsel doğrulama (emülatör)
- **1. sayfa (Fatiha):** başlık + 7 satır, hepsi ortalı; satır dağılımı basılı nüshayla aynı. QCF modunda süslü ayet numaraları ve gerçek hat.
- **6. sayfa:** 15 satır, 2:30 ile başlıyor ve 2:37 ile bitiyor; QCF modunda basılı 1421H sayfasının görünümünün aynısı.
- **Kelimeye dokunma:** "وَإِذۡ" → `2:30:1`; vurgulanıyor, tekrar dokununca kalkıyor (widget testiyle de korunuyor).
- **Koyu tema:** metin alanı da koyu; QCF glifleri temaya göre renkleniyor.
- **Bulunan ve düzeltilen hata:** QCF modunda ortalı satırlar taşıyordu (yazı boyutu satır tek parça metin gibi ölçülüyordu). Ölçüm, ekrandaki gibi parça parça yapılacak şekilde düzeltildi.

### 8.3 Ölçümler
**Uygulama boyutu (NF-PF06, hedef ≤ 60 MB):** prod release, arm64 **22,4 MB** (armeabi-v7a 19,8 MB). İçerik veritabanı dahil. QPC Hafs fontu ~1 MB ekleyecek. QCF paketi uygulamaya girmez (indirme ~130 MB, cihazda 208 MB).

**Kaydırma (emülatör, profile derleme, 20 sayfa):**
| Yöntem | build p90 | raster p90 | Kare p90 | 60 fps'yi aşan kare |
|---|---|---|---|---|
| Tek font | 0,8–1,6 ms | ~16 ms | ~17 ms | %7–%25 |
| QCF (yeni sayfalar) | 23–26 ms | 55–64 ms | 55–74 ms | ~%70 |
| QCF (fontu yüklü sayfalarda geri) | 1,3–1,6 ms | ~50 ms | ~51 ms | ~%72 |

**Yorum:**
- **Veritabanı darboğaz değil:** sayfa verisi 10 ms'nin altında yükleniyor.
- **QCF'deki build yükü, her sayfanın yeni fontunun yüklenmesinden geliyor:** Flutter yeni font gelince metinleri yeniden düzenliyor; fontu yüklü sayfalarda bu yük kayboluyor. Çözüm: fontları kaydırma anında değil, boş anlarda önceden ve topluca yüklemek.
- **QCF'deki raster yükü** karmaşık hat gliflerinin çizimi. Emülatörün grafik birimi **yazılımla taklit edildiği** (`ro.hardware.egl=emulation`) için bu sayılar gerçek cihazı temsil etmiyor. **Gerçek bir telefonda ölçülmesi gerekiyor.**
- **Raster gerçek cihazda da yavaş çıkarsa** yedek çözüm: sayfayı bir kez resme çizip kaydırırken resmi göstermek. Bellek maliyeti sayfa başına ~9 MB; 5 sayfa tutulur.

### 8.4 Font lisansı
QPC Hafs ve QCF fontlarının ikisi de KFGQPC'nin malı; lisans metni yazılı izin olmadan çoğaltmayı yasaklıyor. Bu yüzden yayından önce **yazılı izin şart** (AK-11). Font, kodda tek bir yerden (`kQuranFontFamily`) değişiyor; izin çıkmazsa yedek, OFL lisanslı Amiri Quran.

### 8.5 İkinci kısım: tek font, ayet görünümü, yatay mod
| Parça | Açıklama |
|---|---|
| **Tek Kur'an fontu** | `assets/fonts/UthmanicHafs_V22.ttf` (KFGQPC HAFS Uthmanic Script v2.2, 298 KB, QUL kaynak 245). Font dosyasının içindeki lisans metni de "KFGQPC'nin malıdır, çoğaltılamaz" diyor → yayın için yazılı izin (AK-11). Varsayılan görünüm artık bu fontla; süslü ayet numaralarını font kendisi çiziyor. |
| **Ayet görünümü (M2-01)** | `ayah_list_view.dart`: 6.236 ayet tek listede (`scrollable_positioned_list` paketi ile istenen ayete doğrudan atlanır). Sure başlarında başlık, her ayetin altında konumu. Yazı boyutu A−/A+ ile %50–%250 (M2-07). |
| **Konum çapası (M2-15)** | `readerAnchorProvider`: okunan ayet. Sayfa görünümünde sayfanın ilk ayeti, ayet görünümünde ekranın en üstündeki ayet. Görünüm değişince yeni görünüm çapadan açılır. `AyahIndex`: 0–6235 sıra ↔ sure:ayet (6.236 ayetin hepsi testle doğrulandı). |
| **Emülatör doğrulaması** | Ayet görünümünde 2:30'a kaydırıldı → sayfa görünümü **6. sayfa** (2:30 bu sayfanın ilk ayeti) → tekrar ayet görünümü **2:30**. |
| **Çift sayfa (M2-03)** | Yatay tablette (en kısa kenar ≥ 600 dp) iki sayfa yan yana; basılı mushaf gibi tek sayfa sağda, çift sayfa solda (1–2, 3–4…). Tablet emülatörü olmadığı için (`cmdline-tools` eksik) ekran testleriyle doğrulandı. |
| **Telefonda yatay** | İlk denemede kullanılamazdı (yazı küçük, satırlar ekran boyunca dağınık). Düzeltildi: sayfa ekran genişliğine sığar, mushaf oranında uzar ve dikey kaydırılır. |
| **Döndürme (M2-10)** | Okunan sayfa döndürmede değişmiyor (emülatör + ekran testi: 5. sayfa → yatay tablette 5–6 açılımı → dikeyde yine 5). |
| **Hata düzeltmesi** | Sayfa okunamadığında çapa ayarlayan kod yakalanmamış hata fırlatıyordu (Riverpod 3 otomatik yeniden deneme); hataya dayanıklı yapıldı. |

### 8.6 Gözlemler
- **Açıklanamayan sayfa sıçraması (tekrarlanamadı):** yeniden kurulumdan sonraki ilk açılışta otomatik dokunma/kaydırma komutları sonrası okuma ekranı 603. sayfada görüldü. Aynı zamanlamayla tekrar denendiğinde sayfalar 1–8 sırayla yüklendi. İlk açılışın yavaş olması ve komutların beklenmedik anda işlenmesi olası neden; gerçek cihaz testinde gözlenecek.
- **Hızlı kaydırma:** ayet görünümünde çok hızlı otomatik kaydırma komutları ilk denemede listeyi kaydırmadı; normal hızda çalışıyor. Gerçek cihazda bakılacak.
- **Tek font görünümü:** satırlar kelimeler arasına boşluk eklenerek yaslanıyor; basılı nüsha harf uzatmasıyla (keşide) yaslar. Satır ve sayfa sınırları aynı; görsel fark yalnızca kelime aralıklarında.

### 8.7 Kalan işler
- **Font paketi izin sorusu ve indirme akışı (TK-06):** paketin nereden indirileceği belirlenmeli (aşağıda).
- ⏸ **Gerçek cihazda performans ölçümü:** ertelendi (kullanıcı kararı).
- ⏸ **7 sayfanın basılı nüshayla karşılaştırılması:** ertelendi (kullanıcı kararı; düzen F0-04'te çapraz doğrulandı).
- **Sonuç raporu:** bu bölüm; yöntem kararı F0-10'da `CLAUDE.md`'ye.

---

## 9. Genel durum ve bekleyen kararlar
**Son güncelleme:** 28.10.2026

| İş paketi | Durum |
|---|---|
| F0-01 Depo ve proje kurulumu | ✅ Android · ⏳ iOS ilk CI çalışması |
| F0-02 Mimari iskelet | ✅ |
| F0-03 Kur'an veri hattı | ✅ |
| F0-04 Metin bütünlüğü testleri (T-01, T-02) | ✅ (25 sayfa QUL ile doğrulandı; esas kelime KFGQPC) |
| F0-05 Mushaf sayfası çizimi (en riskli) | 🔨 Neredeyse tamam (çizim, dokunma, temalar, boyut, ayet görünümü, çift sayfa); kalan: font paketi indirme (§8.7); gerçek cihaz ve basılı nüsha ertelendi |
| F0-06 Kullanıcı veritabanı | ⬜ |
| F0-07 Dil · F0-08 Tema · F0-10 `CLAUDE.md` · F0-11 Erişilebilirlik | ⬜ |
| F0-09 Test ve CI | ✅ · ⏳ kırmızıya düşme denemesi |

**Bekleyen kararlar ve işler**
- **Uygulama adı:** aday "Kur'anla Yaşamak"; karar sonraya bırakıldı (AK-04).
- **Veri ve font lisansı (AK-11):** Quran.com / KFGQPC; yayından önce yazılı izin gerekecek.
- ~~**Secde listesi (Q-8)**~~: ✅ Karar (28.10.2026): **14 secde** (Hanefi). 22:77'deki ۩ işareti basılı metnin parçası olarak sayfada görünür, ama uygulama onu secde ayeti olarak işaretlemez.
- **Arama metni (Faz 1):** `ayahs.text_uthmani` Tanzil kökenli (Tanzil metniyle aynı); uygulamada kaldığı sürece "Hakkında" ekranında Tanzil atfı zorunlu. Arama KFGQPC metniyle yapılabilirse alan kaldırılır (~1,3 MB, atıf yükümlülüğü kalkar). Tanzil dosyalarının APK'ya girmediği doğrulandı.
- **Yayın öncesi kelime bölünmesi teyidi:** lisans görüşmelerinde (AK-11) Diyanet'in dijital mushafındaki bölünmeye de bakılması önerilir (Q-12).
- **Android `cmdline-tools` kurulumu:** lisans onayı için.
- **GitHub'da yapılacaklar:** iOS iş akışını elle çalıştırmak; bilerek bozulmuş bir PR ile CI'ın kırmızıya düştüğünü görmek.
