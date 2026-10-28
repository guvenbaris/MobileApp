# Veri Kaynakları ve Lisans Envanteri

> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (8. İçerik: İÇ-01, İÇ-03, İÇ-10; AK-05, AK-11), `Fazlar/Faz_0.md` (F0-03, F0-04), `Fazlar/Faz_0_Notlar.md`
> **Kural (İÇ-10):** Yeni bir içerik kaynağı eklenmeden önce aşağıdaki lisans kontrol listesi doldurulur. Yayın için uygun olmayan kaynak yalnızca geliştirmede kullanılabilir.
> **Son güncelleme:** 28.10.2026

## Özet

| Kaynak | Ne için | Durum | Yayın için uygun mu |
|---|---|---|---|
| Quran.com API v4 | Ayet metinleri (`text_uthmani`, `text_qpc_hafs`), cüz/hizb/rubu'/secde, sure bilgileri; Corpus kelime bölünmesi ve QCF V2 glif kodları (yalnızca eşleme köprüsü) | ✅ Kullanılıyor | ❓ **Belirsiz**: AK-11 |
| **KFGQPC metni** (`text_qpc_hafs`, Quran.com üzerinden) | **Esas kelime bölünmesi** (77.430 kelime) | ✅ Kullanılıyor | Asıl hak sahibi KFGQPC: AK-11 |
| QUL (Tarteel) | Medine 1421H düzeni: satırlar, ortalı satırlar, QCF V2 glif birimleri | ✅ Kullanılıyor (elle indirildi) | ❓ Kaynak sayfalarında "telif bilgisi yok" |
| **DigitalKhatt New Madina fontu + kelime metni** (QUL font 247, script 48) | **Uygulamanın tek Kur'an fontu ve ekranda gösterilen metin** (sayfa, ayet görünümü, başlıklar) | ✅ Kullanılıyor (karar 28.10.2026) | ✅ **SIL OFL 1.1** (Amine Anane, Tarteel Inc.): uygulamaya gömülebilir, lisans metni `assets/fonts/DigitalKhatt-OFL.txt` ile dağıtılır. Kelime metninin lisansı QUL'de belirtilmemiş (AK-11). |
| ~~QPC Hafs fontu (KFGQPC)~~ | ~~Varsayılan görünüm~~ | ❌ **Kaldırıldı** (28.10.2026): DigitalKhatt seçildi | Yazılı izin gerektiriyordu |
| QCF V2 sayfa fontları (QUL üzerinden) | Yalnızca düzen doğrulaması (`check_line_widths.dart`) | 🟡 Depoda değil; uygulamada **kullanılmıyor**. Glif kodları veritabanında duruyor; izin alınırsa birebir paket ileride eklenebilir | Asıl hak sahibi KFGQPC: AK-11 |
| Tanzil | **Dosyaları yalnızca test referansı** (T-01 metin, T-02 sayfa/cüz/rubu'/secde); uygulama paketine girmez. ⚠️ Ancak Quran.com'dan gelen `ayahs.text_uthmani` metni Tanzil metninin aynısıdır (Tanzil kökenli) ve veritabanıyla uygulamaya girer. | ✅ Testlerde kullanılıyor | ✅ CC BY 3.0 (değiştirmeden, atıfla). `text_uthmani` uygulamada kaldığı sürece "Hakkında" ekranında Tanzil atfı ve bağlantısı **zorunlu** |

**Kur'an metninde hiçbir karakter değiştirilmedi.** Yapılan tüm işlemler aşağıda (Q-1…Q-14) gerekçesiyle listelenmiştir.

**Kullanım türleri:** 🟢 **Uygulama**: veri uygulamayla kullanıcıya gider. 🔵 **Eşleme**: yalnızca veritabanı üretilirken kaynakları birbirine bağlamak için kullanılır, uygulamaya girmez. 🟡 **Test/doğrulama**: yalnızca testlerde veya doğrulama araçlarında kullanılır, uygulamaya girmez.

## İndirilen dosyalar ve indirme amaçları

| Dosya (depodaki yeri) | Kaynak ve indirme yolu | İçerik | Neden indirildi / nerede kullanılıyor |
|---|---|---|---|
| `quran_app/tool/content/sources/quran_com/chapters.json` | Quran.com API, `GET /chapters?language=en` ve `?language=tr`; `fetch_sources.dart` ile | 114 surenin bilgileri | 🟢 Sure listesi ve sure bilgileri (Türkçe/Arapça/İngilizce ad, iniş yeri, ayet sayısı, besmele) → `surahs` tablosu. Ana sayfadaki sure listesi bundan gelir. |
| `quran_app/tool/content/sources/quran_com/verses.json` | Quran.com API, `GET /verses/by_page/1..604?mushaf=1&words=true`; `fetch_sources.dart` ile | 6.236 ayetin iki metni, cüz/hizb/rubu'/secde, Corpus bölünmesine göre kelimeler ve QCF V2 glif kodları | 🟢 Ayet metinleri ve bölüm bilgileri → `ayahs` tablosu. 🟢 Esas kelimeler KFGQPC metninden bölünür → `words` tablosu. 🔵 Corpus kelimeleri ve glif kodları yalnızca eşleme için (kelime metinleri ayrıca saklanmaz). |
| `quran_app/tool/content/sources/quran_com/manifest.json` | `fetch_sources.dart` üretir | Kaynak adresi ve indirme zamanı | Kayıt: verinin ne zaman, nereden indirildiği; veritabanının `content_meta` tablosuna yazılır |
| `quran_app/tool/content/sources/qul/qpc-v2-15-lines.db` | QUL, "KFGQPC V2 layout (1421H print)", https://qul.tarteel.ai/resources/mushaf-layout/10; ücretsiz hesapla elle | 604 sayfa × 15 satırlık düzen: satır türü, ortalı mı, satırdaki ilk/son glif, sure numarası | 🟢 Mushaf sayfa düzeni → `layout_lines` ve `layout_pages` tabloları. Sayfaların basılı nüshayla aynı satırlara bölünmesi bundan gelir (M2-02). İlk indirme amacı Quran.com düzenini doğrulamaktı; Quran.com'da satır hataları çıkınca düzen kaynağı yapıldı (Q-13). |
| `quran_app/tool/content/sources/qul/qpc-v2.db` | QUL, "QPC V2 Glyph – Word by Word", https://qul.tarteel.ai/resources/quran-script/61; ücretsiz hesapla elle | 83.668 glif birimi (konum ve QCF V2 glif kodu) | 🟢 Glif birimleri → `layout_glyphs` tablosu: sayfanın birebir fontla çizimi ve kelimeye dokunma için (M3-03, M8-02). 🔵 Satırlardaki glif numaralarını kelimelere bağlamak için. |
| `quran_app/tool/content/sources/qul/digital-khatt-v2.db` | QUL, "Digital Khatt V2 script – Word by word", https://qul.tarteel.ai/resources/quran-script/48; ücretsiz hesapla elle | 83.668 kelime birimi, DigitalKhatt kodlamasıyla; kelime numaraları `qpc-v2.db` ile aynı | 🟢 Ekranda gösterilen metin (sayfa ve ayet görünümü) |
| `quran_app/assets/fonts/DigitalKhattV2.otf` + `DigitalKhatt-OFL.txt` | QUL, "Digital Khatt V2 Font", https://qul.tarteel.ai/resources/font/247 (font); OFL metni https://github.com/DigitalKhatt/madinafont | DigitalKhatt New Madina v0.1 (CFF2, 522 KB) | 🟢 Uygulamanın tek Kur'an fontu. OFL gereği lisans metniyle dağıtılır. |
| `quran_app/tool/content/sources/qul/manifest.json` | Elle yazıldı | QUL dosyalarının kaynağı, tarihi, lisans notu | Kayıt |
| QCF V2 sayfa fontları, 604 TTF, 208 MB (**depoda değil**; `Projects/qul_indirilenler/QPC V2 Font.ttf`) | QUL, "QPC V2 Font – Page by Page", https://qul.tarteel.ai/resources/font/249; ücretsiz hesapla elle | Her mushaf sayfası için ayrı font dosyası | 🟡 Düzen doğrulaması: `check_line_widths.dart` ile satır genişliklerinin ölçülmesi (Q-13). İleride 🟢 kullanıcının onayıyla indirilecek "birebir görünüm" font paketi (TK-06, F0-05). Boyutu nedeniyle uygulama paketine girmez. |
| `quran_app/tool/content/sources/tanzil/quran-uthmani.txt` | Tanzil, https://tanzil.net/download (Osmanlı yazımı, tüm işaretler); `fetch_sources.dart tanzil` ile | 6.236 ayetin metni, telif notu dosya sonunda | 🟡 Yalnızca test: Quran.com'dan gelen ayet metninin bağımsız bir kaynakla karakter karakter karşılaştırılması (T-01). Metindeki ۞ ve ۩ işaretleri rubu' ve secde kontrollerinde kullanılır (T-02). |
| `quran_app/tool/content/sources/tanzil/quran-data.xml` | Tanzil, https://tanzil.net/res/text/metadata/quran-data.xml; `fetch_sources.dart tanzil` ile | Sure ayet sayıları, cüz, rubu', sayfa (1405H) ve secde başlangıçları | 🟡 Yalnızca test: ayet sayıları, cüz/rubu' başlangıçları ve sayfa başlarının bağımsız kontrolü (T-01, T-02) |
| `quran_app/tool/content/sources/tanzil/manifest.json` | `fetch_sources.dart` üretir | Kaynak, lisans, indirme zamanı | Kayıt |

### İndirilip kullanılmayan veya kaldırılan veriler
| Veri | Neden indirildi | Neden kullanılmıyor |
|---|---|---|
| Quran.com 1421H sayfa/satır numaraları (eski `layout_madani_1421.json`) | İlk düzen kaynağı olarak (F0-03) | QUL ve font ölçümüyle 4 sayfada satır hatası bulundu (Q-13); düzen kaynağı QUL oldu, dosya silindi |
| Quran.com 1405H (QCF V1) satır verisi | İkinci Medine düzeni adayı olarak (F0-03) | 8 sayfada tutarsız (Q-7); depoya hiç alınmadı |
| Quran.com 1405H sayfa başları (20 sayfa, tek seferlik sorgu) | Tanzil sayfa verisinin hangi baskıya ait olduğunu anlamak için (F0-04) | Yalnızca kontrol amaçlıydı; sonuç Q-10'a yazıldı, saklanmadı |
| QUL "Digital Khatt layout" (kaynak 21) | DigitalKhatt'a özel düzen var mı diye | `qpc-v2-15-lines.db` ile 9.046 satırın hepsi aynı çıktı; ayrıca saklanmadı |
| KFGQPC HAFS Uthmanic Script fontu (QUL kaynak 245) | Varsayılan font olarak (F0-05) | Yazılı izin gerektirdiği için DigitalKhatt seçildi; uygulamadan kaldırıldı |
| DigitalKhatt GitHub `madina.otf` (2,6 MB) | Kapsama denetimi için | QUL'deki V2 sürümü (522 KB) ve onun kelime metni kullanıldı |
| Quranic Arabic Corpus web sayfaları (2:75, 2:181, 15:7, 36:22, 37:130) | Kelime bölünmesindeki tutarsızlığı çift kontrol etmek için (F0-04) | Yalnızca karşılaştırma amaçlıydı; sonuç Q-12'ye yazıldı, veri saklanmadı |

> Not: Kök klasördeki `reviews/` (rakip uygulama yorumları) Kur'an içeriği değildir; yalnızca gereksinim analizinde kullanıldı ve depoya girmez.

## Veritabanı alanlarının kaynağı ve kullanımı

| Tablo / alan | Kaynak | Kullanım |
|---|---|---|
| `surahs.*` | Quran.com `chapters.json` | 🟢 Sure listesi, sure bilgileri |
| `ayahs.text_qpc_hafs` | Quran.com (KFGQPC metni) | Esas kelime bölünmesinin kaynağı; 🟡 DigitalKhatt metninin harf ve durak işareti referansı. Ekranda gösterilmiyor. |
| `ayahs.text_uthmani` | Quran.com; **Tanzil kökenli** (Tanzil metniyle karakteri karakterine aynı, T-01) | 🟢 Ekranda gösterilmiyor; ileride arama için düşünülüyor (Faz 1). 🟡 T-01'de Tanzil ile karşılaştırılan metin. ⚠️ Uygulamada kaldığı sürece Tanzil lisansı geçerlidir (değiştirmeden + atıf). Arama KFGQPC metniyle yapılabilirse Faz 1'de kaldırılabilir: veritabanı ~1,3 MB küçülür, atıf yükümlülüğü kalkar. |
| `ayahs.juz`, `hizb`, `rub` | Quran.com | 🟢 Cüz, hizb ve rubu' göstergeleri (M2-04, M2-05) |
| `ayahs.sajdah` | Quran.com | 🟢 Secde ayeti göstergesi; **14 secde** (Hanefi, karar Q-8) |
| `words.word_text`, `position` | KFGQPC metni (`text_qpc_hafs` bölünerek) | 🟢 Kelime konumu (sure:ayet:kelime), kelimeye dokunma, hata işaretleri, arama |
| `words.morph_first`, `morph_last` | Quran.com/Corpus kelimeleriyle otomatik hizalama | 🔵→🟢 İleride kelime meali ve ses verisini doğru kelimeye bağlamak için (M3) |
| `layout_lines.*`, `layout_pages.*` | QUL `qpc-v2-15-lines.db` (+ 254. sayfa düzeltmesi) | 🟢 Mushaf sayfa düzeni; ayet ↔ sayfa dönüşümü (M2-15) |
| `layout_glyphs.glyph` | QUL `qpc-v2.db` | 🟡 Uygulamada kullanılmıyor (QCF paketi kaldırıldı); izin alınırsa birebir görünüm için saklanıyor |
| `layout_glyphs.digital_khatt_text` | QUL `digital-khatt-v2.db` (kelime numaraları QPC V2 ile aynı; betik doğrular) | 🟢 Mushaf sayfasında gösterilen metin |
| `ayahs.text_digital_khatt` | QUL `digital-khatt-v2.db` (ayetin glif birimleri birleştirilerek) | 🟢 Ayet görünümünde gösterilen metin. 🟡 T-01: harf iskeleti ve durak işaretleri denetimi (Q-15) |
| `layout_glyphs.first_word_id`, `last_word_id` | Otomatik hizalama (QUL glifi ↔ Quran.com glifi ↔ KFGQPC kelimesi) | 🟢 Glife dokununca hangi kelimenin seçileceği |
| `content_meta.*` | Betik | Kayıt: içerik sürümü, kaynak, üretim zamanı |

---

## 1. Quran.com API v4

| Alan | Değer |
|---|---|
| Adres | https://api.quran.com/api/v4 (kimlik doğrulamasız) |
| İndirme | `fetch_sources.dart quran_com` → `quran_app/tool/content/sources/quran_com/` |
| İndirme tarihi | 28.10.2026 (`manifest.json` içinde tam zaman). İki ayrı indirmede metin ve meta veri birebir aynı çıktı. |
| Kullanılan uç noktalar | `GET /chapters?language=en\|tr`, `GET /verses/by_page/{1..604}?mushaf=1&words=true` |
| Alınan alanlar | Ayet: `text_uthmani`, `text_qpc_hafs`, cüz, hizb, rubu', secde. Kelime (Corpus bölünmesi): `position`, `char_type_name`, `text_uthmani`, `code_v2`. Sure: Arapça ad, Latin okunuş, TR ad, EN anlam, iniş yeri ve sırası, besmele, ayet sayısı |
| Kullanılmayan | Sayfa/satır numaraları: 4 sayfada hatalı bulundu (Q-13); düzen QUL'den alınır |
| Asıl hak sahibi | Metin ve QCF V2 glifleri: Kral Fahd Kur'an Basım Kompleksi (KFGQPC). API: Quran Foundation / Quran.com |

## 2. QUL (Quranic Universal Library, Tarteel)

| Alan | Değer |
|---|---|
| Adres | https://qul.tarteel.ai (dosyalar ücretsiz hesapla, elle indirilir) |
| Dosyalar | `quran_app/tool/content/sources/qul/qpc-v2-15-lines.db` (KFGQPC V2 layout, 1421H; kaynak 10) ve `qpc-v2.db` (QPC V2 Glyph – Word by Word; kaynak 61). Değiştirilmeden saklanır. |
| Fontlar | QPC V2 Font – Page by Page (kaynak 249): 604 TTF, toplam 208 MB. **Depoda değil.** |
| İndirme tarihi | 28.10.2026 |
| Lisans | Kaynak sayfalarında "We don't have copyright information for this resource". Asıl hak sahibi KFGQPC. |

## 3. Bilinen durumlar ve yapılan işlemler

| # | Gözlem | Yapılan / Durum |
|---|---|---|
| Q-1 | Quran.com'un kelime metinleri ile ayet metni farklı yazım sürümlerinden. | ✅ **Çözüldü:** kelimeler artık KFGQPC ayet metninden bölünüyor; kelimeler ayet metnini birebir oluşturuyor (T-01). Quran.com kelime metni saklanmıyor. |
| Q-2, Q-3 | Quran.com kelime metninde görünmez yön karakteri (27:26) ve farklı kodlanmış elif-medde (70:1, 82:1, 108:1). | ✅ Geçersiz: Quran.com kelime metni artık saklanmıyor. |
| Q-4 | Quran.com: 84:21'in ayet sonu işareti 13. satırda verilmiş. | ✅ QUL düzeni 14. satır diyor (önceki düzeltmemizle aynı). Düzen artık QUL'den geldiği için ayrı düzeltme gerekmiyor. |
| Q-5 | Sure başlığı ve besmele satırları Quran.com'da yoktu; kuralla çıkarılıyordu. | ✅ QUL satır türlerini veriyor; 9.046 satırın türü kuralımızla birebir aynı. QUL besmele satırlarında sure numarası yok: önceki sure başlığından alınır. |
| Q-6 | Ortalı satır bilgisi yoktu. | ✅ **Çözüldü:** QUL'den, 256 satır (ilk iki sayfanın tamamı dahil). |
| Q-7 | 1405H baskısı (QCF V1) Quran.com satır verisi 8 sayfada tutarsız. | İkinci Medine düzeni şimdilik yok; QUL'ün V1 düzeniyle (kaynak 15) doğrulanıp eklenebilir. |
| Q-8 | Meta veride 14 secde (22:77 yok); metinde 15 ۩ işareti. 14 Hanefi sayısı, 22:77 Şafii'de secde. | ✅ **Karar (kullanıcı, 28.10.2026): 14 secde.** Uygulamanın secde göstergesi `ayahs.sajdah` alanını (14 secde) kullanır; T-02 bunu ve farkın yalnızca 22:77 olduğunu denetler. 22:77'deki ۩ işareti basılı metnin parçası olduğu için mushaf sayfasında görünmeye devam eder. |
| Q-9 | Quran.com `text_uthmani`: 110 surenin 1. ayetinde besmele çıkarılırken başta bir boşluk kalmış. | Yalnızca bu boşluk kırpılıyor. 6.236 ayet Tanzil ile karakteri karakterine aynı (T-01). |
| Q-10 | Tanzil'in sayfa verisi 1405H baskısına ait; 1421H düzenimizde 25 sayfanın ilk ayeti farklı. | ✅ **Doğrulandı:** QUL'ün 1421H düzeni bu 25 sayfada bizimle aynı. T-02 farkları tek tek listeliyor. Not: QUL ve Quran.com aynı ekipten (Tarteel/Quran Foundation); tam bağımsız değiller. Satırlar ayrıca fontla ölçüldü (Q-13). |
| Q-11 | Tanzil meta verisi 106. rubu'u 15:50'de başlatıyor; kendi metnindeki ۞ işareti 15:49'da. | Bizim veri (15:49) işaretle uyumlu; T-02'de belgeli istisna. |
| **Q-12** | **Kelime bölünmesi kaynaklara göre değişir.** Harfler her kaynakta aynı, yalnızca 7 yerde kelime sınırı farklı (aşağıdaki tablo). | **Esas: KFGQPC metni (77.430 kelime)**, kullanıcı kararı 28.10.2026. Corpus ve glif eşlemeleri harf iskeletiyle **otomatik** çıkarılır; testler farkların yalnızca bu yerlerde olduğunu denetler. Hizalamada tek imla farkı 11:13 (KFGQPC افتريه / Quran.com افتراه). |
| **Q-13** | **Satır hataları.** Quran.com'un satır verisi 27, 177, 400, 443. sayfalarda birer kelimeyi yanlış satıra koyuyor (satır genişliği ±%9–16 sapıyor). QUL bu sayfalarda doğru. 254. sayfada iki kaynak da hatalı: Quran.com "بَعۡدَ مَا"yı 7. satıra (−%5,9), QUL 6. satıra (+%4,1) koyuyor. | Düzen **QUL'den** alınır. 254. sayfa için tek, gerekçeli düzeltme: "بَعۡدَ" 6. satırın sonu, "مَا" 7. satırın başı (+%0,5 / −%0,9). Doğrulama: `check_line_widths.dart` ile 8.790 iki yana yaslı satırın tamamı %3 içinde (ortanca %0,37, en büyük %2,63). |
| **Q-15** | **Ekranda gösterilen metin DigitalKhatt'ın kelime metnidir** ve farklı bir Unicode kodlaması kullanır (ayrık hemze, açık tenvin U+08F0–08F2, iklabda tek hareke + küçük mim, kelimeye bitişik vakf/rubu' işaretleri). Ham karşılaştırmada Tanzil ile yalnızca 298 ayet aynı. | Kodlamadan bağımsız iki denetim (T-01): **(1) harf iskeleti** DigitalKhatt = KFGQPC = Tanzil, **6.236 ayetin tamamında**; **(2) durak işaretleri** (U+06D6–06DB) DigitalKhatt = KFGQPC (resmi 1421H metni), **6.236 ayetin tamamında**. Tanzil'in durak işaretleri 323 ayette farklı: 1405H baskısını izliyor, bu yüzden durak için referans değil. 52:37'de DigitalKhatt küçük sîni harfin **altına** (U+06E3) yazıyor; basılı nüshayla uyumlu (KFGQPC Unicode metni üstte U+06DC kullanıyor). Ek olarak her ayetin kendi numarasıyla bittiği ve tüm metnin sağlama değeri denetleniyor. |
| **Q-14** | KFGQPC metninde ayırıcılar: ayet numarası ve ۞ işaretinden sonra genelde bölünmez boşluk (U+00A0); 2:72'de ayet numarasından önce normal boşluk. | Kelime bölmede iki tür boşluk da ayırıcı sayılır; metin olduğu gibi saklanır. |

### Q-12 Kelime bölünmesi karşılaştırması

| Yer | Tanzil | **KFGQPC (esas)** | Quran.com | Corpus | QUL / QCF glifi |
|---|---|---|---|---|---|
| 15:7 لَّوۡمَا | 2 | **1** | 2 | 2 | 2 |
| 27:20 مَالِيَ | 2 | **1** | 2 | 2 | 2 |
| 36:22 وَمَالِيَ | 2 | **1** | 2 | 2 | 2 |
| 37:130 إِلۡ يَاسِينَ | 2 | **2** | 1 | 1 | 1 |
| بَعۡدَ مَا (2:181, 8:6, 13:37) | 2 | **2** | 1 | 1 | 2 |
| **Toplam kelime** | 77.433 | **77.430** | 77.429 | | 77.432 |

- **Corpus ve Quran.com dilbilgisi birimini sayıyor:** "baʿdamā" bağlaç, "Il-yāsīn" özel isim. Aynı ifadenin esreli hali "min baʿdi mā" (27 yer) her kaynakta 2 kelime.
- **Arap yazısında ا ve و sonraki harfe bağlanmaz:** bu yüzden "لوما" ile "لو ما" basılı sayfada yalnızca boşluk genişliğiyle ayrılır.
- **Veritabanındaki eşleme alanları:**
  - Kelime → Corpus: `words.morph_first`, `words.morph_last` (ileride kelime meali ve ses için).
  - Glif → kelime: `layout_glyphs.first_word_id`, `layout_glyphs.last_word_id` (kelimeye dokunma için).
- **Glif eşlemesi bu 4 yerde bire bir değil:** 15:7, 27:20 ve 36:22'de bir kelime iki glif; 37:130'da bir glif iki kelime.

---

## 4. Tanzil (test referansı)

| Alan | Değer |
|---|---|
| Adres | https://tanzil.net |
| Lisans | Creative Commons Attribution 3.0. Metin **değiştirilmeden** kopyalanabilir; kaynak (Tanzil Project) açıkça belirtilmeli ve tanzil.net'e bağlantı verilmeli; telif notu korunmalı |
| İndirme | `fetch_sources.dart tanzil` → `quran_app/tool/content/sources/tanzil/` (28.10.2026) |
| Dosyalar | `quran-uthmani.txt`: Osmanlı yazımı, tüm işaretler (vakf, ۩, ۞), telif notu dosya sonunda. `quran-data.xml`: sure, cüz, rubu', sayfa (1405H), secde meta verisi |
| Saklama | Bayt bayt, değiştirilmeden (`.gitattributes` ile git satır sonu dönüşümü kapalı; `sources/` klasörünün tamamı için) |
| Kullanım | Dosyaları yalnızca testlerde (`test/content/`); uygulama paketine **girmez** (APK içeriğiyle doğrulandı). Ancak aynı metin Quran.com üzerinden `ayahs.text_uthmani` alanıyla uygulamaya girer; bu alan kaldığı sürece atıf zorunludur. |

### Karşılaştırma sonuçları (28.10.2026)
- **Metin:** Quran.com `text_uthmani` Tanzil metniyle aynı kaynaktan geliyor. Tanzil'deki besmele çıkarılınca 6.236 ayetin **tamamı** karakteri karakterine aynı (Q-9).
- **Cüz:** 30 başlangıcın hepsi aynı.
- **Rubu':** 240 başlangıcın 239'u aynı; tek fark Tanzil'in kendi çelişkisi (Q-11).
- **Secde:** metin işaretleri 15, Quran.com meta verisi 14; uygulamada 14 kullanılır (Q-8).
- **Sayfa:** 604 sayfanın 579'u aynı; 25 fark 1405H/1421H baskı farkı (Q-10).

---

## 5. Bütünlük güvenceleri

| Ne | Nasıl korunuyor |
|---|---|
| `text_uthmani` (6.236 ayet) | T-01: Tanzil ile karakter karakter karşılaştırma |
| Kelimeler | T-01: kelimeler KFGQPC ayet metnini birebir oluşturur; Corpus farkı yalnızca 7, glif farkı yalnızca 4 bilinen yerde |
| `text_qpc_hafs`, kelimeler, cüz/hizb/rubu'/secde, düzen satırları ve glifler | T-01: `tool/content/reference/checksums.json` içindeki sure başına SHA-256 değerleri; bağımsız kontrollerden sonra sabitlendi |
| Sayfa, cüz, rubu', secde, satır yapısı | T-02: Tanzil meta verisi, metindeki ۞/۩ işaretleri; glif kapsaması, kelimenin tek satırda olması, ortalı satırlar, 254. sayfa düzeltmesi |
| Satır genişlikleri | `tool/content/check_line_widths.dart <font_klasörü>`: fontlar depoda olmadığı için yerelde, düzen değiştiğinde çalıştırılır |

**Kaynak bilerek güncellenirse:**
1. `build_content_db.dart` çalıştırılır.
2. Testler çalıştırılır; değişen sureler listelenir.
3. Farklar incelenir.
4. Düzen değiştiyse satır genişliği aracı da çalıştırılır.
5. `update_checksums.dart` çalıştırılır.
6. `checksums.json` farkı commit'te gözden geçirilir.

---

## 6. Lisans Kontrol Listesi (İÇ-10)

Her kaynak için doldurulur. ❓ olan maddeler yayından önce kapatılmalıdır.

| Madde | Quran.com API v4 | QUL (düzen, glif, font) | Tanzil |
|---|---|---|---|
| Hak sahibi belli mi? | ✅ Quran Foundation (API); KFGQPC (metin, fontlar) | ✅ Tarteel (derleme); KFGQPC (düzen, glifler, fontlar) | ✅ Tanzil Project |
| Lisans metni var mı? | ❓ API kullanım koşulları incelenmedi | ❌ "Telif bilgisi yok" | ✅ CC BY 3.0 |
| Ticari kullanıma izin var mı? | ❓ | ❓ (QUL SSS: "çoğu kaynak ticari kullanılabilir, kaynağın lisansına bakın") | ✅ |
| Uygulamaya gömülerek dağıtılabilir mi? | ❓ | ❓ | ✅ (değiştirmeden) |
| Değişiklik izni | Gerekmiyor: metin değiştirilmiyor | Düzende 1 satır düzeltmesi (Q-13) belgelendi | ❌ Değiştirilemez |
| Atıf zorunluluğu ve metni | ❓ | ❓ | ✅ "Tanzil Quran Text, Copyright (C) Tanzil Project" + bağlantı |
| "Hakkında" ekranında gösterilecek (İÇ-01) | Evet | Evet | **Evet** (`ayahs.text_uthmani` uygulamada kaldığı sürece) |
| Yayın için uygun mu? | ❓ AK-11 | ❓ AK-11 | ✅ |
| Kontrol tarihi / kontrol eden | 28.10.2026 / geliştirme | 28.10.2026 / geliştirme | 28.10.2026 / geliştirme |

---

## Değişiklik Geçmişi
| Tarih | Değişiklik |
|---|---|
| 28.10.2026 | İlk sürüm: Quran.com API v4 kaynağı, bilinen durumlar Q-1…Q-8, lisans kontrol listesi |
| 28.10.2026 | Tanzil test referansı olarak eklendi; karşılaştırma sonuçları; Q-8 güncellendi, Q-9…Q-11 eklendi; bütünlük güvenceleri bölümü |
| 28.10.2026 | QUL eklendi (düzen ve glif kaynağı); esas kelime bölünmesi KFGQPC (77.430); Q-1…Q-6 ve Q-10 çözüldü/güncellendi; Q-12…Q-14 eklendi; satır genişliği doğrulaması |
| 28.10.2026 | **Font kararı: yalnız DigitalKhatt (OFL).** KFGQPC fontları kaldırıldı; DigitalKhatt kelime metni ve fontu eklendi; Q-15 (ekrandaki metnin doğrulanması) |
| 28.10.2026 | Tanzil kökenli `ayahs.text_uthmani` alanı ve atıf yükümlülüğü açıkça yazıldı; Faz 1'de arama metni kararıyla birlikte değerlendirilecek |
| 28.10.2026 | Q-8 kararı: 14 secde. Dosya düzeyinde "İndirilen dosyalar ve indirme amaçları", "İndirilip kullanılmayan veriler" ve "Veritabanı alanlarının kaynağı ve kullanımı" bölümleri eklendi |
