# Veri Kaynakları ve Lisans Envanteri

> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (8. İçerik: İÇ-01, İÇ-03, İÇ-10; AK-05, AK-11), `Fazlar/Faz_0.md` (F0-03)
> **Kural (İÇ-10):** Yeni bir içerik kaynağı eklenmeden önce aşağıdaki lisans kontrol listesi doldurulur. Yayın için uygun olmayan kaynak yalnızca geliştirmede kullanılabilir.
> **Son güncelleme:** 28.10.2026

## Özet

| Kaynak | Ne için | Durum | Yayın için uygun mu |
|---|---|---|---|
| Quran.com API v4 | Ayet metni, kelimeler, sure meta verisi, Medine 1421H sayfa/satır düzeni, QCF V2 glif kodları | ✅ Geliştirmede kullanılıyor | ❓ **Belirsiz**: AK-11 ile çözülecek |
| Tanzil | **Yalnızca test referansı** (T-01 metin, T-02 sayfa/cüz/rubu'/secde). Uygulamaya girmez. | ✅ Testlerde kullanılıyor | ✅ CC BY 3.0 (değiştirmeden, atıfla) |
| QUL (Tarteel) | Düzen verisinin doğrulanması, ortalı satır bilgisi, ek düzenler | ⬜ İndirmek için ücretsiz hesap gerekiyor | ❓ Kaynak sayfalarında "telif bilgisi yok" yazıyor |
| KFGQPC (Kral Fahd Kompleksi) | Metnin ve QCF fontlarının asıl sahibi | ⬜ Yazılı izin alınmadı | Lisans/izin AK-11 kapsamında |

---

## 1. Quran.com API v4

| Alan | Değer |
|---|---|
| Adres | https://api.quran.com/api/v4 (kimlik doğrulamasız) |
| İndirme | `quran_app/tool/content/fetch_sources.dart` → `quran_app/tool/content/sources/quran_com/` |
| İndirme tarihi | 28.10.2026 (`manifest.json` içinde tam zaman) |
| Kullanılan uç noktalar | `GET /chapters?language=en\|tr`, `GET /verses/by_page/{1..604}?mushaf=1&words=true` |
| Alınan alanlar | Ayet: `text_uthmani`, `text_qpc_hafs`, cüz, hizb, rubu', secde. Kelime: `position`, `char_type_name`, `text_uthmani`, `page_number`, `line_number`, `code_v2`. Sure: Arapça ad, Latin okunuş, TR ad, EN anlam, iniş yeri ve sırası, besmele, ayet sayısı |
| Düzen | `mushaf=1` → KFGQPC 1421H baskısı (QCF V2), 604 sayfa × 15 satır. Uygulamadaki kimliği: `madani_1421` |
| Asıl hak sahibi | Metin ve QCF V2 glifleri: Kral Fahd Kur'an Basım Kompleksi (KFGQPC). API: Quran Foundation / Quran.com |

### Bilinen durumlar ve yapılan işlemler
Metin **hiçbir yerde değiştirilmedi**. Aşağıdakiler kaynaktaki gözlemler ve tek düzen düzeltmesidir.

| # | Gözlem | Etki | Yapılan |
|---|---|---|---|
| Q-1 | Kelime metinleri (`words.text_uthmani`) ile ayet metni (`ayahs.text_uthmani`) aynı yazım sürümünden değil. Kelime metninde tenvin için küçük mim işaretleri (U+06ED, U+06E2) var; ayet metninde vakf işaretleri ayrı birer parça. 3.601 ayette kelimeler birleştirilince ayet metni çıkmıyor. | Asıl metin **ayet metnidir**; T-01 ayet metni üzerinden yapılır. Kelime metni yalnızca kelimeye dokunma ve arama için yardımcı veridir. | Olduğu gibi saklandı |
| Q-2 | 27:26'nın 8. kelimesinde secde işareti (U+06E9) ve görünmez yön karakteri (U+200F) var. | Arama normalizasyonunda temizlenmeli (Faz 1) | Olduğu gibi saklandı |
| Q-3 | 70:1, 82:1 ve 108:1'deki birer kelimede elif-medde birleşik karakterle (U+0622) yazılmış; ayet metninde ayrık (U+0627 + U+0653). | Arama normalizasyonunda eşitlenmeli (Faz 1) | Olduğu gibi saklandı |
| Q-4 | **Düzen hatası:** 84:21'in ayet sonu işareti 13. satırda verilmiş, oysa ayetin 3–6. kelimeleri ve 84:22 14. satırda. | Satır sırası bozuluyor | `build_content_db.dart` içindeki `_lineCorrections` ile **yalnızca satır numarası** 14'e düzeltildi. F0-05'te basılı nüshayla kontrol edilecek. |
| Q-5 | Sure başlığı ve besmele satırları API'de yok (kelimesi olmayan satırlar). | Satır türü çıkarım gerektiriyor | Kural: surenin ilk satırının üstündeki 2 satır (Fatiha ve Tevbe'de 1). Başlık sayfa başından önceye taşarsa önceki sayfanın son satırına düşer (ör. 76/15 Nisâ başlığı, 77/1 besmele). 604 sayfanın tamamında kurala uymayan boş satır yok; betik her üretimde bunu denetler. |
| Q-6 | Ortalı satır (`is_centered`) bilgisi yok. | Sayfa çiziminde gerekli (ilk iki sayfa ve bazı sure sonları) | F0-05'te QUL verisiyle veya kuralla çözülecek |
| Q-7 | **1405H baskısı (QCF V1, `mushaf=2`) dışarıda bırakıldı:** satır verisinde 8 sayfada (123, 144, 534, 586, 590, 591, 594, 595) kuralla açıklanamayan boş satırlar var. | İkinci Medine düzeni şimdilik yok | QUL verisiyle doğrulanınca eklenebilir |
| Q-8 | Meta veride 14 secde var (22:77 secde değil). Metinde ise **15 secde işareti (۩)** var, 22:77 dahil (Tanzil meta verisi de 15 sayar). 14 Hanefi sayısıdır; 22:77 Şafii'de secdedir. | M2-05: hangi listenin gösterileceği **fıkhi bir tercih**; kullanıcı / içerik kurulu kararı (AK-06) | Veri olduğu gibi saklandı; T-02 testi farkın yalnızca 22:77 olduğunu denetler. Mushaf sayfasında ۩ işareti zaten basılı metnin parçası olarak görünür. |
| Q-9 | Quran.com `text_uthmani` alanı Tanzil metninin aynısı, ancak 110 surenin 1. ayetinde besmele çıkarılırken başta bir **boşluk karakteri** kalmış. | Metin karşılaştırması ve gösterim | `build_content_db.dart` yalnızca bu baştaki boşluğu kırpar (`trimLeft`). Sonuçta 6.236 ayetin tamamı, Tanzil metninden besmele çıkarılmış haliyle karakteri karakterine aynıdır (T-01). |
| Q-10 | Tanzil'in sayfa verisi **1405H** baskısına aittir (Quran.com'un 1405H verisiyle birebir aynı). Bizim düzenimiz **1421H**: 25 sayfanın (121–123, 145, 532–534, 565, 568, 570, 576, 584, 586, 588–590, 592–600) ilk ayeti farklı. | T-02'nin bağımsız referansı yalnızca 579 sayfayı doğrulayabiliyor | 25 fark T-02 testinde tek tek listelendi; liste dışındaki her fark testi kırar. **Bu 25 sayfanın 1421H basılı nüshayla (veya QUL verisiyle) doğrulanması bekleniyor** (F0-05). |
| Q-11 | Tanzil meta verisi 106. rubu'u 15:50'de başlatıyor, ama Tanzil'in kendi metnindeki ۞ işareti 15:49'da. | Referansın kendi içinde çelişkisi | Bizim veri (15:49) metindeki işaretle uyumlu; T-02'de istisna olarak belgelendi. Diğer 239 rubu' ve 30 cüz başlangıcı Tanzil ile aynı. |

---

## 2. Tanzil (test referansı)

| Alan | Değer |
|---|---|
| Adres | https://tanzil.net |
| Lisans | Creative Commons Attribution 3.0. Metin **değiştirilmeden** kopyalanabilir; kaynak (Tanzil Project) açıkça belirtilmeli ve tanzil.net'e bağlantı verilmeli; telif notu korunmalı |
| İndirme | `fetch_sources.dart tanzil` → `quran_app/tool/content/sources/tanzil/` (28.10.2026) |
| Dosyalar | `quran-uthmani.txt`: Osmanlı yazımı, tüm işaretler (vakf, ۩, ۞), telif notu dosya sonunda. `quran-data.xml`: sure, cüz, rubu', sayfa (1405H), secde meta verisi |
| Saklama | Bayt bayt, değiştirilmeden (`.gitattributes` ile git satır sonu dönüşümü kapalı) |
| Kullanım | Yalnızca testlerde (`test/content/`). Uygulama paketine **girmez**. |

### Karşılaştırma sonuçları (28.10.2026)
- **Metin:** Quran.com `text_uthmani` Tanzil metniyle aynı kaynaktan geliyor. Tanzil'deki besmele çıkarılınca 6.236 ayetin **tamamı** karakteri karakterine aynı (Q-9 boşluğu kırpıldıktan sonra).
- **Cüz:** 30 başlangıcın hepsi aynı.
- **Rubu':** 240 başlangıcın 239'u aynı; tek fark Tanzil'in kendi çelişkisi (Q-11).
- **Secde:** metin işaretleri 15, Quran.com meta verisi 14 (Q-8).
- **Sayfa:** 604 sayfanın 579'u aynı; 25 fark 1405H/1421H baskı farkı (Q-10).

---

## 3. Bütünlük güvenceleri (F0-04)
| Ne | Nasıl korunuyor |
|---|---|
| `text_uthmani` (6.236 ayet) | T-01: Tanzil ile karakter karakter karşılaştırma |
| `text_qpc_hafs`, kelimeler, cüz/hizb/rubu'/secde, düzen satırları ve glifler | T-01: `tool/content/reference/checksums.json` içindeki sure başına SHA-256 değerleriyle karşılaştırma. Bu değerler veri bağımsız kontrollerden geçtikten sonra sabitlendi. |
| Sayfa, cüz, rubu', secde | T-02: Tanzil meta verisi ve metindeki ۞/۩ işaretleriyle |

Kaynak bilerek güncellenirse: `build_content_db.dart` → testler → farklar incelenir → `update_checksums.dart` → `checksums.json` farkı commit'te gözden geçirilir.

## 4. Lisans Kontrol Listesi (İÇ-10)

Her kaynak için doldurulur. ❓ olan maddeler yayından önce kapatılmalıdır.

| Madde | Quran.com API v4 | Tanzil |
|---|---|---|
| Hak sahibi belli mi? | ✅ Quran Foundation (API); KFGQPC (metin, fontlar) | ✅ Tanzil Project |
| Lisans metni var mı? | ❓ API kullanım koşulları incelenmedi | ✅ CC BY 3.0 |
| Ticari kullanıma izin var mı? | ❓ | ✅ |
| Uygulamaya gömülerek dağıtılabilir mi? | ❓ | ✅ (değiştirmeden) |
| Değişiklik izni | Gerekmiyor: metin değiştirilmiyor; tek düzen düzeltmesi (Q-4) belgelendi | ❌ Değiştirilemez |
| Atıf zorunluluğu ve metni | ❓ | ✅ "Tanzil Quran Text, Copyright (C) Tanzil Project" + bağlantı |
| "Hakkında" ekranında gösterilecek (İÇ-01) | Evet | Kullanılırsa evet |
| Yayın için uygun mu? | ❓ AK-11 | ✅ |
| Kontrol tarihi / kontrol eden | 28.10.2026 / geliştirme | 28.10.2026 / geliştirme |

---

## Değişiklik Geçmişi
| Tarih | Değişiklik |
|---|---|
| 28.10.2026 | İlk sürüm: Quran.com API v4 kaynağı, bilinen durumlar Q-1…Q-8, lisans kontrol listesi |
| 28.10.2026 | Tanzil test referansı olarak eklendi; karşılaştırma sonuçları; Q-8 güncellendi, Q-9…Q-11 eklendi; bütünlük güvenceleri bölümü |
