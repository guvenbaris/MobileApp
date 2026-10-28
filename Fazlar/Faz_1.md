# Faz 1: Okuyucu

> **Amaç:** Tam özellikli, **internetsiz** çalışan bir Kur'an okuma ve dinleme deneyimi: mushaf ve ayet görünümü, meal ve tefsir, kelime meali, arama ve gezinme, kesintisiz ses, yer imi, not ve birden fazla okuma ilerlemesi.
> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (M2, M3, M4, M5, M6, M13, M16; T-01…T-10), `Yol_Haritasi.md`, `Ekran_Tasarimi.md` (Faz 1 ekranları E-02…E-16), `VERI_KAYNAKLARI.md`, `CLAUDE.md`, `Faz_1_Notlar.md` (iş paketleri bittikçe yazılır)
> **Durum:** 🔨 Başladı (29.10.2026)

## Faz Sonu Çıktısı (Definition of Done)
- [ ] Uygulama alt sekmeli kabukla açılıyor (Bugün, Kur'an, Hafızlık*, Ben); son okunan yere **tek dokunuşla** dönülüyor (M6-05). *Hafızlık sekmesi Faz 2'de dolar.
- [ ] Okuma ekranı: sayfa ↔ ayet görünümü, çubukları gizleme, ekranı açık tutma, sayfa okları, cüz/hizb/sayfa göstergeleri, döndürmede konum korunması; **T-09 geçiyor**.
- [ ] En az **bir Türkçe meal** ve **kelime meali** uygulamayla geliyor (M16-01); ek meal/tefsir indirilebiliyor; meal–ayet eşleşmesi **T-03** ile doğrulanıyor.
- [ ] Arapça (harekesiz de), meal ve `2:255` biçiminde arama internetsiz ≤ 500 ms (NF-PF03).
- [ ] Ses: kari seçimi, **gapless**, hız, ayet/aralık tekrarı, otomatik ilerleme, vurgulama, arka planda ve kilit ekranında çalma, toplu indirme; **T-06 geçiyor**.
- [ ] Yer imi (klasörlü), not, vurgu ve birden fazla okuma ilerlemesi kullanıcı veritabanında; migration testiyle (**T-04**) korunuyor.
- [ ] Uçak modunda tüm çekirdek akışlar çalışıyor (**T-08**); erişilebilirlik taraması geçiyor (**T-10**).
- [ ] Türkiye mushaf düzeni için kaynak ve lisans durumu netleşti (AK-11). Veri varsa düzen eklendi; yoksa yol ve tarih belli.
- [ ] Gerçek orta segment Android cihazda soğuk açılış ≤ 2 sn ve sayfa geçişi ≤ 100 ms ölçüldü (NF-PF01, NF-PF02).

## Faz 1 Başlangıç Kararları
Aşağıdakiler varsayılan önerilerdir; itiraz yoksa bu şekilde uygulanır. Lisansı belirsiz kaynaklar **yalnızca geliştirmede** kullanılır (İÇ-10). Mimari kaynaktan bağımsız kalır; lisanslı kaynak gelince yalnızca veri değişir.

| # | Konu | Öneri | Not |
|---|---|---|---|
| S1 | Geliştirme meali (TR) ve yayın meali | Geliştirmede Quran.com/QUL'deki **Diyanet İşleri** meali. **Yayın için iki yol paralel yürür:** (a) Diyanet'ten yazılı izin istenir; (b) telif süresi dolmuş bir meal yedek olarak hazırlanır (S2). | Meal bir telif eseridir: kaynağı yazmak (atıf) **izin yerine geçmez** (`Faz_1_Notlar.md` §1.2). Varsayılan meal uygulamayla geleceği için (M16-01) karar **Faz 1 sonuna kadar** verilmeli. |
| S2 | Ek mealler ve kamu malı adayları | Telif süresi dolmuş olabilecek mealler: TR **Elmalılı Hamdi Yazır** (ö. 1942) ve **Ömer Rıza Doğrul** (ö. 1952) **özgün** metinleri; EN **Pickthall** (ö. 1936) ve **Yusuf Ali** (ö. 1953, 1934 özgün metni). Sadeleştirilmiş/yeniden düzenlenmiş baskılar **ayrı eserdir**, kullanılmaz. | Her biri için dijital kaynağın gerçekten özgün metni verdiği ve kaynağın kendi koşulları kontrol edilir; hukuk danışmanı onayı (AK-09). Yazar, kaynak, sürüm bilgi ekranında (M3-07). Saheeh International gibi telifli mealler izinsiz eklenmez. |
| S3 | Kelime meali (TR, EN) | QUL'deki kelime meali verileri (aday); KFGQPC kelime bölünmesine otomatik eşleme. | Kelime sınırı farkları Q-12'de belli; eşleme orada test edilir. |
| S4 | Kök ve morfoloji (M3-04, M4-04) | **Kaynak lisansı önce kontrol edilir.** Quranic Arabic Corpus verisinin GPL lisanslı olduğu biliniyor (doğrulanacak); uygulamaya gömülmesi uygun olmayabilir. Alternatif: QUL kök verisi. | [Ö] öncelikli; lisans çözülmezse Faz 1'den çıkar. |
| S5 | Tefsir | Geliştirmede 1 TR + 1 AR + 1 EN tefsir, **indirilebilir** paket. Uygulamayla gelmez (boyut). | T-03: tefsir doğru ayete bağlı. |
| S6 | Ses kaynağı | **Sure bazlı ses + ayet zaman damgaları** (QUL "segments" verisi). Gapless ve vurgulama için bu biçim gerekir. Geliştirmede 2–3 kari. | Yayın için ≥ 10 lisanslı kari, Türk hafızlar dahil (M5-01, İÇ-05, AK-05). |
| S7 | Türkiye mushaf düzeni (M2-02 [Z]) | **Araştırma iş paketi (F1-03).** Diyanet'in dijital mushafı ve açık veri aranır. Veri bulunamazsa düzen verisi üretimi ayrı bir iş olarak planlanır. | Lisans AK-11. Bu madde v1.0 yayınını bloklayabilir; riskler tablosunda. |
| S8 | Uygulama kabuğu | 4 alt sekme: **Bugün · Kur'an · Hafızlık · Ben**; v1.1'de **Dersler** eklenir. | Ayrıntı: `Ekran_Tasarimi.md` §3. |
| S9 | `ayahs.text_uthmani` (Tanzil kökenli) | ✅ **Uygulandı (29.10.2026, kullanıcı onayı):** alan kaldırıldı (içerik sürümü 7, 13,9 MB). Tanzil tek dış test referansı; T-01 harf iskeletini Tanzil ile karşılaştırır. Arama (F1-08) KFGQPC metninin harekesiz biçiminden üretilir. | Uygulamada Tanzil yükümlülüğü ve besmele sorusu kapandı. Ayrıntı: `Faz_1_Notlar.md` §1. |

## Teknik Kararlar (Faz 1'de verilir)
| # | Konu | Öneri | Gerekçe |
|---|---|---|---|
| TK-11 | Ses çalma | `just_audio` + `audio_service` | Gapless (tek dosya içinde ayet aralığı veya birleştirilmiş kaynak), hız, arka plan, kilit ekranı, kulaklık tuşları. Pub sürümü ve lisansı eklemeden önce kontrol edilir (VERI_KAYNAKLARI §7). |
| TK-12 | Arama | İçerik veritabanında **SQLite FTS5** tabloları (harekesiz Arapça, her meal için ayrı) | Çevrimdışı, ≤ 500 ms. Paketlenen SQLite'ta FTS5'in açık olduğu F1-08'in ilk işinde doğrulanır. |
| TK-13 | İndirilebilir içerik paketleri | Paket = sürümlü SQLite (meal, tefsir) veya klasör (ses) + manifest. Kurulu paketler kullanıcı veritabanında listelenir; içerik veritabanı salt okunur kalır (MK-05). | M16-02, M5-09, M5-10; düzen paketleri (M2-14) aynı altyapıyı kullanır. |
| TK-14 | İndirme | Arka planda indirme kütüphanesi (ör. `background_downloader`); duraklatma/iptal, kaldığı yerden devam, indirme yeri seçimi (Android SD). | M5-09. Güncellemede indirilenler silinmez (M5-10, T-04). |
| TK-15 | Ekranı açık tutma | `wakelock_plus` | M2-12 |
| TK-16 | Kabuk ve derin bağlantı | go_router `StatefulShellRoute` (sekmeler kendi geçmişini tutar); `/read?ayah=2:255` derin bağlantısı | M4-07, ayet paylaşımı (M6-07) |
| TK-17 | Paylaşım görseli | Ayet kartı widget'ı `RepaintBoundary` ile görsele çevrilir; `share_plus` ile paylaşılır | M6-07; sade şablon, reklam/marka abartısı yok |

---

## İş Paketleri

Öncelik: **[Z]** zorunlu, **[Ö]** önemli, **[İ]** isteğe bağlı. Her paket bitince kutusu işaretlenir ve `Faz_1_Notlar.md`'ye bölüm yazılır.

### F1-00 Faz 0'dan Devredilenler [Z]
Faz 0 kullanıcı kararıyla kapandı (29.10.2026); aşağıdakiler bu faza taşındı (Yol Haritası, faz geçiş kuralı 2).
- [ ] iOS: `ios.yml`'ın GitHub'da ilk çalıştırılması ve simülatörde açılış (F0-01)
- [ ] CI: bilerek bozulan bir PR'ın kırmızıya düştüğünün görülmesi (F0-09)
- [ ] F0-05 sonuç raporu: seçilen yöntem, sorunlar, Türkiye düzeni için uygulanabilirlik (F1-03 ile birlikte)
- [ ] Gerçek cihazda performans ölçümü (NF-PF01, NF-PF02) ve 7 sayfanın basılı nüshayla karşılaştırılması (ertelenmişti)
- [ ] TalkBack ile elle kontrol (F0-11; adımlar Faz_0_Notlar §13.3)
- [ ] Arapça arayüz çevirilerinin anadili Arapça biri tarafından gözden geçirilmesi (yayın öncesi; metinler bu fazda çoğalacak)

### F1-01 Uygulama Kabuğu ve Gezinme [Z] — M4-01, M4-07, M6-05
- [ ] Alt sekmeli kabuk (S8, TK-16); her sekme kendi geçmişini korur; Arapçada sekme sırası sağdan sola
- [ ] **Bugün** ekranının Faz 1 sürümü: "Okumaya devam et" kartı (birden fazla ilerleme varsa her biri), son dinlenen, günün ayeti (E-02)
- [ ] **Kur'an** dizini: Sure / Cüz / Sayfa sekmeleri, `2:255` ve sayfa numarasıyla atlama (E-03)
- [ ] **Git** paneli: okuma ekranından çıkmadan sure, cüz, sayfa, ayet seçimi (M4-07)
- [ ] Derin bağlantı `/read?ayah=s:a`; geçersiz bağlantıda hata durumu
- **Bitti:** Uygulama açılışından son okunan ayete tek dokunuş; okuma ekranından ana menüye dönmeden herhangi bir ayete gidilebiliyor.

### F1-02 Okuma Ekranı [Z] — M2-01, M2-03, M2-04, M2-05, M2-07, M2-09…M2-13
- [ ] Çubukların dokununca gizlenip gösterilmesi; ekranı kendiliğinden kapatmaz (M2-13)
- [ ] Okurken ekran kapanmaz, ayarlanabilir (M2-12, TK-15)
- [ ] Sayfa okları (isteğe bağlı) + kaydırma; kenar hareketleri sistemin geri hareketiyle çakışmaz (M2-09)
- [ ] Cüz, hizb, sayfa ve sağ/sol sayfa göstergesi her zaman görünür (M2-04); secde ve rubu'/hizb işaretleri (M2-05)
- [ ] Yazı boyutu kilidi; sayfa görünümünde yakınlaştırma (M2-07)
- [ ] Kontrollü otomatik kaydırma, hız ayarlı, sayfa görünümünde de (M2-11) [Ö]
- [ ] Okuma ayarları paneli (E-10): görünüm, tema, yazı, düzen, tecvid, ekran açık
- [ ] T-09: döndürme ve çoklu pencere testleri (KK M2-10: Bakara 150)
- **Bitti:** Okuma ekranı E-04/E-05 tasarımına uygun; T-09 geçiyor.

### F1-03 Mushaf Düzenleri [Z] — M2-02, M2-14, AK-11
- [ ] **Türkiye mushaf düzeni araştırması:** kaynak, satır/sayfa yapısı, lisans; sonuç raporu (F0-05 raporuyla birlikte)
- [ ] Düzen seçme ayarı; düzen değişince aynı ayette kalma (KK M2-15: Kehf 45)
- [ ] İndirilebilir düzen paketi altyapısı (TK-13); T-02 her düzen için
- [ ] Türkiye düzeni verisi (kaynak bulunursa) [Z]; IndoPak 15 satır [Ö]
- **Bitti:** İkinci bir düzen eklenip seçilebiliyor ve tüm kayıtlar aynı ayette kalıyor; ya da Türkiye düzeni için yol ve tarih belli.

### F1-04 Renkli Tecvid [Ö] — M2-06
- [ ] Spike: DigitalKhatt ile tecvid renklendirme verisi (QUL tecvid verisi) ve lisansı
- [ ] Aç/kapat; renge dokununca kural açıklaması (TR/AR/EN)
- [ ] Renkler üç temada kontrast testinden geçer
- **Bitti:** Tecvid açıkken renkler metni bozmadan gösteriliyor (T-01 yine geçiyor).

### F1-05 Meal [Z] — M3-01, M3-02, M3-06, M3-07, M3-09, T-03
- [ ] Meal verisi şeması ve hattı (paketli varsayılan meal + indirilebilir mealler, TK-13)
- [ ] Kamu malı yedek meal (S2): kaynağın özgün metni verdiğinin doğrulanması, veriye alınması, okunabilirlik değerlendirmesi. Yayın meali kararı Faz 1 sonunda verilir (kullanıcı, 29.10.2026)
- [ ] Ayet görünümünde meal; en fazla 3 meal yan yana/alt alta (M3-02) [Ö]
- [ ] Sayfa görünümünde ayete uzun basınca meal paneli (E-08)
- [ ] Meal seçimi kalıcı (M3-06); her mealin yazar/kaynak/sürüm bilgisi (M3-07)
- [ ] T-03: her ayete doğru meal bağlı (ayet sayısı, sure sınırları, örnek ayetlerin sağlaması)
- [ ] M3-09: özel isimlerin İslami formu, seçilen mealde örnek kontrol listesiyle
- **Bitti:** Varsayılan meal internetsiz geliyor; ikinci meal indirilip seçilebiliyor; T-03 geçiyor.

### F1-06 Kelime Meali ve Kelime Kartı [Z] — M3-03, M3-04, M5-11
- [ ] Kelime meali verisi (TR, EN) ve KFGQPC kelimelerine eşleme (S3); farklı bölünen 7 yer testle
- [ ] Mushafta kelimeye dokununca **kelime kartı** (E-07): anlam, okunuş, (varsa) kök
- [ ] Kök ve kökün tüm geçişleri (M3-04) [Ö], S4 lisansına bağlı
- [ ] Kelime telaffuzu (M5-11) [Ö], F1-09'a bağlı
- **Bitti:** Sayfa görünümünde herhangi bir kelimeye dokununca anlamı açılıyor (F0-05'teki kelime kimliği altyapısı üzerine).

### F1-07 Tefsir [Z] — M3-05, M3-07, T-03
- [ ] İndirilebilir tefsir paketi (S5); ayet bazında açılır, birden fazla ayeti kapsayan tefsir aralığı doğru gösterilir
- [ ] T-03: tefsir doğru ayete bağlı (Al Quran'daki kayma şikâyeti)
- [ ] Kaynak bilgisi (M3-07)
- **Bitti:** Tefsir indirildikten sonra internetsiz açılıyor; T-03 geçiyor.

### F1-08 Arama [Z] — M4-02…M4-06, NF-PF03
- [ ] FTS5 doğrulaması (TK-12); harekesiz Arapça arama dizini KFGQPC metninden (S9 ✅: `text_uthmani` kaldırıldı)
- [ ] Meal içinde arama; kaynak filtresi kalıcı (M4-03)
- [ ] Kök ile arama [Ö] (S4)
- [ ] Arama ekranı (E-11): son aramalar, sonuç vurgusu, `2:255`/sayfa algılama
- [ ] Konu dizini [İ] (M4-05)
- [ ] Performans testi: tüm Kur'an'da arama ≤ 500 ms
- **Bitti:** "رحمن", "rahman" (meal) ve `2:255` aramaları internetsiz ve hedef sürede sonuç veriyor.

### F1-09 Ses [Z] — M5-01…M5-10, M5-14, T-06
- [ ] Ses çalma altyapısı (TK-11) ve kari kataloğu (S6)
- [ ] **Gapless** çalma; vasıllı geçişler kesilmez (M5-02)
- [ ] Hız 0.5x–2.0x (0.25 adım) (M5-03); ayet/aralık tekrarı N kez veya sonsuz, **eksiksiz** (M5-04)
- [ ] Sonraki ayete ve sureye otomatik geçiş (M5-05); çalınan ayet vurgulanır ve sayfa ilerler (M5-06)
- [ ] Arka plan, kilit ekranı, bildirim kontrolleri, kulaklık tuşları (M5-07); kaldığı yerden devam (M5-08)
- [ ] Toplu indirme (sure/cüz/tamamı), indirme yeri, indirme yöneticisi (M5-09, E-13); güncellemede silinmez (M5-10)
- [ ] Uyku zamanlayıcısı (M5-14) [Ö]
- [ ] Mini oynatıcı + tam oynatıcı (E-09)
- [ ] T-06: tekrar sayısı, gapless geçiş, duraklat/devam testleri
- **Bitti:** İndirilmiş bir surede ses ≤ 300 ms başlıyor (NF-PF04), 3 kez tekrar tam 3 kez çalıyor, ekran kapalıyken çalmaya devam ediyor.

### F1-10 Yer İmi, Not, Vurgu ve Okuma İlerlemeleri [Z] — M6-01…M6-08, T-04
- [ ] Kullanıcı veritabanı v3: yer imi (klasör), not, vurgu, okuma ilerlemesi tabloları; konum `sure:ayet(:kelime)` (M2-15)
- [ ] Migration v2→v3 + veri koruma testi (T-04); 1.000 kayıtta liste ≤ 300 ms (NF-PF08)
- [ ] Ayet eylem paneli (E-06): yer imi, not, vurgu, kopyala, paylaş, dinle, tekrar, meal/tefsir
- [ ] Birden fazla okuma ilerlemesi (Hatim, Ezber, Ramazan…), her biri kendi son okunanıyla (M6-04, E-16)
- [ ] "Tamamlandı" işaretini geri alma (M6-06)
- [ ] Kayıtlarım ekranı (E-12): klasörler, toplu silme, notlarda arama, kısa özet görünümü (M6-08)
- [ ] Ayet paylaşımı: metin ve sade görsel (M6-07, TK-17) [Ö]
- **Bitti:** KK M6-05 (Hac 35) ve KK M1-05'in yerel kısmı (10 yer imi yeniden açılışta) testle doğrulandı.

### F1-11 İndirmeler ve Çevrimdışı [Z] — M16-02, M16-03, M16-04, T-08
- [ ] Paket yöneticisi (TK-13): meal, tefsir, ses, düzen; sürüm ve boyut bilgisi, silme
- [ ] Bağlantı yoksa işlemler sıraya alınır; "ağ yok" ile "sunucu hatası" ayrı mesajlar (M16-03, M16-04)
- [ ] T-08: uçak modunda çekirdek akışlar (okuma, meal, arama, indirilmiş ses, yer imi)
- **Bitti:** Uçak modunda T-08 senaryolarının hepsi geçiyor.

### F1-12 Hakkında ve Kaynaklar [Z] — İÇ-01, M3-07
- [ ] Hakkında ekranı (E-15): Kur'an metni kaynağı ve sürümü, mushaf düzeni, font, meal/tefsir/kari kaynakları
- [x] ~~Tanzil için tıklanabilir tanzil.net bağlantısı~~: gerekmiyor, Tanzil metni uygulamaya girmiyor (S9)
- [ ] Lisans sayfası bağlantısı
- **Bitti:** Uygulamadaki her içerik kaynağının adı, sürümü ve lisansı uygulama içinden görülebiliyor.

### F1-13 Ayarlar ve Erişilebilirlik [Z] — M13-02…M13-05, T-05, T-10
- [ ] Ayarlar ekranının bölümlenmesi (E-14): Okuma, Meal ve Tefsir, Ses, İndirmeler, Görünüm, Dil, Hakkında
- [ ] Sistem yazı boyutuna uyum, çok büyük boyutlarda taşma yok; yüksek kontrast teması (M13-04)
- [ ] Ekran okuyucuyla **ayet ayet okuma**: ayet görünümünde ayet + meal tek düğüm; sayfa görünümünde ayet bazında gezinme (M13-03)
- [ ] Sağ/sol el için kontrol konumu (M13-05) [İ]
- [ ] T-05 (tüm yeni ayarlar) ve T-10 (erişilebilirlik taraması) genişletilir
- **Bitti:** TalkBack ile bir sure baştan sona ayet ayet dinlenebiliyor; tüm ayarlar yeniden açılışta korunuyor.

### F1-14 Faz 1 Kalite Kapısı [Z] — 12. bölüm
- [ ] T-01…T-10'dan Faz 1'e düşenler otomatik çalışıyor (T-07 Faz 4)
- [ ] Gerçek cihazda performans: soğuk açılış, sayfa geçişi, arama, ses başlatma, pil (NF-PF01…PF05, PF07)
- [ ] Uygulama boyutu ≤ 60 MB (NF-PF06), paketli meal ve kelime meali dahil
- [ ] Yasak listesi (7. bölüm) ve ilkeler (3. bölüm) ile uyum kontrolü (faz geçiş kuralı 3)
- [ ] `VERI_KAYNAKLARI.md`: yeni kaynakların hepsi dosya tablosunda ve kontrol listesinde
- **Bitti:** Kontrol listesi tamamlandı; ölçümler hedefte veya sapmalar gerekçesiyle kayıtlı.

---

## Riskler
| Risk | Etki | Önlem |
|---|---|---|
| Türkiye mushaf düzeni için dijital veri veya lisans yok | M2-02 [Z] karşılanamaz, v1.0 gecikir | F1-03 ilk iş olarak başlar; Diyanet ile görüşme (AK-11) paralel yürür; gerekirse düzen verisi üretimi ayrı iş paketi olur |
| Varsayılan meal (Diyanet) için yayın izni gecikir veya alınamaz | M16-01 gereği paketlenecek meal belirsiz | İzin başvurusu Faz 1'in başında yapılır; mimari meal kaynağından bağımsız; S2'deki kamu malı adayı yedek olarak hazırlanır |
| Kari seslerinin lisansı ve boyutu | M5-01 (≥ 10 kari) karşılanamaz | Sesler uygulamaya gömülmez, indirilir; kari başına izin süreci erkenden başlar (İÇ-05) |
| Kök/morfoloji verisinin lisansı (GPL olasılığı) | M3-04, M4-04 [Ö] düşer | S4: önce lisans; uygun değilse kapsamdan çıkar |
| Gapless çalmanın iki platformda farklı davranması | M5-02 [Z] | Sure bazlı dosya + zaman damgası; T-06 iki platformda; iOS testi CI'da |
| Paketli içerikle uygulama boyutunun büyümesi | NF-PF06 (≤ 60 MB) | Yalnızca varsayılan meal ve kelime meali paketli; diğerleri indirilir; F1-14'te ölçülür |
| DigitalKhatt ile tecvid renklendirme verisinin uyuşmaması | M2-06 [Ö] | F1-04 önce spike; olmazsa Faz 2'ye kayar |

## Kapsam Dışı (Faz 1)
- Hafızlık araçları, alışkanlık/seri, zikir, bildirimler (Faz 2). Hafızlık sekmesi Faz 1'de "yakında" boş durumuyla görünür.
- Metin hatası bildirimi ve destek (M14; yerel kısmı Faz 2, sunucu Faz 3). Ayet eylem panelinde yeri ayrılır.
- Hesap ve senkron (Faz 3), dersler ve abonelik (Faz 4).
- Çalma listesi (M5-13, v1.2), meal sesli okuması (M5-12) [İ], transliterasyon (M3-08) [İ].

## Değişiklik Geçmişi
| Tarih | Değişiklik |
|---|---|
| 29.10.2026 | S9 uygulandı (`text_uthmani` kaldırıldı, içerik sürümü 7); S1/S2 meal lisansı yolları netleştirildi (atıf izin yerine geçmez; izin + kamu malı yedek) |
| 29.10.2026 | İlk sürüm: Faz 0 kullanıcı kararıyla kapandı, açık kalanlar F1-00'a devredildi; ekran tasarımı `Ekran_Tasarimi.md` ile birlikte planlandı |
