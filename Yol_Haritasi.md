# Yol Haritası

> **Bağlı dokümanlar:** `Proje_Gereksinimleri.md` (ne yapılacak), `Fazlar/Faz_N.md` (fazın detaylı iş listesi), `Ekran_Tasarimi.md` (tüm fazların ekranları; her faz kendi E-xx ekranlarını uygular).
> **Kural:** Bir faz dosyası sadece o faza başlarken yazılır. Faz bitince bu dosyadaki durum güncellenir.
> **Son güncelleme:** 29.10.2026

## Fazlar

| Faz | Ad | Kapsam (gereksinim kodları) | Çıktı | Durum |
|---|---|---|---|---|
| **0** | Temel ve İskelet | Mimari, veri altyapısı, Kur'an verisi, mushaf çizim denemesi, test ve CI altyapısı (MK-01…MK-09, T-01, T-02) | Çalışan iskelet: bir mushaf sayfası veritabanından doğru çiziliyor | ✅ Tamamlandı (29.10.2026; açık kalanlar Faz 1'e devredildi) |
| **1** | Okuyucu | M2, M3, M4, M5, M6, M13, M16 | Tam özellikli, çevrimdışı okuma ve dinleme | 🔨 Devam ediyor (`Fazlar/Faz_1.md`) |
| **2** | Alışkanlık ve Hafızlık | M7, M8, M10, M12, M14 (yerel kısımlar), M1 arayüzü (sahte servisle) | v1.0'ın tüm özellikleri, sunucusuz | ⬜ |
| 🔒 | **Kilometre taşı: Veri Modeli Dondurma** | Kullanıcı veri modeli + `API_Sozlesmesi.md` dondurulur | | ⬜ |
| **3** | Sunucu, Senkron ve Beta | Sunucu (ASP.NET Core, AK-03), M1 gerçek entegrasyon, M14-02, senkron testleri, kapalı beta (Y-01) | **v1.0 yayını** | ⬜ |
| **4** | Eğitim ve Ödeme | M9, M11, M15 | **v1.1 yayını** | ⬜ |
| **5** | Genişleme | Çalma listesi, Warş/Kalûn, hafız-hoca modu, yeni ders yolları; v2.0 kararları | v1.2+ | ⬜ |

### Fazlara göre ekranlar (`Ekran_Tasarimi.md`)
| Faz | Ekranlar |
|---|---|
| 1 | Bilgi mimarisi ve alt sekmeler (§3); E-02 Bugün (temel), E-03 Kur'an dizini, E-04/E-05 Okuma, E-06 Ayet eylemleri, E-07 Kelime kartı, E-08 Meal/Tefsir, E-09 Oynatıcı, E-10 Okuma ayarları, E-11 Arama, E-12 Kayıtlarım, E-13 İndirmeler, E-14 Ayarlar, E-15 Hakkında, E-16 Okuma ilerlemeleri |
| 2 | E-01 Karşılama, E-02 Bugün (hedef, seri, tekrar), E-17…E-20 Hafızlık, E-21…E-23 Alışkanlık, E-24 Zikir, E-25 Bildirimler, E-26 Hata bildir (yerel) |
| 3 | E-27 Hesap, senkron, yedek; E-26 Destek (sunucu) |
| 4 | Dersler sekmesi, E-28 Ders yolları ve ders, E-29 Abonelik |

**Durum simgeleri:** ⬜ Başlamadı · ⏳ Hazırlanıyor · 🔨 Devam ediyor · ✅ Tamamlandı

## Paralel İş Akışları (kod dışı)

Bu işler geliştirmeyle aynı anda yürür ve aşağıdaki fazları bloklar.

| İş | İlgili karar | Bloklayacağı faz | Durum |
|---|---|---|---|
| **Diyanet Kurul onayı (dijital Kur'an yayını)** | AK-14 | v1.0'ı bloklamaz (kullanıcı kararı 29.10.2026); Türkiye düzeni/font için sonra başvurulur. | ⏸ |
| Mushaf düzeni kaynağı ve lisansı | AK-11 | Faz 1 sonu (yayın lisansı); geliştirme açık veriyle başlar. **Türkiye düzeni (M2-02 [Z]) için veri araştırması Faz 1'in ilk işi (F1-03).** | ⬜ |
| Meal, tefsir ve kari lisansları | AK-05 | Faz 1 sonu (paketlenecek varsayılan meal, M16-01), Faz 3 (diğerleri) | ⬜ |
| Uygulama adı ve marka | AK-04 | Faz 0 (paket adı), Faz 3 (mağaza) | ⬜ |
| KVKK hukuki danışmanlık | AK-09 | Faz 3 (yayın öncesi) | ⬜ |
| İçerik kurulu ve ders hocaları | AK-06 | Faz 4 içerik üretimi | ⬜ |
| İlk ders yolları ve müfredat; **içerik üretimi** (2 yol × 30 ders) | AK-12 | Faz 4 | ⬜ (Faz 1 sırasında başlamalı) |
| Fiyatlar | AK-10 | Faz 4 | ⬜ |

## Yayın Öncesi Hatırlatmalar
- [ ] Geçici paket adı `com.example.quranapp`, **ilk mağaza yüklemesinden önce** kalıcı adla değiştirilecek (Faz 3). Kişisel ad kullanılmayacak.
- [ ] Görünen uygulama adı marka kararıyla (AK-04) güncellenecek.

## Faz Geçiş Kuralları
1. Bir faz, faz dosyasındaki tüm **[Z]** iş paketleri "bitti" kriterlerini karşılayınca kapanır.
2. Kapanmayan [Ö] ve [İ] işler sonraki faza veya yapılacaklar listesine taşınır ve bu dosyaya not edilir.
3. Her faz sonunda `Proje_Gereksinimleri.md` ile kısa bir uyum kontrolü yapılır (yasaklar ve ilkeler).

## Değişiklik Geçmişi
| Tarih | Değişiklik |
|---|---|
| 28.10.2026 | İlk sürüm |
| 28.10.2026 | Faz 0 başladı |
| 29.10.2026 | Fazlara göre ekran eşlemesi eklendi (`Ekran_Tasarimi.md`) |
| 29.10.2026 | Faz 0 kapandı (kullanıcı kararı). Kapanmayan [Z] maddeler (iOS ilk CI çalışması, CI kırmızı denemesi, F0-05 sonuç raporu ve ertelenen 2 doğrulama, TalkBack elle kontrolü) Faz 1'e taşındı: `Faz_1.md` F1-00 (faz geçiş kuralı 2). Faz 1 başladı; tüm fazların ekranları `Ekran_Tasarimi.md`'de planlandı. |
