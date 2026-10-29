# Faz 1 Çalışma Notları

> **Amaç:** Faz 1'de her iş paketinde ve kararda **ne yapıldığını, neden öyle yapıldığını, hangi dosyaların değiştiğini ve bilinen sorunları** kayıt altına almak. `Faz_1.md` ne yapılacağını ve kutucukları tutar; bu dosya nasıl ve neden yapıldığını anlatır.
> **Bağlı dokümanlar:** `Faz_1.md`, `../Ekran_Tasarimi.md`, `../VERI_KAYNAKLARI.md`, `../CLAUDE.md`, `Faz_0_Notlar.md` (Faz 0 geçmişi)
> **Kural:** Her iş paketi bittiğinde buraya bir bölüm eklenir; sondaki "Genel durum" tablosu güncellenir.

## İçindekiler
1. [S9: Tanzil metninin uygulamadan çıkarılması ve meal lisansı](#1-s9-tanzil-metninin-uygulamadan-çıkarılması-ve-meal-lisansı)
2. [F1-00 Faz 0'dan Devredilenler](#2-f1-00-faz-0dan-devredilenler)
3. [F1-01 Uygulama Kabuğu ve Gezinme](#3-f1-01-uygulama-kabuğu-ve-gezinme)
4. [F1-02 Okuma Ekranı](#4-f1-02-okuma-ekranı)
5. [F1-03 Türkiye Mushaf Düzeni Araştırması](#5-f1-03-türkiye-mushaf-düzeni-araştırması-sonuç-raporu)
6. [Genel durum ve bekleyen kararlar](#6-genel-durum-ve-bekleyen-kararlar)

---

## 1. S9: Tanzil metninin uygulamadan çıkarılması ve meal lisansı
**Tarih:** 29.10.2026 · **Durum:** ✅ · **Karar:** kullanıcı ("tek bir test kaynağı yeterli, veri değişmeyeceği için")

### 1.1 Yapılan
`ayahs.text_uthmani` alanı Quran.com'dan geliyordu ve Tanzil metnidir. Ekranda hiç kullanılmıyordu; yalnızca T-01'de Tanzil ile karşılaştırılıyordu. Ama uygulamayla dağıtıldığı için Tanzil'in koşullarını getiriyordu: telif notu, atıf, tanzil.net bağlantısı, değiştirmeme. Besmele ayrımı da açık bir soruydu. Alan kaldırıldı.

| Değişiklik | Dosya |
|---|---|
| `text_uthmani` sütunu kaldırıldı; içerik sürümü **6 → 7** (cihazda yeni veritabanı kendiliğinden kopyalanır) | `lib/features/quran/data/content_database.dart` (+ üretilen `.g.dart`) |
| `Ayah.textUthmani` kaldırıldı | `quran_models.dart`, `drift_quran_repository.dart` |
| Betik alanı ve Tanzil notunu artık yazmıyor (ham `verses.json` dokunulmadı) | `tool/content/build_content_db.dart` |
| Lisans sayfasında yalnızca font lisansı (Tanzil notu gerekmiyor); `registerContentLicenses()` artık veritabanı almıyor; kullanılmayan `metaValue` kaldırıldı | `content_licenses.dart`, `bootstrap.dart`, `content_database.dart` |
| Lisans sayfası üst metninden (`aboutLegalese`, 3 dil) "Tanzil Project (tanzil.net)" çıkarıldı: Tanzil'den dağıtılan içerik yok | `lib/l10n/app_*.arb` |
| Sağlama değerlerinden `textUthmani` satırları çıkarıldı | `tool/content/content_checksums.dart`, `tool/content/reference/checksums.json` |

**Sonuç:** `content.sqlite` 15,5 MB → **13,9 MB**.

### 1.2 Testler ve kanıt
- **T-01:** "her ayetin metni Tanzil ile karakteri karakterine aynı" testinin yerine "her ayetin harfleri bağımsız kaynakla (Tanzil) aynı: KFGQPC ve DigitalKhatt" testi geldi. Tanzil **tek dış referans** olarak kaldı.
  - Bu test önceden yalnızca dolaylıydı: harfler `text_uthmani` üzerinden karşılaştırılıyordu. Artık uygulamadaki iki metnin ikisi de doğrudan Tanzil dosyasıyla karşılaştırılıyor.
  - T-02 (sayfa, cüz, rubu', secde) değişmedi.
- **Bilerek bozma:** veritabanı kopyasında 2:255'in KFGQPC metninde bir lam (ل) nun (ن) yapıldı. Test şu mesajla kırıldı: "2:255 KFGQPC: 1. karakterde fark (veritabanı U+0646, Tanzil U+0644)". Veritabanı geri yüklenince geçti.
- **Verinin geri kalanı değişmedi:** `checksums.json` farkı yalnızca 114 `textUthmani` satırının silinmesi; başka hiçbir sağlama değeri değişmedi.
- **Yeni lisans testi:** içerik veritabanında `text_uthmani` sütunu ve Tanzil'e ait meta veri olmadığı denetleniyor. Biri alanı yanlışlıkla geri eklerse test kırılır.
- **Toplam:** 161 test geçiyor; `flutter analyze --fatal-infos` temiz.

### 1.3 Soru: Meal lisanssız, yalnızca "buradan kullandık" diyerek eklenebilir mi?
**Kısa cevap: hayır.** Bu bölüm geliştirme ekibinin değerlendirmesidir, hukuki görüş değildir. Yayın öncesi hukuk danışmanına (AK-09) onaylatılmalıdır.

- **Meal bir telif eseridir.** Kur'an'ın kendisi kimsenin eseri değildir, ama bir meal çevirmenin (ya da hakları devraldığı yayıncının) eseridir. Türk hukukunda (FSEK) çeviri "işlenme eser" olarak korunur.
- **Atıf ile izin farklı şeylerdir.**
  - Kaynağı yazmak, *izin verilmiş* bir kullanımda atıf yükümlülüğünü karşılar; kullanım hakkı vermez.
  - Uygulamanın ücretsiz ve reklamsız olması da tek başına izin yerine geçmez. Üstelik uygulamada ücretli dersler olacak; "ticari olmayan kullanım" koşullu izinler bu yüzden yetmeyebilir.
- **Bir mealin bir sitede veya API'de bulunması** (Quran.com, QUL, Tanzil) serbest olduğu anlamına gelmez. Bu siteler mealleri çoğu zaman hak sahibinin izniyle ve kendi koşullarıyla yayınlar. O izin onlara verilmiştir, bize değil.

**Yasal yollar:**

| Yol | Nasıl | Artısı | Eksisi |
|---|---|---|---|
| **1. İzin (önerilen ana yol)** | Diyanet İşleri Başkanlığı'na yazılı başvuru. Uygulamanın ücretsiz ve reklamsız olduğu, mealin değiştirilmeden ve kaynağıyla gösterileceği anlatılır. | Türkiye'de en çok güvenilen meal; kullanıcı beklentisi (M3-01). | Süre ve sonuç belirsiz. |
| **2. Telif süresi dolmuş (kamu malı) meal** | FSEK'te koruma, eser sahibinin ölümünden sonra 70 yıl sürer (süre hesabının ayrıntısı hukukçuya doğrulatılmalı). Adaylar: **Elmalılı Hamdi Yazır** (ö. 1942) ve **Ömer Rıza Doğrul** (ö. 1952) özgün metinleri; EN için **Pickthall** (ö. 1936), **Yusuf Ali** (ö. 1953). | İzin gerekmez. | Dil eski. Piyasadaki **sadeleştirilmiş** baskılar sadeleştirenin ayrı eseridir ve korunur. Dijital metni yayınlayan kurumun kendi koşulları veya veri tabanı hakkı olabilir; kaynak dikkatle seçilmeli. |
| **3. Açık lisanslı meal** | Çevirmenin veya kurumun açıkça serbest lisansla (ör. Creative Commons) yayınladığı meal. | Koşullar yazılı ve net. | Türkçe için güvenilir bir örnek henüz bilinmiyor; araştırılmalı. |

**Öneri:** geliştirme Diyanet meali ile sürer. Faz 1'in başında Diyanet'e izin başvurusu yapılır; başvuru metnini hazırlayabilirim. Yedek olarak bir kamu malı meal (ör. Elmalılı'nın **özgün** metni) kaynağı doğrulanarak hazırlanır. Karar Faz 1 sonuna kadar verilir (Faz_1.md S1, S2). Aynı ilke tefsir, kelime meali, kari sesleri ve kök verisi için de geçerlidir (İÇ-04…İÇ-06).

---

## 2. F1-00 Faz 0'dan Devredilenler
**Tarih:** 29.10.2026 · **Durum:** 🔨 Yazılı işler ve araçlar ✅ · fiziksel kontroller kullanıcıda · CI ve iOS işleri bu adımda yapılmadı (kullanıcı isteği)

F1-00'daki işlerin çoğu bilgisayarda yapılamaz: gerçek telefon, basılı mushaf, TalkBack'i dinleme, anadili Arapça biri. Bu yüzden her biri için **işi birkaç dakikaya indiren bir araç** hazırlandı ve araçlar emülatörde uçtan uca denendi. Yazılı iş olan F0-05 sonuç raporu doğrudan yazıldı (§2.5).

### 2.1 Basılı nüsha karşılaştırma paketi
- **Araç:** `test/manual/page_sheet_test.dart`. Normal `flutter test`'te atlanır.
- **Çalıştırma:** PowerShell'de `$env:PAGE_SHEET=1; flutter test test/manual/page_sheet_test.dart`.
- **Çıktı:** `build/page_check/`. 7 sayfanın uygulamadaki gibi çizilmiş PNG'si (gerçek veri, DigitalKhatt, açık tema) ve `README.md` kontrol çizelgesi: her satırın türü, ilk ve son kelimesi, "☐ aynı" kutusu.
- **Sayfa seçimi:** F0-05'teki "rastgele 5" yerine düzenin özel durumlarını kapsayan 5 sayfa seçildi.

| Sayfa | Neden |
|---|---|
| 1 | Fatiha: ortalı satırlar, sure başlığı |
| 2 | Bakara başı: sure başlığı ve besmele |
| 176 | İlk secde ayeti (7:206) |
| 187 | Tevbe başı: besmelesiz sure |
| 254 | Tek düzen düzeltmesinin yapıldığı sayfa (Q-13, 13:37) |
| 440 | Yasin başı |
| 604 | Son sayfa: üç kısa sure, ortalı satırlar |

- **Kontrol:** 254. sayfanın görüntüsünde düzeltme yerinde: 6. satır "بَعۡدَ" ile bitiyor, 7. satır "مَا" ile başlıyor. 604. sayfada üç sure, başlıkları ve besmeleleri ve ortalı son satırlar doğru yerde.
- **Bulunan ve düzeltilen:** ilk denemede metinlerin altında sarı çizgiler vardı. Bu, Flutter'ın "üstünde Material yok" uyarısıdır. Uygulamada görünmez (okuma ekranı Scaffold içinde); araçta sayfa Material ile sarıldı.

### 2.2 Gerçek cihaz performans testi
| Ölçüm | Araç | Komut (quran_app içinde, telefon USB ile bağlı) |
|---|---|---|
| Soğuk açılış (motor başlangıcı → ilk kare), NF-PF01 | `tool/perf/startup.dart` (Flutter'ın `--trace-startup` ölçümü, 4 tekrar) | `dart run tool/perf/startup.dart <cihaz_kimliği>` |
| Sayfa yükleme ve 20 sayfa kaydırmada kare süreleri, NF-PF02 | `integration_test/perf_test.dart` + `test_driver/perf_driver.dart` | `flutter drive --profile --no-dds --flavor dev --driver=test_driver/perf_driver.dart --target=integration_test/perf_test.dart -d <cihaz_kimliği>` |

Sonuçlar konsolda özetlenir; ayrıntı `build/perf_startup.json` ve `build/perf_result.json` dosyalarındadır. İkisi de **profile** derlemesiyle çalışır; debug sayıları anlamsızdır.

**Emülatörde deneme** (araçların çalıştığını göstermek için; sayılar gerçek cihazı temsil etmez, grafik birimi yazılımla taklit ediliyor):

| Ölçüm | Emülatör | Hedef |
|---|---|---|
| Soğuk açılış | 1.053 ms (1. ölçüm), 884 ms (2.) | ≤ 2.000 ms |
| Uygulama içi açılış (veritabanları → ana sayfa ilk kare) | 306 ms | — |
| Sayfa yükleme (veritabanı) | p50 5 ms, p90 6 ms, en uzun 13 ms | — |
| Kaydırma, 555 kare | build p90 1,2 ms · raster p90 16,7 ms · bütçeyi aşan 18 (build) / 78 (raster) | takılma yok, sayfa geçişi ≤ 100 ms |

Raster süresi emülatörün yazılım grafik biriminden etkileniyor (F0-05 §8.3'teki gözlemle aynı). Asıl sonuç gerçek cihazda alınacak.

**Bulunan:** `flutter drive` varsayılan ayarla VM servisine bağlanamıyor ("Failed to connect to VM Service… try adding `--no-dds`"). Komuta `--no-dds` eklendi.

**Açılış sırası notu:** uygulama şu an ana sayfayla açılıyor; son okunan sayfa tek dokunuşla açılıyor (M6-05). NF-PF01'in "son okunan sayfaya kadar" ölçümü, F1-01'de "Devam et" akışı tamamlanınca bu araca eklenecek.

### 2.3 TalkBack
- **Otomatik kanıt:** emülatörde uygulamanın Android erişilebilirlik ağacı (`uiautomator dump`, TalkBack'in okuduğu ağaç) okundu. Ayarlar düğmesinin adı var; sure satırları tek parça okunuyor: "Surah 2 / Al-Baqarah / 286 verses / البقرة". Emülatör dili İngilizce olduğu için metinler İngilizce. F0-11'deki etiketler gerçek Android'e ulaşıyor.
- **Kalan:** kulakla dinleme. Adımlar Faz_0_Notlar §13.3'te.

### 2.4 Arapça gözden geçirme tablosu
- **Araç:** `dart run tool/l10n/export_review_sheet.dart` → `build/l10n_review.csv`. Excel'de doğru açılır (UTF-8 BOM).
- **İçerik:** 39 metin. Sütunlar: anahtar, açıklama, Türkçe, English, العربية, boş "Öneri (العربية)" ve "Not".
- **Kullanım:** gözden geçiren doldurup geri gönderir; öneriler `app_ar.arb`'ye işlenir.
- **Zamanlama:** metinler Faz 1 boyunca çoğalacak. Tablo her an yeniden üretilebilir; asıl gözden geçirme Faz 1 sonuna yakın yapılırsa tek seferde biter.

### 2.5 F0-05 Sonuç Raporu: Mushaf Sayfası Çizim Yöntemi
**Seçilen yöntem (TK-06):**
- Font: **DigitalKhatt New Madina** (SIL OFL).
- Ekrandaki metin: DigitalKhatt kelime metni.
- Satırlar: QUL'ün Medine 1421H düzeni (604 sayfa × 15 satır).
- Yazı boyutu, sayfanın en uzun satırı ekrana sığacak şekilde parça parça ölçülerek hesaplanır.
- Yaslama: iki yana yaslı satırlarda kelimeler satıra yayılır, ortalı satırlar ortalanır.
- Konum düzenden bağımsız `sure:ayet(:kelime)` olarak tutulur.

**Denenen yöntemler:**

| Yöntem | Sonuç | Neden seçilmedi / seçildi |
|---|---|---|
| KFGQPC Hafs (tek font) | Çalıştı; akıcı | Yazılı izin gerekiyor |
| QCF V2 (sayfa başına font, birebir görünüm) | Basılı sayfanın aynısı; emülatörde yavaş (kare p90 55–74 ms); 208 MB | Yazılı izin; boyut; indirme gerekir (internetsiz ilk açılış ilkesiyle çelişir) |
| **DigitalKhatt** | Medine hattı; akıcı (kare p90 ~17 ms, emülatör); 0,5 MB; OFL | **Seçildi**: açık lisans, uygulamayla gelir, metni harf ve durak işaretiyle doğrulanıyor (T-01, Q-15) |

**Karşılaşılan sorunlar ve çözümleri:**

| Sorun | Çözüm |
|---|---|
| Quran.com satır verisinde 4 sayfada hatalı satır | Düzen QUL'den alındı (Q-13) |
| 254. sayfada iki kaynak da hatalı | Font genişliği ölçümüyle tek, gerekçeli düzeltme |
| Kelime bölünmesi kaynaklara göre farklı (7 yer) | Esas KFGQPC; eşlemeler otomatik (Q-12) |
| DigitalKhatt'ın boşluk karakteri dar | Akan metinde `wordSpacing` |
| Ortalı satırların taşması | Ölçüm ekrandaki gibi parça parça yapıldı |
| DigitalKhatt'ın farklı Unicode kodlaması | Kodlamadan bağımsız denetim: harf iskeleti + durak işaretleri (Q-15) |

**Basılı nüshadan bilinen tek görsel fark:** basılı Medine mushafı satırları harf uzatmasıyla (keşide) yaslar; uygulama kelime aralığıyla yaslar. Satır ve sayfa sınırları aynıdır. Keşideyle yaslama ileride değerlendirilecek (DigitalKhatt'ın yaslama motoru bunu destekliyor; Flutter'da uygulanabilirliği ayrı bir deneme ister).

**Türkiye mushaf düzeni için uygulanabilirlik (ön değerlendirme; kesinleşmesi F1-03'te):**
- **Veri modeli hazır.** Bir düzen = `mushaf_layouts` kaydı + sayfa → satır → kelime aralığı eşlemesi. Türkiye düzeni kod değişikliği olmadan veri olarak eklenebilir (M2-14). Kayıtlar düzenden bağımsız olduğu için düzen değişince kaybolmaz (M2-15).
- **Asıl engel veri.** Türkiye'de yaygın mushafların satır satır dijital düzen verisi açık kaynaklarda bulunamadı. Diyanet uygulamaları sayfa görüntüsü kullanıyor (F0-05 §8.7). Yollar:
  1. Diyanet'ten düzen verisi veya izin,
  2. basılı bir Türkiye mushafından düzen verisinin üretilmesi (≈ 9.000 satır sonu; yarı otomatik bir araçla ve çift kontrolle).
  
  İkisinin de lisans ve emek boyutu F1-03'te çıkarılacak.
- **Görünüm farkı.** Türkiye mushafları farklı bir hat geleneğiyle yazılıdır. DigitalKhatt ise Medine hattıdır. Satır ve sayfa sınırları birebir yapılabilir; hafızlar için asıl önemli olan sayfa ve satır konumudur. Ama harflerin görünümü basılı Türkiye nüshasının aynısı olmaz. Türkiye hattına uygun, lisansı serbest bir font araştırılmalı.
- **Satır genişliği riski.** Başka bir hat için dizilmiş satırlar DigitalKhatt ile çizildiğinde bazı satırlar sığmayabilir veya fazla boş kalabilir. `check_line_widths.dart` benzeri bir ölçüm Türkiye düzeni için de çalıştırılmalı.
- **Doğrulanacak bilgiler** (F1-03): Türkiye'de yaygın hafız mushaflarının sayfa sayısı ve satır yapısı, sayfaların ayet sonuyla bitip bitmediği ("ayet berkenar") ve cüz başına sayfa sayısı. Bunlar, düzen verisinin üretilmesini kolaylaştırabilir.

**Sonuç:** Medine düzeni için yöntem tamam ve doğrulandı. Türkiye düzeni için yöntem uygun, ama veri ve lisans yok; bu, v1.0'ı bloklayabilecek bir risktir (Faz_1.md riskler tablosu). F1-03 bu yüzden öncelikli.

---

## 3. F1-01 Uygulama Kabuğu ve Gezinme
**Tarih:** 29.10.2026 · **Durum:** ✅ · **Gereksinimler:** M4-01, M4-07, M6-05 · **Ekranlar:** §3, E-02, E-03 (`Ekran_Tasarimi.md`)

### 3.1 Yapılanlar
| Parça | Dosya | Açıklama |
|---|---|---|
| Kabuk | `lib/core/widgets/app_shell.dart`, `lib/core/routing/app_router.dart` | go_router `StatefulShellRoute`: 4 alt sekme (Bugün · Kur'an · Hafızlık · Ben). Her sekme kendi geçmişini korur (TK-16). Seçili sekmeye tekrar dokunmak o sekmenin başına döner. Arapçada sekme sırası aynalanır. |
| Tam ekran rotalar | `app_router.dart`, `app_routes.dart` | Okuma (`/read`) ve Ayarlar (`/settings`) sekmelerin **üstünde** açılır; geri tuşu açıldıkları sekmeye döner. |
| Bugün (E-02) | `features/today/` | Devam et kartı: son okunan ör. "Bakara 150 · Sayfa 23 · Cüz 2", tek dokunuşla oraya (M6-05). Hiç okunmadıysa "Okumaya başla" → Fatiha. Günün ayeti: tarihe göre (aynı gün herkese aynı ayet; 977 adımla 6.236 günde her ayet bir kez), uzun ayetler atlanır; "Oku" ile açılır. |
| Kur'an dizini (E-03) | `features/quran/presentation/quran_index_page.dart` | Atlama kutusu (`2:255`, `2 255`, `٢:٢٥٥`, sayfa `50`; geçersizde uyarı). Sure sekmesi: numara, ad, "Mekkî/Medenî · N ayet", Arapça ad. Cüz sekmesi: 30 cüz, açılınca 8 rubu' ("Hizb 1 · ¼ — Bakara 26 · Sayfa 5"). Sayfa sekmesi: 604 sayfa ızgarası. Altta "Son okunan" şeridi. |
| Hafızlık | `features/memorize/` | "Yakında" boş durumu; sekme Faz 2'de dolar (ET-7). |
| Ben | `features/me/` | Ayarlar, Lisanslar. İlerlemeler, indirmeler vb. sonraki paketlerde. |
| Git paneli (M4-07) | `features/reader/presentation/go_to_sheet.dart` | Okuma ekranında 🔍 düğmesiyle: sure + ayet, sayfa veya cüz. Sayfa ve ayet görünümünde aynı çapadan açılır (M2-15). Geçersiz ayet numarasında panel kapanmaz. |
| Derin bağlantı | `features/reader/presentation/reader_entry.dart` | `/read?ayah=2:255`, `/read?page=50`; parametresiz = son okunan. Geçersiz bağlantıda hata durumu ("Bu bağlantı geçerli bir ayete veya sayfaya ait değil"). İşletim sistemi düzeyinde bağlantı kaydı (Android intent, iOS universal link) alan adı/uygulama adı kararıyla (AK-04) yapılacak. |
| Veri | `quran_navigation.dart`, `QuranRepository.quarterStarts` | Atlama ayrıştırıcısı (`parseJump`) ve 240 rubu'un başlangıç ayeti ve sayfası (tek SQL sorgusu). Cüz dizini bundan türetilir. |

### 3.2 Bulunan ve düzeltilen hatalar
- **Atlama kutusu ilk girdiyi yok sayıyordu.** Ayet sayıları henüz yüklenmemiş bir sağlayıcıdan senkron okunuyordu; değer `null` gelince girdi sessizce yok sayılıyordu. Değer artık beklenerek okunuyor. Testle bulundu.
- **Sayfa ızgarasında numaralar alt alta kırılıyordu** ("1/0"). Düğmenin varsayılan iç boşluğu 72 px hücrede yazıya yer bırakmıyordu. Emülatör görüntüsünde fark edildi. Test, numaranın tek satırda olduğunu denetliyor; düzeltme yokken kırıldı (yazı yüksekliği 40 px, beklenen 20 px).
- **Okuma ekranında başlık kesiliyordu** ("Ayet 2:…"). Git düğmesi eklenince ayet görünümünde çubukta 5 düğme oldu. Başlık artık kesilmek yerine küçülüyor. Kalıcı çözüm F1-02'de: yazı boyutu ve tema düğmeleri okuma ayarları paneline (E-10) taşınacak.

### 3.3 Testler
| Test | Kontrol |
|---|---|
| `test/features/quran/quran_navigation_test.dart` | Atlama biçimleri (`2:255`, `2.255`, `2 255`, Doğu Arap rakamları, sayfa); geçersizler (`2:287`, `115:1`, `605`…); rubu'un hizb içindeki çeyreği |
| `test/features/navigation_test.dart` (17 test) | 4 sekme; sekme durumu korunuyor; okuma sekmenin üstünde açılıp geri dönüyor. Devam et (sahte veride Bakara 150 → sayfa 16) ve Okumaya başla (Fatiha). Günün ayeti tarihe göre. Dizin: sure, atlama, geçersiz uyarı, cüz → rubu', sayfa ızgarası, son okunan şeridi. Derin bağlantı geçerli/geçersiz. Git paneli: sayfa, ayet, ayet görünümünde atlama, geçersiz ayette panel açık. |
| `test/features/accessibility_test.dart` | Yeni ekranların hepsi (Bugün, Kur'an'ın 3 sekmesi, Hafızlık, Ben, Git paneli) etiket, dokunma alanı (Android 48, iOS 44) ve metin kontrastı kurallarından geçiyor. |
| Güncellenen testler | Eski ana sayfaya bağlı dil, tema, uygulama ve entegrasyon testleri yeni sekmelere göre güncellendi. `test/helpers`'a `openTab()` eklendi. |

**Emülatör (gerçek veri):** Bugün, Kur'an dizini ve cüz listesi kontrol edildi. Cüz ve rubu' başlangıçları basılı Medine mushafıyla uyumlu (2:26 → s. 5, 2:44 → s. 7, 2:142 → s. 22). Rubu'a dokununca okuma ekranı o ayette açıldı.

**Toplam:** 184 test geçiyor (1 elle çalıştırılan atlanıyor); analiz temiz.

### 3.4 Bilmeniz gerekenler
- **Ana sayfa (`HomePage`) kaldırıldı.** Yerini Bugün (`TodayPage`) ve Kur'an dizini (`QuranIndexPage`) aldı. Test anahtarları değişti: `home.read` → `today.continue`, `home.settings` → `today.settings`, `home.surah.N` → `quran.surah.N`.
- **Günün ayeti** şimdilik yalnızca Arapça; meal F1-05'te eklenecek. Seçim kuralı yerine seçilmiş bir ayet listesi düşünülürse (ET-2), yalnızca `dailyAyahProvider` değişir. Cihazın yerel tarihi kullanılır (emülatör GMT'de olduğu için Türkiye'den bir gün geride görünebilir).
- **Okuma ilerlemesi şimdilik tek** (son okunan). Birden fazla ilerleme (Hatim, Ramazan…) F1-10'da kartta seçilebilir olacak.

---

## 4. F1-02 Okuma Ekranı
**Tarih:** 29.10.2026 · **Durum:** ✅ (dokunma kuralı ET-8 onay bekliyor) · **Gereksinimler:** M2-01, M2-03, M2-04, M2-05, M2-07, M2-09…M2-13, T-09 · **Ekranlar:** E-04, E-05, E-10, §7 (`Ekran_Tasarimi.md`)

### 4.1 Yapılanlar
| Parça | Dosya | Açıklama |
|---|---|---|
| Çubuklar (M2-13) | `features/reader/presentation/reader_page.dart` | Üst çubuk (başlık, ⚙ okuma ayarları) ve alt çubuk (görünüm, otomatik kaydırma, Git) içeriğin **üstünde** durur; açılıp kapanınca sayfa yeniden ölçülmez, yazı boyutu zıplamaz. Okuma ekranı çubuklar açık açılır; çubuklar **asla kendiliğinden kapanmaz**. Geçiş 150 ms solma; sistemde "hareketi azalt" açıksa anında. |
| Dokunma kuralı | aynı | Çubuklar açıkken içeriğe ilk dokunuş (kelimenin üstünde de) yalnızca çubukları kapatır. Çubuklar kapalıyken kelimeye dokunmak kelimeyi seçer; sayfanın üst/alt bilgi şeridine veya kelime arasına dokunmak çubukları açar. Kaydırma her durumda sayfayı çevirir. Gerekçe §4.3; onay ET-8. |
| Ekran açık (M2-12, TK-15) | `core/platform/wake_lock.dart` | `WakeLock` arayüzü + `wakelock_plus` uygulaması (testlerde sahte). Ayar açıksa (varsayılan) **yalnızca okuma ekranındayken** ekran kapanmaz; çıkınca bırakılır. Ayar kapalı olsa da otomatik kaydırma sürerken açık kalır. Eklenti hata verirse okuma engellenmez, uyarı loglanır. |
| Sayfa çevirme (M2-09) | `reader_page.dart` | Ekranın sol ve sağ kenarındaki **24 dp şerit** (cihazın hareket alanı daha genişse o kadar) yatay sürüklemeyi sayfa çevirmeden önce yakalar: sistemin geri hareketiyle çakışmaz. Şerit dokunuşları engellemez. **Sayfa okları** ayarla açılır (varsayılan kapalı, ET-5): çubuklar açıkken alt çubuğun iki ucunda, kapalıyken ekranın alt köşelerinde. Mushaf sağdan sola olduğu için **sol ok sonraki, sağ ok önceki sayfadır** (arayüz dilinden bağımsız). |
| Sayfa çerçevesi (M2-04, M2-05) | `mushaf_page_frame.dart`, `mushaf_mark.dart` | Basılı nüshadaki gibi her sayfanın üstünde sure adı ve "Cüz 9 · Hizb 18", altında rubu'/secde işareti, sayfa numarası ve **Sağ/Sol sayfa** (tek numara sağda). Çubuklar gizliyken de görünür; çift sayfada her sayfanın kendi çerçevesi vardır. `۞`/`۩` simgeleri Kur'an fontuyla çizilir (arayüz fontlarında olmayabilir). |
| İşaret verisi | `drift_quran_repository.dart`, `mushaf_page.dart` | `MushafPage.sajdahAyahs` ve `quarterStarts`: **o sayfada başlayan** secde ayetleri (yalnız 14 Hanefi secde; 22:77 sayılmaz) ve rubu' başları. Düzenden hesaplanır (M2-14: başka düzende de doğru). Tek ek sorgu. |
| Ayet görünümü | `ayah_list_view.dart` | Rubu' başında "۞ Hizb 1 · ¼", secde ayetinde "۩ Secde"; altta her zaman görünen bilgi satırı "Cüz 1 · Hizb 1 · Sayfa 5" (okunan ayetin). |
| Yakınlaştırma ve kilit (M2-07) | `reader_page.dart`, `reader_settings.dart` | Sayfa görünümünde iki parmakla ×3'e kadar yakınlaşma. Yakınken tek parmak sayfayı kaydırır, çevirmez; sayfa değişince yakınlık sıfırlanır. **Yazı boyutu kilidi** açıkken A−/A+, kaydırıcı ve yakınlaştırma kapanır. |
| Otomatik kaydırma (M2-11) | `reader_page.dart`, `ayah_list_view.dart` | Alt çubuktaki ▶ ile başlar; başlayınca çubuklar kapanır. **Ekrana dokunmak durdurur** ve çubukları geri getirir. Hız 1–10: ayet görünümünde 15–105 piksel/sn sürekli kaydırma; sayfa görünümünde 184–40 sn'de bir sayfa (kademe 5 ≈ 2 dk). Kur'an'ın sonunda kendiliğinden durur. Kaydırmanın kendisi oturumluktur (kaydedilmez); hız ayarı kalıcıdır. |
| Okuma ayarları paneli (E-10) | `reader_settings_sheet.dart` | Görünüm (Sayfa/Ayet), tema (Cihaz/Açık/Sepya/Koyu), yazı boyutu (A−, kaydırıcı %50–%250, A+), yazı kilidi, mushaf düzeni (şimdilik yalnızca bilgi: Medine 1421 H), ekran açık, sayfa okları, otomatik kaydırma hızı. Her değişiklik anında uygulanır ve kalıcıdır. Tecvid (F1-04), kelime meali (F1-06) ve düzen seçimi (F1-03) o paketlerde eklenecek; boş yer tutucu konmadı. |
| Ayarlar (T-05) | `reader_settings.dart` | Yeni kalıcı anahtarlar: `reader.textScaleLocked`, `reader.keepScreenOn`, `reader.pageArrows`, `reader.autoScrollSpeed`. |
| Kaldırılanlar | `theme_settings.dart`, `reader_page.dart` | Okuma çubuğundaki tema ve A−/A+ düğmeleri panele taşındı (F1-01 §3.2'deki başlık sıkışması kalıcı olarak çözüldü); `ThemeSettingsNotifier.cycleFrom` kullanılmadığı için silindi. Rubu' etiketi (`¼ ½ ¾`) Kur'an dizini ile ortak yardımcıya taşındı (`quarter_l10n.dart`). |

**Yeni paket:** `wakelock_plus` 1.8.2 (BSD-3). Lisans kontrolü ve getirdiği paketler `VERI_KAYNAKLARI.md` §7'de. Dikkat: alt bağımlılık `dbus` (yalnızca Linux masaüstünde kullanılır) **MPL-2.0** lisanslıdır. Değiştirilmeden kullanıldığı için uygulamanın kaynağını açmayı gerektirmez; lisans metni Flutter'ın lisans sayfasında kendiliğinden yer alır. İstenirse ekranı açık tutma ~20 satırlık kendi platform koduyla da yapılabilir (paket ve 10 alt bağımlılık düşer).

### 4.2 Bulunan ve düzeltilen sorunlar
- **Kelimelerin dokunma alanı 48 dp'nin altındaydı** (42 dp). Erişilebilirlik testi okuma ekranında ilk kez sayfa çizimiyle çalışınca yakaladı. Kelimenin dokunma alanı artık satırın tüm yüksekliği (telefonda satır ≈ 53 dp); seçili kelimenin vurgusu da satır yüksekliğinde. *Bilinen sınır:* tek harfli kelimelerin **genişliği** 48 dp'den dar kalabilir. Metin içindeki bağlantılar gibi bu, yönergenin istisnasıdır.
- **"Seçilen kelime" çubuğu son satırın üstüne biniyordu** (çubuklar üst katmana alınınca). Eskisi gibi ekranın altında yer açan çubuk oldu (D1: metnin üstüne bir şey binmez). F1-06'da kelime kartı yerini alacak.
- **`۞` ve `۩` arayüz fontunda kutu olarak çıktı** (gerçek veriyle alınan görüntüde). Simgeler Kur'an fontuyla çiziliyor.
- **Çubuklar açıkken onları kapatacak boş alan yoktu:** gerçek sayfada satırlar kelimelerle dolu, üst/alt bilgi şeritleri de çubukların altında kalıyor. Dokunma kuralı buna göre değişti (§4.3).

### 4.3 Karar gerektiren: dokunma kuralı (ET-8)
E-04 "boş alana dokunuş çubukları açar/kapatır, kelimeye dokunuş kelime kartı" diyordu. Gerçek sayfa görüntüsünde boş alan neredeyse yok (iki yana yaslı 15 satır). Uygulanan kural:
- **Çubuklar açıkken** ilk dokunuş her yerde çubukları kapatır.
- **Çubuklar kapalıyken** kelimeye dokunmak kelimeyi açar; üst/alt şeride veya kelime arasına dokunmak çubukları açar.

Böylece okurken (çubuklar kapalı) kelimeye dokunmak hep kelimeyi açar; çubukları kapatmak için de yer aramak gerekmez. Ekran okuyucuda içerik bölgesinin "Menüyü göster/gizle" eylemi var.

Diğer seçenek: her dokunuş çubukları açıp kapatır, kelime kartı uzun basışla açılır. Ama uzun basış ayet eylem paneline ayrılmış (E-06); iki işlev çakışır. Bu yüzden uygulanan kural önerilir. Onay `Ekran_Tasarimi.md` ET-8'de bekliyor.

### 4.4 Testler
| Test | Kontrol |
|---|---|
| `test/features/reader/reader_screen_test.dart` (16 test, gerçekçi sahte sayfalarla) | Çubuklar dokununca kapanıp açılıyor, 5 dk beklemede kapanmıyor; ilk dokunuş kelimeyi seçmiyor, ikincisi seçiyor. Çubuklar gizliyken üst/alt şerit: "Cüz 1 · Hizb 1", "5", "Sağ sayfa"; 6. sayfa "Sol sayfa". Sayfa altında "۞ Hizb 1 · ¼" ve "۩ Secde"; ayet görünümünde bilgi satırı, rubu' ve secde işareti. Ekran açık: varsayılan açık, ayardan kapanıyor, ekrandan çıkınca bırakılıyor, ayar kapalıyken otomatik kaydırmada açık. Kenar şeridinden (sol ve sağ) kaydırma sayfa çevirmiyor, ortadan çeviriyor. Oklar varsayılan kapalı; sol ok sonraki, sağ ok önceki; çubuklar kapalıyken köşede. İki parmakla yakınlaşma ve yakınken sayfa çevrilmemesi; kilitle A+ ve yakınlaştırma kapalı. Otomatik kaydırma: sayfa görünümünde 40 sn'de sonraki sayfa, dokununca duruyor; ayet görünümünde liste ilerliyor ve duruyor. Panelden görünüm değişince okunan ayet aynı (M2-01). Erişilebilirlik: çubuklar açık, gizli ve ayar paneli için etiket, 48 dp ve kontrast. |
| `test/features/reader/t09_rotation_test.dart` (7 test) | **T-09, KK M2-10.** Bakara 150 açıkken sayfa ve ayet görünümünde: telefon dikey→yatay→dikey; tablet dikey→yatay (çift sayfa, 7. açılım)→dikey; çoklu pencere (ekranın yarısı, üçte biri, serbest pencere, katlanabilir, tam ekran). Okunan ayet her adımda 2:150, sayfa 16. Ayar paneli açıkken ve çubuklar gizliyken döndürme. |
| `test/features/quran/drift_quran_repository_test.dart` (+2, gerçek veri) | 176. sayfada secde 7:206; 341. sayfada (22:77) secde yok; 5. sayfada 2:26 rubu' başı. **604 sayfanın tamamı:** sayfalardan toplanan secdeler veritabanındaki 14 secdeyle, rubu' başları cüz dizinindeki bağımsız SQL sorgusuyla (240 rubu', ayet ve sayfasıyla) birebir aynı. |
| `test/features/reader/reader_persistence_test.dart` | Yeni dört ayarın varsayılanları ve yeniden açılışta korunması (T-05). |
| Güncellenen | Tema testi artık panelden seçiyor. Sahte depo isteğe bağlı sayfa verisi ve ayet listesi veriyor (`withPages`, `sajdahs`); cüz bilgisi tutarlı (2:142'den sonrası Cüz 2), bu yüzden Bugün kartı beklentisi "Cüz 2" oldu (gerçek mushafla aynı). `test/helpers/fake_wake_lock.dart` eklendi. |

**Bilerek bozma:**
- *T-09:* (a) döndürmede okunan ayeti sayfa başına çeken bir satır eklendi → tablet ve çoklu pencere testleri "beklenen 2:150, bulunan 2:141" ile kırıldı. (b) döndürmede sayfa denetleyicisi 1. sayfaya kuruldu → "7. açılım bulunamadı" ile kırıldı. Geri alınınca geçti.
- *İşaret verisi:* rubu' hesabında "önceki ayet" sorgudan çıkarıldı → iki test kırıldı (her başlayan ayet rubu' başı sayıldı). Geri alınınca geçti.

**Gerçek veriyle görsel kontrol:** geçici bir testle (DigitalKhatt ve Roboto fontu, gerçek `content.sqlite`) 6 ekran görüntüsü alındı: 5. sayfa çubuklar açık; 176. sayfa çubuklar gizli ve oklar açık (üstte "A'râf · Cüz 9 · Hizb 18", altta "۩ Secde · 176 · Sol sayfa"); sepya temada ayar paneli; ayet görünümü; koyu temada 50. sayfa (Âl-i İmrân başı); seçili kelime. Bulunan üç sorun §4.2'de. Geçici test dosyası silindi.

**Android derlemesi:** `flutter build apk --debug --flavor dev -t lib/main_dev.dart` başarılı (yeni yerel eklentiyle; 86 sn).

**Toplam:** 209 test geçiyor (1 elle çalıştırılan atlanıyor); `flutter analyze --fatal-infos` ve `dart format` temiz.

### 4.5 Bilmeniz gerekenler
- **Çubuklar metnin üstünde durur.** Açıkken üst çubuk ilk satırın bir kısmını, alt çubuk sayfa altındaki bilgi şeridini örter; bir dokunuşla kapanır. Çubukları içerikten ayrı yere koymak, her açılıp kapanışta sayfayı yeniden ölçtürür ve yazı boyutu zıplar; bu yüzden tercih edilmedi.
- **Ekran açık ayarı yalnızca okuma ekranında** geçerlidir; diğer ekranlarda telefonun kendi zaman aşımı geçer.
- **Otomatik kaydırma hızları** ilk tahmindir. Gerçek okumada denenip gerekirse `ReaderSettings.autoScrollPixelsPerSecond` ve `autoScrollPageDuration` ayarlanır.
- **Telefon yatay:** sayfa genişliğe sığar ve dikey kaydırılır (F0-05). Bu durumda üst/alt bilgi şeritleri ekranda sabit kalır.
- **Emülatörde denenmedi** (bu oturumda açık değildi). Gerçek telefonda bir kez denenmeli: okuma ekranında 2–3 dakika dokunmadan bekleyin, ekran kararmamalı; okuma ayarlarından "Ekran açık kalsın" kapatılınca telefonun süresiyle kararmalı. Kenar şeridinin sistemin geri hareketiyle birlikte davranışı da aynı denemede görülür.

---

## 5. F1-03 Türkiye Mushaf Düzeni Araştırması (sonuç raporu)
**Tarih:** 29.10.2026 · **Durum:** ✅ Araştırma, altyapı ve 1405H geliştirme paketi; Türkiye düzeni v1.0 sonrası · **Gereksinimler:** M2-02, M2-14, AK-11 · **Bağlı:** F0-05 sonuç raporu (§2.5)

> Bu bölüm geliştirme ekibinin değerlendirmesidir, hukuki görüş değildir. Yönetmelikle ilgili sonuçlar hukuk danışmanına (AK-09) doğrulatılmalıdır.

### 5.1 En önemli bulgu: Diyanet yönetmeliği dijital Kur'an yayınlarını da kapsıyor
**Kur'an-ı Kerim Basım ve Yayım Kriterleri Hakkında Yönetmelik** (Resmî Gazete 2/11/2022, sayı 32001; değişiklik 28/6/2024, sayı 32586; dayanağı 633 sayılı Kanun md. 6). Metin: mevzuat.gov.tr (yönetmelik 7.5.39802).

| Madde | Hüküm (özet) | Bu uygulama için anlamı |
|---|---|---|
| 1, 2, 4(d) | Kapsam: basılı mushaflar **ve "sesli, görüntülü ve elektronik ortamda" mealli/mealsiz Kur'an-ı Kerim** yayımlamak için hazırlanan eserler ("dijital eser"). | Uygulamamız büyük olasılıkla "dijital eser" sayılır. |
| 9(1) | **Kurulun (Mushafları İnceleme ve Kıraat Kurulu) mührü/onayı bulunmayan eserler basılamaz ve yayımlanamaz.** | Türkiye'de yayın için Kurul onayı gerekir. |
| 7, 8, 9(2)b | Başvuru Kurula form ve "ikişer adet ilgili materyal" ile yapılır. Dijital eserde süreç: ilk inceleme (hatalar giderilir) → **yayım** → Kurulun son incelemesi → onay. Son incelemede hata çıkarsa eser yayımdan kaldırılır, düzeltilip yeniden yayımlanır. | Başvuru yayından önce yapılmalı; onay yayından sonra gelir. Süre belirsiz. |
| 8(3) | **Meal içeren eserler önce Din İşleri Yüksek Kurulunun uygun görüşünü alır.** | Meal (F1-05) eklenince ek bir aşama. |
| 9(3) | Onaylanan esere **hiçbir ekleme, çıkarma veya değiştirme yapılamaz.** | Mushaf/metin kısmında güncellemeler yeniden incelemeyi gerektirebilir. Uygulamanın diğer özellikleri (hafızlık, ayarlar) bu kapsama girer mi, belirsiz. |
| 5(3)a | Sayfalar **ayet berkenar, sayfa tutar ve on beş satırlı** olur. | Medine 1421 düzenimiz bunu karşılıyor (15 satır; 604 sayfanın hiçbiri ayet ortasında başlamıyor, F1-02'de doğrulandı). |
| 5(3)c | **Cüz sonları 20 ve katları**, son sayfa **604**; İhlas, Felak, Nas ile biter. | 604 tutuyor. "Cüz sonları 20 ve katları" ifadesinin sayfa numaralamasına nasıl uygulandığı basılı bir Diyanet mushafıyla doğrulanmalı (Medine'de 2. cüz 22. sayfada başlar). |
| 5(3)b | Resm-i Osmani **veya Aliyyü'l-Kari** imlası; geleneksel harekeleme **aynen korunur**. | Türkiye mushafları yazım ve işaret (dabt) bakımından Medine'den farklıdır; DigitalKhatt metni Medine dabtıdır. |
| 5(3)e–g, j | Secavend işaretleri kelime sonuna küçük ve satır üstüne; **cüz, hizb ve secde gülleri çerçevenin dışında**; sure ismi, cüz ve sayfa numarası çerçeve dışında. | F1-02'deki sayfa üst/alt şeritleri bu düzene uygun (bilgiler çerçeve dışında). Secavend Medine'de farklı işaretlerle yazılır. |
| 5(3)k | **Mealsiz eserlerde çerçeve içinde Türkçe karakter yer almaz.** | Mushaf sayfasının içinde Türkçe metin göstermiyoruz; uygun. |
| 5(3)m | Mehabete uygun düşmeyen, doğru okumaya katkı sağlamayan, **renk karmaşasına yol açan renklendirme yapılmaz.** | Renkli tecvid (F1-04) "doğru okumaya katkı" sayılabilir; Kurula sorulmalı. Hafızlık renkleri (Faz 2) kullanıcı açınca görünür. |
| 5(3)n | **Eserde Kurul tarafından uygun görülen yazı tipi (font) kullanılır.** | DigitalKhatt'ın Kurulca uygun görülmesi gerekir; olmazsa Kurulun uygun gördüğü bir font. |
| 5(2) | Dijital eserlerin hızlandırma/yavaşlatma programlarında hadr, tedvir ve tahkik ölçüleri dikkate alınır. | Ses hızı ayarı (M5-03, F1-09) için not. |
| 11 | Onaysız yayında: yayının durdurulması, toplatma, **internette erişimin engellenmesi**. | Türkiye'de mağaza erişimi riski. |
| 9(4) | Yurt dışı menşeli **basılı** eserlerin ithali ve yurt içinde basımı: yurt içinde satılmamak şartıyla izin belgesi. | Medine düzenini Türkiye'de dijital olarak sunmanın durumu bu maddeyle netleşmiyor; Kurula sorulmalı. |

**Değerlendirme:**
- Türkiye'de yayımlanacak bir Kur'an uygulaması için Kurul onayı **yayın öncesi bir yasal adım** olarak görünüyor. Bu yalnızca "Türkiye düzeni" sorusu değil, uygulamanın Türkiye'de yayımlanması sorusu.
- Piyasadaki birçok uygulamanın onaylı olup olmadığını bilmiyoruz; bu, kuralın uygulanma biçimine dair bir şey söylemez.
- Başvuru, Diyanet meal izni (S1) ve Türkiye düzeni verisi talebiyle **tek bir görüşmede** birleştirilebilir.
- Bu nedenle yeni açık karar önerildi: **AK-14** (`Proje_Gereksinimleri.md` §14).

### 5.2 Türkiye mushafı ile Medine mushafı arasındaki farklar
| Konu | Bulgu | Kaynak |
|---|---|---|
| Sayfa yapısı | İkisi de 604 sayfa, 15 satır, ayet berkenar (hafız mushafı, "mushafü'l-huffâz"). | Yönetmelik 5(3); TDV İslâm Ansiklopedisi "Mushaf" |
| Cüz | Çoğunlukla aynı. | Cumhuriyet İlahiyat Dergisi, 2017 (Diyanet ve Medine mushaflarının cüz/hizb/rükû karşılaştırması) |
| Hizb | **Farklı.** Medine: cüz başına 2 hizb, her biri 4 rubu' (cüz başına 8 rubu'). Diyanet: her cüz **4 hizbe** bölünür. 4, 7, 11, 26 ve 30. cüzlerde bazı hizbler farklı yerden başlar; makaleye göre bu yüzden bazı cüz başları da değişir. | Aynı makale |
| Yazım ve işaretler (dabt) | Farklı (imla ve secavend işaretleri). Bu, Türkiye düzeninin yalnızca satır sonları değil, **kendi metni ve fontu** demek olduğunu gösteriyor. | Yönetmelik 5(3)b, e; dabtu'l-mushaf karşılaştırma makalesi (DergiPark) |
| Satır ve sayfa sonları | Satır satır karşılaştırma bulunamadı; basılı nüshalarla doğrulanmalı. | — |

### 5.3 Dijital veri ve lisans durumu
| Aranan | Sonuç |
|---|---|
| QUL (20 onaylı, 8 yapım aşamasında düzen) | Medine (KFGQPC V1 1405H, V2 1421H), IndoPak 13/15/16 satır vb. **Türkiye düzeni yok.** QUL yeni düzen taleplerini GitHub üzerinden kabul ediyor. |
| Açık kaynak depolar (GitHub, pub.dev) | Türkiye/Diyanet/Hafız Osman düzeni için satır verisi **bulunamadı**; bulunanların hepsi Medine düzeni. |
| Diyanet (kuran.diyanet.gov.tr) | Mushaf PDF'i ve Word uyumlu Hamdullah, Abay, Latif fontlarının yayınlandığı bildiriliyor; sayfa içeriği okunamadı, lisans koşulları görülemedi. Diyanet'in uygulaması sayfa görüntüsü kullanıyor (F0-05 §8.7). |
| Lisans | Açık lisanslı bir Türkiye düzeni verisi yok. Diyanet'in metni, düzeni ve fontları için yazılı izin gerekir (İÇ-04: atıf izin yerine geçmez). |

### 5.4 Türkiye düzeni için yollar
| Yol | Ne gerekir | Artısı | Eksisi |
|---|---|---|---|
| **A. Diyanet'ten veri ve izin (önerilen)** | Diyanet'e başvuru: Kurul onayı (§5.1) + dijital düzen/metin verisi veya izin + uygun font + meal izni (S1). | Hem yasal uyum hem veri tek kanaldan; Türkiye'deki kullanıcı beklentisi. | Süre ve sonuç belirsiz; ticari uygulama olduğu için izin verilmeyebilir. |
| B. Basılı Türkiye mushafından düzen verisi üretmek | Onaylı bir basılı nüshadan ≈ 9.000 satır sonu; yarı otomatik araç + çift kontrol. **Metin ve font** sorunu çözülmez: Türkiye dabtında Unicode metin ve uygun font da gerekir. | Bağımsız. | Emek büyük; metin/font yine izin gerektirir; sonuç Kurul incelemesinden geçmeli. |
| C. Medine düzeniyle yayın, Türkiye düzeni sonra | Kurula Medine düzeni ve DigitalKhatt ile başvurmak; Türkiye düzeni v1.x'te. | En hızlısı. | Kurulun Medine düzenini ve fontu kabul edip etmeyeceği bilinmiyor; M2-02'deki [Z] Türkiye düzeni v1.0'da karşılanmaz. |

**Kullanıcı kararı (29.10.2026):** Diyanet başvurusu ilk sürümü bloklamaz; v1.0 Medine düzeniyle hazırlanır (yol C), Türkiye düzeni ve gerekirse font için başvuru sonra (yol A). Mimari düzen paketine hazır tutulur.

**İlk öneri (kayıt için):** A ve C birlikte. Kurula Medine düzeniyle başvurulur ve aynı yazıda Türkiye düzeni verisi/izni istenir. Uygulama mimarisi bu sırada hazır hâle getirilir (düzen seçimi, indirilebilir düzen paketi, düzene özel metin ve font). Böylece veri gelince yalnızca paket üretilir.

**Mimari için sonuç:** Türkiye düzeni = ayrı satır düzeni **+ kendi glif metni + kendi fontu + kendi hizb bölümlemesi**. Mevcut şema bunun çoğunu taşıyor (`layout_glyphs` metni düzene özel, `mushaf_layouts.font_pack` var). Eksik: düzene özel hizb/rubu' bölümlemesi (şu an `ayahs.hizb/rub` tek ve Medine'ye ait). Paket altyapısında bu da düzene bağlanmalı.

**Tarih önerisi:** Diyanet başvurusu Faz 1 içinde (meal izniyle birlikte). Türkiye düzeni v1.0'ı bloklayabilir; karar AK-11 ve AK-14 ile.

### 5.6 Uygulama: düzen seçimi ve düzen paketi altyapısı
**Durum:** ✅ altyapı · ⏳ gerçek ikinci düzen verisi (Medine 1405H için QUL dosyaları bekleniyor)

| Parça | Dosya | Açıklama |
|---|---|---|
| Düzen modeli | `features/quran/domain/mushaf_layout.dart` | `MushafLayout` (kimlik, sayfa ve satır sayısı, font paketi, sürüm, yerleşik mi) ve `kDefaultLayout` (Medine 1421H). Eski `kDefaultLayoutId` ve `kDefaultPageCount` sabitleri kaldırıldı: sayfa sayısı artık seçili düzenden gelir. |
| Depo | `drift_quran_repository.dart` | Düzen tabloları, düzenin bulunduğu veritabanından okunur: yerleşik düzen içerik veritabanından, paket düzeni paketin kendi dosyasından. Metin, kelime ve ayet her zaman içerik veritabanından gelir. İki veritabanını birleştiren sorgular (sayfanın ilk ayeti, rubu' başlarının sayfası) ikiye bölündü. Yeni: `getLayouts()`. |
| Düzen paketi (TK-13) | `layout_package_store.dart` | Paket, içerik veritabanıyla aynı şemada bir SQLite dosyasıdır; yalnızca tek düzenin satırlarını ve kimliğini taşır. **Kurulumda doğrulanır:** tür `layout`, kimlik var ve yerleşik düzenle çakışmıyor, **kelime parmak izi** içerikle aynı, düzen kaydı tek ve kimlikle aynı, sayfa sayısı tutuyor, font destekleniyor. Dosya geçici adla kopyalanır, sonra yerine alınır; aynı düzenin eski sürümü silinir. |
| Kelime parmak izi | `tool/content/words_hash.dart`, `content_meta.wordsHash` | Paket glifleri kelimelere `words.id` ile bağlar. İçerik yeniden üretilip kelimeler değişirse eski paket **reddedilir** (yanlış kelimeye bağlanmaz). İçerik sürümü **7 → 8** (yalnızca bu alan eklendi; metin ve düzen değişmedi). |
| Kurulu paketler | `core/database/user_database.dart` (v3), `user_data/...` | Yeni tablo `installed_packages` (SyncedRecord): paket kimliği, tür, sürüm, dosya adı, boyut. **Kullanıcı veritabanı v2 → v3**; migration ve veri koruma testi (T-04). |
| Katalog ve seçim | `features/quran/application/layout_providers.dart` | `layoutCatalogProvider`: cihazdaki düzenler ve paket veritabanları; `install(dosya)` ve `remove(kimlik)`. `layoutSelectionProvider`: seçim, ayar anahtarı `mushaf.layoutId` (kalıcı). `currentLayoutProvider`: seçilen düzen cihazda yoksa (paket silinmiş ya da uyumsuz) yerleşik düzen. Seçim kaydı silinmez; paket geri gelirse o düzen yine açılır. |
| Açılış | `bootstrap.dart` | Kurulu paketler açılır. Açılamayan paket atlanır ve loglanır, kaydı korunur; uygulama yerleşik düzenle çalışmaya devam eder. |
| Geliştirme gelen kutusu | `layout_package_inbox.dart` | **Yalnızca `dev`:** `/sdcard/Android/data/<paket>/files/packages_inbox/` klasörüne `adb push` ile bırakılan paket, açılışta kurulur ve klasörden silinir. İndirme altyapısı (F1-11) gelene kadar cihazda denemek için. README "Mushaf düzeni paketleri". |
| Okuma ekranı | `reader_page.dart`, `reader_providers.dart` | Düzen değişince okunan ayet **aynı kalır**, yeni düzendeki sayfası açılır (M2-15). Mushaf sayfaları, sayfa sayısı, Git paneli, Kur'an dizinindeki sayfa ızgarası ve `/read?page=` bağlantısı seçili düzene göre çalışır. |
| Okuma ayarları (E-10) | `reader_settings_sheet.dart`, `layout_l10n.dart` | "Mushaf düzeni" bölümünde cihazdaki düzenler listelenir: ad, "604 sayfa · 15 satır", paketse "İndirilen paket". Bilinen düzenlerin adı dil dosyasından gelir, yeni paketlerinki verideki addan. |

**Bulunan ve düzeltilen hata:** mushaf sayfası satır sayısını **15 olarak sabit** varsayıyordu. 20 satırlık bir düzenle yapılan test, sayfanın 281 piksel taştığını gösterdi. Satır sayısı artık düzenden geliyor (`MushafPage.linesPerPage`). IndoPak (13/16 satır) gibi düzenler için gerekliydi.

**Testler:**

| Test | Kontrol |
|---|---|
| `test/features/quran/layout_package_test.dart` (16) | Gerçek içerikten türetilen "birleşik sayfalar" test düzeni (302 sayfa × 30 satır) ile: kurulum, açılış, yeni sürümün eskisinin yerine geçmesi. **5 tür bozuk paketin reddi:** başka içerikle üretilmiş, tür yanlış, yerleşik kimlik, kimlik ve kayıt farklı, desteklenmeyen font. Dosyası silinmiş kayıt açılmıyor. **KK M2-15:** Kehf 45 Medine'de 298., test düzeninde 149. sayfa ve aynı ayet. Sayfa çizimi paketten, metin içerikten geliyor; 240 rubu' başı yeni düzenin sayfalarıyla. Katalog: kur, seç, kaldır (seçim yerleşik düzene düşüyor, kayıt ve dosya siliniyor). Seçimin yeniden açılışta korunması. Açılışta bozuk paketin atlanması. Gelen kutusu. |
| `test/features/reader/layout_switch_test.dart` (3) | Okuma ekranında panelden düzen değişince Bakara 150 korunuyor, sayfa 16 → 8 → 16; ayet görünümüne gidip dönünce yine yeni düzenin sayfası. Seçili düzende Git panelinin sınırı (1–15) ve sayfa ızgarası. Seçili düzen cihazda yoksa yerleşik düzen açılıyor. |
| `test/content/t02_layout_packages_test.dart` | **T-02 her düzen için:** `build/packages/` altındaki her pakette sayfalar tüm ayetleri boşluksuz kapsıyor mu, satırlar glifleri sırayla bir kez kapsıyor mu, hiçbir kelime iki satıra bölünmüyor mu, satır sayısı aşılmıyor mu, sure başlıkları ve besmeleler doğru mu. Medine 1405H paketi için ek olarak sayfa başları Tanzil'in 1405H sayfa verisiyle birebir aynı olmalı. Şimdilik paket olmadığı için yalnız test düzeni denetleniyor. |
| `test/drift/user_database/migration_test.dart` | v2 → v3: profil, ayarlar (silinmiş olan dahil) ve okuma konumu (Kehf 45) birebir korunuyor; yeni tablo boş. |

**Bilerek bozma:**
- (a) Okuma ekranında düzen değişimini dinleyen satır kaldırıldı → "Sayfa 8 beklendi, Sayfa 16 bulundu".
- (b) v3 migration adımı boşaltıldı → üç migration testi kırıldı.
- (c) Kelime parmak izi kontrolü kaldırıldı → başka içerikle üretilmiş paketin reddi testi kırıldı.
- (d) Test düzeninin satır sayısı 29'a düşürüldü → paket T-02 "1–29 beklendi, 30 bulundu".

Hepsi geri alınınca geçti.

**Emülatörde gerçek geçiş (29.10.2026):** önceki sürümün (kullanıcı veritabanı v2, içerik 7) üstüne kuruldu. Açılışta v2 yedeği alındı (`backups/user_v2_…`), `content_v8.sqlite` kopyalandı ve eskisi silindi. Kullanıcının 8 ayarı ve son okunan yeri (Mülk 1) yedekle birebir aynı; `installed_packages` tablosu eklendi.

**Toplam:** 232 test geçiyor (2 atlanan: elle çalıştırılan sayfa paketi testi ve henüz üretilmemiş paketler); analiz ve biçim temiz; Android debug derlemesi başarılı.

### 5.7 Gerçek ikinci düzen: Medine 1405H (geliştirme paketi)
**Durum:** ✅ (29.10.2026). Kullanıcı kararı: "1405'i indireyim, test edelim; o kısım açık kalsın, daha sonra kapatalım." Düzen değiştirmenin v1.0'da görünür olup olmayacağı sonra karara bağlanacak.

**Sonuç:**
- QUL dosyaları: `qpc-v1-15-lines.db` (kaynak 15; dosyanın içinde "Quran Complex V1 (1405 print)") ve `qpc-v1-glyph-codes-wbw.db` (kaynak 57). İndirme klasörünün adı "1415H" ama içerik 1405H baskısı.
- **V1 glif birimleri V2 ile birebir aynı:** 83.668 birimin hepsi aynı numara ve konumda. Bu yüzden kelime eşlemesi ve DigitalKhatt metni yerleşik düzenden alındı; yeni eşleme ya da elle düzeltme yok.
- **Bağımsız doğrulama:** 1405H ile 1421H arasında ilk glifi farklı sayfalar tam 25 (121, 122, 123, 145, 532…600). Bunlar T-02'de elle listelenmiş bilinen 25 farkın aynısı (Q-10). 9.046 satırın 4.385'i iki baskıda aynı.
- **T-02 (paket):** 604 sayfanın ilk ayeti Tanzil'in sayfa verisiyle (1405H) birebir aynı; yapı denetimleri geçti. Bozma denemesi: aynı kimlikle 1421H satırlarından paket üretildi → "121. sayfa: 5:77 beklendi, 5:78 bulundu".
- **Araç:** `tool/content/build_layout_package.dart` → `build/packages/madani_1405_v1.sqlite` (6,6 MB; depoda değil). QUL satır okuma ve denetimi iki üreticinin ortak kullandığı `tool/content/qul_layout.dart`'a taşındı. Taşıma sonrasında içerik veritabanının 7 tablosu ve parmak izi önceki üretimle birebir aynı.
- **Emülatörde:** paket `adb push` ile gelen kutusuna bırakıldı, açılışta kuruldu ve kutudan silindi; okuma ayarlarından seçildi. 4. sayfa doğru çizildi ("Bakara · Cüz 1 · Hizb 1", "4 · Sol sayfa"). Not: Windows'ta Git Bash `/sdcard/...` yollarını Windows yoluna çeviriyor; `MSYS_NO_PATHCONV=1` gerekir (PowerShell'de sorun yok).
- **Bilinen:** 1405H satırları DigitalKhatt (1421H yazımı) ile çizildiğinde bazı satırlar sığmak için sayfanın yazı boyutunu küçültebilir; satır genişliği ölçümü (`check_line_widths.dart` benzeri) bu paket için yapılmadı.

**Önceki plan (kayıt için):**
- **Ne gerekiyor:** QUL'den iki dosya (ücretsiz hesapla elle): "KFGQPC V1 layout (1405H print)" SQLite (kaynak 15) ve "QPC V1 Glyphs – Word by Word" (kaynak 57). Dosyalar `tool/content/sources/qul/` altına konur.
- **Sonra yapılacak:** paket üretim aracı (`tool/content/build_layout_package.dart`) yazılır. V1 glif birimleri, aynı konumlu V2 birimleri üzerinden esas kelimelere ve DigitalKhatt metnine bağlanır. Bu eşlemenin geçerli olup olmadığı dosya gelince denetlenir; tutmazsa araç hata verir. T-02 sayfa başlarını Tanzil'in 1405H verisiyle karşılaştırır.
- **Lisans:** QUL'ün iki düzen sayfası da "telif bilgisi yok" diyor. Asıl hak sahibi KFGQPC; durum yerleşik 1421H düzeniyle aynı (❓, AK-11). İÇ-10 gereği paket **yalnızca geliştirmede** kullanılır, lisans netleşmeden dağıtılmaz. Paketler uygulamaya gömülmediği için bu doğal olarak sağlanır.

### 5.5 Kaynaklar
- Yönetmelik metni: mevzuat.gov.tr, "Kur'an-ı Kerim Basım ve Yayım Kriterleri Hakkında Yönetmelik" (RG 2/11/2022-32001; değişiklik RG 28/6/2024-32586)
- TDV İslâm Ansiklopedisi, "Mushaf" maddesi (islamansiklopedisi.org.tr/mushaf)
- Cumhuriyet İlahiyat Dergisi (Haziran 2017): Diyanet ve Medine mushaflarında cüz, hizb ve rükû (DergiPark makale dosyası 313002; DOAJ a5924ac96f1a4a90a984194c2079771b)
- QUL mushaf düzenleri (qul.tarteel.ai/mushaf_layouts, resources/mushaf-layout/15 ve /10)

---

## 6. Genel durum ve bekleyen kararlar
**Son güncelleme:** 29.10.2026

| İş paketi | Durum |
|---|---|
| S9 (Tanzil metni uygulamadan çıkarıldı) | ✅ |
| F1-00 Faz 0'dan devredilenler | 🔨 F0-05 raporu ✅; araçlar hazır (sayfa paketi, performans, çeviri tablosu); gerçek cihaz, basılı nüsha, TalkBack dinleme ve Arapça gözden geçirme kullanıcıda; CI ve iOS sonra |
| F1-01 Uygulama kabuğu ve gezinme | ✅ |
| F1-02 Okuma ekranı | ✅ (dokunma kuralı ET-8 onay bekliyor) |
| F1-03 Mushaf düzenleri | ✅ Araştırma (§5), düzen seçimi ve paket altyapısı (§5.6), Medine 1405H geliştirme paketi (§5.7). Açık: düzen değiştirmenin v1.0'da görünür olup olmayacağı (kullanıcı sonra karar verecek); Türkiye düzeni v1.0 sonrası (AK-14) |
| F1-04 … F1-14 | ⬜ |

**Bekleyen kararlar ve işler**
- **AK-14 Diyanet Kurul onayı: ⏸ ertelendi (kullanıcı kararı, 29.10.2026).** "Diyanet yönetmeliği olmadan ilerleyelim; daha sonra eklemek istediğimizde font için başvuru yapıp ekleriz; ilk sürümümüze engel olmasın." Risk kayıtlı (§5.1, md. 11). Türkiye düzeni verisi Diyanet'ten geleceği için **Türkiye düzeni de v1.0 sonrasına kayar** (M2-02 [Z] önceliğinin güncellenmesi kullanıcı onayına sunuldu).
- **Yayın meali (S1, S2), karar Faz 1 sonunda (kullanıcı, 29.10.2026):** Kullanıcı, uygulama ticari olacağı için Diyanet'in izin vermeyeceğini düşünüyor. Bu yüzden **kamu malı yedek meal gerçek bir seçenek olarak hazırlanacak**: kaynak doğrulaması, metin hattı ve okunabilirlik değerlendirmesi F1-05 içinde yapılacak. Diyanet başvurusu yine de denenebilir. Geliştirme Diyanet mealiyle sürüyor.
- **Faz 1 başlangıç kararları S1–S8 ve TK-11…TK-17:** öneri halinde; itiraz yoksa uygulanır.
- **ET-1 ("Ben") ve ET-7 (Hafızlık sekmesi "yakında")** öneriye göre uygulandı; itiraz yoksa kesinleşir.
- **Ekran tasarımı açık soruları ET-1…ET-8** (`Ekran_Tasarimi.md` §10). Yeni: **ET-8** okuma ekranında dokunma kuralı (§4.3). ET-5 (sayfa okları varsayılan kapalı) öneriyle uygulandı.
- **`wakelock_plus` ve MPL-2.0 alt bağımlılığı (`dbus`):** sorun görülmüyor (değiştirilmeden kullanılıyor); istenirse paket yerine kendi platform kodu yazılabilir (§4.1).
- **Gerçek cihazda bir kez:** ekranın açık kalması ve kenar şeridinin geri hareketiyle birlikte davranışı (§4.5).
- **Emülatör:** içerik sürümü 7'ye çıktı; uygulama güncel kodla ilk açılışta yeni veritabanını kendiliğinden kopyalar ve eskisini siler.
