# Faz 0: Temel ve İskelet

> **Amaç:** Sonraki tüm fazların üzerine inşa edileceği iskeleti kurmak ve projenin **en büyük teknik riskini** erkenden çözmek: mushaf sayfasının basılı nüshayla birebir aynı çizilmesi.
> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (özellikle 9.7 Mimari Kısıtlar, 8. İçerik, 12. Test), `Yol_Haritasi.md`, `Faz_0_Notlar.md` (her iş paketinde ne yapıldığı ve neden)
> **Durum:** 🔨 Devam ediyor (F0-01 Android tarafı, F0-02, F0-03, F0-04 ve F0-09 tamam; F0-05 tamam (2 doğrulama ertelendi); F0-06 ve F0-07 tamam; iOS doğrulaması ve CI kırmızı denemesi GitHub'da ilk çalıştırmayı bekliyor)

## Faz Sonu Çıktısı (Definition of Done)
- [ ] Flutter projesi Android (API 24+) ve iOS (15+) üzerinde açılıyor.
- [ ] Kur'an verisi veritabanından okunuyor ve **seçilen bir mushaf sayfası basılı nüshayla birebir çiziliyor** (Fatiha, Bakara 1. sayfa ve rastgele 5 sayfa elle kontrol edildi).
- [x] Kur'an metin bütünlüğü (T-01) ve sayfa düzeni (T-02) testleri otomatik çalışıyor ve geçiyor. (25 baskı farkı QUL'ün 1421H düzeniyle doğrulandı; satırlar fontla ölçüldü)
- [ ] Katmanlı mimari, kullanıcı veritabanı (UUID, zaman damgaları, migration altyapısı) ve sahte servis arayüzleri hazır.
- [ ] TR/AR/EN dil altyapısı ve tema altyapısı çalışıyor (AR'de RTL).
- [ ] CI analiz + test çalıştırıyor (haftalık, PR'da ve elle; her commit'te değil, karar 28.10.2026).
- [ ] `CLAUDE.md` mimari ve kod kurallarıyla yazıldı.

## Faz 0 Başlangıç Kararları
| # | Konu | Karar |
|---|---|---|
| S1 | Paket adı (application id / bundle id) | ✅ Geçici: `com.example.quranapp`. **İlk mağaza yüklemesinden önce kalıcı adla değiştirilir** (Faz 3 kontrol listesine eklendi). Kişisel ad kullanılmayacak. |
| S2 | Proje adı | ✅ Flutter proje/Dart paket adı: `quran_app` (nötr, markadan bağımsız). Telefonda görünen ad geçici olarak "Kur'an" olur; marka kararıyla (AK-04) değiştirilir. |
| S3 | İlk hedef mushaf düzeni (AK-11) | ✅ Medine mushafı, 604 sayfa (Kral Fahd). Diğer düzenler M2-14 ile eklenir; Türkiye düzeni Faz 1'de. |
| S4 | Geliştirme ortamı | ✅ Flutter 3.47.8 / Dart 3.13.7, Android Studio, Android SDK 36, emülatör (API 37) kuruldu ve doğrulandı (28.10.2026). ⚠️ Android `cmdline-tools` eksik (lisans onayı için gerekli, derlemeyi engellemiyor). iOS derlemesi GitHub Actions macOS makinesinde yapılacak. |
| S5 | Depo yapısı | ✅ Git deposu proje kökünde (`main` dalı); Flutter projesi `quran_app/` altında. Dokümanlar depoda; yorum analizi ham verileri (`test.csv`, `google_play_reviews/`, `output_appstore/`) depo dışında. Uzak depo: özel GitHub reposu (TK-09). |

---

## Teknik Kararlar (Faz 0'da verilir)

Aşağıdakiler varsayılan önerilerdir; itiraz yoksa bu şekilde uygulanır. Kararlar `CLAUDE.md`'ye yazılır.

| # | Konu | Öneri | Gerekçe |
|---|---|---|---|
| TK-01 | Durum yönetimi | **Riverpod** | Test edilebilir, bağımlılık enjeksiyonu yerleşik; MK-06 (servisleri değiştirebilme) için uygun |
| TK-02 | Yerel veritabanı | **Drift (SQLite)** | Tip güvenli, **sürümlü migration** desteği (MK-04), büyük salt okunur veriyle iyi çalışır, test edilebilir |
| TK-03 | Yönlendirme | **go_router** | Derin bağlantı (ayet paylaşımı) desteği |
| TK-04 | Klasör yapısı | **Özellik bazlı (feature-first)** + katmanlar: `presentation / application / domain / data` | Modüller (M2, M8…) birbirinden bağımsız büyüyebilir |
| TK-05 | Dil dosyaları | Flutter `gen_l10n` + ARB dosyaları | Resmi yöntem; NF-Y01 |
| TK-06 | **Mushaf çizim yöntemi** | ✅ **Güncel karar (28.10.2026, F0-05 sonrası): yalnız DigitalKhatt New Madina** (SIL OFL, 0,5 MB). Medine hattının dijital yeniden çizimi; sayfa, ayet görünümü ve başlıklar bu fontla; satırlar QUL 1421H düzeniyle. KFGQPC fontları ve QCF paketi kullanılmaz (izin ihtiyacı ve 130 MB indirme ortadan kalktı). ~~İlk karar: Uygulama **tek bir Kur'an fontuyla** (ör. KFGQPC Uthmanic Hafs, ~1 MB) ve QUL'ün satır düzeniyle gelir; 604 sayfanın hepsi aynı fontla, satır ve sayfa sınırları basılı nüshayla aynı. **QCF V2 sayfa fontları (birebir görünüm, 604 dosya, 208 MB) isteğe bağlı pakettir:** kullanıcıya sorulur, onay verirse indirilir ve **tamamı indikten sonra** tüm sayfalar birlikte geçer; karışık görünüm olmaz.~~ | 208 MB, uygulama boyutu hedefini (NF-PF06 ≤ 60 MB) aşıyor ve ilk açılış internetsiz olmalı (M16-01). Glif fontlarının ağırlığı harf çizimleri; küçültme payı yok. Kelimeye dokunma iki yöntemde de düzen verisiyle çalışır. F0-05'te iki yöntem ekranda denenir. |
| TK-07 | Ortamlar (flavor) | `dev` ve `prod` | Sahte ve gerçek servislerin ayrılması |
| TK-08 | Kod kalitesi | `flutter_lints` + ek katı kurallar, `dart format` | |
| TK-09 | CI | GitHub Actions (analiz, test, Android derleme) | Repo GitHub'da olacaksa; değilse eşdeğeri |
| TK-10 | Çökme raporlama | **Faz 3'te karar verilir** (Sentry / Crashlytics / kendi sunucu). Faz 0'da yalnızca soyut `CrashReporter` arayüzü kurulur. | Sunucu ve gizlilik kararlarına bağlı (NF-A02) |

---

## İş Paketleri

Öncelik: **[Z]** zorunlu, **[Ö]** önemli. Her paket bitince kutusu işaretlenir.

### F0-01 Depo ve Proje Kurulumu [Z]
- [x] Git deposu, `.gitignore`, dal stratejisi (`main` + özellik dalları)
- [x] Flutter projesi oluşturma; `minSdk 24`, iOS deployment target 15
- [x] Paket adı (S1), uygulama adı (S2)
- [x] `dev` / `prod` flavor yapılandırması (TK-07) — Android: productFlavors (dev paketi `.dev` ekli, yan yana kurulabilir); Dart: `main_dev.dart` / `main_prod.dart`. iOS Xcode şemaları Mac/CI erişimiyle eklenecek.
- [x] Lint kuralları ve format ayarı (TK-08)
- [x] `README.md`: kurulum ve çalıştırma
- [ ] iOS'ta açılış doğrulaması: `ios.yml` iş akışı hazır, GitHub'da ilk çalıştırma bekleniyor
- **Bitti:** Uygulama iki platformda ve iki flavor'da boş ekranla açılıyor.

### F0-02 Mimari İskelet [Z] — MK-06, MK-07
- [x] Feature-first klasör yapısı (TK-04)
- [x] Riverpod kurulumu ve bağımlılık sağlayıcıları (Riverpod 3, kod üretimsiz)
- [x] go_router ile temel rotalar (Ana sayfa, Okuma, Ayarlar)
- [x] Hata ve sonuç tipleri (`Result<T>` = `Ok`/`Err`, `AppFailure`), loglama arayüzü (`AppLogger`); yakalanmamış hatalar `CrashReporter`'a yönlenir
- [x] **Sahte servis arayüzleri:** `AuthService`, `SyncService`, `LessonRepository`, `BillingService`, `CrashReporter`. Her biri için `Fake…` uygulaması; flavor'a göre seçilir. `prod`'da gerçek uygulaması olmayan servis açık bir `UnimplementedError` verir (sessizce sahteye düşmez); `CrashReporter` TK-10 kararına kadar iki ortamda da sahtedir. Arayüzler iskelet düzeyindedir; ayrıntıları veri modeli dondurulurken kesinleşir.
- **Bitti:** Bir sahte servisin gerçeğiyle değiştirilmesi tek satırlık sağlayıcı değişikliğiyle yapılabiliyor (örnek testle gösterilir).

### F0-03 Kur'an Veri Hattı [Z] — İÇ-01, İÇ-02, İÇ-10, MK-05
- [x] Geliştirme için kaynak seçimi ve **lisans kontrol listesi** (İÇ-10): Quran.com API v4 (metin, kelime, sure meta verisi, Medine 1421H/QCF V2 düzeni). Tanzil F0-04'te bağımsız referans olarak eklenecek. Quran.com'un yayın lisansı belirsiz; AK-11 ile çözülür. 1405H (QCF V1) düzeni satır verisi tutarsız olduğu için alınmadı.
- [x] Ham veriyi işleyip **salt okunur içerik veritabanı** üreten dönüştürme betiği (depoda, tekrar çalıştırılabilir): `tool/content/fetch_sources.dart` (ham veri, depoda) + `tool/content/build_content_db.dart` (veritabanı, depo dışında; üretimde veriyi doğrular)
- [x] Şema: sure, ayet, kelime, cüz, hizb/rubu', secde işaretleri, sure meta verisi (ad TR/AR/EN, iniş yeri, ayet sayısı)
- [x] **Çoklu mushaf düzeni şeması (M2-14):** metin (ayet/kelime) bir kez saklanır; her düzen ayrı bir `mushaf_layout` kaydı ve kendi `sayfa → satır → kelime aralığı` eşlemesiyle tanımlanır. Yeni düzen eklemek kod değişikliği değil, veri + font paketi eklemektir. Tablolar: `mushaf_layouts`, `layout_lines` (sayfa/satır → tür + kelime aralığı), `layout_pages` (sayfa → ilk/son ayet), `layout_word_glyphs` (kelime → sayfa fontu glifi).
- [x] İçerik veritabanı uygulama paketine gömülü gelir (M16-01); sürüm numarası taşır (`kContentVersion`; ilk açılışta cihaza kopyalanır, salt okunur açılır; 11,6 MB)
- [x] Veri kaynağı, sürümü ve lisansı `VERI_KAYNAKLARI.md` dosyasına yazılır (bilinen veri durumları Q-1…Q-8 dahil)
- [x] Doğrulama: emülatörde temiz kurulumda sure listesi veritabanından ≤ 2 sn'de geliyor (entegrasyon testi)
- **Bitti:** Uygulama ilk açılışta internetsiz olarak tüm Kur'an verisine erişiyor.

### F0-04 Metin Bütünlüğü Testleri [Z] — T-01, T-02
- [x] T-01: 114 sure, 6.236 ayet; her ayetin metni referans kaynakla karşılaştırması (Tanzil ile karakter karakter; KFGQPC metni, kelimeler ve düzen sure başına SHA-256 ile)
- [x] T-02: 604 sayfanın ilk ve son ayeti referansla eşleşiyor (Tanzil 1405H; 1421H'ye özgü 25 fark tek tek listelendi, doğrulama bekliyor), satırlar tüm kelimeleri sırayla kapsıyor
- [x] Kelime sayısı ve cüz/hizb/rubu'/secde sınırları kontrolü
- [x] Testler CI'da çalışır (haftalık, PR'da ve elle) ve yerelde `flutter test` ile push öncesi çalıştırılır
- [x] Doğrulama: 2:255'te bir hareke ve 36:1'de bir şedde değiştirildi; iki test de kırıldı ve yeri tam gösterdi
- **Bitti:** Veride tek bir karakter değiştirildiğinde test başarısız oluyor (bilerek bozularak denenir).

### F0-05 Mushaf Sayfası Çizim Denemesi (Spike) [Z] — M2-01, M2-02, TK-06
> Projenin en riskli teknik konusu. Faz 1'e geçmeden çözülmelidir.
- [x] Sayfa çizimi; satır düzeni ve ortalı satırlar birebir (TK-06). Üç yöntem denendi (KFGQPC Hafs, QCF V2 birebir, DigitalKhatt); **seçilen: DigitalKhatt** (açık lisans, Medine hattı, akıcı).
- [x] Kelimeye dokununca kelime kimliğinin alınması (M3-03 ve M8-02'nin ön koşulu); iki çizim yönteminde de
- [x] Açık / sepya / koyu temada çizim (M2-08); koyu temada metin alanı da koyu, QCF glifleri temaya göre renkleniyor
- [x] Yazı boyutu ölçekleme ve tablette çift sayfa ön denemesi (M2-03, M2-07): ayet görünümünde %50–%250; yatay tablette çift sayfa (açılım 1–2, 3–4…; widget testleriyle); telefonda yatayda sayfa genişliğe sığar ve dikey kaydırılır; döndürmede sayfa korunur (M2-10). Sayfa görünümünde yakınlaştırma Faz 1'de.
- [x] Uygulama boyutu (NF-PF06): prod release arm64 **22,4 MB** (içerik veritabanı dahil)
- [~] Performans (NF-PF02): emülatörde ölçüldü (tek font akıcı; QCF'de çizim yavaş, emülatörün yazılım GPU'su nedeniyle). ⏸ **Gerçek cihaz ölçümü ertelendi** (kullanıcı kararı 28.10.2026; geçişler çalışıyor).
- [x] ~~Font paketi indirme akışı ve izin sorusu (TK-06)~~: gerek kalmadı; DigitalKhatt uygulamayla gelir (karar 28.10.2026)
- [x] **Düzen değiştirme denemesi (M2-14, M2-15):** mushaf sayfası ↔ ayet görünümü geçişinde aynı ayette kalınıyor (emülatörde: ayet görünümünde 2:30 → sayfa 6 → tekrar 2:30). Konum düzenden bağımsız `sure:ayet` çapasıyla tutuluyor.
- [ ] Sonuç raporu: seçilen yöntem, karşılaşılan sorunlar, Türkiye mushaf düzeni için uygulanabilirlik
- **Bitti:** Seçilen 7 sayfa (Fatiha, Bakara 2, rastgele 5) basılı nüshayla yan yana karşılaştırıldı ve farksız; yöntem kararı `CLAUDE.md`'ye yazıldı.
- ⏸ **Ertelendi (kullanıcı kararı 28.10.2026):** basılı nüsha karşılaştırması ileride yapılacak. Gerekçe: düzen kelime kelime üç kaynakla ve font genişliği ölçümüyle doğrulandı (F0-04). Yöntem kararı F0-10'da `CLAUDE.md` yazılırken eklenecek.

### F0-06 Kullanıcı Veritabanı Altyapısı [Z] — MK-02, MK-03, MK-04, MK-09
- [x] İçerik veritabanından **ayrı** kullanıcı veritabanı (MK-05): `lib/core/database/user_database.dart`, cihazda `user/user.sqlite`
- [x] Temel tablo şablonu: UUID id, `createdAt`, `updatedAt`, `deletedAt` (`SyncedRecord`; tarihler UTC, ISO-8601 metin)
- [x] **Konum tipi:** tüm kullanıcı kayıtlarında konum `sure:ayet(:kelime)` olarak tutulur; sayfa numarası asla saklanmaz (M2-15): `reading_positions` (surah, ayah, word)
- [x] İlk tablolar: `user_profiles` (localUserId), `settings`; v2'de `reading_positions` (son okunan yer)
- [x] Migration altyapısı ve migration test şablonu (T-04 temeli): `drift_dev make-migrations`, şema fotoğrafları `drift_schemas/`, testler `test/drift/`
- [x] Güncelleme öncesi otomatik yerel yedek (NF-G03): şema sürümü eskiyse migration'dan önce kopya, son 3 yedek
- **Bitti:** Örnek bir v1→v2 migration'ı test ile doğrulandı; veri kaybı yok. ✅ (bilerek bozulan migration testi kırdı)

### F0-07 Dil ve Yerelleştirme [Z] — M13-01, NF-Y01, NF-Y03
- [x] `gen_l10n` + TR / AR / EN ARB dosyaları (`lib/l10n/`, şablon `app_tr.arb`; Arapça çoğul kuralları dahil)
- [x] AR için tam RTL düzen kontrolü (widget testi + emülatör: ana sayfa, okuma, ayarlar)
- [x] Dil seçimi ayarı ve kalıcılığı (M13-02): Cihaz dili / Türkçe / العربية / English; cihaz dili desteklenmiyorsa İngilizce. Ek: rakam seçimi (NF-Y03): dile göre / Batı / Doğu Arap
- [x] Kodda gömülü metin olmadığını denetleyen lint/kontrol: `test/l10n/no_hardcoded_strings_test.dart` (bilerek eklenen metni yakaladı)
- **Bitti:** Dil değişince tüm iskelet ekranları o dile ve yöne geçiyor. ✅

### F0-08 Tema ve Tasarım Temeli [Z] — M2-08, NF-E01, NF-E03
- [ ] Renk sistemi: açık, sepya, koyu (WCAG AA kontrast)
- [ ] Tipografi ölçeği (arayüz fontu + Arapça fontlar)
- [ ] Temel bileşenler: buton, liste öğesi, boş durum, hata durumu
- [ ] Minimum dokunma alanı 44×44
- **Bitti:** Üç tema iskelet ekranlarında çalışıyor ve seçim kalıcı.

### F0-09 Test ve CI Altyapısı [Z] — 12. bölüm
- [x] Birim, widget ve entegrasyon testi klasör yapısı (`test/` lib yapısını izler, `integration_test/` cihaz testleri, `test/helpers/` ortak yardımcılar)
- [x] GitHub Actions: `analyze` + `test` + Android derleme (`ci.yml`: haftalık, PR'da ve elle; her commit'te değil). iOS derleme + simülatörde açılış testi `ios.yml` ile haftalık/elle.
- [x] Test kapsamı raporu (iş özeti + `lcov.info` çıktısı)
- [ ] Doğrulama: bilerek bozulan bir commit/PR'ın CI'da kırmızıya düştüğü görülecek
- **Bitti:** Hatalı bir commit CI'da kırmızıya düşüyor.

### F0-10 Proje Dokümantasyonu [Z]
- [ ] `CLAUDE.md`: mimari, klasör yapısı, teknik kararlar (TK-01…TK-10), kod kuralları, test kuralları, gereksinim kodlarına atıf kuralı
- [ ] `VERI_KAYNAKLARI.md`: veri ve lisans envanteri
- [ ] Commit mesajlarında gereksinim kodu kullanımı (ör. `feat(M2-01): sayfa görünümü`)
- **Bitti:** Yeni bir oturumda/geliştiricide proje yalnızca bu dosyalarla anlaşılabiliyor.

### F0-11 Erişilebilirlik Temeli [Ö] — M13-03
- [ ] İskelet ekranlarda semantik etiketler
- [ ] TalkBack/VoiceOver ile hızlı kontrol

---

## Riskler
| Risk | Etki | Önlem |
|---|---|---|
| Mushaf fontu/düzen verisi lisansı yayın için uygun değil | Yayın gecikir | Geliştirme açık veriyle sürer; AK-11 paralel takip edilir; mimari veri kaynağından bağımsız |
| Türkiye mushaf düzeni için hazır dijital veri yok | M2-02 [Z] karşılanamaz | F0-05 raporunda değerlendirilir; gerekirse düzen verisi üretimi ayrı iş olur |
| Sayfa fontlarının uygulama boyutunu artırması | NF-PF06 aşılır | Fontların sıkıştırılması veya ilk açılışta indirme (internetsiz ilk açılış kuralıyla dengelenir) |
| Arapça render farklılıkları (Android/iOS) | Metin bozuk görünür | F0-05'te iki platformda karşılaştırma |

## Kapsam Dışı (Faz 0)
- Okuma ekranının gerçek özellikleri (Faz 1)
- Ses, meal, arama (Faz 1)
- Sunucu ve gerçek servisler (Faz 3)

## Değişiklik Geçmişi
| Tarih | Değişiklik |
|---|---|
| 28.10.2026 | İlk sürüm |
| 28.10.2026 | S4 güncellendi, S5 (depo yapısı) eklendi; F0-01 Android tarafı tamamlandı |
| 28.10.2026 | F0-02 Mimari İskelet tamamlandı; editör VS Code (paylaşılan `.vscode/launch.json` ile dev/prod profilleri) |
| 28.10.2026 | F0-09 Test ve CI altyapısı yazıldı; iOS iş akışı maliyet nedeniyle haftalık/elle |
| 28.10.2026 | CI de her commit yerine haftalık + PR + elle çalışacak şekilde değiştirildi |
| 28.10.2026 | F0-03 Kur'an veri hattı tamamlandı; ilk düzen Medine 1421H (QCF V2) |
| 28.10.2026 | F0-04 metin bütünlüğü testleri tamamlandı; Tanzil test referansı |
| 28.10.2026 | F0-06 kullanıcı veritabanı tamamlandı; okuma ayarları ve son okunan yer kalıcı |
| 28.10.2026 | F0-07 dil ve yerelleştirme tamamlandı; TR/AR/EN, RTL, rakam seçimi, gömülü metin denetimi |
| 28.10.2026 | F0-05: font kararı yalnız DigitalKhatt (OFL); ekrandaki metin harf ve durak işaretiyle doğrulanıyor (T-01) |
| 28.10.2026 | F0-05 başladı: sayfa çizimi (iki yöntem), kelimeye dokunma, temalar, boyut ve ilk performans ölçümleri |
| 28.10.2026 | F0-04 ek: QUL düzen/glif kaynağı oldu; esas kelime bölünmesi KFGQPC (77.430); satır genişliği doğrulaması; TK-06 font kararı |
