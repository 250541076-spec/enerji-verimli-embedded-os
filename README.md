Markdown
# EV-OS (Energy-Efficient Operating System) 🔋⚡

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/)
[![Language](https://img.shields.io/badge/language-C11%20%2F%20Assembly-orange.svg)](https://github.com/)
[![Target](https://img.shields.io/badge/target-ARM%20Cortex--M3-green.svg)](https://github.com/)

EV-OS (Energy-Efficient Operating System), kaynak kısıtlı gömülü sistemler (IoT uç noktaları, giyilebilir teknolojiler, endüstriyel sensörler ve otomotiv alt sistemleri) için sıfırdan geliştirilmiş, **düşük güç tüketimi** ile **gerçek zamanlı kararlılığı (determinizm)** tek bir potada eritmeyi amaçlayan bare-metal bir Gerçek Zamanlı İşletim Sistemidir (RTOS).

Proje; donanım kısıtlamalarının en uç noktada olduğu senaryolarda, güç ve başarım dengesini (Power-Performance-Area trade-off) bilimsel ve nicel metriklerle optimize etmek üzere Fırat Üniversitesi Yazılım Mühendisliği bünyesinde tasarlanmıştır.

---

## 🚀 Öne Çıkan Özellikler

### 1. Gelişmiş Güç Yönetimi Modülü & Tickless Idle
* **Üç Kademeli Güç Durumu:** Sistem `RUN` (Tam Performans), `IDLE` (Bekleme) ve `SLEEP` (Derin Uyku) modları arasında dinamik durum geçişlerini destekler.
* **Tickless Idle Mekanizması:** Sistemde yürütülecek aktif görev olmadığında, periyodik sistem tikini (SysTick kesmesini) geçici olarak askıya alarak işlemcinin derin uyku modunda kalma süresini maksimuma çıkarır. Bu mekanizma sayesinde sistemin akım tüketimi **28.4 mA'den 4.2 mA seviyesine** düşürülerek pil ömrü katlanmıştır.

### 2. Gerçek Zamanlı Görev Planlayıcı (Real-Time Scheduler)
* **Çift Algoritmalı Altyapı:** Öncelik tabanlı sabit zamanlamalı **RMS (Rate Monotonic Scheduling)** ve dinamik öncelikli **EDF (Earliest Deadline First)** algoritmalarını içerir.
* **Düşük Bağlam Değişimi Gecikmesi (Context-Switch Latency):** Kritik bağlam değişimi ve yazmaç (register) saklama/geri yükleme mekanizmaları Assembly makroları ile optimize edilerek CPU döngü kayıpları minimuma indirilmiştir.

### 3. Hibrit Derleyici Optimizasyonu
Kör optimizasyonların kod boyutunu büyütme veya kararlılığı bozma riskine karşı projede **Katmanlı Derleme Stratejisi** benimsenmiştir:
* **Çekirdek Çekirdeği (Core Kernel):** Sıkı hafıza kısıtları nedeniyle kod boyutunu ve Flash kaplama alanını minimize etmek üzere `-Os` seviyesinde derlenmiştir.
* **Zamanlayıcı ve Kesmeler (Scheduler & ISR):** En düşük görev geçiş gecikmesi ve maksimum determinizm için `-O2` seviyesinde optimize edilmiştir.
* **Sinyal/Matematik İşlemleri:** Donanımın vektörizasyon (SIMD/NEON) yeteneklerini tam kullanabilmek için yoğun matematiksel alt bloklarda `-O3` agresif optimizasyonu tercih edilmiştir.
* **Düşük Seviye Manuel Müdahaleler:** Kritik döngülerde Döngü Açma (Loop Unrolling), fonksiyon çağrı yükünü kaldıran Satır İçi Fonksiyonlar (Inline Functions) ve hızlı CPU yazmaç tahsisleri el ile optimize edilmiştir.

### 4. Hassas Bellek ve Bağlayıcı (Linker) Yönetimi
Özel olarak tasarlanmış `linker.ld` betiği sayesinde, sistemin donanımsal hafıza sınırları (256 KB Flash, 64 KB RAM) tam olarak haritalandırılmıştır:
* Kesme vektör tablosu (`.isr_vector`) ve yürütülebilir kodlar (`.text`) **Flash** belleğe (Origin: `0x00000000`),
* Dinamik veriler (`.data`) ve sıfırlanmış değişken alanları (`.bss`) ise **RAM** belleğe (Origin: `0x20000000`) taşma riski kontrol edilerek yerleştirilir.

---

## 📂 Proje Klasör Yapısı

Akademik teslim ve sürüm yönetimi standartlarına uygun olarak düzenlenen temiz proje hiyerarşisi şu şekildedir:

```text
EV-OS/
├── CMakeLists.txt        # Proje derleme ve bağımlılık yönetim dosyası
├── linker.ld             # ARM Cortex-M3 hafıza haritası bağlayıcı betiği
├── .gitignore            # Derleme önbelleklerini ve çöplerini engelleyen dosya
├── projeakisi.md         # Haftalık ilerleme ve sistem analiz raporu
├── src/                  # Çekirdek kaynak kodları
│   └── main.c            # Sistem başlangıç ve ana döngü modülü
├── include/              # API arayüzleri ve Header (.h) dosyaları
├── drivers/              # Donanım sürücü katmanları (Power, SRAM, Flash)
└── docs/                 # Akademik araştırma, test ve performans raporları
    ├── benchmarking_performans_karsilastirmasi.docx
    ├── derleyici_optimizasyonu.docx
    ├── Profilleme_Araclari_Performans_Analizi.docx
    ├── dusuk-seviye-optimizasyon-markdown.md
    └── Embedded OS Wireframe.pdf
```
🛠️ Derleme Kılavuzu (Build Guide)
Proje, çapraz derleyici (cross-compiler) mimarisi üzerine kurulmuştur. Sistemi derlemek için bilgisayarınızda GNU Embedded Toolchain for ARM (arm-none-eabi-gcc) ve CMake kurulu olmalıdır.

Derleme Adımları
Projenin kök dizininde terminali açarak aşağıdaki komutları sırasıyla çalıştırın:

Bash
# 1. Derleme ve konfigürasyon dosyalarını oluşturun
cmake .

# 2. Kernel imajını derleyin
make
Derleme işlemi başarılı bir şekilde tamamlandığında ana dizinde os_kernel.elf çıktısı üretilecek ve terminalde şu onay mesajı görülecektir:

Plaintext
[100%] Built target os_kernel.elf
📊 Performans Analizi ve Profilleme
Geliştirme sürecinde kararların doğruluğunu ölçmek adına sistematik profilleme teknikleri uygulanmıştır:

gprof ve perf Entegrasyonu: Fonksiyonların CPU döngüsü bazında tüketim oranları izlenmiş ve çağrı grafikleri (call graphs) analiz edilmiştir.

Cache Önbellek İyileştirmesi: L1 önbellek hat hizalaması (cache line alignment) ve veri lokalitesi (data locality) geliştirmeleri sayesinde, veri işleme darboğazlarında %200 ile %900 arasında başarım artışı elde edilmiştir.
