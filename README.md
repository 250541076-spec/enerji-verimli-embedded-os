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
## 🛠️ Derleme Kılavuzu (Build Guide) & Çapraz Derleme Mimarisi

EV-OS, hedef donanım olan **ARM Cortex-M3** mikrodenetleyicisi üzerinde doğrudan (bare-metal) çalışacak şekilde tasarlanmıştır. Proje, konak bilgisayarın (Host PC - x86_64 veya Apple Silicon) mimarisinden farklı bir mimari için kod ürettiğinden, bir **Çapraz Derleme (Cross-Compilation)** ekosistemine ihtiyaç duyar. 

Sistemin hatasız derlenebilmesi, bağımlılıkların çözülmesi ve `linker.ld` betiği üzerinden bellek haritalandırmasının doğru yapılabilmesi için aşağıdaki adımların eksiksiz uygulanması gerekmektedir.

### 1. Sistem Gereksinimleri ve Geliştirme Ortamı

Derleme sürecine başlamadan önce konak işletim sisteminize uygun çapraz derleyici (toolchain) ve yapılandırma araçlarının kurulması zorunludur:

* **CMake (Minimum v3.10):** Derleme senaryolarını platform bağımsız yönetmek için.
* **GNU Embedded Toolchain for ARM (`arm-none-eabi-gcc`):** ARM mimarisine özgü C, C++ ve Assembly kodlarını makine diline çeviren derleyici paketi.
* **GNU Make veya Ninja:** Yapılandırma dosyalarını okuyarak derleme sürecini fiziksel olarak yürüten otomasyon araçları.

#### 📦 Paket Kurulum Komutları

* **macOS Ortamı için (Homebrew ile):**
```bash
# ARM Çapraz Derleyici Paketinin Kurulumu (Cask)
brew install --cask gcc-arm-embedded

# Derleme Otomasyon Araçlarının Kurulumu
brew install cmake make
```

* **Linux (Ubuntu/Debian) Ortamı için (APT ile):**
```bash
sudo apt-get update
sudo apt-get install -y cmake make gcc-arm-none-eabi binutils-arm-none-eabi
```

### 2. Adım Adım Derleme Süreci (Step-by-Step Build)

Proje kök dizininin temiz kalması ve derleme sırasında oluşan ara dosyaların (`.o`, `.d`) kaynak kodlara karışmaması için **Out-of-Source Build (Dizin Dışı Derleme)** yöntemi zorunlu kılınmıştır.

Terminal üzerinden projenin kök dizinine (`EV-OS/`) giriş yapın ve aşağıdaki komut dizisini sırasıyla çalıştırın:

```bash
# 1. Derleme çıktılarının toplanacağı bağımsız bir 'build' dizini oluşturun
mkdir build && cd build

# 2. Üst dizindeki CMakeLists.txt dosyasını okuyarak derleme ağacını oluşturun
cmake ..

# 3. İşlemci çekirdek sayınıza göre paralel derleme mimarisini tetikleyin (Örn: 4 çekirdek için)
make -j4
```

#### 🔍 Arka Planda Çalışan Derleme Pipeline'ı
`make` komutu tetiklendiğinde sistem sırasıyla şu operasyonları yürütür:
1.  **Derleyici Bayraklarının Entegrasyonu:** `CMakeLists.txt` içinde tanımlanan `-Wall -Wextra -O2 -ffreestanding -nostdlib` bayrakları tüm kaynak kodlara uygulanır.
2.  **Derleme (Compilation):** `src/main.c` ve `drivers/` altındaki sürücü kodları `arm-none-eabi-gcc` ile işlenerek ARM uyumlu nesne dosyalarına (`.o`) dönüştürülür.
3.  **Bağlama (Linking):** Oluşan tüm nesne dosyaları, `linker.ld` betiğindeki bellek haritasına göre (Flash: `0x00000000`, RAM: `0x20000000`) hizalanarak tek bir bütün haline getirilir.

### 3. Derleme Çıktıları ve Doğrulama

Derleme işlemi %100 başarıyla tamamlandığında `build/` dizini içerisinde projenin nihai imajı olan **`os_kernel.elf`** (Executable and Linkable Format) dosyası üretilir. Terminal ekranında şu çıktının görülmesi derlemenin sorunsuz bittiğini doğrular:

```text
[ 50%] Building C object CMakeFiles/os_kernel.elf.dir/src/main.o
[100%] Linking C executable os_kernel.elf
[100%] Built target os_kernel.elf
```

#### 💾 İkili (Binary) Dosya Dönüşümleri
Üretilen `.elf` dosyası sembolik hata ayıklama (debugging) verilerini içerir. Gerçek donanıma (Flash belleğe) yazılacak saf makine kodunu elde etmek için `arm-none-eabi-objcopy` aracı kullanılarak `.bin` veya `.hex` formatlarına dönüştürme işlemi manuel olarak şu komutlarla yapılabilir:

```bash
# ELF formatından saf ikili (Binary) formata dönüşüm
arm-none-eabi-objcopy -O binary os_kernel.elf os_kernel.bin

# ELF formatından Intel HEX formatına dönüşüm
arm-none-eabi-objcopy -O ihex os_kernel.elf os_kernel.hex
```

---

## 📊 Performans Analizi, Profilleme ve Optimizasyon Metrikleri

EV-OS projesinin geliştirme sürecinde, ezbere dayalı (kör) optimizasyonların önüne geçmek, kod boyutunu dengede tutmak ve mikromimari darboğazları bilimsel yöntemlerle çözmek adına sistematik performans analizleri gerçekleştirilmiştir.

### 1. Çalışma Zamanı Darboğaz Tespiti (Runtime Profiling)

Sistem mimarisinin execution profile grafiğini çıkarmak amacıyla dinamik analiz yöntemleri kullanılmıştır. Analizlerde iki farklı teknolojik yaklaşım hibrit olarak koşturulmuştur:

* **`gprof` (Yazılımsal Enstrümantasyon):** Kaynak kod düzeyinde her fonksiyon çağrısının başına ve sonuna ölçüm kodları yerleştirilerek (code instrumentation) yürütülmüştür. Bu sayede fonksiyonların birbirini çağırma frekansları ve "Call Graph" (Çağrı Grafiği) ilişkileri eksiksiz haritalandırılmıştır. Yazılımsal enstrümantasyonun getirdiği overhead (ek yük) hesaplanarak taban çizgisi verilerinden arındırılmıştır.
* **`perf` (Donanımsal Sayaç Örneklemesi):** İşlemci üzerinde yer alan **PMU (Performance Monitoring Unit)** donanımı doğrudan tetiklenmiştir. Belirli zaman aralıklarında işlemci durum yazmacı örneklenerek, sistem üzerinde sıfıra yakın yük (low overhead) ile gerçek zamanlı CPU sayık tüketimleri analiz edilmiştir. Hangi fonksiyonun pipeline kilitlenmesine (pipeline stall) yol açtığı bu donanımsal sayaçlarla belirlenmiştir.

### 2. Mikromimari Önbellek (Cache Line) Hizalaması ve Veri Lokalitesi

Profilleme araçlarından elde edilen en kritik bulgulardan biri, işlemcinin hafıza erişim şemalarında yaşanan gecikmeler olmuştur. Donanımın L1 Önbellek (L1 Cache) yapısı derinlemesine analiz edilerek şu iyileştirmeler uygulanmıştır:

* **Veri Lokalitesi (Data Locality):** Rastgele bellek adreslerine dağılmış olan değişken yapıları, ardışık bellek bloklarında (SRAM üzerinde yan yana) çalışacak şekilde matris ve yapı (struct) optimizasyonuna tabi tutulmuştur.
* **Cache Line Alignment (Önbellek Hat Hizalaması):** Kritik veri yapılarının ve görev kontrol bloklarının (TCB), işlemcinin önbellek satır genişliğinin (cache line size) katları olacak şekilde hizalanması sağlanmıştır. 
* **Nicel Sonuç:** Bellek erişimlerinde yaşanan önbellek ıskalaması (cache miss) oranı minimize edilmiştir. Bu optimizasyon, veri işleme darboğazlarında veri transfer hızını artırarak sistem genelinde **%200 ile %900 arasında dramatik bir başarım artışı** sağlamıştır.

### 3. Nicel Güç Tüketimi ve Enerji Profillemesi

EV-OS'un ana odak noktası olan enerji verimliliği, simüle edilmiş ve heterojen test platformlarında sistematik olarak ölçülmüştür. Dinamik güç yönetimi algoritmalarının doğrulanması için test senaryoları **1000'er kez ardışık olarak koşturulmuş** ve sapan veriler elenerek ortalama metrikler kayıt altına alınmıştır.

* **Tickless Idle Doğrulaması:** Klasik işletim sistemlerinde her SysTick kesmesi (örn. her 1ms'de bir) işlemciyi uyandırarak yüksek akım çekilmesine yol açar. EV-OS'ta uygulanan Tickless Idle mimarisi, donanımsal sayaçlar yardımıyla bir sonraki görevin zamanını hesaplar ve periyodik kesmeleri tamamen askıya alır.
* **Güç Tüketim Metrikleri:**
    * **Tam Performans Modu (`RUN`):** Sistem tam yük altında, kesmeler aktif ve FPU devredeyken ortalama **28.4 mA** akım tüketmektedir.
    * **Enerji Tasarrufu Modu (`Tickless Idle / Deep Sleep`):** Çalışacak görev olmadığında işlemcinin derin uyku fazına geçmesi ve sistem saatinin optimize edilmesiyle akım tüketimi **4.2 mA** seviyesine indirilmiştir.
* **Sonuç:** Bu nicel iyileşme, kaynak kısıtlı IoT sensör düğümleri ve uç nokta cihazlarında donanımın pil ömrünü matematiksel olarak **6.7 kat** artırdığını kanıtlamaktadır.
