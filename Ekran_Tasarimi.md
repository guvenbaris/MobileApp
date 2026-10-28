# Ekran Tasarımı

> **Amaç:** v1.0'dan v1.2'ye kadar eklenecek tüm özellikler düşünülerek uygulamanın **bilgi mimarisini, ekranlarını ve etkileşim kurallarını** tek yerde planlamak. Böylece her fazda eklenen ekran, baştan düşünülmüş bir yere oturur ve sonradan büyük bir düzen değişikliği gerekmez (Y-05).
> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (ilkeler İ1–İ10, yasaklar, M1–M16), `reviews/Kuran_Uygulamasi_Yorum_Analizi.md` (rakip yorumları), `Fazlar/Faz_1.md`, `CLAUDE.md` (tema ve bileşen kuralları)
> **Durum:** Taslak v0.1 (29.10.2026). Çizimler kutu çizimi (wireframe) düzeyindedir; renk ve görsel ayrıntı tema katmanından gelir (F0-08). Görsel tasarım geliştikçe ekran kodları (E-xx) aynı kalır.

## İçindekiler
1. [Rakip uygulamalardan çıkarılan dersler](#1-rakip-uygulamalardan-çıkarılan-dersler)
2. [Tasarım ilkeleri](#2-tasarım-ilkeleri)
3. [Bilgi mimarisi ve gezinme](#3-bilgi-mimarisi-ve-gezinme)
4. [Ekran listesi](#4-ekran-listesi)
5. [Ekranlar](#5-ekranlar)
6. [Tablet, yatay ve katlanabilir düzenler](#6-tablet-yatay-ve-katlanabilir-düzenler)
7. [Etkileşim ve hareket kuralları](#7-etkileşim-ve-hareket-kuralları)
8. [Bileşen kataloğu](#8-bileşen-kataloğu)
9. [Görsel dil](#9-görsel-dil)
10. [Açık tasarım soruları](#10-açık-tasarım-soruları)

---

## 1. Rakip uygulamalardan çıkarılan dersler

Ekranlar hiçbir uygulamanın kopyası değildir. Her uygulamanın kullanıcıların sevdiği **kalıbı** alınır, şikâyet edilen kısmı tasarımda baştan engellenir. Kaynak: yorum analizi ve gereksinimler.

| Uygulama | Örnek alınan kalıp | Tasarımda engellenen sorun |
|---|---|---|
| **Al Quran** (Greentech) | Ayet eylem menüsünün zenginliği (dinle, tekrar, meal, tefsir, not, pin). Kelimeye dokununca anlam ve kök. Çoklu meal. Kontrollü otomatik kaydırma. Ayet aralığı tekrarı. | Her açılışta bağış/puan pop-up'ı. Güncellemeyle kaybolan ayarlar ve yer imleri. Geri hareketinin sayfa çevirmeyle çakışması. Kalabalık ayarlar. |
| **AyahPath** | Kısa, adım adım günlük ders ekranı: okuma + dinleme + yansıtma sorusu. Ders yolunda ilerleme çizgisi. | Karşılamada ödeme ekranı. "Size özel plan" anketi. Habersiz yenileme. Uygulamada iptal yolunun olmaması. Ödeme sonrası ikinci ödeme ekranı. |
| **Tarteel** | Ezber ekranı: ayetleri gizleyip kelime kelime açma. Müteşabih işaretleri. Tekrar (muraja'a) takvimi. Kayıt arşivi. Sade ve iyi kurgulanmış karşılama. | Sonradan ücretli yapılan özellik. İnternet zorunluluğu. Silinemeyen hata kaydı. Tablette çift sayfa ve mushaf rengi eksikliği. VoiceOver eksikliği. |
| **Quranly** | Tek ayete odaklanan sakin okuma. Günlük hedef halkası ve seri. Cuma Kehf hatırlatması. Temiz, modern arayüz. | Suçluluk temelli ödeme dili, sahte geri sayım. Hayvan figürlü oyunlaştırma. Bir gün kaçınca sıfırlanan seri. Bildirim bombardımanı. Fiziksel mushaftan okunanı girememe. |
| **Diyanet Kur'an-ı Kerim** | Türkiye'de alışılmış mushaf görünümü ve sayfa düzeni. Diyanet meali. Türk hafızların kıraati. Sure/cüz/sayfa ile hızlı erişim. Türkçe, resmî ve güven veren dil. | Seçeneklerin dağınık ve derin menülerde olması. Sınırlı kişiselleştirme. Hafızlık ve alışkanlık araçlarının olmaması. Bunları tek, düzenli bir yapıda sunuyoruz. |

**Konumlandırma özeti (Gereksinimler §1):** Al Quran'ın cömertliği (her şey ücretsiz) + Quranly'nin alışkanlık motoru (sade) + Tarteel'in hafızlık deneyimi (yapay zekâsız, internetsiz) + AyahPath'in ders formatı (şeffaf ödeme) + Diyanet'in Türkiye'ye uygun mushafı ve dili.

---

## 2. Tasarım ilkeleri

| # | İlke | Ekrana yansıması |
|---|---|---|
| D1 | **Mushaf önce gelir** | Okuma ekranında Kur'an metninin üstüne hiçbir şey binmez: rozet, öneri, reklam, sayaç. Çubuklar dokununca gizlenir (M2-13). Metin kırpılmaz, kesilmez. |
| D2 | **Sakin arayüz** | Pop-up yok (YASAK-11). Öneriler küçük, kapatılabilir ve "bir daha gösterme"li (M12-03). Kutlama animasyonu yerine sade cümle: "Bugün 12 ayet okudun" (M7-11). |
| D3 | **Her yere iki dokunuşta** | Bugün'den son okunana 1 dokunuş (M6-05). Okurken herhangi bir ayete Git paneliyle 2 dokunuş (M4-07). Ayet eylemleri uzun basışla tek panelde. |
| D4 | **Kaldığın yer kutsaldır** | Görünüm, düzen, tema, döndürme, dil değişince okunan ayet aynı kalır (M2-01, M2-10, M2-15). Hiçbir ayar kendiliğinden sıfırlanmaz (M13-02). |
| D5 | **Ücretsiz olan net, ücretli olan dürüst** | Okuma, dinleme, meal, tefsir, hafızlık ücretsiz ve kilitsiz görünür; kilit simgesi yalnızca dersler sekmesinde. Ödeme ekranı yalnızca kullanıcı isteyince açılır; fiyat, yenileme fiyatı ve iptal aynı ekranda (M11-05). |
| D6 | **Saygılı dil** | Suçlama, korkutma, aciliyet yok (YASAK-02, YASAK-04). Eksik gün "kaçırdın" değil; mazeret günü önerilir (M7-03). |
| D7 | **Tek elle kullanım** | Sık kullanılan eylemler ekranın alt yarısında (alt çubuk, mini oynatıcı, alt panel). Üst çubukta yalnızca bilgi ve seyrek eylemler. |
| D8 | **Herkes için** | 48×48 dokunma alanı, AA kontrast, ekran okuyucu etiketleri, sistem yazı boyutu (F0-08, F0-11). Arapçada ayna düzen (RTL). |
| D9 | **İnternetsiz varsayılır** | İnternet gerektiren her yerde durum açıkça yazılır ("indirildi", "indirilecek", "bağlantı bekleniyor"). Hata mesajı ağ yokluğunu sunucu hatasından ayırır (M16-04). |
| D10 | **Kaynak görünür** | Her meal, tefsir, kari ve dersin kaynağı ve onaylayanı bir dokunuşla görülür (M3-07, M9-05, İÇ-01). |

---

## 3. Bilgi mimarisi ve gezinme

### 3.1 Alt sekmeler
v1.0'da 4 sekme, v1.1'de **Dersler** eklenince 5 sekme. Sekmeler kendi geçmişini korur. Okuma ekranı tam ekran açılır ve sekme çubuğunu gizler.

| Sekme | Simge (öneri) | İçerik | Faz |
|---|---|---|---|
| **Bugün** | güneş/ev | Devam et, günlük hedef, seri, günün ayeti, tekrar zamanı gelen ezber, (v1.1) günün dersi | 1 (temel), 2 (hedef/seri/ezber) |
| **Kur'an** | açık kitap | Sure/cüz/sayfa dizini, arama, Kayıtlarım (yer imi, not, vurgu) | 1 |
| **Hafızlık** | katmanlar | Ezber haritası, tekrar takvimi, test, kayıtlar, hata listesi | 2 (Faz 1'de "yakında" boş durumu) |
| **Dersler** | kep | Ders yolları, haftalık ücretsiz ders, ilerleme | 4 (v1.1) |
| **Ben** | kişi | Okuma ilerlemeleri, istatistik, zikir sayacı, indirmeler, ayarlar, hesap, destek | 1 (ayarlar, indirmeler), 2–3 (diğerleri) |

```
┌──────────────────────────────────────────┐
│                 (içerik)                 │
├──────────────────────────────────────────┤
│  ☀ Bugün   📖 Kur'an   ◫ Hafızlık   👤 Ben │   v1.0
│  ☀ Bugün  📖 Kur'an  ◫ Hafızlık  🎓 Dersler  👤 Ben │ v1.1
└──────────────────────────────────────────┘
```
Arapçada sekme sırası sağdan sola dizilir (Bugün en sağda).

### 3.2 Gezinme haritası
```
Karşılama (ilk açılış, 4 adım) ──► Bugün
Bugün ── Devam et ─────────────────────────► Okuma (E-04/E-05)
      ── Günün ayeti ──────────────────────► Okuma (o ayet)
      ── Tekrar zamanı (F2) ───────────────► Hafızlık › Tekrar
Kur'an ── Sure/Cüz/Sayfa ──────────────────► Okuma
       ── Arama (E-11) ────────────────────► Okuma (sonuç ayeti)
       ── Kayıtlarım (E-12) ───────────────► Okuma (kaydın ayeti)
Okuma ── Git paneli · Ayet eylemleri · Kelime kartı · Meal/Tefsir paneli
      ── Mini oynatıcı ─► Tam oynatıcı (E-09)
      ── Okuma ayarları (E-10)
Hafızlık (F2) ── Ezber haritası ─► Okuma (gizleme modu)
              ── Test · Kayıt · Hata listesi
Dersler (F4) ── Yol ─► Ders ─► Quiz/Yansıtma
Ben ── İlerlemeler · İstatistik (F2) · Zikir (F2) · İndirmeler · Ayarlar · Hakkında · Hesap (F3) · Destek
```
Derin bağlantılar: `/read?ayah=2:255`, `/read?page=50`, `/search?q=…`, `/memorize/test`. Ayet paylaşımı derin bağlantı üretir (M6-07).

---

## 4. Ekran listesi

| Kod | Ekran | Faz | Gereksinimler |
|---|---|---|---|
| E-01 | Karşılama (4 adım) | 2 (dil adımı 1) | M1-09, YASAK-03 |
| E-02 | Bugün | 1 → 2 → 4 | M6-05, M7-01…M7-12, M9-08 |
| E-03 | Kur'an dizini + Git paneli | 1 | M4-01, M4-07 |
| E-04 | Okuma: sayfa görünümü | 1 | M2-01…M2-13, M5-06 |
| E-05 | Okuma: ayet görünümü | 1 | M2-01, M3-01, M3-02, M3-03 |
| E-06 | Ayet eylem paneli | 1 | M5-04, M6-01…M6-03, M6-07, M14-01 |
| E-07 | Kelime kartı | 1 | M3-03, M3-04, M5-11 |
| E-08 | Meal / tefsir paneli ve seçimi | 1 | M3-01, M3-05…M3-07 |
| E-09 | Ses: mini ve tam oynatıcı | 1 | M5-01…M5-08, M5-14 |
| E-10 | Okuma ayarları paneli | 1 | M2-06, M2-07, M2-08, M2-11, M2-12, M2-14 |
| E-11 | Arama | 1 | M4-02…M4-06 |
| E-12 | Kayıtlarım (yer imi, not, vurgu) | 1 | M6-01…M6-03, M6-08 |
| E-13 | İndirmeler | 1 | M5-09, M5-10, M16-02 |
| E-14 | Ayarlar | 1 | M13-01…M13-05 |
| E-15 | Hakkında ve kaynaklar | 1 | İÇ-01, M3-07 |
| E-16 | Okuma ilerlemeleri | 1 | M6-04, M6-06 |
| E-17 | Hafızlık merkezi | 2 | M8-05, M8-06, M8-13 |
| E-18 | Gizleme modu ve hata işaretleme | 2 | M8-01…M8-04 |
| E-19 | Ezber testi | 2 | M8-07 |
| E-20 | Kayıt (ses) ve karşılaştırma | 2 | M8-08…M8-11 |
| E-21 | Hedef, seri ve takvim | 2 | M7-01…M7-04, M7-12 |
| E-22 | Hatim planı ve elle giriş | 2 | M7-05, M7-06 |
| E-23 | İstatistikler | 2 | M7-08 |
| E-24 | Zikir sayacı | 2 | M10-01…M10-04 |
| E-25 | Bildirim ayarları | 2 | M12-01…M12-06 |
| E-26 | Hata bildir ve destek | 2 (yerel) / 3 | M14-01…M14-04 |
| E-27 | Hesap, senkron, yedek | 3 | M1-01…M1-10 |
| E-28 | Ders yolları ve ders | 4 | M9-01…M9-13 |
| E-29 | Abonelik ve sponsorluk | 4 | M11-01…M11-13 |

---

## 5. Ekranlar

Her ekranda: amaç, kutu çizimi (TR, dikey telefon), öğeler, davranış, durumlar (yükleniyor / boş / hata / çevrimdışı).

### E-01 Karşılama (en fazla 4 adım, M1-09)
**Amaç:** Uygulamayı denemeden önce hiçbir şey istemeden, 30 saniyede okumaya başlatmak. **Ödeme ekranı yok** (YASAK-03). Her adım "Atla" ile geçilebilir.

```
 Adım 1/4                         Atla
┌──────────────────────────────────────┐
│        بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ        │
│                                      │
│   Uygulama dilini seçin              │
│   ( ) Cihaz dili  (•) Türkçe         │
│   ( ) العربية     ( ) English        │
│                                      │
│              [ Devam ]               │
└──────────────────────────────────────┘
 2/4 Okuma hedefi: [5 ayet] [1 sayfa] [10 dk] [Sonra]
 3/4 Meal: Diyanet (varsayılan, değiştirilebilir) · Mealsiz
 4/4 Hatırlatma: saat seçimi + "İzin ver" / "Şimdi değil"
```
- Hesap istenmez (M1-01); hesap Ben sekmesinden isteğe bağlıdır.
- Bildirim izni yalnızca 4. adımda, kullanıcı saat seçerse istenir (YASAK-19).
- Faz 1'de yalnızca dil adımı var (cihaz dili desteklenmiyorsa); diğerleri Faz 2'de.

### E-02 Bugün
**Amaç:** Kullanıcıyı tek dokunuşla okumaya döndürmek ve günlük alışkanlığı sakin bir dille göstermek.

```
┌──────────────────────────────────────┐
│ Bugün                      29 Ekim ⚙︎ │
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │ Okumaya devam et        Hatim ▾  │ │
│ │ Bakara 150 · Sayfa 23 · Cüz 2    │ │
│ │ ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ %4      │ │
│ │                    [ Devam et ▸ ]│ │
│ └──────────────────────────────────┘ │
│  ◔ Bugünkü hedef        🔥 12 gün    │  (Faz 2)
│    3 / 5 ayet          en uzun: 40   │
│ ┌──────────────────────────────────┐ │
│ │ Tekrar zamanı: Mülk (s. 562–564) │ │  (Faz 2)
│ │                     [ Başla ▸ ]  │ │
│ └──────────────────────────────────┘ │
│  Günün ayeti                         │
│  ﴿ أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ ﴾       │
│  "Bilesiniz ki kalpler ancak..."     │
│  Ra'd 28            [Oku] [Paylaş]   │
│  ─ Cuma: Kehf okuma önerisi    ✕     │  (Faz 2, kapatılabilir)
├──────────────────────────────────────┤
│ ☀ Bugün  📖 Kur'an  ◫ Hafızlık  👤 Ben │
└──────────────────────────────────────┘
```
- **Devam kartı:** birden fazla ilerleme varsa (Hatim, Ezber, Ramazan) açılır menüyle veya yatay kaydırmayla seçilir (M6-04).
- **Hedef halkası ve seri** (Faz 2): rakam ve sade cümle; hayvan/canavar figürü yok (YASAK-12). Seri tehlikedeyse mazeret günü önerilir (M7-03). Hasenat sayacı varsayılan kapalı (M7-12).
- **Öneri kartları** (Cuma Kehf, mübarek gece, ders): en fazla 1 tane, kapatılabilir, "bir daha gösterme" (M12-03).
- **v1.1:** "Bu haftanın ücretsiz dersi" kartı (M9-08); ödeme ekranına değil derse götürür.
- **Boş durum** (ilk açılış): "Okumaya başla" kartı → Fatiha.

### E-03 Kur'an dizini ve Git paneli
**Amaç:** Sure, cüz, sayfa veya ayete en kısa yoldan gitmek (M4-01).

```
┌──────────────────────────────────────┐
│ Kur'an                       🔍  🔖  │
│ ┌──────────────────────────────────┐ │
│ │ 🔍 Sure, ayet (2:255) veya kelime │ │
│ └──────────────────────────────────┘ │
│  [ Sure ]  [ Cüz ]  [ Sayfa ]        │
├──────────────────────────────────────┤
│ ① Fâtiha           Mekkî · 7    الفاتحة │
│ ② Bakara           Medenî · 286  البقرة │
│ ③ Âl-i İmrân       Medenî · 200 آل عمران│
│ ...                                  │
│ ▸ Son okunan: Bakara 150 (s. 23)     │  (yapışkan alt şerit)
├──────────────────────────────────────┤
│ ☀ Bugün  📖 Kur'an  ◫ Hafızlık  👤 Ben │
└──────────────────────────────────────┘
```
- **Cüz sekmesi:** 30 cüz; her cüzün içinde hizb/rubu' başlangıçları açılır liste. **Sayfa sekmesi:** 1–604 ızgara veya numara girişi; seçili düzene göre.
- **Arama kutusu:** `2:255` yazılırsa doğrudan ayete, `50` yazılırsa sayfaya gider; kelime yazılırsa E-11 açılır.
- **🔖** Kayıtlarım (E-12).
- Faz 2'de ezber durumu sure satırında küçük ilerleme çizgisiyle gösterilir.

**Git paneli** (okuma ekranından, alttan açılır; M4-07):
```
┌──────────────────────────────────────┐
│ Git                             ✕    │
│ [ Sure ▾ Bakara ]  [ Ayet ▾ 150 ]    │
│ [ Cüz 2 ]  [ Sayfa 23 ]  [ Git ▸ ]   │
│ Son gidilenler: Kehf 1 · Yasin 1     │
└──────────────────────────────────────┘
```

### E-04 Okuma: sayfa görünümü
**Amaç:** Basılı mushafla birebir sayfa; okurken dikkat dağıtmamak (D1).

Çubuklar **görünür** (ekrana bir dokunuş):
```
┌──────────────────────────────────────┐
│ ←  Bakara · Cüz 2 · Hizb 3      ⋯  ⚙︎ │  üst çubuk
├──────────────────────────────────────┤
│        ┌──────────────────────┐      │
│        │     سُورَةُ البَقَرَة     │      │
│  ‹     │   15 satır mushaf    │    › │  isteğe bağlı oklar (M2-09)
│        │   sayfası (DigitalKhatt)│     │
│        │                      │      │
│        └──────────────────────┘      │
│            ۞ 23 · sağ sayfa           │  sayfa no + sağ/sol göstergesi (M2-04)
├──────────────────────────────────────┤
│ ▶ Mişari · Bakara 150   ⏸  ⟳3   ⌃    │  mini oynatıcı (çalıyorsa)
│ 📄/☰  🔊  Meal  🔖  Git               │  alt çubuk
└──────────────────────────────────────┘
```
Çubuklar **gizli** (varsayılan okuma hali):
```
┌──────────────────────────────────────┐
│  Cüz 2                       Sayfa 23 │  ince, soluk bilgi satırı (M2-04 her zaman görünür)
│                                      │
│        (yalnızca mushaf sayfası)     │
│                                      │
└──────────────────────────────────────┘
```
- **Dokunma:** boş alana tek dokunuş çubukları açar/kapatır; çubuklar kendiliğinden kapanmaz (M2-13). Kelimeye dokunuş **kelime kartı** (E-07), ayete uzun basış **ayet eylem paneli** (E-06).
- **Sayfa çevirme:** yatay kaydırma (mushaf sağdan sola; sonraki sayfa soldan gelir) + isteğe bağlı oklar. Ekran kenarındaki 24 dp şerit sistemin geri hareketine bırakılır (M2-09, §7).
- **Ses çalarken:** çalınan ayet hafif zeminle vurgulanır, sayfa kendiliğinden ilerler (M5-06).
- **İşaretler:** secde ayetinde kenarda ۩ notu, rubu'/hizb başında ۞ (M2-05). Faz 2'de hata işaretleri ve ezber renkleri yalnızca kullanıcı açarsa görünür.
- **Otomatik kaydırma** (M2-11): alt çubuktan; hız kaydırıcısı, dokununca durur.
- **Ekran açık** (M2-12): ayardan; okuma ekranında geçerli.
- **Durumlar:** sayfa yüklenirken sayfa rengi boş alan (titreme yok). Hata olursa ErrorState ve "Tekrar dene".

### E-05 Okuma: ayet görünümü
**Amaç:** Anlamaya odaklı okuma; meal, kelime meali ve tek ayet odağı (Quranly'nin sevilen kalıbı).

```
┌──────────────────────────────────────┐
│ ←  Bakara 150 · Cüz 2           ⋯  ⚙︎ │
├──────────────────────────────────────┤
│                         ┌────────┐   │
│  وَمِنْ حَيْثُ خَرَجْتَ فَوَلِّ وَجْهَكَ  │ 2:150  │   │
│  شَطْرَ ٱلْمَسْجِدِ ٱلْحَرَامِ ...      └────────┘   │
│  ─────────────────────────────────   │
│  Diyanet: "Nereden çıkarsan çık,     │
│  yüzünü Mescid-i Haram tarafına..."  │
│  Elmalılı: "..."            (≤ 3 meal, M3-02)
│  ─────────────────────────────────   │
│  [kelime meali açıksa: her kelimenin │
│   altında küçük Türkçe karşılık]     │
├──────────────────────────────────────┤
│ 2:151 ...                            │
├──────────────────────────────────────┤
│ 📄/☰  🔊  Meal  🔖  Git     A− A+     │
└──────────────────────────────────────┘
```
- Ayetler dikey listede; okunan ayet ekranın üstündeki ayettir (M2-15). Sayfa görünümüne geçişte o ayetin sayfası açılır.
- **Odak modu** (seçenek): tek ayet tam ekran, sağa-sola kaydırarak ayet ayet ilerleme.
- Yazı boyutu Arapça ve meal için ayrı ayarlanır (A−/A+, %50–%250; kilitlenebilir, M2-07).
- Sure başında sure adı, iniş yeri, ayet sayısı; besmele (Fatiha ve Tevbe kuralına uygun).
- Ekran okuyucu: her ayet "Ayet 2:150, [Arapça], [meal]" olarak tek düğümde okunur (M13-03).

### E-06 Ayet eylem paneli
**Amaç:** Bir ayetle ilgili her şeyi tek panelde toplamak (Al Quran'ın sevilen menüsü, daha düzenli).

```
┌──────────────────────────────────────┐
│ ───                                  │
│ Bakara 150                      ✕    │
│ وَمِنْ حَيْثُ خَرَجْتَ ...               │
│                                      │
│ [🔊 Dinle] [⟳ Tekrarla] [📖 Meal/Tefsir] │
│ [🔖 Yer imi] [✎ Not] [🖍 Vurgula]       │
│ [⧉ Kopyala] [↗ Paylaş] [⚑ Hata bildir]  │
│ ──────────────────────────────────   │
│ Bu ayetle ilgili ders (v1.1)    ✕    │  (M9-06, kapatılabilir)
└──────────────────────────────────────┘
```
- Ayete uzun basınca açılır; sayfa görünümünde seçilen ayetin tüm kelimeleri hafifçe vurgulanır.
- **Tekrarla:** başlangıç–bitiş ayeti ve tekrar sayısı (1–99 / ∞) seçimi; doğrudan oynatıcıyı başlatır (M5-04).
- **Yer imi:** klasör seçimi (son kullanılan varsayılan); **Not:** tam ekran editör; **Vurgula:** 5 renk (M6-03).
- **Paylaş:** metin (Arapça + seçili meal + kaynak) veya sade görsel kart (M6-07).
- **Hata bildir** (Faz 2): konum, kaynak ve sürüm kendiliğinden eklenir (M14-01).
- Birden fazla ayet seçimi (ilk ayete uzun bas, sonra diğerine dokun): kopyala, paylaş, tekrarla, yer imi.

### E-07 Kelime kartı
**Amaç:** Mushafta kelimeye dokununca anlamı açmak (M3-03; Al Quran'ın en sevilen özelliği).

```
┌──────────────────────────────────────┐
│ ───                                  │
│   ٱلْمَسْجِدِ         [🔊 Dinle]  ✕     │
│   el-mescidi                         │  okunuş (isteğe bağlı, M3-08)
│   mescid, secde yeri                 │  kelime meali (TR)
│   Kök: س ج د · Kur'an'da 92 geçiş ▸   │  (M3-04, lisansa bağlı)
│   Bakara 150 · 12. kelime            │
│   [ Ayeti aç ] [ Hata işaretle (F2) ] │
└──────────────────────────────────────┘
```
- Kart sayfanın altında küçük panel olarak açılır, sayfayı kapatmaz. Sonraki/önceki kelimeye kaydırılabilir.
- "92 geçiş" → kök geçişleri listesi (E-11 kök sonuçları).
- Faz 2'de hafızlık modunda bu kart yerine hata türü seçimi açılır (E-18).

### E-08 Meal / tefsir paneli ve seçimi
```
 Sayfa görünümünde: alt panel (yarım ekran, yukarı çekilince tam)
┌──────────────────────────────────────┐
│ Bakara 150     [Meal] [Tefsir]   ✕   │
│ Diyanet ▾                            │
│ "Nereden çıkarsan çık, yüzünü..."    │
│ ‹ 149            151 ›               │
│ ⓘ Diyanet İşleri Başkanlığı, 2018    │  kaynak (M3-07)
└──────────────────────────────────────┘
 Meal seçimi (Ayarlar › Meal ve Tefsir):
  ☑ Diyanet İşleri (TR) · paketli
  ☑ Elmalılı (TR) · 2,1 MB · İndirildi
  ☐ Saheeh International (EN) · 1,8 MB · [İndir]
  Sıralamak için sürükle · En fazla 3 meal (M3-02)
```
- Tefsir sekmesi ayet aralığına ait tefsiri gösterir; aralık başlıkta yazar ("Bakara 148–150 için"), böylece tefsirin hangi ayete ait olduğu her zaman bellidir (M3-05).
- Varsayılan meal **seçili gelir ama dayatılmaz**; karşılamada değiştirilebilir (İ10, YASAK-20).
- Tablet yatayda panel sağda sabit sütun olur (§6).

### E-09 Ses: mini ve tam oynatıcı
```
 Mini (okuma ekranının altında, sekmelerde de görünür):
┌──────────────────────────────────────┐
│ ▶ Mişari Raşid · Bakara 150  ⏮ ⏸ ⏭ ⌃ │
└──────────────────────────────────────┘
 Tam (mini oynatıcı yukarı çekilince):
┌──────────────────────────────────────┐
│ ⌄                                    │
│        Bakara 150 / 286              │
│        Mişari Raşid el-Afasi ▾       │  kari seçimi
│  ●━━━━━━━━━━━━━━━○─────────  12:40   │
│        ⏮     ⏸     ⏭                 │
│  Hız  [0.75] [1.0] [1.25] …          │  0.5–2.0, 0.25 adım
│  Tekrar  Ayet ▾  Bakara 150–152  ×3  │  aralık + sayı (∞ dahil)
│  Bitince  [Sonraki sure ▾]           │  dur / sonraki sure (M5-05)
│  ⏾ Uyku zamanlayıcısı  [15 dk ▾]     │  (M5-14)
│  ⬇ Bu sure indirildi · Tümünü yönet ▸ │
└──────────────────────────────────────┘
```
- Kilit ekranında ve bildirimde: kari, sure:ayet, önceki/sonraki ayet, duraklat (M5-07).
- Duraklatınca kaldığı yerden devam eder (M5-08). Tekrar sayacı oynatıcıda görünür: "2/3".
- İndirilmemiş surede çalma akışla yapılır; çevrimdışıysa "Bu sure indirilmedi" ve "İndir" düğmesi (D9).

### E-10 Okuma ayarları paneli
Okuma ekranındaki ⚙︎ ile alttan açılır; değişiklik anında sayfaya uygulanır.
```
┌──────────────────────────────────────┐
│ Okuma ayarları                  ✕    │
│ Görünüm     [📄 Sayfa] [☰ Ayet]       │
│ Tema        [Açık] [Sepya] [Koyu]    │
│ Yazı        A− ━━━━○━━━ A+   🔒 Kilitle │
│ Mushaf      Medine 1421H ▾           │  (M2-14) düzen seçimi
│ Tecvid      [ ○ ] renkli tecvid      │  (M2-06)
│ Kelime meali[ ● ]                    │
│ Ekran açık  [ ● ] okurken kapanmasın │  (M2-12)
│ Sayfa okları[ ○ ]                    │  (M2-09)
│ Oto kaydırma hız ━━○━━━  [Başlat]    │  (M2-11)
└──────────────────────────────────────┘
```

### E-11 Arama
```
┌──────────────────────────────────────┐
│ ←  🔍 rahmet                     ✕   │
│ [ Arapça ] [ Meal ] [ Kök ]          │
│ Filtre: Diyanet ✓  Elmalılı ✓   ▾    │  kalıcı (M4-03)
├──────────────────────────────────────┤
│ 79 sonuç                             │
│ Bakara 157 · s. 24                   │
│   "...Rablerinden bağışlamalar ve    │
│   **rahmet** vardır..."              │
│ Âl-i İmrân 107 · s. 63               │
│   ...                                │
├──────────────────────────────────────┤
│ Son aramalar: sabır · 2:255 · رحيم    │
└──────────────────────────────────────┘
```
- Arapça arama harekesiz yazımı da bulur (M4-02); yazılan dile göre sekme kendiliğinden seçilir (Arapça harf → Arapça).
- Sonuçta eşleşen kelime vurgulanır. Dokununca okuma ekranı o ayette açılır ve ayet kısa süre vurgulanır.
- Konu dizini [İ]: arama boşken "Konular" (aile, sabır, rızık…) listesi (M4-05).
- İnternetsiz (M4-06); sonuç ≤ 500 ms.

### E-12 Kayıtlarım (yer imi, not, vurgu)
```
┌──────────────────────────────────────┐
│ ←  Kayıtlarım                 ⋯  ✓   │  ✓ = seçim modu (toplu silme)
│ [ Yer imleri ] [ Notlar ] [ Vurgular ]│
│ 📁 Tümü (24) · 📁 Ezber (8) · 📁 Dua (5) · + │
├──────────────────────────────────────┤
│ 🔖 Kehf 45 · "وَٱضْرِبْ لَهُم مَّثَلَ..."    │  kısa özet (M6-08)
│    Ezber · 2 gün önce                │
│ 🔖 Bakara 255 · Âyetü'l-Kürsî          │
│    Dua · 1 hafta önce                │
└──────────────────────────────────────┘
```
- Görünüm seçeneği: kısa özet / meal ile / yalnız konum (M6-08).
- Notlarda arama (M6-02). Silinen kayıt alttaki çubukta "Geri al" ile 10 sn geri alınabilir (yumuşak silme).
- 1.000 kayıtta ≤ 300 ms (NF-PF08): liste sanal kaydırmalı.
- **Boş durum:** "Henüz yer imi yok. Bir ayete uzun basıp 🔖 ile ekleyebilirsiniz."

### E-13 İndirmeler
```
┌──────────────────────────────────────┐
│ ←  İndirmeler          Kullanılan 1,2 GB │
│ Konum: Dahili depolama ▾ (SD kart)    │  (M5-09)
│ [ Sesler ] [ Meal/Tefsir ] [ Düzenler ]│
├──────────────────────────────────────┤
│ Mişari Raşid  ▸  114 sureden 12'si    │
│   [Tümünü indir 1,1 GB]              │
│ Abdülbasit    ▸  İndirilmedi          │
│ ── Sürüyor ──                        │
│ Yasin (Mişari) ━━━━━○──  %62  ⏸ ✕    │
└──────────────────────────────────────┘
```
- Sure, cüz veya tümü indirilebilir; duraklat, iptal, kaldığı yerden devam (M5-09).
- İndirilenler güncellemede silinmez (M5-10); silme yalnız kullanıcı isteğiyle ve onayla.
- Bağlantı yoksa indirme sıraya alınır: "Bağlantı gelince devam edecek" (M16-03).

### E-14 Ayarlar
Bölümler (her biri bir alt sayfa ya da liste bölümü):
| Bölüm | İçerik | Faz |
|---|---|---|
| Görünüm | Tema, dil, rakamlar, yazı boyutu, yüksek kontrast | 0 → 1 |
| Okuma | Varsayılan görünüm, mushaf düzeni, tecvid, ekran açık, sayfa okları | 1 |
| Meal ve Tefsir | Seçili mealler ve sıra, tefsir, kelime meali dili, okunuş | 1 |
| Ses | Varsayılan kari, hız, bitince davranış, indirme konumu | 1 |
| Hafızlık | Tekrar planı aralıkları, hata türleri renkleri, müteşabih göster | 2 |
| Hedef ve Bildirimler | Günlük hedef, hatırlatma saatleri, bildirim türleri, hasenat (varsayılan kapalı) | 2 |
| Hesap ve Yedek | Giriş, senkron, dışa/içe aktar, hesabı sil | 3 |
| Abonelik | Durum, sonraki ödeme, iptal (tek dokunuş) | 4 |
| Gizlilik | Analitik ve çökme raporu (kapatılabilir, NF-A02) | 3 |
| Hakkında | Kaynaklar, lisanslar, sürüm, düzeltme günlüğü | 1 |

### E-15 Hakkında ve kaynaklar
```
┌──────────────────────────────────────┐
│ ←  Hakkında                          │
│ Kur'an'ı okuma ve ezberleme uygulaması│
│ Sürüm 1.0.0 (içerik 6)               │
│ ── Kur'an metni ve mushaf ──          │
│ Metin: KFGQPC (Medine 1421H) ▸        │
│ Düzen: Medine 1421H, 604 sayfa ▸      │
│ Font: DigitalKhatt New Madina (OFL) ▸ │
│ ── Meal, tefsir, ses ──               │
│ Diyanet İşleri meali · 2018 ▸         │
│ Kariler ▸                            │
│ ── ──                                │
│ Lisanslar ▸  ·  Düzeltme günlüğü ▸    │
│ Tanzil Project · tanzil.net ↗        │  (gerekirse, VERI_KAYNAKLARI §4)
└──────────────────────────────────────┘
```

### E-16 Okuma ilerlemeleri
```
 Ben › Okuma ilerlemeleri
┌──────────────────────────────────────┐
│ ←  Okuma ilerlemeleri           +    │
│ ● Hatim        Bakara 150 · %4    ▸  │
│ ● Ramazan      Yasin 12 · %72     ▸  │
│ ● Araştırma    Nur 35             ▸  │
│ Varsayılan: Hatim ▾                  │
└──────────────────────────────────────┘
```
- Her ilerleme kendi son okunanını tutar (M6-04); okuma ekranının üst çubuğundaki ⋯ menüsünden hangi ilerlemeye yazılacağı seçilir.
- Yanlış "tamamlandı" işareti geri alınabilir (M6-06).

### E-17 Hafızlık merkezi (Faz 2)
**Amaç:** Hafızın ezber durumunu sayfa sayfa görmesi ve günün tekrarına başlaması (Tarteel'in sevilen kalıbı; ücretsiz ve internetsiz).

```
┌──────────────────────────────────────┐
│ Hafızlık                         ⚙︎   │
│ Ezberlenen 4 cüz · 82 sayfa  ━━━ %14 │  (M8-13)
│ ┌──────────────────────────────────┐ │
│ │ Bugünkü tekrar: 6 sayfa          │ │  (M8-06)
│ │ Mülk 562–564 · Nebe 582–584      │ │
│ │                      [ Başla ▸ ] │ │
│ └──────────────────────────────────┘ │
│ Ezber haritası      [Cüz] [Sayfa]    │
│ ▣▣▣▣▣▣▣▣▣▣ ▣▣▤▤□□□□□□  (cüz 30)      │  renk: ezberlendi/öğreniliyor/tekrar lazım
│ [ 📝 Test ] [ 🎙 Kayıt ] [ ⚑ Hatalarım ] │
├──────────────────────────────────────┤
│ ☀ Bugün  📖 Kur'an  ◫ Hafızlık  👤 Ben │
└──────────────────────────────────────┘
```
- Harita seçili mushaf düzenine göre hesaplanır; durum ayet aralığı olarak saklanır (M8-05, M2-15).
- Kareye dokununca: sayfayı aç / durum değiştir / gizleme moduyla tekrar et.

### E-18 Gizleme modu ve hata işaretleme (Faz 2)
```
┌──────────────────────────────────────┐
│ ←  Mülk · s. 562 · Gizleme       ⋯   │
│  ﴿ تَبَٰرَكَ ٱلَّذِى ▒▒▒▒▒ ▒▒▒▒▒▒ ▒▒▒▒ ﴾     │  açılan kelimeler + gizli kelimeler
│   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒     │
├──────────────────────────────────────┤
│ [ Sonraki kelime ] [ Ayeti aç (uzun) ] │  (M8-01)
│ [ Hata işaretle ] [ Hepsini göster ]  │
└──────────────────────────────────────┘
 Hata işaretle → kelimeye dokun → tür:
   ( ) Unuttum ( ) Karıştırdım ( ) Hareke ( ) Tecvid   [Kaydet]
```
- Hatalar sayfada renkli alt çizgiyle görünür; dokununca düzenle/sil (M8-03).
- Müteşabih ayetler kenarda işaretli; dokununca benzer ayetler listesi (M8-04).
- Gizlenen kelimeler ezberi bozmayacak nötr bir şekille kapatılır; Kur'an metninin yerine başka yazı konmaz.

### E-19 Ezber testi (Faz 2)
```
┌──────────────────────────────────────┐
│ ←  Ezber testi        Soru 3 / 10    │
│ Aralık: Cüz 30                        │
│ Bu ayetin devamını okuyun:            │
│  ﴿ عَمَّ يَتَسَآءَلُونَ ﴾  …                │
│          [ Cevabı göster ]            │
│  (gösterildikten sonra)               │
│     [ ✓ Doğru ]     [ ✗ Yanlış ]      │
└──────────────────────────────────────┘
```
- Aralık seçimi: sure, cüz, sayfa aralığı veya "ezberlediklerim" (M8-07). Sonuç sayfası sade: "10 sorudan 8'i doğru". Yanlışlar tekrar listesine eklenebilir.

### E-20 Kayıt ve karşılaştırma (Faz 2)
- **Kayıt:** sayfa/aralık seç → kaydet. "Ekrana bakmadan" seçeneğinde ekran kararır, ortada yalnızca kayıt göstergesi kalır (M8-10).
- **Dinleme:** kayıt mushaf metniyle yan yana çalınır; kullanıcı hatalı kelimeye dokunup işaretler (M8-08). "Kariyle art arda" düğmesi aynı ayeti kariden çalar (M8-09).
- Kayıtlar cihazda kalır; paylaşım yalnızca kullanıcı başlatırsa (M8-11, GH-03, YASAK-18). Kayıt listesinde her kaydın yanında "yalnızca bu cihazda" notu.

### E-21 Hedef, seri ve takvim (Faz 2)
```
┌──────────────────────────────────────┐
│ ←  Hedef ve seri                     │
│ Günlük hedef: [ 5 ayet ▾ ]            │  ayet/sayfa/dakika/cüz (M7-01)
│ Seri 12 gün · En uzun 40 gün          │  (M7-02)
│ Mazeret günü: bu ay 2 hakkın var  ▸   │  (M7-03)
│   Ekim 2026                           │
│  Pt Sa Ça Pe Cu Ct Pz                 │
│  ▪  ▪  ▫  ▪  ▪  ◦  ▪                  │  ısı haritası (M7-04); ◦ = mazeret
│  Güne dokun → o gün okunanlar          │
└──────────────────────────────────────┘
```
- Dil sade: "Bugün okumadın, istersen mazeret günü kullanabilirsin." Suçlama yok (M12-04).

### E-22 Hatim planı ve elle giriş (Faz 2)
- **Hatim planı:** başlangıç ve bitiş tarihi → günlük pay (sayfa) hesaplanır; Ramazan şablonu (M7-05).
- **Elle giriş:** "Mushaftan okudum" → sayfa aralığı (ör. 23–30) ve tarih (M7-06). İstatistiğe ve seriye eklenir; kaynağı "fiziksel mushaf" olarak görünür.

### E-23 İstatistikler (Faz 2)
- Gün/hafta/ay sütun grafiği, toplam sayfa, hatim sayısı, ortalama süre (M7-08). Grafikler tema paletini kullanır ve ekran okuyucu için tablo karşılığı vardır.

### E-24 Zikir sayacı (Faz 2)
```
┌──────────────────────────────────────┐
│ ←  Zikir          Sübhânallah ▾   ↺   │
│                                      │
│                 27                    │
│               / 33                    │  hedefte titreşim (+ses) (M10-02)
│      (ekranın her yeri dokunma alanı)  │  (M10-01)
│                                      │
│  سُبْحَانَ ٱللَّهِ · "Allah'ı tesbih ederim" │
└──────────────────────────────────────┘
```
- Ekrana bakmadan kullanım: büyük dokunma alanı, her dokunuşta hafif titreşim, sesle sayma **yok** (KD-02). Ekran kapanmaz.

### E-25 Bildirim ayarları (Faz 2)
- Tür bazında açma/kapama: okuma, tekrar, Cuma, ders, duyuru (M12-02). Her türün saati ve sayısı; varsayılan günde en fazla 1 (M12-01). Pazarlama bildirimi ayrı izinle ve varsayılan kapalı (M12-05).
- Her bildirimin önizlemesi ekranda gösterilir; dil saygılıdır.

### E-26 Hata bildir ve destek (Faz 2 yerel, Faz 3 sunucu)
- Ayet eylem panelinden: konum, kaynak, sürüm kendiliğinden dolu; açıklama ve isteğe bağlı ekran görüntüsü (M14-01). Gönderim çevrimdışıysa sıraya alınır.
- Destek: bilet listesi ve durumu (M14-02); "Düzeltme günlüğü" bağlantısı (M14-03).

### E-27 Hesap, senkron ve yedek (Faz 3)
- Hesap isteğe bağlıdır; "Neden hesap?" açıklaması: cihazlar arası senkron ve yedek. E-posta, Google, Apple (M1-02); hesaba yöntem ekleme (M1-03).
- Girişte yerel veri birleştirilir ve kullanıcıya özet gösterilir: "24 yer imi ve 3 ilerleme hesabına eklendi" (M1-05).
- Dışa/içe aktar (JSON) (M1-08). Hesabı sil: ne silineceği, 30 gün ve abonelik iptal yolu tek ekranda (M1-10).

### E-28 Ders yolları ve ders (Faz 4, v1.1)
```
 Dersler sekmesi
┌──────────────────────────────────────┐
│ Dersler                              │
│ Bu haftanın ücretsiz dersi ▸          │  (M9-08)
│ ┌──────────────────────────────────┐ │
│ │ Kur'an'ı Anlamaya Giriş · Başlangıç│ │
│ │ 12 / 30 ders  ━━━━━━○────         │ │
│ │ Sıradaki: Fatiha'nın anlamı  ▸    │ │
│ └──────────────────────────────────┘ │
│ Diğer yollar: Namaz ve İbadet · Elif-ba ve Tecvid │
└──────────────────────────────────────┘
 Ders ekranı: başlık · süre (7 dk) · anlatıcı seçimi
   metin + ses oynatıcı · ayet kutusu (Arapça + meal + ses)
   "Bu derste ne düşündün?" (yansıtma notu) · 3–5 soruluk quiz
   Hazırlayan / onaylayan hoca adı · kaynakça · ⚑ hata bildir (M9-05, M9-12)
```
- Abone olmayan için ücretli derste özet/ilk dakikalar açık, sonra sade bir "Abonelikle devam" kartı; **kilit tüm ekranı kaplamaz**, okuma özelliklerine hiç kilit konmaz (M9-08, İ1).
- Dersler ileri atlanabilir (M9-07). "Size özel plan" ifadesi yok (YASAK-08).

### E-29 Abonelik ve sponsorluk (Faz 4, v1.1)
```
┌──────────────────────────────────────┐
│ ←  Ders aboneliği                    │
│ Tüm dersler, tek abonelik (M11-08)    │
│ ( ) Aylık   ₺xx / ay                  │
│ (•) Yıllık  ₺xxx / yıl                │
│ ( ) Ömür boyu ₺xxxx (tek ödeme)       │
│ Yenileme: ₺xxx · 29 Ekim 2027         │  aynı ekranda, okunaklı (M11-05)
│ 7 gün ücretsiz, kart istenmez         │  (M11-04)
│ İptal: Ayarlar › Abonelik › İptal     │
│ [ Devam et ]                          │
│ Ödeyemiyorum → sponsorluk havuzundan erişim ▸ │ (M11-10)
│ Aboneliği geri yükle                  │
└──────────────────────────────────────┘
```
- Geri sayım, "son fırsat", vicdan dili **yok** (YASAK-02, YASAK-04). Kapatma düğmesi her zaman görünür. Ödeme sonrası ikinci teklif yok (YASAK-09).
- Ayarlar › Abonelik: durum, sonraki ödeme tarihi ve tutarı, tek dokunuşla mağaza iptal sayfası (M11-07).

---

## 6. Tablet, yatay ve katlanabilir düzenler

| Durum | Düzen |
|---|---|
| Telefon dikey | Tek sütun (yukarıdaki çizimler) |
| Telefon yatay | Mushaf sayfası genişliğe sığar, dikey kaydırılır (F0-05). Ayet görünümü iki sütuna geçmez. |
| Tablet dikey | Tek sayfa, büyük; meal paneli alttan yarım ekran |
| **Tablet yatay** | **Çift sayfa** (sağda tek, solda çift sayfa, basılı mushaf gibi; M2-03). Meal/tefsir açılırsa tek sayfa + sağda meal sütunu. |
| Katlanabilir açık | Tablet yatay gibi; menteşe çizgisi iki sayfanın arasına denk gelir (NF-P02) |
| Liste ekranları (tablet) | İki bölmeli: solda liste (sure dizini, kayıtlar, ayarlar), sağda içerik |

```
 Tablet yatay, meal açık:
┌─────────────────────────────┬──────────────┐
│                             │ Bakara 150   │
│      mushaf sayfası 23      │ Diyanet ▾    │
│                             │ "Nereden..." │
└─────────────────────────────┴──────────────┘
```

---

## 7. Etkileşim ve hareket kuralları

| Hareket | Okuma ekranında anlamı | Not |
|---|---|---|
| Tek dokunuş (boş alan) | Çubukları aç/kapat | |
| Tek dokunuş (kelime) | Kelime kartı (E-07) | Hafızlık modunda: sonraki kelimeyi aç / hata işaretle |
| Uzun basış (ayet) | Ayet eylem paneli (E-06) | Sürükleyince çoklu seçim |
| Yatay kaydırma | Sayfa çevir (sağdan sola mushaf) | **Ekranın sol/sağ kenarındaki 24 dp şerit sistemin geri hareketine bırakılır** (M2-09; Al Quran şikâyeti) |
| Dikey kaydırma | Ayet görünümünde liste; telefon yatayda sayfa içi | |
| İki parmakla yakınlaştırma | Sayfa görünümünde büyütme | Yazı boyutu kilitliyse kapalı (M2-07) |
| Mini oynatıcıyı yukarı çekme | Tam oynatıcı | |
| Alt paneli aşağı çekme | Paneli kapat | Panel içindeki liste en üstteyse |

- **Geri tuşu** (Android): açık panel → panel kapanır; değilse okuma ekranından çıkılır. Okuma ekranından çıkış onay istemez; konum zaten kaydedilmiştir.
- **Titreşim:** yalnızca zikir sayacında ve tekrar hedefinde; okuma ekranında yok.
- **Animasyon:** kısa (≤ 250 ms) ve işlevsel. Sistemde "hareketi azalt" açıksa kapanır.

---

## 8. Bileşen kataloğu

| Bileşen | Durum | Kullanıldığı yerler |
|---|---|---|
| `AppButton`, `AppListItem`, `AppSectionHeader` | ✅ F0-08 | Her yer |
| `EmptyState`, `ErrorState`, `LoadingState` | ✅ F0-08 | Her liste ve veri ekranı |
| `MushafPageView` | ✅ F0-05 | E-04, E-18 |
| `AppBottomSheet` (tutamaçlı alt panel, yarım/tam) | Faz 1 | E-06, E-07, E-08, E-10, Git paneli |
| `ContinueCard` (devam et kartı) | Faz 1 | E-02 |
| `SegmentedTabs` (Sure/Cüz/Sayfa, Meal/Tefsir) | Faz 1 | E-03, E-08, E-11, E-12 |
| `AyahTile` (Arapça + meal + kelime meali) | Faz 1 | E-05, E-11 sonuçları, E-12 |
| `MiniPlayer`, `PlayerSheet` | Faz 1 | E-09 |
| `ReaderChrome` (üst/alt çubuk, gizlenebilir) | Faz 1 | E-04, E-05 |
| `DownloadTile` (ilerleme, duraklat, iptal) | Faz 1 | E-13, E-08 |
| `DismissibleTip` (kapatılabilir öneri, "bir daha gösterme") | Faz 1 | E-02, E-06 |
| `ProgressRing` (hedef halkası), `StreakBadge` (sade) | Faz 2 | E-02, E-21 |
| `HeatmapCalendar` | Faz 2 | E-21 |
| `MemorizationGrid` (ezber haritası) | Faz 2 | E-17 |
| `ShareCard` (ayet görseli şablonu) | Faz 1 [Ö] | E-06 |

Yeni bileşenler `lib/core/widgets/`'a ya da yalnız bir özelliğe aitse o özelliğin `presentation/widgets/` klasörüne yazılır; renk ve ölçüleri temadan alır (CLAUDE.md).

---

## 9. Görsel dil

- **Renk:** üç tema (açık, sepya, koyu) ve palet rolleri F0-08'de tanımlı (`AppPalette`). Hafızlık renkleri (ezberlendi/öğreniliyor/tekrar lazım), vurgu renkleri ve tecvid renkleri Faz 1–2'de palete **rol** olarak eklenir ve kontrast testine girer.
- **Tipografi:** arayüz sistem fontu; Kur'an metni DigitalKhatt; meal metni okunaklı gövde boyutu (en az 16, ayarlanabilir). Arapça arayüz metni sistemin Arapça fontuyla.
- **Simgeler:** Material Symbols (çizgi stili); dini kavramlar için figür/hayvan/karakter kullanılmaz (YASAK-12). Sure başlığı süslemesi sade çerçeve; ileride sure adı fontu (F0-05 notu).
- **Boşluk:** 4'ün katları (`AppSpacing`); okuma ekranında kenar boşluğu geniş, liste ekranlarında standart.
- **Ses ve titreşim:** varsayılan sessiz; yalnızca kullanıcı açarsa.
- **Metin dili:** kısa, ikinci tekil şahıs ve saygılı ("Okumaya devam et", "Bugün 5 ayet okudun"). Ünlem, aciliyet ve suçlama yok.

---

## 10. Açık tasarım soruları

| # | Soru | Öneri | Karar |
|---|---|---|---|
| ET-1 | Sekme adı "Ben" mi "Profil" mi? | "Ben": hesapsız kullanımda "profil" yanıltıcı | ⏳ |
| ET-2 | Bugün ekranında günün ayeti her gün mü değişsin, kullanıcı mı seçsin? | Her gün değişir; yer imlerinden "favori ayetler" seçeneği | ⏳ |
| ET-3 | Okuma açılışta hangi görünümde başlasın? | Son kullanılan görünüm (F0-06'da kalıcı) | ✅ Uygulanıyor |
| ET-4 | Ayet görünümünde varsayılan: tüm sure listesi mi, tek ayet odak mı? | Liste; odak modu seçenek | ⏳ |
| ET-5 | Sayfa okları varsayılan açık mı? | Kapalı (kaydırma yeterli); ayarlardan açılır | ⏳ |
| ET-6 | Marka rengi ve logo | Uygulama adı (AK-04) ile birlikte | ⏳ |
| ET-7 | Hafızlık sekmesi Faz 1'de görünsün mü? | Görünsün, "yakında" boş durumuyla (sekme yerleşimi sonradan değişmesin, Y-05) | ⏳ |

---

## Değişiklik Geçmişi
| Tarih | Değişiklik |
|---|---|
| 29.10.2026 | İlk taslak (v0.1): rakip dersleri, ilkeler, bilgi mimarisi, E-01…E-29, tablet düzenleri, etkileşim kuralları, bileşen kataloğu |
