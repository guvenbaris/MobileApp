# Proje Gereksinimleri Dokümanı

| Alan | Değer |
|---|---|
| Proje | `[Uygulama Adı]` (çalışma adı). Kur'an okuma, hafızlık ve günlük İslami eğitim uygulaması |
| Doküman sürümü | 1.5 (taslak) |
| Teknoloji | Flutter (Android 7.0+ / iOS 15+); sunucu v1.0 betasından önce hazır olacak (AK-03) |
| Tarih | 28.10.2026 |
| Dayanak | `Kuran_Uygulamasi_Yorum_Analizi.md` (4 rakip uygulama, ~232 bin kullanıcı yorumu) |
| Durum | Kapsam dondurulmaya hazır. Değişiklikler 15. bölümdeki süreçle yapılır. |

> **Bu dokümanın amacı:** Projenin sınırlarını çizmek. Burada yazmayan bir özellik kapsam dışıdır. Burada "YASAK" olarak işaretlenen bir uygulama, hiçbir sürümde ve hiçbir gerekçeyle yapılmaz. Küçük değişiklikler 15. bölümdeki süreçle eklenebilir.

---

## İçindekiler
1. Vizyon ve Hedef
2. Hedef Kitle
3. Ürün İlkeleri (Değişmez Kurallar)
4. Kapsam ve Sürümler
5. Kapsam Dışı
6. Fonksiyonel Gereksinimler (Modüller)
7. Yasaklar (Kesinlikle Yapılmayacaklar)
8. İçerik, Kaynak ve Lisans Gereksinimleri
9. Fonksiyonel Olmayan Gereksinimler
10. Gizlilik, Güvenlik ve Hukuki Uyum
11. Veri Modeli (Ana Varlıklar)
12. Kalite, Test ve Yayın Süreci
13. Başarı Ölçütleri (KPI)
14. Açık Kararlar
15. Değişiklik Yönetimi
16. Sözlük

---

## 1. Vizyon ve Hedef

**Vizyon:** Kur'an'ı okumayı, anlamayı ve ezberlemeyi **ücretsiz, reklamsız ve internetsiz** sunan; geliri yalnızca isteğe bağlı, şeffaf ve kaliteli **eğitim içeriğinden** elde eden güvenilir bir uygulama.

**Konumlandırma:** Al Quran'ın cömertliği + Quranly'nin alışkanlık motoru + yapay zekâsız hafızlık araçları (ücretsiz) + AyahPath tarzı günlük dersler (ücretli).

**Ürün hedefleri**
| # | Hedef |
|---|---|
| H1 | Kategorideki en güvenilir uygulama olmak: metin doğruluğu, veri kaybı yok, şeffaf ödeme |
| H2 | Kullanıcının günlük Kur'an alışkanlığını sürdürmesini sağlamak |
| H3 | Hafızlık yapanlara ücretsiz, internetsiz bir çalışma aracı sunmak |
| H4 | Sürdürülebilir gelir için ücretli eğitim aboneliğini doğrulamak |
| H5 | Türkçe pazarda birinci tercih olmak, ardından AR/EN pazarlarına açılmak |

---

## 2. Hedef Kitle

| Persona | Tanım | Ana ihtiyaç | Kullandığı modüller |
|---|---|---|---|
| **P1: Düzenli okuyucu** | Her gün biraz okumak isteyen, meal ile anlamaya çalışan yetişkin | Kaldığı yerden devam, meal, hatırlatıcı, seri | Okuma, Meal, Alışkanlık |
| **P2: Hafız / hafızlık öğrencisi** | Ezber yapan veya ezberini koruyan, sayfa düzenine hassas kullanıcı | Doğru mushaf düzeni, ayet gizleme, tekrar planı, kayıt | Okuma, Hafızlık, Ses |
| **P3: Yeni başlayan / öğrenen** | Dini bilgisini artırmak isteyen veya yeni Müslüman | Sade ve yapılandırılmış dersler, Türkçe anlatım | Eğitim, Okuma |
| **P4: Dinleyici** | Daha çok dinleyen, belirli sure/zikir listeleri olan kullanıcı | Kari seçimi, çalma listesi, arka planda çalma | Ses, Zikir |

**Yaş sınırı:** Bkz. Açık Karar AK-07.
**Dil önceliği:** 1) Türkçe, 2) Arapça (RTL), 3) İngilizce.

---

## 3. Ürün İlkeleri (Değişmez Kurallar)

Bu ilkeler her özellik kararında test olarak kullanılır. Bir özellik bu ilkelerden biriyle çelişiyorsa yapılmaz.

| # | İlke |
|---|---|
| İ1 | **Kur'an'a erişim her zaman ücretsizdir:** okuma, dinleme, meal, tefsir ve kelime meali. |
| İ2 | **Reklam yoktur.** Üçüncü parti reklam SDK'sı uygulamaya hiç eklenmez. |
| İ3 | **Hafızlık araçları ücretsizdir.** |
| İ4 | **Gelir yalnızca eğitim içeriğinden** gelir: ders aboneliği, tek seferlik ödeme ve bağış/sponsorluk. |
| İ5 | **Ödeme şeffaftır:** sadece resmi mağaza ödemesi, yenilemeden önce hatırlatma, tek dokunuşla iptal. |
| İ6 | **Kullanıcı verisi kutsaldır:** yer imi, not, seri ve ilerleme hiçbir güncellemede kaybolmaz. |
| İ7 | **Metin doğruluğu tartışılmaz:** Kur'an metni yalnızca onaylı kaynaktan alınır ve değiştirilmez. |
| İ8 | **Çekirdek deneyim internetsiz çalışır.** |
| İ9 | **Saygılı dil ve tasarım:** suçlama, korkutma, dini vicdanla satış ve abartılı oyunlaştırma yoktur. |
| İ10 | **Tarafsızlık:** Tartışmalı meal veya tefsir varsayılan olarak dayatılmaz; seçim kullanıcıya bırakılır. |

---

## 4. Kapsam ve Sürümler

| Sürüm | İçerik | Modüller | Hedef |
|---|---|---|---|
| **v1.0 (MVP)** | Güvenilir okuyucu + alışkanlık + hafızlık araçları + **hesap ve senkron** | M1–M8, M10, M12–M14, M16 | Ücretsiz çekirdeği piyasaya çıkarmak ve kullanıcı tabanı oluşturmak |
| **v1.1** | Ücretli günlük eğitim | M9, M11, M15 | Gelir modelini doğrulamak |
| **v1.2** | İyileştirmeler | Çalma listesi, Warş/Kalûn, hafız-hoca modu, ek ders yolları | Bağlılık ve genişleme |
| **v2.0 (opsiyonel)** | Genişleme | Namaz vakti/kıble, aile grupları, yapay zekâ değerlendirmesi | 14. bölümdeki açık kararlara bağlı |

> **Sunucu:** Mobil uygulama sunucu olmadan geliştirilir (9.7 Mimari Kısıtlar); sunucuya bağlı servisler sahte (mock) uygulamalarla çalışır. Veri modeli geliştirme boyunca değişeceği için sunucu, **veri modeli dondurulduktan sonra** (v1.0 özellikleri tamamlanınca, test sürecinin başında) yazılır ve bağlanır. Böylece değişiklikler iki yerde birden yapılmaz. Sunucu (hesap, senkron, hata bildirimi, destek) **v1.0 kapalı betasından önce** hazır olur; v1.0 sunucu olmadan yayınlanmaz.
>
> **Kilometre taşı – Veri Modeli Dondurma:** v1.0 özellikleri tamamlanınca kullanıcı veri modeli ve API sözleşmesi (`API_Sozlesmesi.md`) dondurulur. Bu noktadan sonraki şema değişiklikleri migration ile, hem mobilde hem sunucuda birlikte yapılır.

> **Not:** Ders içeriğinin üretimi v1.0 geliştirmesiyle **paralel** başlar. v1.1 yayınlandığında en az **2 ders yolu × 30 ders** hazır olmalıdır.

**Öncelik etiketleri (MoSCoW):** **[Z]** Zorunlu, sürüm bu olmadan çıkmaz. **[Ö]** Önemli, mümkünse aynı sürümde. **[İ]** İsteğe bağlı, zaman kalırsa.

---

## 5. Kapsam Dışı

Aşağıdakiler bu projede **yapılmaz**. Gerekirse 15. bölümdeki süreçle yeniden değerlendirilir.

| # | Kapsam dışı | Gerekçe |
|---|---|---|
| KD-01 | **Yapay zekâ ile tilavet tanıma / hata tespiti** | Maliyet, doğruluk ve itibar riski (Tarteel analizi). En erken v2.0'da değerlendirilir. |
| KD-02 | **Sesle zikir sayma** | Ses tanıma gerektirir; KD-01 ile birlikte değerlendirilir. |
| KD-03 | Sosyal akış, yorum, beğeni, herkese açık profil | Moderasyon yükü, kapsam dağılması |
| KD-04 | Herkese açık sıralama tablosu (leaderboard) | Riyaya teşvik ve rekabet baskısı; İ9 |
| KD-05 | Fetva / soru-cevap hizmeti, canlı hoca görüşmesi | Hukuki ve dini sorumluluk |
| KD-06 | Hadis külliyatı, dua kitabı gibi Kur'an dışı geniş içerik kütüphaneleri | Kapsam; yalnızca derslerde gerektiği kadar kullanılır |
| KD-07 | Fiziksel ürün satışı (basılı mushaf vb.) | Kapsam; Quranly'nin "ödedim, ürün gelmedi" şikâyetleri |
| KD-08 | Web üzerinden abonelik satışı | İ5 ve mağaza politikaları |
| KD-09 | Akıllı saat uygulaması | v2.0 sonrası |
| KD-10 | Namaz vakti, kıble, ezan | v2.0'da opsiyonel modül olarak değerlendirilir |
| KD-11 | Kıraat-i aşere / tüm rivayetler | v1.x'te yalnızca Hafs; Warş ve Kalûn v1.2 |
| KD-12 | Çocuk modu, çocuk profilleri, ebeveyn kontrolü | v1.x 13+ yaş sınırıyla yayınlanır (AK-07); v2.0'da değerlendirilir |

---

## 6. Fonksiyonel Gereksinimler

Her gereksinimin bir kodu ve önceliği vardır. Kabul kriteri (KK) verilenler test senaryosuna dönüştürülür.

### M1. Hesap, Karşılama Akışı ve Senkronizasyon
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M1-01 | Uygulama **hesapsız** kullanılabilir; okuma, dinleme ve hafızlık için giriş zorunlu değildir. | [Z] |
| M1-02 | İsteğe bağlı hesap: e-posta + şifre, Google ile giriş, Apple ile giriş. | [Z] |
| M1-03 | Kullanıcı hangi yöntemle kaydolmuş olursa olsun hesabına başka yöntem ekleyebilir veya şifre belirleyebilir (Tarteel'in giriş sorunu). | [Ö] |
| M1-04 | Şifre sıfırlama e-postası 2 dakika içinde ulaşır; ulaşmazsa uygulama içinde yeniden gönderme ve destek yönlendirmesi olur. | [Z] |
| M1-05 | Hesapsız kullanıcıların yerel verisi, hesap açıldığında hesaba **birleştirilir**, silinmez. | [Z] |
| M1-06 | Yer imi, not, pin, seri, plan, hafızlık durumu, ders ilerlemesi ve ayarlar cihazlar arasında senkronlanır. | [Z] |
| M1-07 | Senkron çakışmasında veri silinmez; birleştirme kuralı uygulanır (bkz. 11. bölüm). | [Z] |
| M1-08 | **Yerel yedek:** tüm kullanıcı verisi dosyaya dışa aktarılabilir ve geri yüklenebilir (JSON). | [Z] |
| M1-09 | Karşılama akışı en fazla 4 ekrandır (dil, okuma hedefi, meal seçimi, bildirim izni). Ödeme ekranı bu akışta **yer almaz**. | [Z] |
| M1-10 | Hesap silme uygulama içinden yapılabilir; tüm veriler 30 gün içinde silinir ve aktif aboneliğin nasıl iptal edileceği gösterilir. | [Z] |

**KK (M1-05):** Hesapsız 10 yer imi oluşturan kullanıcı giriş yaptığında 10 yer imi hesabında görünür.

### M2. Mushaf ve Okuma Deneyimi
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M2-01 | **Sayfa (mushaf) görünümü** ve **ayet ayet görünüm**; ikisi arasında tek dokunuşla geçilir ve **konum korunur**. | [Z] |
| M2-02 | Mushaf düzenleri: Medine (Kral Fahd), Türkiye'de yaygın mushaf düzeni, IndoPak 15 satır. Sayfa başı ve sonu basılı nüshayla **birebir** aynıdır. | [Z] (Medine + TR), [Ö] (IndoPak), [İ] (Haremeyn) |
| M2-03 | Yatay mod; tablette ve katlanabilir cihazda **çift sayfa** görünüm. | [Z] |
| M2-04 | Sağ/sol sayfa göstergesi; cüz, hizb ve sayfa numarası her zaman görünür. | [Z] |
| M2-05 | Secde ayetleri, rubu'/hizb işaretleri gösterilir. | [Z] |
| M2-06 | Renkli tecvid gösterimi açılıp kapatılabilir; renge dokununca kural açıklaması çıkar. | [Ö] |
| M2-07 | Yazı boyutu en az %50–%250 arası ayarlanabilir; ayar kilitlenebilir. | [Z] |
| M2-08 | Temalar: açık, krem/sepya (mushaf rengi), koyu. **Koyu modda metin alanı da koyudur.** | [Z] |
| M2-09 | Sayfa geçişi: kaydırma + isteğe bağlı ok butonları. Ekran kenarı hareketleri sistemin geri hareketiyle **çakışmaz**. | [Z] |
| M2-10 | Ekran döndürüldüğünde okunan sayfa **değişmez**. | [Z] |
| M2-11 | Kontrollü otomatik kaydırma (hız ayarlı, sayfa görünümünde de çalışır). | [Ö] |
| M2-12 | Okuma sırasında ekran kapanmaz (ayarlanabilir). | [Z] |
| M2-13 | Arayüz çubukları dokununca gizlenir/gösterilir ve kendiliğinden ekranı kapatmaz. | [Z] |
| M2-14 | **Mushaf düzeni değiştirme:** kullanıcı ayarlardan mushaf düzenini (M2-02) değiştirebilir; yeni düzenler uygulama güncellemesi veya indirilebilir paketle eklenebilir. Ek düzenler isteğe bağlı indirilir (M16-02). | [Z] |
| M2-15 | **Konum düzenden bağımsızdır:** son okunan, yer imi, not, vurgu, hata işareti ve ezber durumu **sayfa numarasıyla değil sure:ayet(:kelime) ile** saklanır. Düzen değişince kullanıcı aynı ayette kalır ve hiçbir kayıt kaybolmaz. | [Z] |

**KK (M2-10):** Bakara 150. ayette dikey→yatay→dikey dönüş yapılınca ekran aynı ayette kalır.
**KK (M2-15):** Medine düzeninde Kehf 45'te yer imi olan kullanıcı başka bir düzene geçtiğinde, sayfa numarası farklı olsa da yer imi Kehf 45'i gösterir ve okuma Kehf 45'ten devam eder.

### M3. Meal, Tefsir ve Kelime Meali
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M3-01 | Birden fazla Türkçe meal (en az: Diyanet + 2 farklı meal, lisansa bağlı); EN ve AR tefsir/meal seçenekleri. | [Z] |
| M3-02 | Aynı anda en fazla 3 meal yan yana gösterilebilir. | [Ö] |
| M3-03 | **Kelime kelime meal** (TR, EN). Mushaf görünümünde kelimeye dokununca anlam açılır. | [Z] |
| M3-04 | Kelime detayında kök, kökün Kur'an'daki tüm geçişleri ve geçiş sayısı gösterilir. | [Ö] |
| M3-05 | Tefsir ayet bazında açılır; gösterilen tefsirin **doğru ayete ait olduğu** otomatik testle doğrulanır. | [Z] |
| M3-06 | Seçilen meal/tefsir ayarı kalıcıdır; güncelleme veya yeniden başlatmada **sıfırlanmaz**. | [Z] |
| M3-07 | Her meal ve tefsirin yazarı, kaynağı ve sürümü bilgi ekranında görünür. | [Z] |
| M3-08 | Transliterasyon (Latin harfli okunuş) isteğe bağlıdır; uyarı bir kez gösterilir ve kapatılabilir. | [İ] |
| M3-09 | Peygamber ve özel isimler meallerde İslami formuyla yazılır (Yusuf, Davud, İsa). | [Z] |

### M4. Arama ve Gezinme
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M4-01 | Sure listesi, cüz listesi, sayfa numarasıyla atlama, "Sure:Ayet" formatında (ör. `2:255`) atlama. | [Z] |
| M4-02 | Arapça metinde arama (harekesiz yazımla da bulur). | [Z] |
| M4-03 | Meal içinde arama (seçili meallerde); sonuçlar kaynağına göre filtrelenir ve filtre kalıcıdır. | [Z] |
| M4-04 | Kök ile arama. | [Ö] |
| M4-05 | Konu dizini (aile, sabır, rızık vb.). | [İ] |
| M4-06 | Arama tamamen internetsiz çalışır. | [Z] |
| M4-07 | Okuma ekranındayken, ana menüye dönmeden sure/ayet atlanabilir. | [Z] |

### M5. Ses (Dinleme)
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M5-01 | En az 10 kari ile başlanır (lisanslı); Türk hafızlar dahil. | [Z] |
| M5-02 | **Gapless** (kesintisiz) çalma; vasıl yapılan ayet geçişleri kesilmez. | [Z] |
| M5-03 | Hız ayarı: 0.5x – 2.0x, 0.25'lik adımlarla. | [Z] |
| M5-04 | Ayet veya aralık tekrarı: N kez (1–99) veya sonsuz; tekrar sayısı **eksiksiz** uygulanır. | [Z] |
| M5-05 | Bir sonraki ayete ve sureye otomatik geçiş; birden fazla sure arka arkaya çalınabilir. | [Z] |
| M5-06 | Çalınan ayet ekranda vurgulanır ve sayfa otomatik ilerler. | [Z] |
| M5-07 | Arka planda çalma, kilit ekranı ve bildirim kontrolleri, kulaklık tuşları. | [Z] |
| M5-08 | Duraklatıp devam edince ses **kaldığı yerden** sürer, ayet başına dönmez. | [Z] |
| M5-09 | Sure, cüz veya tüm Kur'an toplu indirilebilir; indirme yeri seçilebilir (Android'de SD kart). İndirme yöneticisinde geri/iptal vardır. | [Z] |
| M5-10 | İndirilen sesler güncellemede **silinmez**. | [Z] |
| M5-11 | Kelimeye dokununca o kelimenin telaffuzu çalınır. | [Ö] |
| M5-12 | Meal sesli okuması (Arapça + Türkçe meal sırayla). | [İ] |
| M5-13 | Kişisel çalma listesi (sure/ayet aralığı + tekrar sayısı). | [İ] (v1.2) |
| M5-14 | Uyku zamanlayıcısı. | [Ö] |

### M6. Yer İmi, Not ve Son Okunan
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M6-01 | Sınırsız yer imi; klasör/koleksiyon desteği; toplu silme. | [Z] |
| M6-02 | Ayete not ekleme; notlarda arama. | [Z] |
| M6-03 | Ayet vurgulama (renkli). | [Ö] |
| M6-04 | **Birden fazla bağımsız okuma ilerlemesi** (ör. Hatim, Ezber, Ramazan); her biri kendi "son okunan" konumunu tutar. | [Z] |
| M6-05 | Uygulama açıldığında son okunan konuma **tek dokunuşla** dönülür; son okunan, ayet düzeyinde ve doğru kaydedilir. | [Z] |
| M6-06 | Yanlışlıkla kaydedilen "okundu/tamamlandı" işaretleri geri alınabilir. | [Z] |
| M6-07 | Ayet paylaşımı: metin ve görsel (sade şablon). | [Ö] |
| M6-08 | Yer imi listesi uzun ayet metnini değil, kısa özeti (Sure:Ayet + ilk kelimeler) gösterir; görünüm değiştirilebilir. | [Ö] |

**KK (M6-05):** Kullanıcı Hac 35'te uygulamayı kapatıp 1 gün sonra açtığında "Devam et" ile Hac 35'e döner.

### M7. Alışkanlık ve Takip
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M7-01 | Günlük hedef türleri: ayet, sayfa, dakika veya cüz. | [Z] |
| M7-02 | Seri (streak) ve **en uzun seri** kaydı. | [Z] |
| M7-03 | **Seri koruma:** ayda en az 2 "mazeret günü" (hastalık, yolculuk, hayız) kullanılabilir; seri sıfırlanmaz. | [Z] |
| M7-04 | Takvim/ısı haritası görünümü; bir güne dokununca o gün okunanlar görülür. | [Ö] |
| M7-05 | Hatim planı (başlangıç–bitiş tarihi, günlük pay hesaplanır); Ramazan hatim şablonu. | [Z] |
| M7-06 | **Fiziksel mushaftan okunanı elle girme** (sayfa aralığı). | [Z] |
| M7-07 | Gezinme okuma sayılmaz; okuma süresi ve ilerleme yalnızca ekranda gerçekten geçirilen süreye göre sayılır. | [Ö] |
| M7-08 | İstatistikler: gün/hafta/ay grafikleri, toplam okunan sayfa ve hatim sayısı. | [Ö] |
| M7-09 | Cuma Kehf hatırlatması; mübarek gün ve gecelere özel okuma önerileri. | [Ö] |
| M7-10 | Ana ekran widget'ı: günün ayeti + bugünkü hedef durumu. | [Ö] |
| M7-11 | Motivasyon dili sade ve saygılıdır (ör. "Bugün 12 ayet okudun"). Hayvan/canavar figürü, "beast mode" gibi ifadeler kullanılmaz (bkz. YASAK-12). | [Z] |
| M7-12 | Hasenat sayacı vardır ama **varsayılan olarak kapalıdır**; kullanıcı ayarlardan açar. Açıklama metninde hesaplamanın tahmini olduğu belirtilir (AK-08). | [Ö] |

### M8. Hafızlık Araçları (Yapay Zekâsız, Ücretsiz)
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M8-01 | **Ayet gizleme modu:** sayfa/ayet gizlenir; tek dokunuşla sonraki kelime, uzun basınca ayetin tamamı açılır (ipucu). | [Z] |
| M8-02 | **Kendi hatanı işaretleme:** kullanıcı yanlış okuduğu kelimeye dokunup hata türünü seçer (unuttu / karıştırdı / hareke / tecvid). | [Z] |
| M8-03 | Hata geçmişi mushaf sayfasında renkli gösterilir; her işaret **silinebilir/düzenlenebilir**. | [Z] |
| M8-04 | **Müteşabih ayetleri işaretleme:** benzer ayetler renkle belirtilir ve dokununca benzerleri listelenir. | [Z] |
| M8-05 | Ezber durumu: "ezberlenmedi / öğreniliyor / ezberlendi / tekrar lazım". Durum **ayet aralığı** olarak saklanır; sayfa ve sure görünümü, seçili mushaf düzenine göre bundan hesaplanır (M2-15). | [Z] |
| M8-06 | **Aralıklı tekrar planı:** ezberlenen sayfalar için otomatik tekrar takvimi ve hatırlatma. | [Z] |
| M8-07 | **Rastgele ezber testi:** kullanıcı aralık seçer, uygulama rastgele ayet başı verir, kullanıcı "cevabı göster" ile kontrol edip doğru/yanlış işaretler. | [Z] |
| M8-08 | **Kayıt:** kullanıcı okumasını kaydeder; kayıt mushaf metniyle yan yana dinlenir ve hatalar elle işaretlenir. Kayıtlar **cihazda** saklanır. | [Z] |
| M8-09 | Kendi kaydını aynı ayetin kari okumasıyla art arda dinleme. | [Ö] |
| M8-10 | **Ekrana bakmadan kayıt modu:** ekran kararır, sadece kayıt göstergesi kalır. | [Ö] |
| M8-11 | Kaydı paylaşma (hocaya/arkadaşa dosya olarak). | [Ö] |
| M8-12 | **Hafız-hoca modu:** hoca öğrencinin kaydını açıp hataları işaretler ve geri gönderir. | [İ] (v1.2) |
| M8-13 | Hafızlık ekranlarında ilerleme yüzdesi (ezberlenen sayfa/cüz). | [Z] |

### M9. Günlük Eğitim (Ücretli, v1.1)
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M9-01 | Dersler **ders yollarında** toplanır (ör. "Kur'an'ı Anlamaya Giriş", "Namaz ve İbadet", "Elif-ba ve Tecvid"). | [Z] |
| M9-02 | Her yol seviyelidir (başlangıç / orta / ileri); başlangıçta **isteğe bağlı** yerleştirme testi yapılır. | [Z] |
| M9-03 | Ders formatı 5–10 dakikalık metin + ses (anlatıcı); ayet ve dualar **Arapça aslı + meal + ses** ile verilir. | [Z] |
| M9-04 | Her dersin sonunda yansıtma sorusu (kişisel not) ve 3–5 soruluk quiz olur. | [Z] |
| M9-05 | Her derste **hazırlayan ve onaylayan hocanın adı** ile kaynakça görünür. | [Z] |
| M9-06 | **Okuma ile entegrasyon:** okuma ekranında, okunan ayetle ilgili ders varsa küçük ve kapatılabilir bir öneri gösterilir. | [Ö] |
| M9-07 | Dersler sırayla açılır ama kullanıcı **ileri atlayabilir**; ilerleme hesapta saklanır. | [Z] |
| M9-08 | **Her hafta 1 ders herkese ücretsiz**; her ücretli dersin önizlemesi (özet veya ilk 1–2 dakika) açıktır. | [Z] |
| M9-09 | Abone dersleri çevrimdışı kullanım için indirebilir. | [Ö] |
| M9-10 | Kadın ve erkek anlatıcı seçeneği. | [İ] |
| M9-11 | Ders yolu tamamlanınca sade bir tamamlama kartı verilir (paylaşılabilir). | [İ] |
| M9-12 | Derslerde hata bildir butonu (M14) bulunur. | [Z] |
| M9-13 | Kişiselleştirme sadece kullanıcının seçtiği yola ve seviyeye göredir. **"Size özel plan" vaadi yapılmaz** (YASAK-08). | [Z] |

### M10. Zikir Sayacı
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M10-01 | Dokunmatik sayaç; ekranın herhangi bir yerine dokunma ile sayar; ekrana bakmadan kullanılabilir. | [Z] |
| M10-02 | Hedef (33/99/100/özel) gelince titreşim + isteğe bağlı ses. | [Z] |
| M10-03 | Hazır zikir listesi (Arapça + okunuş + anlam) ve özel zikir ekleme. | [Ö] |
| M10-04 | Günlük zikir geçmişi. | [İ] |
| M10-05 | Sesle sayma **yapılmaz** (KD-02). | – |

### M11. Abonelik, Ödeme ve Sponsorluk (v1.1)
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M11-01 | Ödeme **yalnızca** Google Play Billing ve App Store In-App Purchase ile alınır. | [Z] |
| M11-02 | Ürünler: aylık abonelik, yıllık abonelik, ömür boyu tek seferlik ödeme, aile planı (5–6 kişi). | [Z] (aylık/yıllık/ömür boyu), [Ö] (aile) |
| M11-03 | **Bölgesel fiyat** (TL ve yerel para birimi, satın alma gücüne göre). | [Z] |
| M11-04 | **Kart istemeyen** 7 günlük deneme. Mağaza bunu desteklemiyorsa deneme, uygulama içi ücretsiz erişim süresi olarak verilir. | [Z] |
| M11-05 | Satın alma ekranında: fiyat, dönem, **yenileme fiyatı**, yenileme tarihi ve iptal yöntemi aynı ekranda ve okunaklı puntoyla gösterilir. | [Z] |
| M11-06 | Yenilemeden ve deneme bitiminden **48–72 saat önce** push + e-posta ile hatırlatma gönderilir. | [Z] |
| M11-07 | Ayarlar > Abonelik: durum, sonraki ödeme tarihi ve tutarı, **tek dokunuşla mağaza iptal sayfasına** yönlendirme. | [Z] |
| M11-08 | Tek abonelik **tüm** dersleri açar; ödemeden sonra ikinci bir ödeme ekranı yoktur. | [Z] |
| M11-09 | Satın alımı geri yükleme (restore) her cihazda çalışır. | [Z] |
| M11-10 | **Sponsorluk havuzu:** kullanıcı başkasına ders aboneliği hediye edebilir veya havuza bağış yapabilir. Ödeyemeyen kullanıcı tek dokunuşla, **soru sorulmadan ve onay bekletilmeden** havuzdan erişim alır (kötüye kullanım için yalnızca makul süre ve sıklık sınırı uygulanır). | [Ö] |
| M11-11 | İade politikası açık yazılır (ör. ilk 14 gün koşulsuz). Uygulama içi destek iade talebini kabul eder ve mağaza yönlendirmesi yapar. | [Z] |
| M11-12 | Ödeme hatası olursa (kart reddi vb.) mağazanın ek süre (grace period) özelliği açıktır; erişim hemen kesilmez. | [Z] |
| M11-13 | Abonelik bitince kullanıcının ders ilerlemesi ve notları **silinmez**. | [Z] |

### M12. Bildirimler
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M12-01 | Hatırlatıcıların saati ve sayısını kullanıcı belirler; varsayılan **günde en fazla 1** bildirimdir. | [Z] |
| M12-02 | Her bildirim türü (okuma, tekrar, ders, Cuma, duyuru) ayrı ayrı kapatılabilir. | [Z] |
| M12-03 | Uygulama içi duyurular ve pop-up'lar da kapatılabilir; aynı içerik "bir daha gösterme" ile bir daha görünmez. | [Z] |
| M12-04 | Bildirim dili saygılıdır; suçlama ve korkutma içermez (YASAK-02). | [Z] |
| M12-05 | Pazarlama bildirimi için ayrı izin alınır, varsayılan olarak kapalıdır. | [Z] |
| M12-06 | Bildirim sistemi sorunsuz çalışır: planlanan zamanda tek tek gelir, uygulama açılınca topluca gelmez (Quranly hatası). | [Z] |

### M13. Ayarlar, Kişiselleştirme ve Erişilebilirlik
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M13-01 | Arayüz dili: TR, AR (tam RTL), EN. Seçilen dilde **tüm** arayüz o dildedir; karışık dil olmaz. | [Z] |
| M13-02 | Tüm ayarlar kalıcıdır; güncelleme veya yeniden başlatmada **sıfırlanmaz**. | [Z] |
| M13-03 | Ekran okuyucu (TalkBack/VoiceOver) desteği: tüm butonlar etiketli, ayetler okunabilir. | [Z] |
| M13-04 | Sistem yazı boyutu ve yüksek kontrast desteği. | [Z] |
| M13-05 | Sağ/sol el kullanımı için kontrollerin konumu ayarlanabilir. | [İ] |

### M14. Destek, Geri Bildirim ve Hata Bildirimi
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M14-01 | **Metin hatası bildir:** her ayette, mealde, tefsirde ve derste; bildirimle birlikte konum, kaynak, sürüm ve isteğe bağlı ekran görüntüsü gönderilir. | [Z] |
| M14-02 | Uygulama içi destek bileti; kullanıcı bilet durumunu görür. Hedef ilk yanıt süresi: 48 saat. | [Z] |
| M14-03 | Doğrulanan metin hataları için kamuya açık bir **düzeltme günlüğü** yayınlanır. | [Ö] |
| M14-04 | Özellik isteği gönderme. | [İ] |
| M14-05 | Mağaza yorumlarına yanıt politikası: 1–2★ yorumlar 72 saat içinde yanıtlanır. | [Ö] |

### M15. İçerik Yönetim Paneli (Yönetici, v1.1)
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M15-01 | Ders yolu, ders, quiz ve ses dosyası oluşturma/düzenleme. | [Z] |
| M15-02 | **Yayın iş akışı:** taslak → yazar → hoca onayı → yayın. Onaysız ders yayınlanamaz. | [Z] |
| M15-03 | Ders sürümleme ve değişiklik geçmişi. | [Z] |
| M15-04 | Hata bildirimlerinin (M14-01) listelenmesi, atanması ve kapatılması. | [Z] |
| M15-05 | Haftalık ücretsiz dersin seçimi ve planlanması. | [Z] |
| M15-06 | Rol bazlı yetki: yönetici, yazar, hoca (onaylayıcı), destek. | [Z] |
| M15-07 | Uygulama içi duyuru yönetimi (sıklık sınırıyla). | [Ö] |

### M16. Çevrimdışı Çalışma ve Veri İndirme
| Kod | Gereksinim | Öncelik |
|---|---|---|
| M16-01 | Kur'an metni, varsayılan meal ve kelime meali **uygulama paketinde** gelir; ilk açılışta internet gerekmez. | [Z] |
| M16-02 | Ek meal, tefsir ve sesler isteğe bağlı indirilir; indirilenler internetsiz çalışır. | [Z] |
| M16-03 | İnternet gerektiren her işlem (senkron, satın alma, ders indirme) bağlantı yoksa sıraya alınır ve kullanıcı bilgilendirilir; uygulama kilitlenmez. | [Z] |
| M16-04 | "Ağ yok" hatası yalnızca gerçekten ağ yoksa gösterilir; sunucu hatası ayrı mesajla belirtilir. | [Z] |

---

## 7. Yasaklar (Kesinlikle Yapılmayacaklar)

Bu maddeler hiçbir sürümde, hiçbir A/B testinde ve hiçbir kampanyada uygulanmaz. Her biri rakip analizindeki somut bir şikâyete dayanır.

| Kod | Yasak | Kaynak şikâyet |
|---|---|---|
| YASAK-01 | Kur'an okuma, dinleme, meal, tefsir veya hafızlık araçlarını ücretli yapmak | Tarteel, Quranly |
| YASAK-02 | Satışta veya bildirimlerde dini vicdanı kullanmak ("Bu seninle Allah arasında", "Söz bozuyorsun", "Gerçekten vaktin yok mu?") | Quranly |
| YASAK-03 | Ödeme ekranını karşılama akışına koymak veya uygulamayı denemeden ödeme/kart istemek | Quranly, AyahPath |
| YASAK-04 | Sahte geri sayım, sahte indirim, sahte "son fırsat" | Quranly |
| YASAK-05 | Mağaza dışı ödeme; uygulamada iptal yolunun olmaması; hesap silinince aboneliğin sürmesi | AyahPath |
| YASAK-06 | Habersiz yenileme; giriş fiyatıyla yenileme fiyatı arasında büyük fark (≥3 kat) | AyahPath |
| YASAK-07 | Ücretsiz verilmiş bir özelliği sonradan ücretliye çevirmek | Tarteel |
| YASAK-08 | Kişiselleştirme anketiyle "size özel plan" vaat edip herkese aynı içeriği vermek | AyahPath |
| YASAK-09 | Ödeme sonrası ek paket veya ikinci paywall | AyahPath |
| YASAK-10 | Üçüncü parti reklam | Kategori standardı |
| YASAK-11 | Her açılışta bağış, puan verme veya premium pop-up'ı; kapatılamayan uygulama içi mesaj | Al Quran, Tarteel, Quranly |
| YASAK-12 | Abartılı oyunlaştırma: canavar/hayvan figürleri, "beast/zombie mode", sıralama baskısı, Kur'an'ın şanına uymayan dil | Quranly, Tarteel |
| YASAK-13 | Reklamda "ücretsiz" deyip temel içeriği kilitlemek | AyahPath, Quranly |
| YASAK-14 | Kur'an metnini onaysız kaynaktan almak, metni değiştirmek veya metni bozan font kullanmak | Quranly, Al Quran |
| YASAK-15 | Onaysız veya kaynaksız ders yayınlamak | AyahPath |
| YASAK-16 | Kullanıcı verisini (yer imi, not, seri, ilerleme, indirilen ses) silebilecek bir güncellemeyi migration testi olmadan yayınlamak | Al Quran, Quranly |
| YASAK-17 | Zorunlu güncelleme ile kullanıcıyı okumanın ortasında kesmek (kritik güvenlik dışı) | Quranly |
| YASAK-18 | Ses kayıtlarını kullanıcının açık izni olmadan sunucuya yüklemek veya bir amaçla işlemek | Tarteel |
| YASAK-19 | Gereksiz izin istemek (konum, rehber, kamera); izin vermeyen kullanıcıyı uygulamadan engellemek | Quranly |
| YASAK-20 | Tartışmalı meal/tefsiri varsayılan yapmak; bir mezhebi veya grubu kötüleyen içerik | Al Quran, Tarteel |
| YASAK-21 | Kur'an bağlamına uymayan içerik ve kutlamalar (ör. başka dinlerin bayram temaları) | Quranly |
| YASAK-22 | Uygulamayı veya dersleri "hocanın yerini tutar" diye pazarlamak | Tarteel |
| YASAK-23 | Kullanıcı davranış verisini veya kişisel veriyi üçüncü taraflara satmak/paylaşmak | Gizlilik |
| YASAK-24 | Sahte, teşvikli veya bot mağaza yorumu | Al Quran ("bot yorum" şikâyeti) |

---

## 8. İçerik, Kaynak ve Lisans Gereksinimleri

| Kod | Gereksinim |
|---|---|
| İÇ-01 | **Kur'an metni:** Kral Fahd Kur'an Basım Kompleksi ve/veya Diyanet onaylı dijital metin. Kaynak, sürüm ve lisans "Hakkında" ekranında yazılır. |
| İÇ-02 | Metin; sure, ayet ve kelime sayılarına karşı **otomatik bütünlük testinden** geçer (bkz. 12. bölüm). |
| İÇ-03 | Mushaf fontları ve sayfa düzenleri için lisans alınır. Font değişikliği öncesi tüm Kur'an'da görsel karşılaştırma testi yapılır. |
| İÇ-04 | **Meal ve tefsirler:** her biri için yazılı lisans/izin alınır (Diyanet meali dahil). Lisansı olmayan içerik eklenmez. |
| İÇ-05 | **Kari sesleri:** her kari kaydı için kullanım izni alınır; kaynak ve kari bilgisi gösterilir. |
| İÇ-06 | Kelime meali ve kök verisi için lisans/kaynak belirtilir. |
| İÇ-07 | **Ders içeriği:** en az 1 ilahiyat uzmanı hoca tarafından onaylanır; onaylayanın adı derste görünür; kaynak gösterilir. İsrailiyat ve zayıf rivayetler ya kullanılmaz ya da açıkça belirtilir. |
| İÇ-08 | **İçerik danışma kurulu:** en az 2 hocadan oluşur; tartışmalı konularda karar verir ve varsayılan meal/tefsir seçimini onaylar. |
| İÇ-09 | Ders içeriğinin telif hakkı projeye ait olur (sözleşmeyle güvence altına alınır). |
| İÇ-10 | Yeni bir içerik kaynağı eklenmeden önce lisans kontrol listesi doldurulur. |

---

## 9. Fonksiyonel Olmayan Gereksinimler

### 9.1 Platform
| Kod | Gereksinim |
|---|---|
| NF-P01 | Flutter ile Android ve iOS (telefon + tablet). Minimum sürümler: **Android 7.0 (API 24), iOS 15**. |
| NF-P02 | Katlanabilir cihaz ve tablet düzenleri desteklenir (Quranly şikâyeti). |
| NF-P03 | iOS ve Android **özellik eşitliği**: bir özellik iki platformda birlikte yayınlanır (Al Quran'daki iOS gerisi kalma şikâyeti). |

### 9.2 Performans
| Kod | Gereksinim | Hedef |
|---|---|---|
| NF-PF01 | Soğuk açılış (son okunan sayfaya kadar) | Orta segment cihazda ≤ 2 sn |
| NF-PF02 | Sayfa geçişi | ≤ 100 ms, takılma yok |
| NF-PF03 | Arama sonucu (tüm Kur'an, çevrimdışı) | ≤ 500 ms |
| NF-PF04 | Ses başlatma (indirilmiş) | ≤ 300 ms |
| NF-PF05 | Ses başlatma (akış) | ≤ 2 sn |
| NF-PF06 | Uygulama ilk indirme boyutu | ≤ 60 MB (sesler hariç) |
| NF-PF07 | Pil tüketimi | 30 dk okumada, ekran hariç ihmal edilebilir düzey (Quranly'nin pil şikâyeti) |
| NF-PF08 | Yer imi/pin listesi | 1.000 kayıtta bile ≤ 300 ms açılış (Al Quran'ın yavaşlama şikâyeti) |

### 9.3 Güvenilirlik
| Kod | Gereksinim | Hedef |
|---|---|---|
| NF-G01 | Çökmesiz oturum oranı | ≥ %99,5 |
| NF-G02 | Kullanıcı verisi kaybı | **0** (her sürümde migration testi zorunlu) |
| NF-G03 | Yerel veri otomatik yedeği | Güncelleme öncesi otomatik yerel yedek alınır, son 3 yedek tutulur |
| NF-G04 | Sunucu erişilebilirliği (senkron, ders, ödeme doğrulama) | ≥ %99,5 aylık |
| NF-G05 | Sunucu kesintisinde | Okuma, dinleme ve hafızlık etkilenmez |

### 9.4 Yerelleştirme
| Kod | Gereksinim |
|---|---|
| NF-Y01 | TR, AR (RTL), EN arayüz; tüm metinler çeviri dosyasından gelir, koda gömülmez. |
| NF-Y02 | Kullanım koşulları, gizlilik politikası ve ödeme metinleri desteklenen her dilde bulunur. |
| NF-Y03 | Tarih, sayı ve para birimi yerel formatta gösterilir; Arapça sayı seçeneği vardır. |

### 9.5 Erişilebilirlik
| Kod | Gereksinim |
|---|---|
| NF-E01 | WCAG 2.1 AA kontrast oranları. |
| NF-E02 | Tüm etkileşimler ekran okuyucuyla yapılabilir (Tarteel'de VoiceOver eksikliği şikâyeti). |
| NF-E03 | Minimum dokunma alanı 44×44 pt. |

### 9.6 Ölçümleme (Analitik)
| Kod | Gereksinim |
|---|---|
| NF-A01 | Analitik **anonim ve asgari** düzeydedir. Okunan ayet içeriği ve notlar analitiğe gönderilmez. |
| NF-A02 | Analitik ve çökme raporlaması kullanıcı tarafından kapatılabilir. |
| NF-A03 | Ölçülecek olaylar 13. bölümdeki KPI'larla sınırlıdır. |

### 9.7 Mimari Kısıtlar (Sunucusuz Başlangıç, Senkrona Hazır Tasarım)
Sunucu kararı ertelendiği için (AK-03), sonradan sunucu eklemenin kolay olması aşağıdaki kurallara bağlıdır. Bu kurallar **v1.0'dan itibaren zorunludur**.

| Kod | Kısıt |
|---|---|
| MK-01 | **Local-first:** Uygulamanın tek doğru kaynağı cihazdaki veritabanıdır. Sunucu sonradan yalnızca senkron katmanı olarak eklenir. |
| MK-02 | Kullanıcı verisi taşıyan her kaydın kimliği **UUID**'dir; otomatik artan sayısal id kullanılmaz (cihazlar arası birleştirmede çakışmayı önler). |
| MK-03 | Her kullanıcı kaydında `createdAt`, `updatedAt` (UTC) ve `deletedAt` (yumuşak silme) alanları bulunur. |
| MK-04 | Veritabanı şeması sürümlüdür; her şema değişikliği yazılı bir migration ile yapılır ve T-04 testinden geçer. |
| MK-05 | Kur'an verisi (salt okunur içerik) ile kullanıcı verisi **ayrı veritabanlarında** tutulur. İçerik güncellemesi kullanıcı verisine dokunmaz. |
| MK-06 | Sunucuya ihtiyaç duyacak her yetenek bir **arayüz (soyutlama)** arkasında yazılır: `AuthService`, `SyncService`, `LessonRepository`, `BillingService`. v1.0'da bunların yerel/boş uygulamaları kullanılır; sunucu gelince sadece uygulama sınıfı değişir. |
| MK-07 | Arayüz katmanı veriye doğrudan değil, repository katmanı üzerinden erişir. |
| MK-08 | Sunucu ile iletişimde kullanılacak veri yapıları (DTO) şimdiden JSON serileştirilebilir tasarlanır; yedek dosyası (M1-08) aynı formatı kullanır. |
| MK-09 | Hesapsız kullanıcıya cihazda yerel bir `localUserId` atanır; hesap açıldığında veriler bu id'den hesaba taşınır (M1-05). |

---

## 10. Gizlilik, Güvenlik ve Hukuki Uyum

| Kod | Gereksinim |
|---|---|
| GH-01 | **KVKK ve GDPR uyumu.** Dini inanca ilişkin veri KVKK'ya göre **özel nitelikli kişisel veri** sayılabilir; bu yüzden işleme için açık rıza alınır, veri minimumda tutulur ve aydınlatma metni hazırlanır. Hukuki danışmanlık alınır (AK-09). |
| GH-02 | Hesapsız kullanımda hiçbir kişisel veri sunucuya gönderilmez. |
| GH-03 | Ses kayıtları yalnızca cihazda saklanır; paylaşım kullanıcının elle başlattığı bir işlemdir. |
| GH-04 | Aktarımda TLS 1.2+, sunucuda şifreli saklama; şifreler güvenli algoritmayla hashlenir. |
| GH-05 | Kullanıcı verisini indirme (taşınabilirlik) ve silme hakkı uygulama içinden kullanılabilir. |
| GH-06 | Ödeme bilgileri uygulamada **saklanmaz**; yalnızca mağaza makbuzu doğrulanır. |
| GH-07 | Google Play abonelik politikalarına ve App Store İnceleme Yönergelerine (dijital içerik için uygulama içi satın alma) uyulur. |
| GH-08 | Mesafeli satış ve tüketici mevzuatına uygun bilgilendirme (cayma hakkı, iade) yapılır. |
| GH-09 | Çocuk kullanıcılar varsa (AK-07): ebeveyn onayı, Google Families politikası ve COPPA uyumu sağlanır. |
| GH-10 | Gizlilik politikası, kullanım koşulları ve abonelik koşulları mağaza sayfasında ve uygulama içinde erişilebilir. |
| GH-11 | Üçüncü parti SDK listesi asgaridedir ve gizlilik politikasında belirtilir; reklam/izleme SDK'sı eklenmez. |
| GH-12 | Sızma testi v1.1 (ödeme) öncesinde yapılır. |

---

## 11. Veri Modeli (Ana Varlıklar)

Ayrıntılı şema teknik tasarımda yapılır; aşağıdaki varlıklar ve kurallar bağlayıcıdır.

| Varlık | Ana alanlar | Not |
|---|---|---|
| Kullanıcı | id, dil, tercih edilen meal(ler), tema, oluşturma tarihi | Hesapsız kullanıcı yerel id ile çalışır |
| OkumaIlerlemesi | id, ad (Hatim/Ezber/…), son konum (sure:ayet), başlangıç–bitiş tarihi | Kullanıcı başına birden fazla |
| OkumaKaydı | tarih, aralık, süre, kaynak (uygulama/fiziksel mushaf) | Seri ve istatistiklerin kaynağı |
| YerImi / Not / Vurgu | konum, klasör, metin, renk, zaman damgası | Silme "yumuşak silme" ile yapılır (geri alınabilir) |
| EzberDurumu | ayet aralığı (başlangıç–bitiş sure:ayet), durum, son tekrar, sonraki tekrar | Aralıklı tekrar algoritmasının girdisi; sayfa görünümü düzene göre hesaplanır |
| MushafDuzeni (içerik) | id, ad, sayfa sayısı, satır sayısı, font paketi, sürüm | Salt okunur içerik; her düzen sayfa→satır→kelime aralığı eşlemesi taşır |
| HataIsareti | kelime konumu, tür, tarih, silindi mi | Kullanıcı düzenleyebilir |
| Kayıt | yerel dosya yolu, konum, tarih | **Sunucuya gitmez** |
| Seri | mevcut, en uzun, mazeret günleri | |
| DersYolu / Ders / Quiz | içerik, seviye, sürüm, onaylayan hoca | İçerik yönetim panelinden gelir |
| DersIlerlemesi | ders id, durum, quiz sonucu, yansıtma notu | Abonelik bitse de korunur |
| Abonelik | mağaza, ürün, durum, yenileme tarihi | Sadece mağaza doğrulamasıyla güncellenir |
| HataBildirimi | konum, kaynak, açıklama, durum | |

**Senkron kuralları**
- Her kayıtta `updatedAt` ve `deletedAt` (yumuşak silme) alanları bulunur.
- Çakışmada aynı kayıt için son yazılan kazanır; **farklı kayıtlar asla birbirini silmez** (birleştirme yapılır).
- Seri ve okuma kayıtlarında birleştirme toplama ile yapılır; kayıt kaybolmaz.

---

## 12. Kalite, Test ve Yayın Süreci

### 12.1 Zorunlu otomatik testler (her sürümde)
| Kod | Test |
|---|---|
| T-01 | **Kur'an metin bütünlüğü:** 114 sure, 6.236 ayet; her ayetin karakter dizisi referans metinle hash karşılaştırması. |
| T-02 | **Sayfa düzeni:** her mushaf düzeninde 604 sayfanın ilk ve son ayeti referansla eşleşir. |
| T-03 | **Meal/tefsir eşleşmesi:** her ayete doğru meal ve tefsir bağlıdır (Al Quran'daki tefsir kayması şikâyeti). |
| T-04 | **Veri migration testi:** önceki 3 sürümün veritabanından güncelleme yapılır; yer imi, not, seri, ilerleme ve indirilen seslerin **tamamı** korunur. |
| T-05 | Ayarların kalıcılığı: güncelleme ve yeniden başlatma sonrası tüm ayarlar aynı kalır. |
| T-06 | Ses: tekrar sayısı, gapless geçiş, duraklat/devam et. |
| T-07 | Satın alma: satın alma, geri yükleme, iptal, yenileme ve ek süre senaryoları (mağaza test ortamında). |
| T-08 | Çevrimdışı: uçak modunda tüm çekirdek akışlar çalışır. |
| T-09 | Döndürme ve çoklu pencere: konum kaybı yaşanmaz. |
| T-10 | Erişilebilirlik taraması. |

### 12.2 Yayın süreci
| Kod | Kural |
|---|---|
| Y-01 | Her sürüm önce **kapalı beta** (en az 7 gün), sonra **kademeli yayın** ile çıkar: %5 → %20 → %50 → %100. |
| Y-02 | Kademeli yayında çökme oranı veya veri kaybı bildirimi eşiği aşılırsa yayın durdurulur. |
| Y-03 | Kritik güvenlik dışında zorunlu güncelleme yoktur; güncelleme istemi "sonra" seçeneğiyle gelir. |
| Y-04 | Her sürümün sürüm notu Türkçe ve anlaşılır yazılır; kaldırılan veya değişen davranış açıkça belirtilir. |
| Y-05 | Büyük arayüz değişikliklerinde eski düzen **en az 1 sürüm** boyunca ayarlardan seçilebilir (Al Quran'daki "eski sürümü geri getirin" şikâyetleri). |
| Y-06 | Sürüm öncesi kontrol listesi: T-01…T-10 geçti, yasak listesi (7. bölüm) gözden geçirildi, lisanslar güncel. |

### 12.3 Manuel kontrol
- En az 1 hafız kullanıcı, her sürümde mushaf düzeni ve hafızlık akışlarını test eder.
- Yeni ders içeriği yayından önce hoca onayından geçer (M15-02).

---

## 13. Başarı Ölçütleri (KPI)

| Alan | Ölçüt | v1.0 hedefi (ilk 6 ay) | v1.1 hedefi |
|---|---|---|---|
| Güven | Mağaza puanı | ≥ 4,7 | ≥ 4,7 |
| Güven | 1★ yorum oranı | ≤ %3 | ≤ %3 |
| Güven | Doğrulanmış metin hatası düzeltme süresi | ≤ 7 gün | ≤ 7 gün |
| Kalite | Çökmesiz oturum | ≥ %99,5 | ≥ %99,5 |
| Kalite | Veri kaybı bildirimi | 0 | 0 |
| Bağlılık | 30. gün tutunma (retention) | ≥ %25 | ≥ %30 |
| Bağlılık | Haftalık aktif / aylık aktif | ≥ %40 | ≥ %45 |
| Gelir | Ücretsiz dersi tamamlayan → deneme | – | Ölçülür (hedef AK-10) |
| Gelir | Deneme → ücretli dönüşüm | – | Ölçülür (hedef AK-10) |
| Gelir | 90. gün ders yolu devam oranı | – | ≥ %30 |
| Gelir | İade oranı | – | ≤ %3 |
| Destek | İlk yanıt süresi | ≤ 48 saat | ≤ 48 saat |

---

## 14. Açık Kararlar

Proje iskeletine başlamadan önce kapatılması gereken kararlar:

| Kod | Karar | Seçenekler / not | Sorumlu | Son tarih |
|---|---|---|---|---|
| AK-01 | ~~Teknoloji yığını (mobil)~~ | ✅ **Karar: Flutter** (28.10.2026) | | Kapatıldı |
| AK-02 | ~~Minimum işletim sistemi sürümleri~~ | ✅ **Karar: Android 7.0 (API 24) / iOS 15** (28.10.2026) | | Kapatıldı |
| AK-03 | Sunucu ve kimlik doğrulama altyapısı | ⏸ **Ertelendi** (28.10.2026). Mobil geliştirme sunucusuz başlar; sunucu **v1.0 kapalı betasından önce** hazır olur. Aday: kendi sunucu (ASP.NET Core). Bu arada uygulama 9.7'deki mimari kısıtlara göre geliştirilir. Abonelik doğrulaması için RevenueCat gibi hazır bir servis de değerlendirilebilir. | | v1.0 beta öncesi |
| AK-04 | Uygulama adı, marka, alan adı | | | |
| AK-05 | Lisansı alınacak meal, tefsir ve kari listesi | İÇ-04, İÇ-05 | | |
| AK-06 | İçerik danışma kurulu ve ders hocaları | İÇ-07, İÇ-08 | | |
| AK-07 | ~~Yaş sınırı~~ | ✅ **Karar: v1.x 13+** (28.10.2026). Çocuk modu ve aile desteği v2.0'da ayrıca değerlendirilir (KD-12). | | Kapatıldı |
| AK-08 | ~~Hasenat sayacı~~ | ✅ **Karar: var, varsayılan kapalı**; ayarlardan açılır (M7-12) (28.10.2026) | | Kapatıldı |
| AK-09 | KVKK hukuki danışmanlık | GH-01 | | |
| AK-10 | Fiyatlar ve dönüşüm hedefleri | Bölge bazlı fiyat tablosu | | |
| AK-11 | Türkiye mushaf düzeni için kaynak/lisans | M2-02 | | |
| AK-12 | İlk ders yolları ve müfredat | M9-01 | | |
| AK-13 | Yapay zekâ değerlendirme kriterleri (v2.0) | KD-01 | | |
| AK-14 | **Diyanet Mushafları İnceleme ve Kıraat Kurulu onayı.** "Kur'an-ı Kerim Basım ve Yayım Kriterleri Hakkında Yönetmelik" (RG 2/11/2022-32001) elektronik ortamdaki Kur'an yayınlarını da kapsar; onaysız eser yayımlanamaz (md. 9), font Kurulca uygun görülmeli (md. 5/3-n), mealli eserler için Din İşleri Yüksek Kurulu görüşü (md. 8/3). | ⏸ **Ertelendi (kullanıcı kararı, 29.10.2026):** ilk sürüm yönetmelik başvurusu beklenmeden hazırlanır; ileride (ör. Türkiye düzeni veya font için) Kurula başvurulur. Risk kayıtlı: onaysız yayına md. 11 yaptırımları uygulanabilir. Ayrıntı: `Fazlar/Faz_1_Notlar.md` §5 | Kullanıcı | v1.0 sonrası (gözden geçirme: yayın öncesi) |

---

## 15. Değişiklik Yönetimi

1. Kapsam değişikliği talebi yazılı yapılır: ne, neden, hangi gereksinim kodunu etkiliyor, hangi sürüme.
2. Talep önce **3. bölümdeki ürün ilkeleri** ve **7. bölümdeki yasaklarla** karşılaştırılır. Çelişen talep reddedilir.
3. **Küçük değişiklik:** mevcut bir modül içinde öncelik değişimi veya [İ] özellik ekleme. Ürün sahibi onayıyla yapılır ve dokümanın sürüm notuna işlenir.
4. **Büyük değişiklik:** yeni modül, kapsam dışı maddenin kapsama alınması veya gelir modeli değişikliği. Doküman sürümü artırılır (1.x → 2.0) ve tüm paydaşlar onaylar.
5. Ürün ilkeleri (3. bölüm) ve yasaklar (7. bölüm) yalnızca büyük değişiklik süreciyle ve gerekçesi yazılarak değiştirilebilir.

**Doküman sürüm geçmişi**
| Sürüm | Tarih | Değişiklik |
|---|---|---|
| 1.0 | 28.10.2026 | İlk taslak |
| 1.1 | 28.10.2026 | AK-01 Flutter, AK-02 Android 7/iOS 15, AK-07 13+, AK-08 hasenat varsayılan kapalı kararları işlendi; AK-03 ertelendi; 9.7 Mimari Kısıtlar ve KD-12 eklendi |
| 1.2 | 28.10.2026 | Sunucu v1.0 betasından önce hazır olacak; hesap ve senkron (M1) yeniden v1.0 kapsamına alındı |
| 1.3 | 28.10.2026 | Sunucu, veri modeli dondurulduktan sonra (test sürecinin başında) yazılacak; "Veri Modeli Dondurma" kilometre taşı eklendi |
| 1.4 | 28.10.2026 | M2-14 mushaf düzeni değiştirme, M2-15 düzenden bağımsız konum eklendi; ezber durumu ayet aralığı bazlı yapıldı |
| 1.5 | 29.10.2026 | AK-14 eklendi: Diyanet Kurul onayı (yönetmelik dijital Kur'an yayınlarını kapsıyor; F1-03 araştırması) |

---

## 16. Sözlük

| Terim | Anlam |
|---|---|
| Mushaf görünümü | Basılı Kur'an sayfasının birebir düzeni |
| Gapless | Ayetler arasında boşluk olmadan, karinin kesintisiz okumasının çalınması |
| Müteşabih ayetler | Birbirine çok benzeyen ve ezberde karıştırılan ayetler |
| Aralıklı tekrar | Ezberi kalıcı kılmak için tekrarları giderek açılan aralıklarla planlama yöntemi |
| Rivayet | Kıraat aktarım yolu (Hafs, Warş, Kalûn…) |
| Seri (streak) | Ardışık okuma günü sayısı |
| Paywall | İçeriği ödeme karşılığında açan ekran/kilit |
| Grace period | Ödeme başarısız olduğunda erişimin hemen kesilmediği ek süre |
| MoSCoW | Önceliklendirme yöntemi: Zorunlu / Önemli / İsteğe bağlı |
| KK | Kabul kriteri |
