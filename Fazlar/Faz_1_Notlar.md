# Faz 1 Çalışma Notları

> **Amaç:** Faz 1'de her iş paketinde ve kararda **ne yapıldığını, neden öyle yapıldığını, hangi dosyaların değiştiğini ve bilinen sorunları** kayıt altına almak. `Faz_1.md` ne yapılacağını ve kutucukları tutar; bu dosya nasıl ve neden yapıldığını anlatır.
> **Bağlı dokümanlar:** `Faz_1.md`, `../Ekran_Tasarimi.md`, `../VERI_KAYNAKLARI.md`, `../CLAUDE.md`, `Faz_0_Notlar.md` (Faz 0 geçmişi)
> **Kural:** Her iş paketi bittiğinde buraya bir bölüm eklenir; sondaki "Genel durum" tablosu güncellenir.

## İçindekiler
1. [S9: Tanzil metninin uygulamadan çıkarılması ve meal lisansı](#1-s9-tanzil-metninin-uygulamadan-çıkarılması-ve-meal-lisansı)
2. [Genel durum ve bekleyen kararlar](#2-genel-durum-ve-bekleyen-kararlar)

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

## 2. Genel durum ve bekleyen kararlar
**Son güncelleme:** 29.10.2026

| İş paketi | Durum |
|---|---|
| S9 (Tanzil metni uygulamadan çıkarıldı) | ✅ |
| F1-00 Faz 0'dan devredilenler | ⬜ |
| F1-01 … F1-14 | ⬜ |

**Bekleyen kararlar ve işler**
- **Yayın meali (S1, S2), karar Faz 1 sonunda (kullanıcı, 29.10.2026):** Kullanıcı, uygulama ticari olacağı için Diyanet'in izin vermeyeceğini düşünüyor. Bu yüzden **kamu malı yedek meal gerçek bir seçenek olarak hazırlanacak**: kaynak doğrulaması, metin hattı ve okunabilirlik değerlendirmesi F1-05 içinde yapılacak. Diyanet başvurusu yine de denenebilir. Geliştirme Diyanet mealiyle sürüyor.
- **Faz 1 başlangıç kararları S1–S8 ve TK-11…TK-17:** öneri halinde; itiraz yoksa uygulanır.
- **Ekran tasarımı açık soruları ET-1…ET-7** (`Ekran_Tasarimi.md` §10).
- **Emülatör:** içerik sürümü 7'ye çıktı; uygulama güncel kodla ilk açılışta yeni veritabanını kendiliğinden kopyalar ve eskisini siler.
