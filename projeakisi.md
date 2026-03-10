PROJE HAFTALIK GÖREV RAPORU
Gömülü Sistemler için Enerji Verimli İşletim Sistemi
Mart 2026


BÖLÜM 1 — EZGİ



1.1  Bu Proje Nedir ve Neden Gerekli?
Günümüzde akıllı saatler, endüstriyel sensörler, tıbbi cihazlar ve otonom araçlar gibi milyarlarca cihaz küçük işlemciler üzerinde çalışmaktadır. Bu cihazların ortak sorunu şudur: sınırlı pil ömrü ile gerçek zamanlı, güvenilir çalışma zorunluluğu aynı anda karşılanmak zorundadır.
Bu proje; düşük güç tüketimi ve gerçek zamanlı performansı birlikte sağlayan, gömülü cihazlar için optimize edilmiş bir işletim sistemi geliştirmeyi hedeflemektedir. Kullanılan teknolojiler: C, Assembly, Linux Kernel ve ARM mimarisi.

1.2  Projenin Temel Hedefleri
Proje beş ana bileşen etrafında şekillenmiştir:



1.3  Kapsam — Ne Yapılacak, Ne Yapılmayacak?
Kapsam Dahilinde
ARM Cortex-M üzerinde çalışan, C ile yazılmış minimal çekirdek
RUN / IDLE / SLEEP güç durumları arasında geçiş yapabilen güç yönetimi modülü
RMS (Hız Monoton) ve EDF (En Erken Son Tarih) algoritmalarını destekleyen görev planlayıcısı
256 KB RAM sınırı altında çalışabilen bellek yönetimi
Gecikme, güç tüketimi ve zamanlama doğruluğunu ölçen donanım test raporları

Kapsam Dışı
Grafik kullanıcı arayüzü (ekran, buton vb. ile etkileşim)
Wi-Fi, Bluetooth gibi kablosuz iletişim protokol yığınları
Bulut entegrasyonu veya mobil uygulama

1.4  Mevcut Durum Analizi
Piyasada FreeRTOS, Zephyr ve ChibiOS gibi açık kaynak RTOS seçenekleri bulunmaktadır. Ancak her birinin belirgin kısıtları vardır:



Akademik literatür de bu boşlukları doğrulamaktadır: Taheri ve ark. (2020), standart zamanlama algoritmalarının enerji ve tamamlanma süresini aynı anda optimize edemediğini göstermektedir. Cao ve ark. (2019) ise mevcut çözümlerin hata toleransını sistem ömrüyle birlikte ele almadığını tespit etmektedir. Bu eksiklikler, projenin özgün değerini ortaya koymaktadır.

1.5  Projenin Potansiyel Etkileri


BÖLÜM 2 — YASEMİN



2.1  Teknoloji Seçim Kriterleri
Dört ana kategori için teknoloji araştırması yapılmıştır: programlama dili, çekirdek yaklaşımı, derleme araç zinciri ve versiyon kontrol sistemi. Her alternatifte değerlendirilen kriterler şunlardır: bellek kullanımı, gerçek zamanlı destek, enerji yönetimi kabiliyeti, ARM uyumluluğu ve topluluk/dokümantasyon olgunluğu.

2.2  Programlama Dili: C ve Assembly
Çekirdek geliştirmede C birincil dil, Assembly ise donanıma özgü kritik bölümler için tamamlayıcı dil olarak seçilmiştir.



Alternatif: Rust, bellek güvenliği açısından üstündür. Ancak Sharma ve ark. (2024), mevcut gömülü Rust araç zinciri ve kütüphane ekosisteminin henüz olgunlaşmadığını saptamaktadır. Bu nedenle ilk sürüm C/Assembly ile geliştirilecek; ileride Rust geçişi değerlendirilecektir.

2.3  Çekirdek Yaklaşımı: Özel Minimal Çekirdek
İki temel yaklaşım değerlendirilmiştir: mevcut Linux çekirdeğinin küçültülmesi (Embedded Linux) ya da sıfırdan minimal çekirdek yazılması.



Karar: ≤256 KB RAM kısıtı nedeniyle tam Linux kullanılamaz. Linux çekirdek mimarisinin tasarım prensipleri referans alınarak özel minimal çekirdek geliştirilecektir.

2.4  Derleme Araç Zinciri: ARM GNU Toolchain


2.5  Teknoloji Seçimi Özet Tablosu


BÖLÜM 3 — HAMZA



3.1  Geliştirme Ortamı Neden Önemli?
Gömülü sistem geliştirmede, kod önce geliştirme bilgisayarında (host) yazılıp derlenir; ardından ARM işlemcili hedef donanıma yüklenir. Bu sürecin sorunsuz işlemesi için tüm ekip üyelerinin aynı araçları, aynı sürümlerde kurması zorunludur. Aksi hâlde 'bende çalışıyor ama sende çalışmıyor' sorunları kaçınılmazdır.

3.2  Kurulacak Araçlar


3.3  Kurulum Adımları (Ubuntu 22.04 / WSL2)
Windows kullanıcıları WSL2 (Windows Subsystem for Linux) kurarak aynı adımları uygulayabilir.

Adım 1 — ARM Araç Zinciri
ARM developer sitesinden güncel toolchain indirilir.
Arşiv /opt/arm-toolchain dizinine çıkarılır.
~/.bashrc dosyasına PATH satırı eklenir.
arm-none-eabi-gcc --version komutuyla kurulum doğrulanır.

Adım 2 — CMake ve Make
sudo apt install cmake make komutuyla kurulur.
cmake --version → 3.20 veya üzeri görünmelidir.

Adım 3 — OpenOCD ve GDB
sudo apt install openocd gdb-multiarch komutuyla kurulur.
openocd --version ile test edilir.
VS Code'a Cortex-Debug eklentisi kurularak OpenOCD ile entegrasyon sağlanır.

Adım 4 — QEMU ARM Simülatörü
sudo apt install qemu-system-arm komutuyla kurulur.
Basit bir test ikili dosyası ile Cortex-M simülasyonu çalıştırılarak doğrulanır.

Adım 5 — VS Code Yapılandırması
C/C++, CMake Tools ve Cortex-Debug eklentileri kurulur.
.vscode/ altında settings.json, launch.json ve c_cpp_properties.json yapılandırılır.
ARM araç zinciri yolu IntelliSense için c_cpp_properties.json'a eklenir.

3.4  Ortam Doğrulama Kontrol Listesi


3.5  Sık Karşılaşılan Sorunlar


BÖLÜM 4 — SABİHA



4.1  Versiyon Kontrol Sistemi Neden Gerekli?
Beş kişilik bir ekipte herkes aynı kod tabanı üzerinde çalışmaktadır. Versiyon kontrol sistemi olmadan 'kim neyi değiştirdi', 'eski sürüme nasıl dönülür' ve 'iki kişi aynı dosyayı aynı anda değiştirirse ne olur' sorularının yanıtı yoktur. Git; bu sorunları çözen, dağıtık ve ücretsiz bir versiyon kontrol sistemidir.

4.2  Kurulum ve İlk Yapılandırma Adımları
GitHub veya GitLab üzerinde yeni bir özel (private) depo oluşturulur.
Her ekip üyesi git config --global user.name ve user.email ile kimliğini tanımlar.
SSH anahtarı oluşturularak GitHub/GitLab hesabına eklenir (şifresiz push/pull için).
Depo yerel makineye klonlanır: git clone <depo-adresi>
Dal (branch) stratejisi belirlenir ve README.md ile ilk commit yapılır.
.gitignore dosyası oluşturularak derleme çıktıları (*.o, *.elf, build/) izleme dışı bırakılır.
GitHub/GitLab üzerinden her ekip üyesine collaborator/member erişimi tanımlanır.

4.3  Dal (Branch) Stratejisi


4.4  Önerilen Depo Dizin Yapısı


4.5  Temel Git Komutları — Hızlı Başvuru


BÖLÜM 5 — SUDE



5.1  Gereksinim Analizi Nedir ve Neden Önemlidir?
Gereksinim analizi; bir sistemin ne yapması gerektiğini (fonksiyonel gereksinimler) ve nasıl yapması gerektiğini (teknik/kalite gereksinimleri) net biçimde tanımlama sürecidir. İyi yapılmış bir gereksinim analizi olmadan geliştirme sürecinde kapsam kayması, zaman kaybı ve gereksiz yeniden yazma kaçınılmazdır.

5.2  Fonksiyonel Gereksinimler
Fonksiyonel gereksinimler, sistemin kullanıcıya veya donanıma sağlaması gereken davranışları tanımlar.



5.3  Teknik Gereksinimler
Teknik gereksinimler, sistemin nasıl çalışması gerektiğine dair ölçülebilir kısıtları ve standartları tanımlar.



5.4  Gereksinim Öncelik Özeti


5.5  Gereksinim Doğrulama Yöntemi
Her gereksinimin nasıl test edileceği ve kabul kriterlerinin ne olduğu aşağıda özetlenmiştir:


Proje İlerleme Planı

1️⃣ Ezgi – Proje Analizi ve Hedef Belirleme (İlk Adım)
Projenin temeli burada atılır. Çünkü diğer herkes senin belirlediğin çerçeveye göre çalışacak.
Sen şunları hazırlarsın:
Projenin amacı
Projenin kapsamı
Mevcut durum analizi (RTOS, FreeRTOS vb.)
Projenin potansiyel etkileri

2️⃣ Sude – Gereksinim Analizi
Senin analizinden sonra Sude şu soruya cevap verir:
Bu sistem tam olarak neleri yapmalı?
Sude iki tür gereksinim yazacak.
Fonksiyonel Gereksinimler
Sistem ne yapmalı?
Örnek:
sistem görev planlama yapmalı
enerji yönetimi sağlamalı
cihaz sürücülerini desteklemeli
Teknik Gereksinimler
Sistem nasıl çalışmalı?
Örnek:
ARM mimarisi desteklenmeli
düşük bellek kullanımı olmalı

3️⃣ Yasemin – Teknoloji Seçimi
Sude gereksinimleri belirledikten sonra Yasemin şu soruya cevap verir:
Bu gereksinimleri hangi teknolojiler karşılayabilir?
Yasemin araştırır:
programlama dili (C / Assembly)
RTOS seçenekleri
ARM mimarisi
Linux tabanlı mı olacak
Sonra avantaj ve dezavantaj yazar.

4️⃣ Hamza – Geliştirme Ortamı Kurulumu
Teknolojiler seçildikten sonra Hamza şu işi yapar:
Geliştirme ortamını hazırlar.
Kurulabilecek araçlar:
VS Code / CLion
GCC ARM toolchain
Make veya CMake
QEMU veya simülatör
Git
Sonra ortamın çalıştığını test eder.

5️⃣ Sabiha – Versiyon Kontrol Sistemi
Ortam hazır olduktan sonra Sabiha:
Git kurar
GitHub repo açar
proje klasörünü yükler
ekip üyelerini ekler

Projenin doğru sırası
En mantıklı sıra şu:
1️⃣ Ezgi → Proje analizi 2️⃣ Sude → Gereksinimler 3️⃣ Yasemin → Teknoloji seçimi 4️⃣ Hamza → Geliştirme ortamı 5️⃣ Sabiha → Git kurulumu
KAYNAKLAR

[1]  Poobalan, A., Zarandi, H.R., Shanthakumar, P. (2024). DyUnS: Dynamic and uncertainty-aware task scheduling for multiprocessor embedded systems. Sustainable Computing: Informatics and Systems, 43, 101013.
[2]  Taheri, G., Khonsari, A., Entezari-Maleki, R. ve Sousa, L. (2020). A hybrid algorithm for task scheduling on heterogeneous multiprocessor embedded systems. Applied Soft Computing, 91, 106202.
[3]  Cao, K., Zhou, J., Xu, G., Chen, M. ve Wei, T. (2019). Lifetime-aware real-time task scheduling on fault-tolerant mixed-criticality embedded systems. Future Generation Computer Systems, 100, 65–75.
[4]  Geng, X. ve ark. (2021). Real-time task scheduling and network device security for complex embedded systems. Microprocessors and Microsystems, 81, 103515.
[5]  Raj, C.A. (2025). Innovations in Real-Time Operating Systems (RTOS) for Safety-Critical Embedded Systems. Journal of Computer Science and Technology Studies, 7(3), 791–797.
[6]  Wang, K.C. (2023). Embedded Real-Time Operating Systems. Springer.
[7]  Scordino, C. ve ark. (2022). Embedded Operating Systems. Taylor & Francis / CRC Press.
[8]  Katal, A., Dahiya, S. ve Choudhury, T. (2023). Energy efficiency in cloud computing data centers. Cluster Computing, 26(3), 1845–1875.
[9]  Amar, S. ve ark. (2023). CHERIoT: Rethinking security for low-cost embedded systems. Microsoft Research.
[10] Mamur, H., Dicle, Z. ve Erdener, S. (2022). IoT based smart embedded system design for indoor plants tracking. UMAGD, 14(2), 611–618.
[11] Sharma, A. ve ark. (2024). Rust for embedded systems: Current state and open problems. ACM CCS 2024.
[12] Bharany, S. ve ark. (2022). Energy efficient fault tolerance techniques in green cloud computing. Sustainable Energy Technologies and Assessments, 53, 102613.
[13] TechRxiv. (2025). Real-Time Operating Systems (RTOS) Energy Efficiency and Fault Tolerance for IoT and Embedded Systems.
----
PROJE TANIMI VE KAPSAMI
Gömülü Sistemler için Enerji Verimli İşletim Sistemi
Mart 2026

1. PROJE GENEL BİLGİLERİ


2. GİRİŞ VE ARKA PLAN
Günümüz teknoloji dünyasında gömülü sistemler; akıllı cihazlardan endüstriyel otomasyon altyapısına, tıbbi cihazlardan otonom araçlara kadar son derece geniş bir uygulama yelpazesine yayılmaktadır. Bu sistemlerin ortak özelliği; sınırlı donanım kaynakları, gerçek zamanlı yanıt gereksinimleri ve uzun süreli pil ömrü beklentisi altında güvenilir şekilde çalışmak zorunda olmalarıdır.
Literatür incelendiğinde, gömülü sistemlerin enerji kısıtlamaları ile yazılım karmaşıklığı arasında derin bir gerilim yaşandığı görülmektedir. Amar ve ark. (2023), mevcut güvenlik çözümlerinin gömülü sistemlere uyarlanmasının güç tüketimi, maliyet ve gerçek zamanlı kısıtlamalar nedeniyle oldukça güç olduğunu belirtmektedir. Mamur ve ark. (2022) ise IoT tabanlı gömülü sistemlerin mikrodenetleyici teknolojilerindeki gelişimle birlikte daha erişilebilir ve ekonomik hale geldiğini vurgulamaktadır.
Bu bağlamda, düşük güç tüketimi ve gerçek zamanlı performansı bir arada sunan, gömülü cihazlar için optimize edilmiş bir işletim sisteminin geliştirilmesi hem akademik hem de pratik açıdan kritik bir ihtiyacı karşılamaktadır.

3. PROJENİN GENEL HEDEFLERİ
3.1 Birincil Hedefler
Bu projenin temel amacı; pil ömrünü uzatmak ve kaynak kısıtlamalı ortamlarda güvenilir çalışmayı sağlamak üzere, gömülü cihazlar için optimize edilmiş, enerji verimli bir işletim sistemi geliştirmektir. Projenin birincil hedefleri şu şekilde özetlenebilir:
Düşük güç tüketimli çekirdek mimarisi tasarlamak ve ARM mimarisi üzerinde C ve Assembly kullanarak gerçekleştirmek
Gerçek zamanlı performans gereksinimlerini karşılayan, öncelik tabanlı görev planlayıcısı (task scheduler) geliştirmek
Güç yönetimi modülü ile uyku modu (sleep mode), boşta kalma modu (idle mode) ve DVFS entegrasyonu sağlamak
Minimal bellek ayak izi ile çalışabilen, kaynak kısıtlı mikrodenetleyicilere uygun bir işletim sistemi ortamı oluşturmak
Donanım test ve doğrulama raporları ile sistemin işlevselliğini ve enerji verimliliğini ölçümlemek

3.2 İkincil Hedefler
Linux kernel mimarisi ve Gömülü Linux deneyimlerinden yararlanarak modüler ve genişletilebilir bir yazılım altyapısı kurmak
Çekirdek ve cihaz sürücülerinin birlikte tutarlı çalıştığı entegre bir sistem mimarisi oluşturmak
Enerji tasarrufu mekanizmalarının zamanlama garantilerini bozmadan uygulanabilirliğini doğrulamak
Geliştirilen sistemin farklı gömülü donanım platformlarına taşınabilirliğini desteklemek

4. PROJENİN KAPSAMI
4.1 Kapsam Dahilindeki Çalışmalar
Proje kapsamında gerçekleştirilecek çalışmalar aşağıda teslim edilecek bileşenler çerçevesinde tanımlanmıştır:
4.1.1 Çekirdek ve Cihaz Sürücüleri
ARM mimarisi üzerinde C ve Assembly dilleri kullanılarak geliştirilecek olan çekirdek; kesme yönetimi, bellek koruma birimi (MPU) yapılandırması ve donanım soyutlama katmanlarını kapsayacaktır. Scordino ve ark. (2022) gibi çalışmalarda belgelenen kompakt RTOS mimarisi yaklaşımı (örneğin ChibiOS/RT'nin 1–5,5 KB arasındaki bellek alanı) referans alınacaktır.
4.1.2 Güç Yönetimi Modülü
Güç yönetimi modülü; aktif (RUN), boşta kalma (IDLE) ve uyku (SLEEP) güç durumları arasında geçişi yöneten bir durum makinesi içerecektir. Raj (2025), RTOS tabanlı sistemlerde CPU kullanım yüzdesi kritik sınırın altına düştüğünde 100 mikrosaniyenin altında algılama gecikmesiyle düşük güç durumlarına geçişin mümkün olduğunu göstermektedir. Bu hedef, güç yönetimi modülünün tasarım referansı olarak benimsenecektir.
4.1.3 Gerçek Zamanlı Görev Planlayıcısı
Görev planlayıcısı; Hız Monoton Zamanlama (RMS) ve En Erken Son Tarih İlkesi (EDF) algoritmalarını destekleyecek, preemptive (önce çekme) yeteneğine sahip olacak ve öncelik terslemesi problemine karşı önlem barındıracaktır. Wang (2023), doğru uygulanmış RMS'nin kontrol döngüsü titremesini geleneksel yaklaşımlarla kıyaslandığında yüzde 42 oranında azaltabildiğini göstermektedir.
4.1.4 Minimal Bellek Ayak İzi
Sistem, 256 KiB'ın altındaki SRAM kapasitesine sahip mikrodenetleyicilerle uyumlu olacak biçimde tasarlanacaktır. Amar ve ark. (2023)'ın CHERIoT çalışmasında belgelenen bu sınır, hedef donanım profili için referans kabul edilmektedir. Sharma ve ark. (2024)'ın önerdiği no_std derleme yaklaşımı da ikili dosya boyutunun minimize edilmesinde değerlendirilecektir.
4.1.5 Donanım Test ve Doğrulama Raporları
Geliştirme sürecinin sonunda; bağlam değiştirme gecikmesi, güç tüketim ölçümleri, görev zamanlama doğruluğu ve uyku modu geçiş süreleri gibi temel performans metriklerini içeren donanım doğrulama raporları hazırlanacaktır.

4.2 Kapsam Dışındaki Çalışmalar
Grafik kullanıcı arayüzü (GUI) veya yüksek seviyeli uygulama katmanı geliştirme
Kablosuz iletişim protokolü (Wi-Fi, Bluetooth) yığını implementasyonu
x86 veya RISC-V dışı mimariler için taşınabilirlik çalışması (ilk sürüm)
Bulut entegrasyonu veya uzaktan izleme arayüzü

5. MEVCUT DURUM ANALİZİ
5.1 Mevcut Çözümlerin Durumu
Akademik literatür ve endüstri gözlemleri, mevcut gömülü işletim sistemi ekosisteminde birkaç temel sorunu net biçimde ortaya koymaktadır:
FreeRTOS, Zephyr ve ChibiOS gibi yaygın RTOS platformları, temel işlevselliği sağlamakla birlikte enerji verimliliği ile güvenlik özelliklerini aynı anda optimize etmekte yetersiz kalmaktadır.
Katal ve ark. (2023), veri merkezlerinin enerji tüketiminin 2030 yılına kadar 2967 TWh'ye ulaşacağını öngörmektedir; bu durum, gömülü sistemlerde enerji optimizasyonunun yalnızca pil ömrüyle sınırlı olmayıp çevresel bir sorumluluk olduğunu da ortaya koymaktadır.
Taheri ve ark. (2020), HEFT gibi standart zamanlama algoritmalarının her zaman uygulanabilir çözümler üretmediğini; enerji ve makespan'in eş zamanlı optimize edilmesinde yetersiz kaldığını belirtmektedir.
Cao ve ark. (2019), mevcut karma kritiklik sistem planlayıcılarının geçici hata toleransını sistem ömrü optimizasyonuyla bütünleşik biçimde ele almadığını tespit etmektedir.

5.2 Teknolojik Boşluklar
İncelenen dört literatür alanı — gömülü sistemler, RTOS, görev planlaması ve enerji verimliliği — bir arada değerlendirildiğinde, mevcut çözümlerde belirgin boşluklar ortaya çıkmaktadır:
Belirsizlik yönetimi eksikliği: Poobalan ve ark. (2024), statik planlama modelleri ile dinamik çalışma ortamı arasındaki tutarsızlıkların göz ardı edildiğini vurgulamaktadır; bu durum gerçek dünya uygulamalarında beklenmedik performans kayıplarına yol açmaktadır.
Enerji–güvenilirlik dengesinin kurulamaması: Cao ve ark. (2019), DVFS'nin düşük voltajlarda geçici hata olasılığını artırdığını; dolayısıyla enerji tasarrufu ile güvenilirlik arasında çözümsüz kalan bir gerilim bulunduğunu göstermektedir.
Makine öğrenmesi entegrasyonunun sınırlılığı: Geng ve ark. (2021), derin öğrenme tabanlı görev planlaması potansiyelini ortaya koymuş; ancak bu yaklaşımın pratik gömülü sistem implementasyonlarına taşınması hâlâ gelişmekte olan bir alan olmaya devam etmektedir.
Güvenlik–kaynak dengesi: Amar ve ark. (2023), donanım kısıtlamaları nedeniyle standart güvenlik mekanizmalarının gömülü sistemlere uyarlanamadığını belgelemektedir.

6. PROJENİN POTANSİYEL ETKİLERİ
6.1 Teknik Etkiler
Projenin başarıyla tamamlanması durumunda beklenen teknik katkılar şu şekilde öngörülmektedir:
Enerji tüketiminin azaltılması: Literatürde belgelenen DVFS ve uyku modu mekanizmalarının entegrasyonu, boşta kalma dönemlerinde güç tüketiminin yüzde 40–99 arasında azaltılmasını mümkün kılacaktır (Raj, 2025; Katal ve ark., 2023).
Zamanlama kesinliğinin artırılması: RMS tabanlı planlayıcı ile kontrol döngüsü titremesinin geleneksel yaklaşımlara kıyasla yüzde 42 oranında azaltılması hedeflenmektedir (Raj, 2025).
Bellek verimliliği: Minimal çekirdek tasarımı ile 256 KiB'ın altındaki bellek kapasitesine sahip sistemlerde çalışabilirliğin sağlanması, Sharma ve ark. (2024)'ın no_std yaklaşımıyla uyumlu düşük boyutlu ikili dosyalar üretmeyi mümkün kılacaktır.
Güvenilir görev yönetimi: Preemptive zamanlama ve öncelik terslemesi koruması, güvenlik kritik senaryolarda görev son teslim tarihi ihlallerinin önüne geçecektir.

6.2 Uygulama Alanlarına Etkisi
Geliştirilen sistem, aşağıdaki uygulama alanlarında doğrudan fayda sağlayabilecek niteliktedir:
IoT ve bağlantılı sensör ağları: Pil ile çalışan IoT düğümlerinin operasyonel ömrü uzatılabilecek; Mamur ve ark. (2022)'ın bitkisel izleme sisteminde benimsediği uyku/uyanma döngüsü gibi yaklaşımlar sistematik biçimde uygulanabilecektir.
Güvenlik kritik sistemler: Havacılık, otomotiv ve tıbbi cihaz sektörlerinde DO-178C, ISO 26262 gibi sertifikasyon standartlarıyla uyumlu, belirleyici zamanlama garantisi sunan bir platform oluşturulacaktır (Raj, 2025).
Endüstriyel otomasyon: Gerçek zamanlı kontrol döngüsü gereksinimleri olan endüstriyel PLC ve sensör sistemlerinde enerji ve güvenilirlik dengesi sağlanabilecektir.
Tarım teknolojisi: Uzak lokasyonlardaki akıllı tarım sensörlerinin pil bağımsızlığı artırılabilecektir.

6.3 Akademik ve Endüstriyel Katkı
Bu proje; enerji verimliliği, görev planlaması ve RTOS mimarisi konularındaki akademik literatürün pratik uygulamaya dönüştürülmesine katkı sağlayacaktır. Taheri ve ark. (2020)'ın heterojen sistemlerde yüzde 6–51 makespan iyileştirmesi ile yüzde 3–16 enerji tasarrufu sağladığı algoritmik yaklaşım, bu proje kapsamında ARM tabanlı gömülü bir platforma uyarlanabilecektir. Poobalan ve ark. (2024)'ın Monte Carlo analizine kıyasla yalnızca yüzde 0,2 sapmayla çalışan bulanık mantık tabanlı belirsizlik yönetimi yaklaşımı ise ileride yapılacak geliştirme iterasyonları için araştırma gündeminin önemli bir parçasını oluşturmaktadır.

7. SONUÇ
Bu belgede, "Gömülü Sistemler için Enerji Verimli İşletim Sistemi" projesinin genel hedefleri, kapsamı, mevcut durum analizi ve potansiyel etkileri sistematik biçimde ele alınmıştır. Gömülü sistemler, RTOS, görev planlaması ve enerji verimliliği alanlarındaki güncel literatür incelemesi; bu projenin hem akademik boşlukları dolduracak hem de endüstriyel ihtiyaçlara yanıt verecek özgün bir konumda bulunduğunu ortaya koymaktadır.
Projenin teslim bileşenleri — çekirdek ve cihaz sürücüleri, güç yönetimi modülü, gerçek zamanlı görev planlayıcısı, minimal bellek ayak izi ve donanım doğrulama raporları — literatürde tespit edilen teknolojik boşluklarla doğrudan örtüşmekte olup proje çıktılarının kaynak kısıtlı ortamlarda hem enerji hem de zamanlama açısından ölçülebilir iyileştirmeler sunması beklenmektedir.

KAYNAKLAR
[1] Poobalan, A., Zarandi, H.R., Shanthakumar, P. (2024). DyUnS: Dynamic and uncertainty-aware task scheduling for multiprocessor embedded systems. Sustainable Computing: Informatics and Systems, 43, 101013.
[2] Geng, X. ve ark. (2021). Real-time task scheduling and network device security for complex embedded systems based on deep learning networks. Microprocessors and Microsystems, 81, 103515.
[3] Taheri, G., Khonsari, A., Entezari-Maleki, R. ve Sousa, L. (2020). A hybrid algorithm for task scheduling on heterogeneous multiprocessor embedded systems. Applied Soft Computing, 91, 106202.
[4] Cao, K., Zhou, J., Xu, G., Chen, M. ve Wei, T. (2019). Lifetime-aware real-time task scheduling on fault-tolerant mixed-criticality embedded systems. Future Generation Computer Systems, 100, 65–75.
[5] Raj, C.A. (2025). Innovations in Real-Time Operating Systems (RTOS) for Safety-Critical Embedded Systems. Journal of Computer Science and Technology Studies, 7(3), 791–797.
[6] Katal, A., Dahiya, S. ve Choudhury, T. (2023). Energy efficiency in cloud computing data centers: a survey on software technologies. Cluster Computing, 26(3), 1845–1875.
[7] Amar, S. ve ark. (2023). CHERIoT: Rethinking security for low-cost embedded systems. Microsoft Research.
[8] Mamur, H., Dicle, Z. ve Erdener, S. (2022). IoT based smart embedded system design for indoor plants tracking. International Journal of Engineering Research and Development, 14(2), 611–618.
[9] Wang, K.C. (2023). Embedded Real-Time Operating Systems. In: Embedded and Real-Time Operating Systems. Springer.
[10] Sharma, A. ve ark. (2024). Rust for embedded systems: Current state and open problems. ACM CCS 2024.
---
FONKSİYONEL VE TEKNİK GEREKSİNİM ANALİZİ



1.GİRİŞ
  Gömülü sistemler, günümüzde IoT cihazları, akıllı ev sistemleri, otomasyon çözümleri ve taşınabilir elektronik cihazlar gibi birçok alanda kullanılmaktadır. Bu sistemler genellikle sınırlı işlem gücü, düşük bellek kapasitesi ve kısıtlı enerji kaynakları ile çalışmaktadır. Bu nedenle gömülü sistemlerde kullanılan işletim sistemlerinin yüksek verimlilik, düşük enerji tüketimi ve gerçek zamanlı performans sunması gerekmektedir.
  Bu proje kapsamında geliştirilecek sistem, gömülü cihazlar için enerji verimli ve gerçek zamanlı çalışabilen bir işletim sistemi mimarisi sunmayı amaçlamaktadır. Sistem, ARM mimarisi üzerinde çalışan gömülü donanımlar için optimize edilmiş Linux tabanlı bir çekirdek kullanacaktır.
  Enerji verimliliği ve görev zamanlama mekanizmaları gömülü sistem performansını doğrudan etkileyen faktörlerdir. Literatürde yapılan çalışmalar, özellikle görev zamanlama algoritmalarının sistem performansı ve enerji tüketimi üzerinde önemli etkileri olduğunu göstermektedir.


2.SİSTEM GENEL TANIMI
  Geliştirilecek sistem, gömülü cihazlarda çalışacak hafif (lightweight) bir işletim sistemi çekirdeği içerecektir. Bu çekirdek, donanım ile uygulamalar arasında köprü görevi görecek ve aşağıdaki temel bileşenlerden oluşacaktır:
İşletim sistemi çekirdeği:
  İşletim sistemi çekirdeği, sistemin en temel bileşenidir. Donanım kaynaklarının yönetimi, görev planlama, bellek yönetimi ve sistem çağrıları gibi temel işlemler çekirdek tarafından gerçekleştirilecektir.
Gerçek zamanlı görev planlayıcısı:
  Gerçek zamanlı sistemlerde görevlerin belirli zaman aralıklarında çalıştırılması gerekmektedir. Bu nedenle sistem içerisinde görevlerin öncelik seviyelerine göre çalıştırılmasını sağlayan bir planlayıcı bulunacaktır.
Güç yönetimi modülü:
  Enerji tüketimini azaltmak amacıyla sistem işlemci kullanımını ve güç durumlarını dinamik olarak yönetebilecek bir güç yönetimi modülü içerecektir.
Cihaz sürücüleri:
  Donanım bileşenlerinin işletim sistemi ile iletişim kurabilmesi için cihaz sürücülerine ihtiyaç duyulmaktadır. Bu sürücüler sensörler, iletişim modülleri ve depolama birimleri gibi farklı donanım bileşenlerini destekleyecektir.
Bellek yönetimi sistemi:
  Sistem sınırlı bellek kaynaklarını verimli bir şekilde kullanabilmek için bellek tahsisi, serbest bırakılması ve izlenmesi gibi işlemleri gerçekleştiren bir bellek yönetimi mekanizmasına sahip olacaktır.
Donanım test ve doğrulama mekanizmaları:
  Sistemin güvenilir çalışmasını sağlamak amacıyla sistem başlangıcında ve çalışma sırasında donanım testleri yapılacaktır
  Sistem özellikle düşük güç tüketimi, yüksek güvenilirlik ve gerçek zamanlı işlem kabiliyeti üzerine odaklanacaktır.


3.FONKSİYONEL GEREKSİNİMLER 
  Fonksiyonel gereksinimler, sistemin hangi görevleri yerine getirmesi gerektiğini tanımlar.
3.1 Görev Planlama 
Sistem bir gerçek zamanlı görev planlayıcısı (Real-Time Scheduler) içermelidir. 
Görevler öncelik seviyelerine göre planlanmalıdır. 
Kritik görevler diğer görevlerden önce çalıştırılabilmelidir. 
Görevler preemptive scheduling yöntemi ile kesintiye uğratılabilir olmalıdır. 
Aynı anda birden fazla görev çalıştırılabilmelidir.
  Bu yapı gerçek zamanlı işletim sistemlerinde yaygın olarak kullanılan planlama yöntemlerine dayanmaktadır.
3.2 Güç Yönetimi
Sistem cihazın enerji tüketimini minimize edecek bir güç yönetimi mekanizması sağlamalıdır.
İşlemci kullanılmadığı zamanlarda düşük güç moduna (sleep mode) geçebilmelidir.
Sistem CPU frekansını dinamik olarak ayarlayabilmelidir.
Pil seviyesine göre sistem davranışı optimize edilmelidir.
Enerji yönetimi, özellikle pil ile çalışan gömülü sistemlerde kritik bir tasarım kriteridir.
3.3 Cihaz Sürücüleri Desteği
Sistem farklı donanım bileşenleri ile iletişim kurabilmek için cihaz sürücüleri desteklemelidir. Sensörler, depolama birimleri ve iletişim modülleri için sürücüler yüklenebilmelidir.
Donanım soyutlama katmanı (HAL) bulunmalıdır. 
Yeni cihaz sürücülerinin sisteme eklenmesi kolay olmalıdır.

3.4 Bellek Yönetimi
Sistem sınırlı bellek kaynaklarını verimli şekilde yönetmelidir. 
Dinamik bellek tahsisi yapılabilmelidir.
Bellek sızıntılarını önlemek için kontrol mekanizmaları bulunmalıdır.
Bellek kullanımını izleyen bir yönetim modülü bulunmalıdır.
  Bellek yönetimi, gömülü sistemlerde performans ve kararlılığı doğrudan etkileyen önemli bir faktördür.
3.5 Sistem İzleme ve Hata Yönetimi 
Sistem çalışma durumunu izleyebilen bir monitoring mekanizması içermelidir. 
Hatalar tespit edildiğinde sistem kayıt (log) oluşturmalıdır. 
Kritik hatalarda sistem güvenli şekilde yeniden başlatılabilmelidir.
3.6 Donanım Test ve Doğrulama  
Sistem donanımın doğru çalıştığını doğrulamak için test araçları içermelidir.
Sistem başlatıldığında temel donanım testleri yapılmalıdır. 
Test sonuçları raporlanmalıdır. 


4.TEKNİK GEREKSİNİMLER 
  Teknik gereksinimler sistemin nasıl çalışması gerektiğini ve hangi teknolojilerin kullanılacağını belirler.
4.1 Donanım Mimarisi 
Sistem ARM tabanlı işlemcileri desteklemelidir. 
ARM Cortex serisi işlemcilerle uyumlu olmalıdır.
Sistem düşük güç tüketimli mikrodenetleyiciler üzerinde çalışabilmelidir.
4.2 Programlama Dilleri
Sistem çekirdeği C programlama dili kullanılarak geliştirilmelidir.
Donanım seviyesindeki işlemler için Assembly dili kullanılmalıdır. 
Sistem düşük seviyeli donanım kontrolü sağlayabilmelidir.
4.3 İşletim Sistemi Yapısı 
Sistem Linux kernel mimarisinden esinlenen modüler bir yapı kullanmalıdır. 
Çekirdek modüler olmalı ve yeni bileşenlerin eklenmesine izin vermelidir.
Sistem minimal bir çekirdek tasarımına sahip olmalıdır.
4.4 Bellek Kullanımı 
Sistem düşük bellek ayak izine sahip olmalıdır. 
Minimum RAM kullanımı hedeflenmelidir. (örn. ≤ 64 KB temel çekirdek)
Sistem küçük gömülü cihazlarda çalışabilecek şekilde optimize edilmelidir.
4.5 Gerçek Zamanlı Performans 
Sistem deterministic response time sağlamalıdır. 
Görevler belirli zaman sınırları içinde tamamlanmalıdır. 
Gerçek zamanlı uygulamalar için gecikme süresi minimum seviyede olmalıdır.
4.6 Güvenilirlik ve Kararlılık
Sistem uzun süre kesintisiz çalışabilecek şekilde tasarlanmalıdır. 
Hata toleransı mekanizmaları bulunmalıdır. 
Sistem çökmelerini önlemek için watchdog mekanizmaları kullanılmalıdır.
4.7 Test ve Doğrulama  
Sistem, gerçek donanım üzerinde entegrasyon ve stres testlerine tabi tutulmalıdır. 
Performans, güç tüketimi ve gerçek zamanlı yanıt ölçülebilir ve raporlanabilir olmalıdır. 
Donanım ve yazılım uyumluluğu, otomatik test senaryoları ile doğrulanmalıdır.

5.PERFORMANS GEREKSİNİMLERİ 
  Sistemin aşağıdaki performans kriterlerini sağlaması hedeflenmektedir:
Düşük CPU kullanımı: ≤ %10-15 idle durumda.
Minimum enerji tüketimi: Sleep modunda minimum, aktif modda optimize edilmiş.
Hızlı görev geçiş süreleri: ≤ 1 ms kritik görevler için.
Düşük bellek kullanımı: Minimal, küçük gömülü cihazlara uygun.
Gerçek zamanlı görevlerde düşük gecikme süresi: ≥ 99.9% uptime hedefi.
  Bu performans hedefleri sistemin özellikle pil ile çalışan gömülü cihazlarda verimli ve güvenilir çalışmasını sağlayacak şekilde belirlenmiştir.


6.DONANIM SOYUTLAMA KATMANI (HAL) VE API TASARIMI 
 Sisteminizin farklı donanımlara kolayca taşınabilmesi ve uygulama geliştiricilerin donanıma erişebilmesi için bu bölümü eklemelisiniz.
Donanım Soyutlama (HAL): Çekirdeğin farklı ARM işlemci ailelerine (Cortex-M0, M4, A serisi vb.) kolayca adapte edilebilmesi için bir HAL yapısı bulunmalıdır.
API Seti: Uygulama geliştiricilerin görev oluşturma, güç modunu değiştirme ve sensör verisi okuma gibi işlemler için kullanacağı standart fonksiyon setleri ( örn. task_create () , power_sleep() )tanımlanmalıdır.

7.GÜVENLİK GEREKSİNİMLERİ (SECURITY REQUIREMENTS)
Gömülü sistemler, özellikle IoT alanında kullanıldığında siber saldırılara açık hale gelir.
Güvenli Başlatma (Secure Boot): Sistemin yalnızca yetkili yazılımı çalıştırdığından emin olmak için bir imza kontrol mekanizması eklenmelidir.
Hafıza Koruması: Bir görevin diğerinin bellek alanına müdahale etmesini önlemek için Memory Protection Unit (MPU) desteği belirtilmelidir.
Veri Şifreleme: İletişim modülleri üzerinden gönderilen verilerin düşük maliyetli şifreleme algoritmaları (örn. AES-Lightweight) ile korunması gereklidir.

8.KULLANICI ARAYÜZÜ VE ARAÇLAR (DASHBOARD/CLI)
Sistemin analiz edilebilmesi ve test sonuçlarının izlenebilmesi için gereken araçlar:
Komut Satırı Arayüzü (CLI): UART üzerinden sistem durumunu, aktif görevleri ve anlık enerji tüketimini sorgulayabilen basit bir terminal arayüzü.
Görselleştirme: Güç tüketimi verilerini grafiksel olarak sunan bir harici izleme aracı desteği.

9.PROJE TAKVİMİ VE RİSK ANALİZİ 
Yönetimsel açıdan projenin başarısını garanti altına alan kısımlar:
Risk Analizi: Donanım temini gecikmesi, bellek sızıntıları veya enerji verimliliği hedeflerinin tutmaması gibi durumlara karşı "B Planları" (mitigation strategies).
Kilometre Taşları (Milestones): "1. Ay: Çekirdek tamamlanması", "2. Ay: Güç modülü testi" gibi bir zaman çizelgesi.

10.SONUÇ 
  Bu dokümanda geliştirilecek enerji verimli gömülü işletim sistemi için gerekli olan fonksiyonel ve teknik gereksinimler ayrıntılı olarak analiz edilmiştir. Tanımlanan gereksinimler sistem tasarımının temelini oluşturacak ve geliştirme sürecinde referans olarak kullanılacaktır.
  Bu gereksinimler doğrultusunda geliştirilecek sistemin düşük enerji tüketimi, yüksek güvenilirlik ve gerçek zamanlı performans sağlaması hedeflenmektedir. Bu özellikler sayesinde sistem, gömülü cihazlarda etkin ve verimli bir işletim sistemi çözümü sunacaktır.
KAYNAKLAR

[1]  Stallings, W. Operating Systems: Internals and Design Principles, 9th Edition, Pearson, 2018.
[2]  Silberschatz, A., Galvin, P., Gagne, G. Operating System Concepts, 10th Edition, Wiley, 2018.
[3]  Marwedel, P. Embedded System Design: Embedded Systems Foundations of Cyber-Physical Systems, Springer, 2019.
[4]  Labrosse, J. J. MicroC/OS-II: The Real-Time Kernel, 2nd Edition, CMP Books, 2002.
[5]  Barr, M., Massa, A. Programming Embedded Systems in C and C++, 2nd Edition, O’Reilly, 2006.
[6]  ARM Ltd. ARM Cortex-M Series Technical Reference Manual, ARM Holdings, 2020.
[7]  Anderson, J. H., Dahlin, M., Neefe, J., et al. Performance and Evaluation of Real-Time Operating Systems, ACM Transactions on Embedded Computing Systems, 2017.
[8]  Ganssle, J. The Art of Designing Embedded Systems, 2nd Edition, Elsevier, 2008.
[9]  Kumar, A., Pande, S., Tripathi, A. Real-Time Embedded Systems: Design Principles and Practices, Springer, 2021.
[10]  ISO/IEC 12207:2017 – Systems and Software Engineering – Software Life Cycle Processes.
[11]  IEEE 802.15.4 Standard, For low-power wireless network communication principles.
[12]  NIST Lightweight Cryptography Project, Security standards for resource-constrained devices.
[13]  FreeRTOS & Zephyr Project Documentation, For industrial energy-efficient RTOS comparisons.
---
Teknoloji Araştırması ve Seçimi

Gömülü Sistemler için Enerji Verimli İşletim Sistemi.
Sorumlu: Yasemin Ubeyd. 

Giriş
Bu bölümde, “Gömülü Sistemler için Enerji Verimli İşletim Sistemi” projesi için en uygun teknolojiler araştırılmış ve sistem gereksinimlerine göre ayrıntılı biçimde değerlendirilmiştir. Projenin temel amacı; düşük güç tüketimi sağlayan, gerçek zamanlı çalışabilen, sınırlı donanım kaynaklarına sahip gömülü cihazlarda güvenilir şekilde çalışacak bir işletim sistemi geliştirmektir.
Bu doğrultuda teknoloji seçimi yapılırken yalnızca yüksek performans değil; aynı zamanda düşük bellek kullanımı, enerji verimliliği, gerçek zamanlı çalışma yeteneği, ARM mimarisi ile uyumluluk, donanıma yakın kontrol, taşınabilirlik, geliştirme kolaylığı, hata ayıklama desteği ve topluluk olgunluğu gibi ölçütler dikkate alınmıştır.
Teknoloji araştırması şu başlıklar altında yürütülmüştür:
Programlama dili seçimi
Çekirdek yaklaşımı
Hedef donanım mimarisi
Derleme araç zinciri
Derleme sistemi
Hata ayıklama ve simülasyon araçları
Sürüm kontrol sistemi
Bu incelemelerin amacı, projeye en uygun teknoloji kümesini belirlemek ve seçilen teknolojilerin neden tercih edildiğini açık biçimde ortaya koymaktır.

Teknoloji Seçim Kriterleri
Proje için kullanılacak teknolojiler belirlenirken aşağıdaki temel kriterler esas alınmıştır.
Düşük Bellek Kullanımı
Gömülü sistemler genellikle sınırlı RAM ve flash belleğe sahiptir. Bu nedenle seçilen teknolojilerin düşük bellek ayak izi ile çalışabilmesi gerekmektedir.
Gerçek Zamanlı Performans
Görevlerin belirli süre sınırları içinde tamamlanması gereken sistemlerde zamanlama gecikmeleri kritik öneme sahiptir. Bu yüzden deterministik davranış sağlayan teknolojiler tercih edilmelidir.
2.3 Enerji Verimliliği
Pil ile çalışan cihazlarda enerji tüketimi doğrudan sistem ömrünü etkiler. Teknoloji seçiminin düşük güç modlarını desteklemesi ve işlemci kaynaklarını verimli kullanması gerekir.
2.4 ARM Uyumluluğu
Projenin hedef donanımı ARM tabanlı olacağı için seçilen yazılım, araç ve geliştirme ortamlarının ARM işlemcilerle uyumlu olması zorunludur.
2.5 Donanıma Yakınlık
İşletim sistemi çekirdeği, sürücüler, kesme yönetimi ve görev zamanlayıcısı gibi alanlarda donanıma doğrudan erişim gerekmektedir. Bu nedenle düşük seviyeli kontrol sağlayan teknolojiler tercih edilmelidir.
2.6 Geliştirme ve Bakım Kolaylığı
Seçilen teknolojiler yalnızca güçlü değil, aynı zamanda ekip tarafından öğrenilebilir, yönetilebilir ve sürdürülebilir olmalıdır.
2.7 Topluluk ve Dokümantasyon Desteği
Geniş kullanıcı topluluğu ve güçlü dokümantasyon desteği, geliştirme sürecinde karşılaşılabilecek sorunların çözümünü kolaylaştırmaktadır.

Programlama Dili Seçimi: C ve Assembly
Gömülü sistemlerde işletim sistemi geliştirmek için en uygun yaklaşım, C dilinin ana geliştirme dili, Assembly dilinin ise donanıma özgü kritik bölümlerde yardımcı dil olarak kullanılmasıdır. Bu iki dil, gömülü sistemler alanında en köklü ve yaygın kullanılan teknolojiler arasındadır.
3.1 C Dilinin Seçilme Nedeni
C dili, işletim sistemi çekirdekleri ve gömülü sistemler için en yaygın kullanılan dillerden biridir. Bunun temel nedeni, C dilinin donanıma yakın çalışabilmesi ve verimli makine kodu üretebilmesidir. Linux çekirdeği, FreeRTOS ve birçok düşük seviyeli gömülü yazılım altyapısı büyük ölçüde C dili ile geliştirilmiştir. Bu da C dilinin hem akademik hem de endüstriyel açıdan güçlü bir tercih olduğunu göstermektedir.
3.2 C Dilinin Avantajları
Donanıma yakın çalışır ve sistem kaynakları üzerinde doğrudan kontrol sağlar.
Bellek yönetimi programcı tarafından ayrıntılı şekilde yapılabilir.
Düşük seviyeli sistem programlaması için uygundur.
Yüksek performanslı ve hızlı çalışabilen derlenmiş kod üretir.
Gömülü sistemlerde çok geniş kullanım alanına sahiptir.
ARM mimarisi için güçlü derleyici desteği vardır.
Çok sayıda açık kaynak örnek, kütüphane ve proje mevcuttur.
Taşınabilirliği yüksektir; farklı mikrodenetleyicilere uyarlanabilir.
İşletim sistemi çekirdeği, sürücü ve bellek yönetimi gibi modüller için uygundur.
Kaynak tüketimi düşüktür ve küçük sistemlerde verimli çalışabilir.
3.3 C Dilinin Dezavantajları
Bellek güvenliği sınırlıdır.
Pointer hataları sistem çökmesine neden olabilir.
Buffer overflow gibi güvenlik açıkları ortaya çıkabilir.
Tip güvenliği bazı modern dillere göre daha zayıftır.
Büyük projelerde hata ayıklama zorlaşabilir.
Yanlış bellek erişimleri ciddi sistem hatalarına yol açabilir.
Programcı hatalarına karşı koruma mekanizması azdır.
Bu dezavantajlara rağmen, gömülü sistem projelerinde performans ve donanım kontrolü gereksinimleri nedeniyle C dili hâlâ en mantıklı ve yaygın seçimdir.

3.4 Assembly Dilinin Seçilme Nedeni
Assembly dili işlemci komut setine doğrudan erişim sağlar. Bu nedenle sistemin bazı bölümlerinde C diline göre daha hassas ve hızlı çözümler sunar. Özellikle işlemci başlangıç kodları, kesme yönetimi, bağlam değiştirme işlemleri ve register düzeyinde kontrol gereken bölümler için Assembly gereklidir.
3.5 Assembly Dilinin Kullanım Alanları
startup kodları
interrupt servis rutinleri
context switch işlemleri
register tabanlı donanım erişimi
zaman açısından çok kritik kod blokları
3.6 Assembly Dilinin Avantajları
Maksimum performans sağlar.
İşlemci komutları doğrudan kullanılabilir.
Zamanlama açısından kritik bölümlerde gecikmeyi azaltır.
Donanım register’ları üzerinde doğrudan kontrol sağlar.
C dilinin erişemediği bazı düşük seviyeli ayrıntılara erişim imkânı verir.
Optimizasyon için çok esnek bir yapıya sahiptir.
3.7 Assembly Dilinin Dezavantajları
Mimariye bağımlıdır; taşınabilirliği düşüktür.
Kod okunabilirliği zayıftır.
Geliştirme süresi uzundur.
Hata ayıklama daha zordur.
Bakım maliyeti yüksektir.
Büyük projelerde yoğun Assembly kullanımı sürdürülebilir değildir.
3.8 Alternatiflerin Değerlendirilmesi
Rust gibi diller bellek güvenliği açısından güçlü avantajlar sunmaktadır. Ancak gömülü sistemler için araç zinciri, hazır örnekler ve ekip alışkanlıkları açısından C kadar yaygın ve pratik değildir. Bu nedenle proje kapsamında başlangıç aşamasında C ve Assembly daha uygun bulunmuştur.
3.9 Karar
Bu proje için:
Ana programlama dili: C
Kritik düşük seviyeli bölümler: ARM Assembly
olarak belirlenmiştir.

 Çekirdek Yaklaşımı: Linux Tabanlı mı, Özel Minimal Çekirdek mi?
Projede çekirdek yapısı için iki temel yaklaşım değerlendirilmiştir:
Embedded Linux kullanmak veya Linux çekirdeğini uyarlamak
Özel, minimal ve hafif bir çekirdek geliştirmek
4.1 Embedded Linux Yaklaşımı
Embedded Linux, Linux çekirdeğinin gömülü cihazlar için uyarlanmış biçimidir. Sürücü desteği, modüler yapı ve geniş topluluk desteği açısından güçlü bir seçenektir.
Avantajları
Çok geniş sürücü desteği sunar.
Güçlü topluluk ve dokümantasyon altyapısına sahiptir.
Açık kaynaklıdır.
Modüler yapı sayesinde özelleştirilebilir.
Olgun ve yaygın kullanılan bir sistemdir.
Ağ, dosya sistemi ve süreç yönetimi gibi alanlarda gelişmiş özellikler sunar.
Dezavantajları
Küçük mikrodenetleyiciler için ağır kalabilir.
Bellek gereksinimi yüksektir.
Gerçek zamanlı davranış için ek düzenlemeler gerekebilir.
Basit ve çok düşük güç tüketimli sistemler için gereğinden fazla karmaşık olabilir.
Önyükleme süresi minimal çekirdeklere göre daha uzundur.

4.2 Özel Minimal Çekirdek Yaklaşımı
Bu yaklaşımda yalnızca proje için gerekli bileşenler geliştirilir. Böylece daha hafif, daha küçük ve daha kontrollü bir sistem elde edilir.
Avantajları
Düşük bellek ayak izi sağlar.
Enerji verimliliği açısından daha avantajlı olabilir.
Yalnızca gerekli modüller içerdiği için daha sade bir yapıya sahiptir.
Deterministik zamanlama elde etmek daha kolaydır.
Gerçek zamanlı gereksinimlere daha uygun hale getirilebilir.
Donanıma özel optimizasyon yapılabilir.
Dezavantajları
Geliştirme süresi daha uzundur.
Sürücülerin ve temel çekirdek bileşenlerinin elde yazılması gerekir.
Test ve doğrulama yükü artar.
Geniş topluluk desteği hazır olarak gelmez.
Geliştirici ekipten daha yüksek teknik bilgi bekler.
4.3 Karşılaştırma ve Tercih
Projenin hedefi enerji verimliliği, küçük bellek ayak izi ve gerçek zamanlı davranış olduğu için özel minimal çekirdek yaklaşımı daha uygun görülmüştür. Ancak Linux kernel mimarisinin modülerlik, soyutlama ve sürücü organizasyonu gibi tasarım ilkeleri referans alınacaktır.
4.4 Karar
Yaklaşım: Özel minimal çekirdek
Mimari referans: Linux kernel prensipleri

 Hedef Donanım Mimarisi: ARM Cortex Serisi
Projede hedef mimari olarak ARM Cortex tabanlı işlemciler seçilmiştir. ARM mimarisi günümüzde gömülü sistemler, IoT cihazları, sensör ağları ve taşınabilir elektroniklerde yaygın biçimde kullanılmaktadır.
5.1 ARM Mimarisi Avantajları
Düşük güç tüketimi sağlar.
Yüksek enerji verimliliği sunar.
Gömülü sistemlerde yaygın biçimde kullanılır.
Geniş üretici desteğine sahiptir.
Araç zinciri ve derleyici desteği güçlüdür.
Gerçek zamanlı uygulamalar için uygundur.
Mikrodenetleyicilerden daha güçlü gömülü işlemcilere kadar geniş ürün yelpazesi sunar.
Donanım ve yazılım topluluğu çok geniştir.
5.2 ARM Mimarisi Dezavantajları
Bazı ileri seviye uygulamalarda daha güçlü platformlara ihtiyaç duyulabilir.
İşlemci ailesine göre özellikler değiştiği için geçişlerde uyarlama gerekebilir.
Çok düşük maliyetli bazı sistemlerde ek yapılandırma gerekebilir.
5.3 Neden Cortex-M?
Cortex-M serisi özellikle düşük güç tüketimi, hızlı kesme yönetimi ve gerçek zamanlı uygulama desteği nedeniyle gömülü sistem projeleri için uygundur.
5.4 Karar
Hedef mimari: ARM
Önerilen alt seri: Cortex
 Derleme Araç Zinciri: ARM GNU Toolchain
Projede ARM tabanlı sistemler için ARM GNU Toolchain (arm-none-eabi-gcc) kullanılacaktır.
6.1 Avantajları
Ücretsiz ve açık kaynaklıdır.
ARM mimarisi için yaygın biçimde kullanılmaktadır.
C ve Assembly desteği sağlar.
Çapraz derleme yapılabilir.
GDB ile kolay entegrasyon sunar.
Yaygın kullanım nedeniyle çok sayıda örnek ve rehber mevcuttur.
Komut satırı üzerinden otomasyon kurmak kolaydır.
6.2 Dezavantajları
İlk kurulum yeni başlayanlar için zor olabilir.
Ticari IDE’lere göre daha fazla manuel yapılandırma isteyebilir.
Hatalı optimizasyon bayrakları hata ayıklamayı zorlaştırabilir.
Ortam kurulumu ekip içinde standartlaştırılmazsa farklılıklar çıkabilir.
6.3 Karar
Derleyici: arm-none-eabi-gcc
Araç zinciri: ARM GNU Toolchain

 Derleme Sistemi: CMake + Makefile
Projede derleme sürecinin düzenli biçimde yürütülmesi için CMake + Makefile yaklaşımı seçilmiştir.
7.1 Avantajları
Modüler proje yapısını destekler.
Farklı klasör ve modüllerin yönetimini kolaylaştırır.
Ekip içinde ortak derleme süreci oluşturur.
Otomatik derleme senaryoları yazılabilir.
Test ve çapraz derleme süreçlerine uyarlanabilir.
Projenin büyümesi durumunda düzeni korur.
7.2 Dezavantajları
Başlangıçta öğrenme eğrisi vardır.
Küçük projelerde fazla ayrıntılı görünebilir.
Yanlış yapılandırma durumunda hata mesajları karmaşık olabilir.
7.3 Karar
Derleme sistemi: CMake
Çalıştırıcı: Make
8 . Hata Ayıklama ve Simülasyon Araçları
Gerçek donanım üzerinde geliştirme yaparken hata ayıklama çok önemlidir. Ayrıca erken aşamada fiziksel kart olmadan test yapabilmek için simülasyon araçlarına ihtiyaç duyulmaktadır.
8.1 GDB
GDB, programın adım adım çalıştırılmasını, breakpoint kullanılmasını ve bellek ile register durumunun incelenmesini sağlar.
Avantajları
Ayrıntılı hata ayıklama sağlar.
Breakpoint ve step-by-step izleme yapılabilir.
Bellek ve register analizi mümkündür.
Açık kaynaklıdır.
Dezavantajları
Yeni başlayanlar için komut yapısı zor gelebilir.
Grafik arayüzlü araçlara göre daha teknik kullanım gerektirir.

8.2 OpenOCD
OpenOCD, JTAG/SWD üzerinden hedef donanım ile bağlantı kurulmasını sağlar.
Avantajları
Donanım üzerinde canlı hata ayıklamayı destekler.
GDB ile entegrasyon sağlar.
Gömülü geliştirme için yaygın kullanılan bir araçtır.
Dezavantajları
Donanıma göre konfigürasyon dosyaları gerekebilir.
İlk ayar süreci karmaşık olabilir.

8.3 QEMU
QEMU, ARM tabanlı sistemlerin sanal ortamda test edilmesine imkân verir.
Avantajları
Donanım olmadan erken test yapılabilir.
Çekirdek ve temel modüller denenebilir.
Geliştirme sürecini hızlandırır.
Hata ayıklama ile birlikte kullanılabilir.
Dezavantajları
Gerçek donanım davranışını her zaman birebir yansıtmayabilir.
Bazı çevresel birimlerin emülasyonu sınırlı olabilir.
8.4 Karar
Hata ayıklama: GDB + OpenOCD
Simülasyon: QEMU
Sürüm Kontrol Sistemi: Git
Proje ekip çalışmasına dayandığı için sürüm kontrol sistemi gereklidir. Bu amaçla Git seçilmiştir.
9.1 Git Avantajları
Değişiklik geçmişini kaydeder.
Ekip içi paralel geliştirmeyi destekler.
Branch mantığı ile özellik bazlı çalışma sağlar.
Eski sürümlere geri dönülebilir.
Hatalı değişiklikler kontrol altına alınabilir.
GitHub veya GitLab ile kolay entegrasyon sunar.
9.2 Git Dezavantajları
Başlangıçta komutların öğrenilmesi zaman alabilir.
Merge conflict durumları yönetim gerektirir.
Disiplinli kullanılmazsa karmaşa oluşabilir.
9.3 Karar
Sürüm kontrol sistemi: Git
Uzak depo: GitHub / GitLab
10.  Seçilen Teknolojilerin Özet Tablosu



 Genel Değerlendirme
Yapılan araştırma sonucunda, projenin ihtiyaçlarına en uygun teknoloji kümesinin; C ve Assembly ile geliştirilen, ARM Cortex-M tabanlı, özel minimal çekirdeğe sahip, ARM GNU Toolchain ile derlenen ve GDB/OpenOCD/QEMU ile test edilen bir yapı olduğu belirlenmiştir.
Bu yapı aşağıdaki hedeflerle güçlü uyum göstermektedir:
düşük güç tüketimi
gerçek zamanlı görev desteği
düşük bellek kullanımı
donanıma yakın kontrol
modüler geliştirme
test ve doğrulama kolaylığı
Linux tabanlı çözümler öğretici ve güçlü olmakla birlikte, bu projenin hedeflediği düşük kaynak tüketimi ve yüksek enerji verimliliği açısından daha hafif bir özel çekirdek yaklaşımı daha uygun görünmektedir.

12.Sonuç
Bu bölümde proje için gerekli teknolojiler ayrıntılı biçimde araştırılmış, alternatifler karşılaştırılmış ve seçilen teknolojilerin avantajları ile dezavantajları değerlendirilmiştir. Sonuç olarak, sistemin C ve Assembly tabanlı, ARM Cortex-M mimarisi üzerinde çalışan, özel minimal çekirdek yaklaşımına sahip ve ARM GNU Toolchain ile geliştirilen bir gömülü işletim sistemi olarak tasarlanmasının en uygun seçenek olduğu görülmüştür.
Seçilen bu teknolojiler; düşük güç tüketimi, gerçek zamanlı performans, düşük bellek ayak izi ve güvenilir çalışma hedeflerini desteklemektedir. Böylece proje, hem akademik açıdan anlamlı hem de teknik açıdan uygulanabilir bir temel üzerine kurulmuş olacaktır.
--------------------------------
GÖMÜLÜ SİSTEMLER İŞLETİM SİSTEMİ PROJESİ: WINDOWS KURULUM REHBERİ

Hepimizin aynı ortamda, hatasız ve uyum içinde çalışabilmesi için bilgisayarlarımızı profesyonel bir geliştirme laboratuvarına çevirmemiz gerekiyor. Kurulumları Windows'un içine gömülü olan "Linux Alt Sistemi (WSL)" üzerinden yapacağız. Bu size karmaşık gelmesin; sadece Windows'un geliştiriciler için sunduğu resmi bir özelliği aktif edeceğiz.
Kurulum sırasında takıldığınız ve ilerleyemediğiniz bir yer olunca çekinmeden yazabilirsiniz elimden geldiğince yardımcı olacağım.
Lütfen aşağıdaki adımları eksiksiz ve sırasıyla uygulayın.
ADIM 1: Kod Editörünün (VS Code) Kurulması
Öncelikle kodlarımızı yazacağımız ana programı kuralım.
code.visualstudio.com adresine gidin.
Mavi "Download for Windows" butonuna tıklayarak kurulum dosyasını indirin.
İndirdiğiniz dosyayı çalıştırıp standart "İleri -> İleri" adımlarıyla kurulumu tamamlayın.
ADIM 2: Windows İçin Linux Alt Sistemi (WSL) Aktivasyonu
Kodlarımızı derleyecek olan ARM araç zinciri ve simülatörler en kararlı Linux üzerinde çalışır. Bu yüzden bilgisayarımızda ufak bir Ubuntu terminali açacağız.

Bilgisayarınızın Başlat menüsüne PowerShell yazın.
Çıkan sonuca Sağ Tıklayıp -> Yönetici Olarak Çalıştır deyin.
Açılan mavi ekrana şu komutu kopyalayıp yapıştırın ve Enter'a basın: wsl --install
Yaklaşık 5-10 dakikalık bir indirme işlemi yapılacak. Yükleme tamamlandığında bilgisayarınızı mutlaka YENİDEN BAŞLATIN.
Bilgisayar açıldığında karşınıza siyah bir Ubuntu terminali gelecek. Sistem sizden bir kullanıcı adı ve şifre belirlemenizi isteyecek.
(Not: Şifrenizi yazarken ekranda karakterler veya yıldızlar görünmez, klavye basmıyor sanmayın. Şifrenizi yazıp Enter'a basın.(8 karakter)).
ADIM 3: VS Code'u Geliştirme Ortamına Bağlama
Şimdi kurduğumuz editör ile arka plandaki Linux sistemini birbirine bağlayacağız.
VS Code'u açın.
Sol taraftaki menüden Eklentiler (Extensions) simgesine tıklayın (Dört küçük kare simgesi).
Arama çubuğuna sırasıyla şunları yazıp Microsoft'un resmi eklentilerini kurun (Install butonuna basın):
WSL (VS Code'u Ubuntu'ya bağlar)
C/C++ (C kodları için otomatik tamamlama ve renklendirme sağlar)
CMake Tools (Projenin derleme sistemini yönetir)
ADIM 4: Geliştirme Araçlarının (Toolchain) Kurulumu
Bilgisayarınızın Başlat menüsüne Ubuntu yazın ve siyah terminal ekranını açın.
Önce sistemin paket listesini güncellemek için şu komutu yazıp Enter'a basın (Sizden belirlediğiniz Linux şifresini isteyecektir): sudo apt update
Şimdi projemiz için gereken derleyiciyi , derleme sistemini , simülatörü ve sürüm kontrol aracını tek seferde kurmak için şu komutu yapıştırıp Enter'a basın: sudo apt install gcc-arm-none-eabi cmake qemu-system-arm gdb-multiarch git make -y (Bu işlem internet hızınıza bağlı olarak birkaç dakika sürebilir. Bittiğinde terminalde yeni komut yazmaya hazır hale gelecektir).            

ADIM 5: Projeyi Bilgisayara Çekme (Git Clone)
Altyapımız tamamen hazır! Şimdi ana proje dosyalarımızı takımın ortak deposundan kendi bilgisayarınıza indireceksiniz.
Açık olan Ubuntu terminalinize şu komutu yapıştırıp Enter'a basın: git clone https://github.com/saidturan/OSproject
Proje bilgisayarınıza indi. Şimdi o klasörün içine girmek için: cd OSproject yaz çalıştır.
Bu klasörü doğrudan VS Code içinde açmak için şu sihirli komutu yazın (noktayı unutmayın): code .                                                                              ADIM 6: İlk Derleme ve Test
VS Code açıldığında, sol tarafta main.c, CMakeLists.txt gibi dosyalarımızı görüyorsanız tebrikler, ekibe başarıyla katıldınız ve geliştirme ortamınız kusursuz çalışıyor demektir!
Sistemin düzgün derleme yaptığını test etmek için: VS Code'un üst menüsünden Terminal -> New Terminal seçeneğine tıklayın.
Alt tarafta açılan panele şu komutu yazın: cmake .
İşlem bitince şu komutu yazın: make
Ekranda yeşil renkli [100%] Built target kernel.elf yazısını gördüyseniz kurulumunuz kusursuz bir şekilde tamamlanmış demektir…
----------------
GÖMÜLÜ SİSTEMLER İŞLETİM SİSTEMİ PROJESİ: MACOS (MACBOOK) KURULUM REHBERİ
macOS halihazırda sistem programlama için çok uygun bir altyapıya sahiptir. Sadece gerekli derleyici ve simülasyon araçlarını kurarak bilgisayarınızı profesyonel bir gömülü sistem laboratuvarına çevireceğiz. Lütfen adımları sırasıyla uygulayın.
ADIM 1: Kod Editörünün (VS Code) Kurulması
Öncelikle kodlarımızı yazacağımız ana programı kuralım.
 code.visualstudio.com adresine gidin.
Mavi "Download Mac Universal" butonuna tıklayarak kurulum dosyasını indirin.
İndirilen dosyayı (genellikle .zip olur) açın ve içinden çıkan "Visual Studio Code" uygulamasını sürükleyip Uygulamalar (Applications) klasörünüzün içine bırakın.
VS Code'u açın, sol taraftaki menüden Eklentiler (Extensions) simgesine tıklayın (Dört küçük kare simgesi).
Arama çubuğuna sırasıyla şunları yazıp kurun:
C/C++ (Microsoft tarafından yayınlanan)
CMake Tools (Microsoft tarafından yayınlanan)
ADIM 2: Terminal ve Homebrew Kurulumu
Gerekli derleyicileri kurabilmek için Mac'in sihirli paket yöneticisi olan Homebrew'u kullanacağız.
Klavyenizden Command (Cmd) + Boşluk tuşlarına aynı anda basarak Spotlight aramasını açın.
Arama çubuğuna Terminal yazın ve Enter'a basın. Karşınıza beyaz veya siyah bir kod ekranı çıkacak.
Terminal ekranına aşağıdaki kodu tamamen kopyalayıp yapıştırın ve Enter'a basın: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
Kurulum sırasında sizden Mac'inizin açılış şifresini (parolanızı) isteyecektir. Not: Şifrenizi yazarken ekranda hiçbir karakter veya yıldız işareti belirmez, bu bir güvenlik önlemidir. Siz şifrenizi yazıp Enter'a basın.
ÖNEMLİ: Kurulum bittiğinde terminal ekranının en altında "Next steps" (Sonraki adımlar) altında size iki satırlık kod verebilir. Eğer verirse, o iki satırı da kopyalayıp terminale yapıştırın ve Enter'a basın (Bu, kurduğumuz aracı Mac'e tanıtır).
ADIM 3: Geliştirme Araçlarının (Toolchain) Kurulumu
Artık tek bir komutla tüm altyapımızı kurabiliriz!
Açık olan Terminal ekranına aşağıdaki komutu kopyalayıp yapıştırın ve Enter'a basın: brew install arm-none-eabi-gcc arm-none-eabi-gdb cmake qemu make git (Bu işlem internet hızınıza bağlı olarak birkaç dakika sürebilir. İndirme ve kurulum işlemleri otomatik yapılacaktır).

ADIM 4: Projeyi Bilgisayara Çekme (Git Clone)
Altyapımız hazır! Şimdi projemizin ana dosyalarını Github üzerinden bilgisayarınıza indireceğiz.
Terminal ekranına şu komutu yapıştırıp Enter'a basın: git clone https://github.com/saidturan/OSproject
İndirdiğimiz proje klasörünün içine girmek için şu komutu yazın: cd OSproject
Bu klasörü doğrudan kod editörümüzde (VS Code) açmak için şu sihirli komutu yazın (noktayı unutmayın): code .
ADIM 5: İlk Derleme ve Test
VS Code açıldığında, sol tarafta main.c, CMakeLists.txt gibi proje dosyalarımızı görüyorsanız tebrikler, ekibe başarıyla katıldınız!
Sistemin düzgün çalıştığını test etmek için:
VS Code'un üst menüsünden Terminal -> New Terminal seçeneğine tıklayın.
Alt tarafta açılan panele şu komutu yazın ve çalıştırın: cmake .
İşlem bitince şu komutu yazın ve çalıştırın: make
Ekranda yeşil renkli [100%] Built target kernel.elf yazısını gördüyseniz kurulumunuz kusursuz bir şekilde tamamlanmış demektir…
