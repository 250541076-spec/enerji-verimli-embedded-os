# Teknoloji Araştırması ve Seçimi

## Gömülü Sistemler için Enerji Verimli İşletim Sistemi
**Sorumlu:** Yasemin Ubeyd

---

## 1. Giriş
Bu bölümde, “Gömülü Sistemler için Enerji Verimli İşletim Sistemi” projesi için en uygun teknolojiler araştırılmış ve sistem gereksinimlerine göre ayrıntılı biçimde değerlendirilmiştir.  

Projenin temel amacı; düşük güç tüketimi sağlayan, gerçek zamanlı çalışabilen, sınırlı donanım kaynaklarına sahip gömülü cihazlarda güvenilir şekilde çalışacak bir işletim sistemi geliştirmektir.

Teknoloji seçimi yapılırken şu kriterler dikkate alınmıştır:
- Düşük bellek kullanımı  
- Enerji verimliliği  
- Gerçek zamanlı çalışma  
- ARM uyumluluğu  
- Donanıma yakın kontrol  
- Taşınabilirlik  
- Geliştirme kolaylığı  
- Hata ayıklama desteği  
- Topluluk desteği  

---

## 2. Teknoloji Seçim Kriterleri

### Düşük Bellek Kullanımı
Gömülü sistemler sınırlı RAM’e sahiptir, bu yüzden düşük bellek kullanımı kritik önemdedir.

### Gerçek Zamanlı Performans
Görevlerin zamanında tamamlanması gerekir.

### Enerji Verimliliği
Pil ömrünü uzatmak için düşük güç tüketimi gerekir.

### ARM Uyumluluğu
Hedef donanım ARM olduğu için tüm araçlar uyumlu olmalıdır.

### Donanıma Yakınlık
Düşük seviyeli kontrol gereklidir.

### Geliştirme Kolaylığı
Ekip tarafından sürdürülebilir olmalıdır.

### Topluluk Desteği
Dokümantasyon ve topluluk önemli avantaj sağlar.

---

## 3. Programlama Dili: C ve Assembly

### C Dilinin Avantajları
- Donanıma yakın çalışma  
- Yüksek performans  
- Düşük bellek kullanımı  
- ARM desteği  

### C Dilinin Dezavantajları
- Bellek güvenliği zayıf  
- Pointer hataları riskli  

### Assembly Kullanımı
Kritik bölümlerde kullanılır:
- Startup  
- Interrupt  
- Context switch  

---

## 4. Çekirdek Yaklaşımı

### Embedded Linux
**Avantaj:**
- Geniş destek  

**Dezavantaj:**
- Ağır  

### Minimal Kernel
**Avantaj:**
- Hafif  
- Enerji verimli  

**Dezavantaj:**
- Geliştirmesi zor  

👉 **Seçim: Minimal Kernel**

---

## 5. Donanım: ARM Cortex-M

### Avantajları
- Düşük güç tüketimi  
- Gerçek zamanlı uygun  

---

## 6. Derleyici
**ARM GNU Toolchain (arm-none-eabi-gcc)**

---

## 7. Derleme Sistemi
**CMake + Makefile**

---

## 8. Debug & Simülasyon

- GDB  
- OpenOCD  
- QEMU  

---

## 9. Version Control
**Git + GitHub**

---

## 10. Özet Tablo

| Kategori | Teknoloji |
|--------|---------|
| Dil | C |
| Low-level | Assembly |
| Kernel | Minimal |
| CPU | ARM Cortex-M |
| Toolchain | GNU |
| Build | CMake |
| Debug | GDB |
| Simülasyon | QEMU |
| VCS | Git |

---

## 11. Genel Değerlendirme
Seçilen yapı:
- düşük güç  
- gerçek zamanlı  
- düşük bellek  
- yüksek kontrol  

---

## 12. Sonuç
Bu proje için en uygun teknoloji:

- C + Assembly  
- ARM Cortex-M  
- Minimal Kernel  

olarak belirlenmiştir.
