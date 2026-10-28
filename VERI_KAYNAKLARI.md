# Veri Kaynakları ve Lisans Envanteri

> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (8. İçerik: İÇ-01, İÇ-03, İÇ-10; AK-05, AK-11), `Fazlar/Faz_0.md` (F0-03)
> **Kural (İÇ-10):** Yeni bir içerik kaynağı eklenmeden önce aşağıdaki lisans kontrol listesi doldurulur. Yayın için uygun olmayan kaynak yalnızca geliştirmede kullanılabilir.
> **Son güncelleme:** 28.10.2026

## Özet

| Kaynak | Ne için | Durum | Yayın için uygun mu |
|---|---|---|---|
| Quran.com API v4 | Ayet metni, kelimeler, sure meta verisi, Medine 1421H sayfa/satır düzeni, QCF V2 glif kodları | ✅ Geliştirmede kullanılıyor | ❓ **Belirsiz**: AK-11 ile çözülecek |
| Tanzil | T-01 için bağımsız referans metin (planlanan, F0-04) | ⬜ Henüz eklenmedi | ✅ CC BY 3.0 (değiştirmeden, atıfla) |
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
| Q-8 | Secde sayısı 14 (22:77 secde olarak işaretli değil). Hanefi mezhebinde 14 secde vardır; bazı Medine baskıları 15 işaret taşır. | M2-05 gösterimi | F0-04'te basılı nüshayla teyit edilecek |

---

## 2. Tanzil (planlanan)

| Alan | Değer |
|---|---|
| Adres | https://tanzil.net |
| Lisans | Creative Commons Attribution 3.0. Metin **değiştirilmeden** kopyalanabilir; kaynak (Tanzil Project) açıkça belirtilmeli ve tanzil.net'e bağlantı verilmeli; telif notu korunmalı |
| Kullanım planı | F0-04 T-01: Quran.com metninden bağımsız ikinci referans olarak |

---

## 3. Lisans Kontrol Listesi (İÇ-10)

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
