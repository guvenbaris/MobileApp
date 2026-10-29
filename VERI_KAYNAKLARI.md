# Veri Kaynakları ve Lisans Envanteri

> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (8. İçerik: İÇ-01, İÇ-03, İÇ-10; AK-05, AK-11), `Fazlar/Faz_0.md` (F0-03, F0-04, F0-05, F0-10), `Fazlar/Faz_0_Notlar.md`
> **Kural (İÇ-10):** Yeni bir içerik kaynağı eklenmeden önce aşağıdaki lisans kontrol listesi doldurulur. Yayın için uygun olmayan kaynak yalnızca geliştirmede kullanılabilir.
> **Uyarı:** Bu belge geliştirme ekibinin kayıtlarıdır, hukuki görüş değildir. ❓ işaretli maddeler yayından önce hak sahipleriyle veya hukuk danışmanıyla (AK-09, AK-11) netleştirilmelidir.
> **Son güncelleme:** 29.10.2026 (Faz 1 S9: Tanzil kökenli `text_uthmani` alanı kaldırıldı; Tanzil yalnızca test referansı)

## Özet

| Kaynak | Ne için | Durum | Yayın için uygun mu |
|---|---|---|---|
| Quran.com API v4 | KFGQPC ayet metni (`text_qpc_hafs`), cüz/hizb/rubu'/secde, sure bilgileri; Corpus kelime bölünmesi ve QCF V2 glif kodları (yalnızca eşleme köprüsü) | ✅ Kullanılıyor | ❓ **Belirsiz**: API kullanım koşulları incelenmedi (AK-11) |
| **KFGQPC metni** (`text_qpc_hafs`, Quran.com üzerinden) | **Esas kelime bölünmesi** (77.430 kelime) | ✅ Kullanılıyor | ❓ Asıl hak sahibi KFGQPC (AK-11) |
| QUL (Tarteel): düzen ve glif birimleri | Medine 1421H düzeni: satırlar, ortalı satırlar, glif birimleri | ✅ Kullanılıyor (elle indirildi) | ❓ Kaynak sayfalarında "telif bilgisi yok" (AK-11) |
| **DigitalKhatt New Madina fontu** (QUL font 247) | **Uygulamanın tek Kur'an fontu** (sayfa, ayet görünümü, başlıklar) | ✅ Kullanılıyor (karar 28.10.2026) | ✅ **SIL OFL 1.1** (Amine Anane, Tarteel Inc.). Font, telif ve lisans bilgisini kendi meta verisinde taşıyor. Lisans metni de uygulama paketinde: `assets/fonts/DigitalKhatt-OFL.txt`, Ayarlar → Lisanslar. |
| **DigitalKhatt kelime metni** (QUL script 48) | **Ekranda gösterilen Kur'an metni** | ✅ Kullanılıyor | ❓ QUL'de lisans belirtilmemiş; fontun OFL lisansı bu metni kapsamaz (AK-11) |
| ~~QPC Hafs fontu (KFGQPC)~~ | ~~Varsayılan görünüm~~ | ❌ **Kaldırıldı** (28.10.2026): DigitalKhatt seçildi | Yazılı izin gerektiriyordu |
| QCF V2 sayfa fontları (QUL üzerinden) | Yalnızca düzen doğrulaması (`check_line_widths.dart`) | 🟡 Depoda değil; uygulamada **kullanılmıyor**. Glif kodları veritabanında duruyor; izin alınırsa birebir görünüm yeniden değerlendirilebilir | ❓ Asıl hak sahibi KFGQPC (AK-11) |
| Tanzil | **Yalnızca test referansı**, tek dış referans (T-01 harf iskeleti, T-02 sayfa/cüz/rubu'/secde). Tanzil metninin hiçbir kısmı uygulamaya girmez (içerik sürümü 7, Faz 1 S9). | ✅ Testlerde kullanılıyor | Dağıtılmadığı için uygulamada yükümlülük yok. Depodaki kopya telif bloğuyla birlikte, aynen saklanıyor (§4). |
| **cpfair/quran-tajweed** | Renkli tecvid (M2-06): 18 kural, 60.057 açıklama | ✅ Kullanılıyor (F1-04) | ✅ **CC BY 4.0** (atıf + değişiklik notu karşılanıyor, §8) |
| Yazılım bağımlılıkları (Dart/Flutter paketleri, SQLite) | Uygulamanın kodu | ✅ | ✅ MIT / BSD-3-Clause; SQLite kamu malı (§7) |

**Kur'an metninin harfleri ve işaretleri hiçbir kaynakta değiştirilmedi.** Uygulamadaki ayet metinleri (KFGQPC ve DigitalKhatt) kaynaklarındaki haliyle saklanır. Diğer işlemler (Q-1…Q-15) metne değil, düzene ve eşlemelere aittir ve gerekçeleriyle listelenmiştir.

**Kullanım türleri:**
- 🟢 **Uygulama:** veri uygulamayla kullanıcıya gider.
- 🔵 **Eşleme:** yalnızca veritabanı üretilirken kaynakları birbirine bağlamak için kullanılır; uygulamaya girmez.
- 🟡 **Test/doğrulama:** yalnızca testlerde veya doğrulama araçlarında kullanılır; uygulamaya girmez.

## Uygulama paketine giren içerik (APK ile doğrulandı, 29.10.2026)

| Dosya | Boyut | İçerik | Lisans yükümlülüğü nasıl karşılanıyor |
|---|---|---|---|
| `assets/db/content.sqlite` | 15,6 MB (içerik sürümü 9; F1-04'ten önce 13,9 MB) | Sure bilgileri, iki ayet metni (KFGQPC, DigitalKhatt), kelimeler, düzen, glif birimleri, renkli tecvid aralıkları | Kaynak listesi: `content_meta.source`. Tanzil metni içermez (testle denetlenir). Kaynakların lisans durumu ❓ (AK-11). |
| `assets/fonts/DigitalKhattV2.otf` | 510 KB (521.832 bayt) | Kur'an fontu | OFL: telif notu ve lisans fontun `name` tablosunda (ID 0 ve 13). |
| `assets/fonts/DigitalKhatt-OFL.txt` | 4 KB | OFL 1.1 lisans metni | Lisans sayfasında gösterilir (`registerContentLicenses`). |
| `NOTICES.Z` (Flutter üretir) | | Tüm Dart/Flutter paketlerinin lisansları | Lisans sayfasında gösterilir (Flutter kendiliğinden). |
| `lib/*/libsqlite3.so` | | SQLite (sqlite3 paketi derleme sırasında ekler) | Kamu malı; yükümlülük yok. |

Tanzil dosyaları, QUL veritabanları, Quran.com JSON dosyaları ve QCF fontları pakette **yok** (APK içeriği listelenerek doğrulandı). Bu dosyalar yalnızca `tool/` altında, geliştirme ve test içindir.

**Uygulama içinde gösterilen lisanslar:** Ayarlar → Hakkında → Lisanslar. Flutter'ın standart lisans sayfası açılır. Üstte kaynak ve atıf metni bulunur (`aboutLegalese`, üç dilde: font, KFGQPC, Quran.com, QUL). Altta DigitalKhatt OFL metni ve tüm paket lisansları yer alır. Ayrıntılı "Hakkında" ekranı İÇ-01 ile eklenecek (F1-12).

## İndirilen dosyalar ve indirme amaçları

| Dosya (depodaki yeri) | Kaynak ve indirme yolu | İçerik | Neden indirildi / nerede kullanılıyor |
|---|---|---|---|
| `quran_app/tool/content/sources/quran_com/chapters.json` | Quran.com API, `GET /chapters?language=en` ve `?language=tr`; `fetch_sources.dart` ile | 114 surenin bilgileri | 🟢 Sure listesi ve sure bilgileri (Türkçe/Arapça/İngilizce ad, iniş yeri, ayet sayısı, besmele) → `surahs` tablosu. Ana sayfadaki sure listesi bundan gelir. |
| `quran_app/tool/content/sources/quran_com/verses.json` | Quran.com API, `GET /verses/by_page/1..604?mushaf=1&words=true`; `fetch_sources.dart` ile | 6.236 ayetin iki metni (`text_uthmani`, `text_qpc_hafs`), cüz/hizb/rubu'/secde, Corpus bölünmesine göre kelimeler ve QCF V2 glif kodları | 🟢 KFGQPC metni ve bölüm bilgileri → `ayahs`. 🟢 Esas kelimeler KFGQPC metninden bölünür → `words`. 🔵 Corpus kelimeleri ve glif kodları yalnızca eşleme için. ⚪ `text_uthmani` (Tanzil kökenli) ham dosyada durur ama **veritabanına alınmaz** (S9). |
| `quran_app/tool/content/sources/quran_com/manifest.json` | `fetch_sources.dart` üretir | Kaynak adresi ve indirme zamanı | Kayıt: verinin ne zaman, nereden indirildiği; `content_meta.source` alanına yazılır |
| `quran_app/tool/content/sources/qul/qpc-v2-15-lines.db` | QUL, "KFGQPC V2 layout (1421H print)", https://qul.tarteel.ai/resources/mushaf-layout/10; ücretsiz hesapla elle | 604 sayfa × 15 satırlık düzen: satır türü, ortalı mı, satırdaki ilk/son glif, sure numarası | 🟢 Mushaf sayfa düzeni → `layout_lines` ve `layout_pages` tabloları. Sayfaların basılı nüshayla aynı satırlara bölünmesi bundan gelir (M2-02). İlk indirme amacı Quran.com düzenini doğrulamaktı; Quran.com'da satır hataları çıkınca düzen kaynağı yapıldı (Q-13). |
| `quran_app/tool/content/sources/qul/qpc-v2.db` | QUL, "QPC V2 Glyph – Word by Word", https://qul.tarteel.ai/resources/quran-script/61; ücretsiz hesapla elle | 83.668 glif birimi (konum ve QCF V2 glif kodu) | 🟢 **Glif birimleri** (satırdaki parçalar ve sırası) → `layout_glyphs`. Sayfa bu birimlerle çizilir (her birimin DigitalKhatt yazılışıyla) ve kelimeye dokunma bu birimlerle çalışır (M3-03, M8-02). 🔵 Satırlardaki glif numaralarını kelimelere bağlamak için. 🟡 **QCF V2 glif kodları** (`layout_glyphs.glyph`) saklanıyor ama kullanılmıyor (QCF fontları uygulamada yok). |
| `quran_app/tool/content/sources/qul/digital-khatt-v2.db` | QUL, "Digital Khatt V2 script – Word by word", https://qul.tarteel.ai/resources/quran-script/48; ücretsiz hesapla elle | 83.668 birim, DigitalKhatt kodlamasıyla; birim numaraları `qpc-v2.db` ile aynı (betik doğrular) | 🟢 Ekranda gösterilen metin (sayfa ve ayet görünümü) → `layout_glyphs.digital_khatt_text`, `ayahs.text_digital_khatt` |
| `quran_app/assets/fonts/DigitalKhattV2.otf` | QUL, "Digital Khatt V2 Font", https://qul.tarteel.ai/resources/font/247; ücretsiz hesapla elle | DigitalKhatt New Madina, "Version 0.1" (CFF2 tabanlı OpenType, 521.832 bayt). Fontun kendi telif notu: "Copyright (c) 2020-2024 Amine Anane, Copyright © 2024 Tarteel Inc.". Lisans alanı: SIL OFL 1.1. Ayrılmış font adı (Reserved Font Name) yok. | 🟢 Uygulamanın tek Kur'an fontu. Değiştirilmeden kullanılır. |
| `quran_app/assets/fonts/DigitalKhatt-OFL.txt` | OFL metni, https://github.com/DigitalKhatt/madinafont deposundan | SIL OFL 1.1 tam metni. Başındaki telif satırları deponun güncel hali: "2020-2025 Amine Anane", "2024-2025 Tarteel Inc.". Fontun içindeki not ise 2020-2024 / 2024 diyor. | 🟢 OFL gereği fontla birlikte dağıtılır; lisans sayfasında gösterilir. Yıl farkı lisansı etkilemez: hak sahipleri ve lisans aynı. |
| `quran_app/tool/content/sources/qul/qpc-v1-15-lines.db` | QUL, "KFGQPC V1 layout (1405H print)", https://qul.tarteel.ai/resources/mushaf-layout/15; ücretsiz hesapla elle (29.10.2026, kullanıcı) | 604 sayfa × 15 satırlık 1405H düzeni | 🔵/🟢 **Yalnızca geliştirme:** indirilebilir düzen paketi `madani_1405` üretilir (`build_layout_package.dart` → `build/packages/`, depoda değil). Amaç: düzen seçimi ve paket altyapısını gerçek ikinci düzenle denemek (F1-03, M2-14). Uygulamaya gömülmez; lisans ❓ (AK-11), dağıtılmaz (İÇ-10). |
| `quran_app/tool/content/sources/qul/qpc-v1-glyph-codes-wbw.db` | QUL, "QPC V1 Glyphs – Word by Word", https://qul.tarteel.ai/resources/quran-script/57; ücretsiz hesapla elle (29.10.2026, kullanıcı) | 83.668 glif birimi (konum ve QCF V1 glif kodu) | 🔵 Glif numaralarının V2 ile aynı olduğunun doğrulanması (83.668'in hepsi aynı numara ve konumda); 🟡 V1 glif kodları paketteki `layout_glyphs.glyph` alanında saklanır, kullanılmaz. |
| `quran_app/tool/content/sources/qul/manifest.json` | Elle yazıldı | QUL dosyalarının kaynağı, tarihi, lisans notu | Kayıt |
| QCF V2 sayfa fontları, 604 TTF, 208 MB (**depoda değil**; `Projects/qul_indirilenler/QPC V2 Font.ttf`) | QUL, "QPC V2 Font – Page by Page", https://qul.tarteel.ai/resources/font/249; ücretsiz hesapla elle | Her mushaf sayfası için ayrı font dosyası | 🟡 Yalnızca düzen doğrulaması: `check_line_widths.dart` ile satır genişliklerinin ölçülmesi (Q-13). Uygulamaya girmez. KFGQPC'den izin alınırsa birebir görünüm paketi yeniden değerlendirilebilir; şu an plan yok (TK-06). |
| `quran_app/tool/content/sources/tanzil/quran-uthmani.txt` | Tanzil, https://tanzil.net/download (Osmanlı yazımı, tüm işaretler; indirme adresinde kullanım koşulları kabulü `agree=true`); `fetch_sources.dart tanzil` ile | 6.236 ayetin metni; telif ve kullanım koşulları bloğu dosya sonunda ("Tanzil Quran Text (Uthmani, Version 1.1), Copyright (C) 2007-2026 Tanzil Project") | 🟡 Test: Quran.com'dan gelen ayet metninin bağımsız bir kaynakla karakter karakter karşılaştırılması (T-01). Metindeki ۞ ve ۩ işaretleri rubu' ve secde kontrollerinde kullanılır (T-02). |
| `quran_app/tool/content/sources/tanzil/quran-data.xml` | Tanzil, https://tanzil.net/res/text/metadata/quran-data.xml; `fetch_sources.dart tanzil` ile | Sure ayet sayıları, cüz, rubu', sayfa (1405H) ve secde başlangıçları; dosya başlığında `copyright="(C) 2008-2009 Tanzil.info" license="cc-by"` | 🟡 Yalnızca test: ayet sayıları, cüz/rubu' başlangıçları ve sayfa başlarının bağımsız kontrolü (T-01, T-02) |
| `quran_app/tool/content/sources/tajweed/tajweed.hafs.uthmani-pause-sajdah.json` | GitHub cpfair/quran-tajweed (commit 496f71c), ham dosya; 29.10.2026 | 60.057 tecvid açıklaması (kural, başlangıç, bitiş) | 🟢 Renkli tecvid (M2-06, F1-04) → `tajweed_spans`. CC BY 4.0 (§8). |
| `quran_app/tool/content/sources/tajweed/quran-uthmani-2017.txt` | GitHub cpfair/quran-tajweed README'sindeki bağlantı (Tanzil Uthmani 1.0.2, 2017 kopyası); 29.10.2026 | Açıklamaların konumlarının bağlı olduğu Tanzil metni, telif bloğuyla aynen | 🔵 **Yalnızca eşleme köprüsü:** açıklama konumlarını DigitalKhatt metnine taşımak için. Uygulamaya girmez (S9). Güncel Tanzil kopyası (`sources/tanzil/`) kodlama değiştiği için kullanılamazdı. |
| `quran_app/tool/content/sources/tanzil/manifest.json` | `fetch_sources.dart` üretir | Kaynak, lisans, indirme zamanı | Kayıt |

### İndirilip kullanılmayan veya kaldırılan veriler
| Veri | Neden indirildi | Neden kullanılmıyor |
|---|---|---|
| Quran.com 1421H sayfa/satır numaraları (eski `layout_madani_1421.json`) | İlk düzen kaynağı olarak (F0-03) | QUL ve font ölçümüyle 4 sayfada satır hatası bulundu (Q-13); düzen kaynağı QUL oldu, dosya silindi |
| Quran.com 1405H (QCF V1) satır verisi | İkinci Medine düzeni adayı olarak (F0-03) | 8 sayfada tutarsız (Q-7); depoya hiç alınmadı |
| Quran.com 1405H sayfa başları (20 sayfa, tek seferlik sorgu) | Tanzil sayfa verisinin hangi baskıya ait olduğunu anlamak için (F0-04) | Yalnızca kontrol amaçlıydı; sonuç Q-10'a yazıldı, saklanmadı |
| ~~QUL "KFGQPC V1 layout (1405H)"~~ | — | Artık kullanılıyor (yukarıda, yalnızca geliştirme paketi) |
| QUL "Digital Khatt layout" (kaynak 21) | DigitalKhatt'a özel düzen var mı diye | `qpc-v2-15-lines.db` ile 9.046 satırın hepsi aynı çıktı; ayrıca saklanmadı |
| KFGQPC HAFS Uthmanic Script fontu (QUL kaynak 245) | Varsayılan font olarak (F0-05) | Yazılı izin gerektirdiği için DigitalKhatt seçildi; uygulamadan ve depodan kaldırıldı |
| DigitalKhatt GitHub `madina.otf` (2,6 MB) | Kapsama denetimi için | QUL'deki V2 sürümü (510 KB) ve onun kelime metni kullanıldı; saklanmadı |
| Quranic Arabic Corpus web sayfaları (2:75, 2:181, 15:7, 36:22, 37:130) | Kelime bölünmesindeki tutarsızlığı çift kontrol etmek için (F0-04) | Yalnızca karşılaştırma amaçlıydı; sonuç Q-12'ye yazıldı, veri saklanmadı |

> Not: Kök klasördeki `reviews/` (rakip uygulama yorumları) Kur'an içeriği değildir; yalnızca gereksinim analizinde kullanıldı ve depoya girmez.

## Veritabanı alanlarının kaynağı ve kullanımı

| Tablo / alan | Kaynak | Kullanım |
|---|---|---|
| `surahs.*` | Quran.com `chapters.json` | 🟢 Sure listesi, sure bilgileri (arayüz diline göre ad: TR okunuş, AR ad, EN Latin okunuş) |
| `ayahs.text_qpc_hafs` | Quran.com (KFGQPC metni) | Esas kelime bölünmesinin kaynağı; 🟡 DigitalKhatt metninin harf ve durak işareti referansı. Ekranda gösterilmiyor. |
| `ayahs.juz`, `hizb`, `rub` | Quran.com | 🟢 Cüz, hizb ve rubu' göstergeleri (M2-04, M2-05) |
| `ayahs.sajdah` | Quran.com | 🟢 Secde ayeti göstergesi; **14 secde** (Hanefi, karar Q-8) |
| `ayahs.text_digital_khatt` | QUL `digital-khatt-v2.db` (ayetin glif birimleri birleştirilerek) | 🟢 Ayet görünümünde gösterilen metin. 🟡 T-01: harf iskeleti ve durak işaretleri denetimi (Q-15) |
| `words.*` | KFGQPC metni (`text_qpc_hafs` bölünerek) | 🟢 Kelime konumu (sure:ayet:kelime), kelimeye dokunma, ileride hata işaretleri ve arama. **83.666 satır = 77.430 kelime + 6.236 ayet sonu işareti** (`is_ayah_end = 1`; işaret metni ayet numarasıdır, ör. "١"). |
| `words.morph_first`, `morph_last` | Quran.com/Corpus kelimeleriyle otomatik hizalama | 🔵→🟢 İleride kelime meali ve ses verisini doğru kelimeye bağlamak için (M3) |
| `mushaf_layouts.*` | Betik | Düzen kaydı: `madani_1421`, 604 sayfa, 15 satır, `font_pack = digital_khatt` (29.10.2026'ya kadar yanlışlıkla `qcf_v2` yazıyordu; uygulama bu alanı okumuyordu) |
| `layout_lines.*`, `layout_pages.*` | QUL `qpc-v2-15-lines.db` (+ 254. sayfa düzeltmesi) | 🟢 Mushaf sayfa düzeni; ayet ↔ sayfa dönüşümü (M2-15) |
| `layout_glyphs.glyph` | QUL `qpc-v2.db` | 🟡 Uygulamada kullanılmıyor (QCF fontları yok); izin alınırsa birebir görünüm için saklanıyor |
| `layout_glyphs.digital_khatt_text` | QUL `digital-khatt-v2.db` (birim numaraları QPC V2 ile aynı; betik doğrular) | 🟢 Mushaf sayfasında gösterilen metin |
| `layout_glyphs.first_word_id`, `last_word_id` | Otomatik hizalama (QUL glifi ↔ Quran.com glifi ↔ KFGQPC kelimesi) | 🟢 Glife dokununca hangi kelimenin seçileceği |
| `content_meta.contentVersion`, `builtAt` | Betik | Kayıt: içerik sürümü (8), üretim zamanı |
| `tajweed_spans.*` | cpfair/quran-tajweed (CC BY 4.0), `tajweed_alignment.dart` ile DigitalKhatt glif metnine eşlenmiş | 🟢 Renkli tecvid (M2-06): glif metninde [başlangıç, bitiş) ve kural (sayı olarak, `TajweedRule` sırası). Düzen paketleri kendi kopyasını taşır. Sağlama değeriyle kilitli (`checksums.json` → `tajweed`). |
| `content_meta.wordsHash` | Betik (`tool/content/words_hash.dart`) | Kelime tablosunun parmak izi; indirilebilir düzen paketleri yalnızca aynı parmak izli içerikle kabul edilir (TK-13, F1-03) |
| `content_meta.source` | Betik | Kayıt: Quran.com indirme zamanı ve kullanılan QUL dosyaları (`qpc-v2-15-lines.db`, `qpc-v2.db`, `digital-khatt-v2.db`) |

---

## 1. Quran.com API v4

| Alan | Değer |
|---|---|
| Adres | https://api.quran.com/api/v4 (kimlik doğrulamasız) |
| İndirme | `fetch_sources.dart quran_com` → `quran_app/tool/content/sources/quran_com/` |
| İndirme tarihi | 28.10.2026 (`manifest.json`: 2026-10-28T11:42:08Z). İki ayrı indirmede metin ve meta veri birebir aynı çıktı. |
| Kullanılan uç noktalar | `GET /chapters?language=en\|tr`, `GET /verses/by_page/{1..604}?mushaf=1&words=true` |
| Alınan alanlar | Ayet: `text_qpc_hafs`, cüz, hizb, rubu', secde (`text_uthmani` de indirilir ama saklanmaz). Kelime (Corpus bölünmesi; yalnızca eşleme için, metni saklanmaz): `position`, `char_type_name`, `text_uthmani`, `code_v2`. Sure: Arapça ad, Latin okunuş, TR ad, EN anlam, iniş yeri ve sırası, besmele, ayet sayısı |
| Kullanılmayan | Sayfa/satır numaraları: 4 sayfada hatalı bulundu (Q-13); düzen QUL'den alınır |
| Asıl hak sahibi | Metin ve QCF V2 glifleri: Kral Fahd Kur'an Basım Kompleksi (KFGQPC). API: Quran Foundation / Quran.com |
| Lisans | ❓ API kullanım koşulları incelenmedi (§6) |

## 2. QUL (Quranic Universal Library, Tarteel)

| Alan | Değer |
|---|---|
| Adres | https://qul.tarteel.ai (dosyalar ücretsiz hesapla, elle indirilir) |
| Depodaki dosyalar | `quran_app/tool/content/sources/qul/`: `qpc-v2-15-lines.db` (KFGQPC V2 layout, 1421H; kaynak 10), `qpc-v2.db` (QPC V2 Glyph – Word by Word; kaynak 61), `digital-khatt-v2.db` (Digital Khatt V2 script – Word by word; kaynak 48). Değiştirilmeden saklanır. |
| Uygulamadaki font | `quran_app/assets/fonts/DigitalKhattV2.otf` (Digital Khatt V2 Font; kaynak 247) |
| Depoda olmayan | QPC V2 Font – Page by Page (kaynak 249): 604 TTF, toplam 208 MB |
| İndirme tarihi | 28.10.2026 |
| Lisans: düzen, glif ve DigitalKhatt kelime metni | ❓ Kaynak sayfalarında "We don't have copyright information for this resource". Düzen ve gliflerin asıl hak sahibi KFGQPC. |
| Lisans: DigitalKhatt fontu | ✅ SIL OFL 1.1; fontun kendi meta verisiyle doğrulandı (§ "Uygulama paketine giren içerik") |

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
| Q-9 | Quran.com `text_uthmani`: 110 surenin 1. ayetinde besmele çıkarılırken başta bir boşluk kalmış. | ✅ **Geçersiz** (içerik sürümü 7): alan artık saklanmıyor (S9). Tanzil ile karşılaştırma harf iskeleti üzerinden yapılıyor (T-01). |
| Q-10 | Tanzil'in sayfa verisi 1405H baskısına ait; 1421H düzenimizde 25 sayfanın ilk ayeti farklı. | ✅ **Doğrulandı:** QUL'ün 1421H düzeni bu 25 sayfada bizimle aynı. T-02 farkları tek tek listeliyor. Not: QUL ve Quran.com aynı ekipten (Tarteel/Quran Foundation); tam bağımsız değiller. Satırlar ayrıca fontla ölçüldü (Q-13). |
| Q-11 | Tanzil meta verisi 106. rubu'u 15:50'de başlatıyor; kendi metnindeki ۞ işareti 15:49'da. | Bizim veri (15:49) işaretle uyumlu; T-02'de belgeli istisna. |
| **Q-12** | **Kelime bölünmesi kaynaklara göre değişir.** Harfler her kaynakta aynı, yalnızca 7 yerde kelime sınırı farklı (aşağıdaki tablo). | **Esas: KFGQPC metni (77.430 kelime)**, kullanıcı kararı 28.10.2026. Corpus ve glif eşlemeleri harf iskeletiyle **otomatik** çıkarılır; testler farkların yalnızca bu yerlerde olduğunu denetler. Hizalamada tek imla farkı 11:13 (KFGQPC افتريه / Quran.com افتراه). |
| **Q-13** | **Satır hataları.** Quran.com'un satır verisi 27, 177, 400, 443. sayfalarda birer kelimeyi yanlış satıra koyuyor (satır genişliği ±%9–16 sapıyor). QUL bu sayfalarda doğru. 254. sayfada iki kaynak da hatalı: Quran.com "بَعۡدَ مَا"yı 7. satıra (−%5,9), QUL 6. satıra (+%4,1) koyuyor. | Düzen **QUL'den** alınır. 254. sayfa için tek, gerekçeli düzeltme: "بَعۡدَ" 6. satırın sonu, "مَا" 7. satırın başı (+%0,5 / −%0,9). Doğrulama: `check_line_widths.dart` ile 8.790 iki yana yaslı satırın tamamı %3 içinde (ortanca %0,37, en büyük %2,63). |
| Q-14 | KFGQPC metninde ayırıcılar: ayet numarası ve ۞ işaretinden sonra genelde bölünmez boşluk (U+00A0); 2:72'de ayet numarasından önce normal boşluk. | Kelime bölmede iki tür boşluk da ayırıcı sayılır; metin olduğu gibi saklanır. |
| **Q-15** | **Ekranda gösterilen metin DigitalKhatt'ın kelime metnidir** ve farklı bir Unicode kodlaması kullanır (ayrık hemze, açık tenvin U+08F0–08F2, iklabda tek hareke + küçük mim, kelimeye bitişik vakf/rubu' işaretleri). Ham karşılaştırmada Tanzil ile yalnızca 298 ayet aynı. | Kodlamadan bağımsız iki denetim (T-01): **(1) harf iskeleti** DigitalKhatt = KFGQPC = Tanzil, **6.236 ayetin tamamında**; **(2) durak işaretleri** (U+06D6–06DB) DigitalKhatt = KFGQPC (resmi 1421H metni), **6.236 ayetin tamamında**. Tanzil'in durak işaretleri 323 ayette farklı: 1405H baskısını izliyor, bu yüzden durak için referans değil. 52:37'de DigitalKhatt küçük sîni harfin **altına** (U+06E3) yazıyor; basılı nüshayla uyumlu (KFGQPC Unicode metni üstte U+06DC kullanıyor). Ek olarak her ayetin kendi numarasıyla bittiği ve tüm metnin sağlama değeri denetleniyor. |

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
- **Glif birimi sayısı 83.668**, KFGQPC kelime + ayet sonu sayısı 83.666: fark bu 4 yerden gelir (+3 −1).

---

## 4. Tanzil (yalnızca test referansı)

| Alan | Değer |
|---|---|
| Adres | https://tanzil.net |
| Lisans | Creative Commons Attribution 3.0 **ve** dosyadaki kullanım koşulları. CC BY normalde değişikliğe izin verir; Tanzil ise kendi koşullarıyla metnin **değiştirilmesini yasaklar**. |
| Kullanım koşulları (dosyadaki metin, özet) | (1) Metin yalnızca **aynen** kopyalanıp dağıtılabilir; değiştirilemez. (2) Her web sitesinde veya uygulamada kullanılabilir; kaynak (Tanzil Project) **açıkça belirtilmeli** ve değişiklikleri izlenebilsin diye **tanzil.net'e bağlantı** verilmeli. (3) Telif notu tüm aynen kopyalara eklenmeli ve metnin **önemli bir bölümünü içeren her dosyada** uygun biçimde yer almalı. |
| İndirme | `fetch_sources.dart tanzil` → `quran_app/tool/content/sources/tanzil/` (2026-10-28T10:27:36Z) |
| Dosyalar | `quran-uthmani.txt`: Osmanlı yazımı, tüm işaretler (vakf, ۩, ۞), telif bloğu dosya sonunda. `quran-data.xml`: sure, cüz, rubu', sayfa (1405H), secde meta verisi |
| Saklama | Bayt bayt, değiştirilmeden (`.gitattributes`: `quran_app/tool/content/sources/** -text`, git satır sonu dönüşümü kapalı) |
| Kullanım | Yalnızca testlerde (`test/content/`): T-01'de KFGQPC ve DigitalKhatt metninin harf iskeleti, sure ve ayet sayıları; T-02'de cüz, rubu', secde ve sayfa başları. Dosyalar uygulama paketine **girmez** (APK ile doğrulandı). İçerik sürümü 7'den beri Tanzil metni veritabanında da yok (`license_notices_test.dart` denetler). |

### Neden yalnızca test referansı (Faz 1 S9, 29.10.2026)
İçerik sürümü 6'ya kadar Quran.com'dan gelen Tanzil kökenli `ayahs.text_uthmani` alanı uygulamayla dağıtılıyordu. Bu da şu yükümlülükleri doğuruyordu: telif notu, atıf, tanzil.net bağlantısı ve metnin değiştirilmemesi. Besmele ayrımının "değiştirme" sayılıp sayılmayacağı da açık soruydu.

Alan ekranda hiç kullanılmıyordu ve arama KFGQPC metninden yapılabilir. Bu yüzden alan kaldırıldı (kullanıcı kararı). Sonuçlar:
- Uygulamada Tanzil'e ait yükümlülük kalmadı; besmele sorusu kapandı.
- Veritabanı 15,5 MB'tan 13,9 MB'a küçüldü.
- Tanzil, **tek bağımsız dış referans** olarak testlerde kalıyor. Kur'an metni değişmeyen bir veri olduğu için ikinci bir test kaynağı gerekmiyor (kullanıcı kararı).
- Depodaki Tanzil dosyaları telif bloğuyla birlikte bayt bayt aynen saklanıyor (`.gitattributes`). Depo özel olduğu sürece bu bir dağıtım değildir; depo herkese açılırsa koşullar dosyalar için yeniden değerlendirilir.

**Kanıt:** sağlama değeri dosyasında yalnızca `textUthmani` satırları (114) silindi; diğer hiçbir değer değişmedi. Yeni harf iskeleti testi 2:255'te bilerek değiştirilen bir harfi yakaladı ("1. karakterde fark: veritabanı U+0646, Tanzil U+0644").

### Karşılaştırma sonuçları (28.10.2026)
- **Metin (28.10.2026, içerik sürümü 6):** o zamanki `text_uthmani`, Tanzil'deki besmele ayrılınca 6.236 ayetin **tamamında** karakteri karakterine aynıydı. Bugün T-01, KFGQPC ve DigitalKhatt metinlerinin harf iskeletini Tanzil ile karşılaştırıyor: 6.236 ayetin tamamında aynı.
- **Cüz:** 30 başlangıcın hepsi aynı.
- **Rubu':** 240 başlangıcın 239'u aynı; tek fark Tanzil'in kendi çelişkisi (Q-11).
- **Secde:** metin işaretleri 15, Quran.com meta verisi 14; uygulamada 14 kullanılır (Q-8).
- **Sayfa:** 604 sayfanın 579'u aynı; 25 fark 1405H/1421H baskı farkı (Q-10).

---

## 5. Bütünlük ve lisans güvenceleri

| Ne | Nasıl korunuyor |
|---|---|
| Ayet metinlerinin harfleri (KFGQPC, DigitalKhatt; 6.236 ayet) | T-01: Tanzil ile harf iskeleti karşılaştırması (tek dış referans) |
| Kelimeler | T-01: kelimeler KFGQPC ayet metnini birebir oluşturur; Corpus farkı yalnızca 7, glif farkı yalnızca 4 bilinen yerde |
| `text_qpc_hafs`, kelimeler, cüz/hizb/rubu'/secde, düzen satırları ve glifler | T-01: `tool/content/reference/checksums.json` içindeki sure başına SHA-256 değerleri; bağımsız kontrollerden sonra sabitlendi |
| Ekranda gösterilen DigitalKhatt metni | T-01: harf iskeleti ve durak işaretleri KFGQPC ile (Q-15) |
| Sayfa, cüz, rubu', secde, satır yapısı | T-02: Tanzil meta verisi, metindeki ۞/۩ işaretleri; glif kapsaması, kelimenin tek satırda olması, ortalı satırlar, 254. sayfa düzeltmesi |
| Satır genişlikleri | `tool/content/check_line_widths.dart <font_klasörü>`: fontlar depoda olmadığı için yerelde, düzen değiştiğinde çalıştırılır |
| **Lisans notları** | `test/content/license_notices_test.dart`: Tanzil metni veritabanında yok; font OFL ve telif notunu taşıyor; OFL dosyası pakette; lisans sayfasına font lisansı ekleniyor. |

**Kaynak bilerek güncellenirse:**
1. `build_content_db.dart` çalıştırılır.
2. Testler çalıştırılır; değişen sureler listelenir.
3. Farklar incelenir.
4. Düzen değiştiyse satır genişliği aracı da çalıştırılır.
5. `update_checksums.dart` çalıştırılır.
6. `checksums.json` farkı commit'te gözden geçirilir.
7. Bu belge güncellenir: dosya tablosu, indirme tarihi ve lisans notu.

---

## 6. Lisans Kontrol Listesi (İÇ-10)

Her kaynak için doldurulur. ❓ olan maddeler yayından önce kapatılmalıdır.

| Madde | Quran.com API v4 (metin, meta veri) | QUL (düzen, glif birimleri) | DigitalKhatt fontu | DigitalKhatt kelime metni | Tanzil (yalnızca test) |
|---|---|---|---|---|---|
| Hak sahibi belli mi? | ✅ Quran Foundation (API); KFGQPC (metin) | ✅ Tarteel (derleme); KFGQPC (düzen, glifler) | ✅ Amine Anane, Tarteel Inc. | ✅ Tarteel / DigitalKhatt (derleme); metin KFGQPC 1421H | ✅ Tanzil Project |
| Lisans metni var mı? | ❓ API kullanım koşulları incelenmedi | ❌ "Telif bilgisi yok" | ✅ SIL OFL 1.1 (font içinde ve `DigitalKhatt-OFL.txt`) | ❌ QUL'de belirtilmemiş | ✅ CC BY 3.0 + kullanım koşulları |
| Ticari kullanıma izin var mı? | ❓ | ❓ (QUL SSS: "çoğu kaynak ticari kullanılabilir, kaynağın lisansına bakın") | ✅ (font tek başına satılamaz; uygulamayla dağıtılabilir) | ❓ | ✅ |
| Uygulamaya gömülerek dağıtılabilir mi? | ❓ | ❓ | ✅ (lisans ve telif notuyla) | ❓ | — (dağıtılmıyor) |
| Değişiklik | Gerekmiyor: metin değiştirilmiyor | Düzende 1 satır düzeltmesi (Q-13) belgelendi | Font değiştirilmiyor (değişiklik olsaydı OFL koşulları geçerli olurdu; ayrılmış ad yok) | Değiştirilmiyor | — (dağıtılmıyor; depoda aynen) |
| Atıf zorunluluğu ve metni | ❓ | ❓ | ✅ Telif notu + lisans metni (karşılanıyor: lisans sayfası) | ❓ | — (dağıtılmıyor) |
| Uygulamada gösteriliyor mu? | 🟡 Lisans sayfası üst metninde adıyla | 🟡 Lisans sayfası üst metninde adıyla | ✅ Lisans sayfası | 🟡 Lisans sayfası üst metninde (QUL olarak) | Gerekmiyor |
| Yayın için uygun mu? | ❓ AK-11 | ❓ AK-11 | ✅ | ❓ AK-11 | ✅ Uygulamaya girmiyor |
| Kontrol tarihi / kontrol eden | 29.10.2026 / geliştirme | 29.10.2026 / geliştirme | 29.10.2026 / geliştirme (font meta verisi okundu) | 29.10.2026 / geliştirme | 29.10.2026 / geliştirme (dosyadaki koşullar okundu) |

**Yayın öncesi kapatılacaklar (özet):**
1. KFGQPC metni, düzeni ve DigitalKhatt kelime metni için yayın izni veya lisans (AK-11). Lisans görüşmelerinde Diyanet'in dijital mushafındaki kelime bölünmesine de bakılması önerilir (Q-12).
2. Quran.com API kullanım koşullarının incelenmesi.
3. ~~Tanzil: besmele ayrımı sorusu veya `text_uthmani`'nin kaldırılması~~ ✅ Kapandı: alan kaldırıldı (S9, içerik sürümü 7).
4. KVKK ve mağaza metinleri (AK-09; bu belgenin kapsamı dışında).

---

## 7. Yazılım bağımlılıkları

Uygulamaya giren Dart/Flutter paketlerinin lisansları; pub önbelleğindeki LICENSE dosyalarından okundu (29.10.2026). Hepsi uygulamayla dağıtılmaya izin verir. Koşulları lisans metninin dağıtılmasıdır: Flutter tüm paket lisanslarını derlemede `NOTICES` dosyasında toplar ve lisans sayfasında gösterir.

| Paket | Sürüm | Lisans |
|---|---|---|
| flutter_riverpod, riverpod | 3.4.3 | MIT |
| go_router | 18.1.1 | BSD-3-Clause |
| drift | 2.35.3 | MIT |
| sqlite3 | 3.8.0 | MIT; derlemede **SQLite**'ı ekler (`libsqlite3.so`): kamu malı |
| path_provider (+ android, foundation) | 2.1.6 (2.3.1, 2.6.0) | BSD-3-Clause |
| path | 1.9.1 | BSD-3-Clause |
| scrollable_positioned_list | 0.3.8 | BSD-3-Clause |
| uuid | 4.6.0 | MIT |
| intl | 0.20.3 | BSD-3-Clause |
| cupertino_icons | 1.0.9 | MIT |
| wakelock_plus (+ platform_interface) | 1.8.2 (1.7.0) | BSD-3-Clause. Ekranı açık tutma (M2-12, TK-15; F1-02) |
| ↳ package_info_plus (+ platform_interface) | 10.2.2 (4.1.0) | BSD-3-Clause (wakelock_plus'ın alt bağımlılığı) |
| ↳ win32, ffi_leak_tracker | 6.4.0, 0.1.2 | BSD-3-Clause (yalnızca Windows'ta çalışır) |
| ↳ dbus | 0.8.0 | **MPL-2.0** (yalnızca Linux'ta çalışır). Dosya düzeyinde copyleft: dbus'ın kendi dosyaları değiştirilirse o dosyalar açılmalıdır; **değiştirilmeden kullanıldığı için uygulamanın kaynağını açmayı gerektirmez**. Lisans metni NOTICES ile dağıtılır. |
| ↳ http, web | 1.6.0, 1.1.2 | BSD-3-Clause |
| ↳ xml, petitparser | 7.1.0, 7.1.0 | MIT |
| Flutter SDK (flutter, flutter_localizations) | 3.47.8 | BSD-3-Clause |

Yalnızca geliştirmede kullanılan paketler (`drift_dev`, `build_runner`, `analyzer`, `crypto`, `flutter_lints`, test paketleri) uygulamaya girmez. Yeni paket eklenince bu tabloya eklenir; GPL gibi uygulamanın kaynak kodunu açmayı gerektiren lisanslı paketler kullanılmaz.

## 8. Renkli tecvid verisi (cpfair/quran-tajweed)

| Alan | Değer |
|---|---|
| Kaynak | https://github.com/cpfair/quran-tajweed (Colin Pfair), commit `496f71cd191da00fa2a37ded79dbbddb033bb0ad` (depo 2021'den beri güncellenmiyor) |
| Dosyalar | `tool/content/sources/tajweed/tajweed.hafs.uthmani-pause-sajdah.json` (veri), `tool/content/sources/tajweed/quran-uthmani-2017.txt` (açıklamaların bağlı olduğu Tanzil Osmanlı metni, sürüm 1.0.2; veri setinin README'sinin bağladığı 2017 kopyası, telif bloğuyla aynen) |
| İndirme | 29.10.2026, `curl` ile ham dosyalar (GitHub) |
| İçerik | 6.236 ayet için 60.057 açıklama, 18 kural (hemze-i vasl, lâm-ı şemsiyye, okunmaz harf, 5 med, gunne, ihfâ, ihfâ-i şefevî, gunneli/gunnesiz/şefevî/mütecâniseyn/mütekâribeyn idğam, iklâb, kalkale). Yalnızca Hafs rivayeti. Konumlar Tanzil metnindeki kod noktası konumlarıdır. |
| Lisans | Veri dosyası: **Creative Commons Attribution 4.0** (ticari kullanım serbest; atıf ve değişiklik notu gerekir). Tanzil metni: Tanzil kullanım koşulları (CC BY 3.0 + değiştirmeme). |
| Kullanım | 🟢 Veri: içerik veritabanında `tajweed_spans` (glif metnindeki aralıklar). 🔵 Tanzil 2017 metni: yalnızca **eşleme köprüsü**; uygulamaya girmez (S9). |
| Eşleme | `tool/content/tajweed_alignment.dart`: harf kümeleri harf iskeletiyle eşlenir; işaretler aynı kod noktasına, yoksa eşdeğer işarete (DigitalKhatt tenvini U+08F0–2), o da yoksa harfe. Aynı harfe düşen kurallardan öncelikli olan kalır; renkli harfin kuralsız harekeleri harfle aynı kuralı alır. **60.057 açıklamanın 60.055'i eşlendi.** Eşlenemeyen 2'si 12:39 ve 12:41'de; 2017 Tanzil metninde bu ayetlerde fazladan bir harf var (iskelet farkı; yeni Tanzil ve KFGQPC ile uyumlu olan bizim metnimiz). |
| Değişiklik (CC BY 4.0 gereği belirtilir) | Konumlar DigitalKhatt metnine taşındı; çakışmalar öncelikle çözüldü; 18 kural 7 renk grubunda gösterilir. Kur'an metninin hiçbir karakteri değişmez (test: tüm gliflerde renkli parçalar birleşince aynı metin). |
| Atıf (karşılanıyor) | Lisans sayfasında "cpfair/quran-tajweed" girdisi (eser sahibi, lisans bağlantısı, değişiklik notu: `kTajweedLicenseNotice`); lisans sayfası üst metni (`aboutLegalese`, 3 dil); renk açıklamaları panelinin altında kaynak notu. `license_notices_test.dart` denetler. |
| Bilinen sınırlar | Veri seti doğruluk ölçüsü yayınlamıyor ("aktif bakımda değil"). Besmele satırları renklendirilmez. Kural açıklamaları (TR/AR/EN) geliştirme ekibince yazıldı; **yayından önce içerik kurulunca (AK-06) gözden geçirilmeli.** |

**Lisans kontrol listesi (İÇ-10):**

| Madde | cpfair/quran-tajweed |
|---|---|
| Hak sahibi belli mi? | ✅ Colin Pfair |
| Lisans metni var mı? | ✅ CC BY 4.0 (README) |
| Ticari kullanıma izin var mı? | ✅ |
| Uygulamaya gömülerek dağıtılabilir mi? | ✅ (atıfla) |
| Değişiklik | Var: DigitalKhatt metnine uyarlama, çakışma çözümü, renk grupları; belirtiliyor |
| Atıf zorunluluğu ve metni | ✅ Karşılanıyor (lisans sayfası + üst metin + panel notu) |
| Uygulamada gösteriliyor mu? | ✅ |
| Yayın için uygun mu? | ✅ Lisans açısından; içerik doğruluğu gözden geçirmesi AK-06 |
| Kontrol tarihi / kontrol eden | 29.10.2026 / geliştirme (README ve lisans okundu) |

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
| 29.10.2026 | **Genel gözden geçirme (F0-10).** Düzeltmeler: (1) Tanzil koşullarının tamamı yazıldı: telif notunun metni içeren dosyada bulunması koşulu eksikti; not artık `content.sqlite` içinde (`content_meta.notice.tanzil`, içerik sürümü 6). Besmele ayrımı açık soru olarak eklendi. "Hiçbir karakter değiştirilmedi" ifadesi Q-9'daki boşluk kırpmayı da anlatacak şekilde düzeltildi. (2) DigitalKhatt kelime metni ayrı kaynak olarak ayrıldı (fontun OFL lisansı metni kapsamaz; lisansı ❓). (3) Font meta verisi okundu: sürüm 0.1, telif 2020-2024 / 2024, OFL, ayrılmış ad yok; OFL dosyasındaki yıl farkı belgelendi. (4) OFL metni ve Tanzil notu uygulama içi lisans sayfasına eklendi; OFL dosyası pakete alındı. (5) "Uygulama paketine giren içerik" bölümü eklendi (APK ile doğrulandı). (6) `qpc-v2.db` satırı düzeltildi: QCF glif kodları kullanılmıyor, glif birimleri kullanılıyor. QCF fontları için "kullanıcı onayıyla indirilecek paket" ifadesi kaldırıldı. (7) §2'ye `digital-khatt-v2.db` ve font 247 eklendi. (8) `words` tablosunun 83.666 satırı (77.430 kelime + 6.236 ayet sonu) ve `mushaf_layouts.font_pack` (`qcf_v2` → `digital_khatt`) düzeltildi; `content_meta.source` artık DigitalKhatt dosyasını da yazıyor. (9) Q-14/Q-15 sırası düzeltildi. (10) Lisans kontrol listesine font ve kelime metni sütunları ile "yayın öncesi kapatılacaklar" eklendi. (11) §7 yazılım bağımlılıkları eklendi. |
| 29.10.2026 | F1-04: renkli tecvid kaynağı cpfair/quran-tajweed (CC BY 4.0) ve eşleme köprüsü Tanzil 2017 kopyası eklendi (§8); içerik sürümü 9 (`tajweed_spans`); lisans sayfasına atıf |
| 29.10.2026 | F1-03: QUL 1405H düzeni (kaynak 15) ve V1 glifleri (kaynak 57) indirildi; `madani_1405` geliştirme paketi. Bulgu: V1 ve V2 glif birimleri birebir aynı numarada; 1405H ile 1421H arasında ilk ayeti farklı 25 sayfa, Q-10'daki elle listelenmiş 25 farkla birebir aynı (iki kaynak birbirini doğruluyor); 1405H sayfa başları Tanzil'in sayfa verisiyle 604/604 aynı |
| 29.10.2026 | F1-03: içerik sürümü 8 (`content_meta.wordsHash`); düzen paketleri ayrı dosyadır, uygulamaya gömülmez. Medine 1405H düzeni (QUL kaynak 15, 57) aday: lisans ❓ (AK-11), yalnızca geliştirmede |
| 29.10.2026 | §7: `wakelock_plus` ve alt bağımlılıkları eklendi (F1-02); `dbus` MPL-2.0 notu |
| 29.10.2026 | **Faz 1 S9:** Tanzil kökenli `ayahs.text_uthmani` alanı ve `content_meta.notice.tanzil` kaldırıldı (içerik sürümü 7, 13,9 MB). Tanzil yalnızca test referansı (tek dış referans). T-01'deki karakter karakter karşılaştırma, KFGQPC ve DigitalKhatt harf iskeletinin Tanzil ile karşılaştırılmasına dönüştü. Q-9 geçersiz; besmele sorusu kapandı; lisans kontrol listesinde Tanzil sütunu "yalnızca test". |
