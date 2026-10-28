# Faz 0: Temel ve İskelet

> **Amaç:** Sonraki tüm fazların üzerine inşa edileceği iskeleti kurmak ve projenin **en büyük teknik riskini** erkenden çözmek: mushaf sayfasının basılı nüshayla birebir aynı çizilmesi.
> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (özellikle 9.7 Mimari Kısıtlar, 8. İçerik, 12. Test), `Yol_Haritasi.md`
> **Durum:** 🔨 Devam ediyor (F0-01 Android tarafı ve F0-02 tamam; iOS doğrulaması CI ile)

## Faz Sonu Çıktısı (Definition of Done)
- [ ] Flutter projesi Android (API 24+) ve iOS (15+) üzerinde açılıyor.
- [ ] Kur'an verisi veritabanından okunuyor ve **seçilen bir mushaf sayfası basılı nüshayla birebir çiziliyor** (Fatiha, Bakara 1. sayfa ve rastgele 5 sayfa elle kontrol edildi).
- [ ] Kur'an metin bütünlüğü (T-01) ve sayfa düzeni (T-02) testleri otomatik çalışıyor ve geçiyor.
- [ ] Katmanlı mimari, kullanıcı veritabanı (UUID, zaman damgaları, migration altyapısı) ve sahte servis arayüzleri hazır.
- [ ] TR/AR/EN dil altyapısı ve tema altyapısı çalışıyor (AR'de RTL).
- [ ] CI her commit'te analiz + test çalıştırıyor.
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
| TK-06 | **Mushaf çizim yöntemi** | **Sayfa bazlı Kur'an fontları (QPC tipi glif fontları) + satır/kelime düzen verisi.** Yedek plan: görsel sayfalar. | Font yöntemi basılı nüshayla birebir düzen, keskin görüntü, küçük boyut, **kelimeye dokunabilme** (M3-03, M8-02 için şart) ve koyu tema sağlar. Görsel yöntemde kelimeye dokunma ve tema zorlaşır. F0-05'te denenerek kesinleşir. |
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
- [ ] iOS'ta açılış doğrulaması (CI macOS makinesi, F0-09 ile)
- **Bitti:** Uygulama iki platformda ve iki flavor'da boş ekranla açılıyor.

### F0-02 Mimari İskelet [Z] — MK-06, MK-07
- [x] Feature-first klasör yapısı (TK-04)
- [x] Riverpod kurulumu ve bağımlılık sağlayıcıları (Riverpod 3, kod üretimsiz)
- [x] go_router ile temel rotalar (Ana sayfa, Okuma, Ayarlar)
- [x] Hata ve sonuç tipleri (`Result<T>` = `Ok`/`Err`, `AppFailure`), loglama arayüzü (`AppLogger`); yakalanmamış hatalar `CrashReporter`'a yönlenir
- [x] **Sahte servis arayüzleri:** `AuthService`, `SyncService`, `LessonRepository`, `BillingService`, `CrashReporter`. Her biri için `Fake…` uygulaması; flavor'a göre seçilir. `prod`'da gerçek uygulaması olmayan servis açık bir `UnimplementedError` verir (sessizce sahteye düşmez); `CrashReporter` TK-10 kararına kadar iki ortamda da sahtedir. Arayüzler iskelet düzeyindedir; ayrıntıları veri modeli dondurulurken kesinleşir.
- **Bitti:** Bir sahte servisin gerçeğiyle değiştirilmesi tek satırlık sağlayıcı değişikliğiyle yapılabiliyor (örnek testle gösterilir).

### F0-03 Kur'an Veri Hattı [Z] — İÇ-01, İÇ-02, İÇ-10, MK-05
- [ ] Geliştirme için açık lisanslı kaynak seçimi ve **lisans kontrol listesi** (İÇ-10). Örnek adaylar: Tanzil Uthmani metni, açık mushaf düzen verileri. Yayın lisansı AK-11 ile ayrıca çözülür.
- [ ] Ham veriyi işleyip **salt okunur içerik veritabanı** üreten dönüştürme betiği (depoda, tekrar çalıştırılabilir)
- [ ] Şema: sure, ayet, kelime, cüz, hizb/rubu', secde işaretleri, sure meta verisi (ad TR/AR/EN, iniş yeri, ayet sayısı)
- [ ] **Çoklu mushaf düzeni şeması (M2-14):** metin (ayet/kelime) bir kez saklanır; her düzen ayrı bir `mushaf_layout` kaydı ve kendi `sayfa → satır → kelime aralığı` eşlemesiyle tanımlanır. Yeni düzen eklemek kod değişikliği değil, veri + font paketi eklemektir.
- [ ] İçerik veritabanı uygulama paketine gömülü gelir (M16-01); sürüm numarası taşır
- [ ] Veri kaynağı, sürümü ve lisansı `VERI_KAYNAKLARI.md` dosyasına yazılır
- **Bitti:** Uygulama ilk açılışta internetsiz olarak tüm Kur'an verisine erişiyor.

### F0-04 Metin Bütünlüğü Testleri [Z] — T-01, T-02
- [ ] T-01: 114 sure, 6.236 ayet; her ayetin metni referans kaynakla hash karşılaştırması
- [ ] T-02: 604 sayfanın ilk ve son ayeti/kelimesi referansla eşleşiyor
- [ ] Kelime sayısı ve cüz/hizb sınırları kontrolü
- [ ] Testler CI'da her commit'te çalışır
- **Bitti:** Veride tek bir karakter değiştirildiğinde test başarısız oluyor (bilerek bozularak denenir).

### F0-05 Mushaf Sayfası Çizim Denemesi (Spike) [Z] — M2-01, M2-02, TK-06
> Projenin en riskli teknik konusu. Faz 1'e geçmeden çözülmelidir.
- [ ] Sayfa fontlarıyla tek bir sayfanın çizilmesi (satır düzeni birebir)
- [ ] Kelimeye dokununca kelime kimliğinin alınması (M3-03 ve M8-02'nin ön koşulu)
- [ ] Açık / sepya / koyu temada çizim (M2-08)
- [ ] Yazı boyutu ölçekleme ve tablette çift sayfa ön denemesi (M2-03, M2-07)
- [ ] Performans ölçümü: sayfa geçişi ≤ 100 ms (NF-PF02), 604 sayfa font boyutunun uygulama boyutuna etkisi (NF-PF06)
- [ ] **Düzen değiştirme denemesi (M2-14, M2-15):** en az iki düzen (ör. Medine + metin tabanlı ayet görünümü ya da ikinci bir sayfa düzeni) arasında geçişte aynı ayette kalındığının gösterilmesi
- [ ] Sonuç raporu: seçilen yöntem, karşılaşılan sorunlar, Türkiye mushaf düzeni için uygulanabilirlik
- **Bitti:** Seçilen 7 sayfa (Fatiha, Bakara 2, rastgele 5) basılı nüshayla yan yana karşılaştırıldı ve farksız; yöntem kararı `CLAUDE.md`'ye yazıldı.

### F0-06 Kullanıcı Veritabanı Altyapısı [Z] — MK-02, MK-03, MK-04, MK-09
- [ ] İçerik veritabanından **ayrı** kullanıcı veritabanı (MK-05)
- [ ] Temel tablo şablonu: UUID id, `createdAt`, `updatedAt`, `deletedAt`
- [ ] **Konum tipi:** tüm kullanıcı kayıtlarında konum `sure:ayet(:kelime)` olarak tutulur; sayfa numarası asla saklanmaz (M2-15)
- [ ] İlk tablolar (iskelet düzeyinde): `user_profile` (localUserId), `settings`
- [ ] Migration altyapısı ve migration test şablonu (T-04 temeli)
- [ ] Güncelleme öncesi otomatik yerel yedek mekanizmasının iskeleti (NF-G03)
- **Bitti:** Örnek bir v1→v2 migration'ı test ile doğrulandı; veri kaybı yok.

### F0-07 Dil ve Yerelleştirme [Z] — M13-01, NF-Y01, NF-Y03
- [ ] `gen_l10n` + TR / AR / EN ARB dosyaları
- [ ] AR için tam RTL düzen kontrolü
- [ ] Dil seçimi ayarı ve kalıcılığı (M13-02)
- [ ] Kodda gömülü metin olmadığını denetleyen lint/kontrol
- **Bitti:** Dil değişince tüm iskelet ekranları o dile ve yöne geçiyor.

### F0-08 Tema ve Tasarım Temeli [Z] — M2-08, NF-E01, NF-E03
- [ ] Renk sistemi: açık, sepya, koyu (WCAG AA kontrast)
- [ ] Tipografi ölçeği (arayüz fontu + Arapça fontlar)
- [ ] Temel bileşenler: buton, liste öğesi, boş durum, hata durumu
- [ ] Minimum dokunma alanı 44×44
- **Bitti:** Üç tema iskelet ekranlarında çalışıyor ve seçim kalıcı.

### F0-09 Test ve CI Altyapısı [Z] — 12. bölüm
- [ ] Birim, widget ve entegrasyon testi klasör yapısı
- [ ] GitHub Actions: `analyze` + `test` + Android derleme
- [ ] Test kapsamı raporu
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
