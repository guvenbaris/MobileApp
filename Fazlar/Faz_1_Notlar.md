# Faz 1 Çalışma Notları

> **Amaç:** Faz 1'de her iş paketinde ve kararda **ne yapıldığını, neden öyle yapıldığını, hangi dosyaların değiştiğini ve bilinen sorunları** kayıt altına almak. `Faz_1.md` ne yapılacağını ve kutucukları tutar; bu dosya nasıl ve neden yapıldığını anlatır.
> **Bağlı dokümanlar:** `Faz_1.md`, `../Ekran_Tasarimi.md`, `../VERI_KAYNAKLARI.md`, `../CLAUDE.md`, `Faz_0_Notlar.md` (Faz 0 geçmişi)
> **Kural:** Her iş paketi bittiğinde buraya bir bölüm eklenir; sondaki "Genel durum" tablosu güncellenir.

## İçindekiler
1. [S9: Tanzil metninin uygulamadan çıkarılması ve meal lisansı](#1-s9-tanzil-metninin-uygulamadan-çıkarılması-ve-meal-lisansı)
2. [F1-00 Faz 0'dan Devredilenler](#2-f1-00-faz-0dan-devredilenler)
3. [F1-01 Uygulama Kabuğu ve Gezinme](#3-f1-01-uygulama-kabuğu-ve-gezinme)
4. [F1-02 Okuma Ekranı](#4-f1-02-okuma-ekranı)
5. [Genel durum ve bekleyen kararlar](#5-genel-durum-ve-bekleyen-kararlar)

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

## 5. Genel durum ve bekleyen kararlar
**Son güncelleme:** 29.10.2026

| İş paketi | Durum |
|---|---|
| S9 (Tanzil metni uygulamadan çıkarıldı) | ✅ |
| F1-00 Faz 0'dan devredilenler | 🔨 F0-05 raporu ✅; araçlar hazır (sayfa paketi, performans, çeviri tablosu); gerçek cihaz, basılı nüsha, TalkBack dinleme ve Arapça gözden geçirme kullanıcıda; CI ve iOS sonra |
| F1-01 Uygulama kabuğu ve gezinme | ✅ |
| F1-02 Okuma ekranı | ✅ (dokunma kuralı ET-8 onay bekliyor) |
| F1-03 … F1-14 | ⬜ |

**Bekleyen kararlar ve işler**
- **Yayın meali (S1, S2), karar Faz 1 sonunda (kullanıcı, 29.10.2026):** Kullanıcı, uygulama ticari olacağı için Diyanet'in izin vermeyeceğini düşünüyor. Bu yüzden **kamu malı yedek meal gerçek bir seçenek olarak hazırlanacak**: kaynak doğrulaması, metin hattı ve okunabilirlik değerlendirmesi F1-05 içinde yapılacak. Diyanet başvurusu yine de denenebilir. Geliştirme Diyanet mealiyle sürüyor.
- **Faz 1 başlangıç kararları S1–S8 ve TK-11…TK-17:** öneri halinde; itiraz yoksa uygulanır.
- **ET-1 ("Ben") ve ET-7 (Hafızlık sekmesi "yakında")** öneriye göre uygulandı; itiraz yoksa kesinleşir.
- **Ekran tasarımı açık soruları ET-1…ET-8** (`Ekran_Tasarimi.md` §10). Yeni: **ET-8** okuma ekranında dokunma kuralı (§4.3). ET-5 (sayfa okları varsayılan kapalı) öneriyle uygulandı.
- **`wakelock_plus` ve MPL-2.0 alt bağımlılığı (`dbus`):** sorun görülmüyor (değiştirilmeden kullanılıyor); istenirse paket yerine kendi platform kodu yazılabilir (§4.1).
- **Gerçek cihazda bir kez:** ekranın açık kalması ve kenar şeridinin geri hareketiyle birlikte davranışı (§4.5).
- **Emülatör:** içerik sürümü 7'ye çıktı; uygulama güncel kodla ilk açılışta yeni veritabanını kendiliğinden kopyalar ve eskisini siler.
