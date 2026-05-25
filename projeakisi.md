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

---------------------------------------------------------------------------------------------------------------------------------

## Enerji Verimli İşletim Sistemi Mimari Tasarım Dokümanı
Bu doküman, ARM Cortex-M mimarisi üzerinde çalışacak olan enerji verimli gerçek zamanlı işletim
sisteminin (RTOS) çekirdek yapısını, bileşenlerini ve veri akış modellerini detaylandırmaktadır.
Sistemin ana felsefesi; işlemcinin "boşta bekleme" (busy-waiting) sürelerini tamamen ortadan
kaldırarak, olay güdümlü (event-driven) bir mimari ile maksimum enerji tasarrufu sağlamaktır.
### 1. Sistem Katmanları ve Bileşenleri
Sistem mimarimiz üç ana katmandan (Layer) oluşmaktadır:
* **Donanım Soyutlama Katmanı (HAL - Hardware Abstraction Layer):** İşletim sisteminin donanım
bağımsızlığını sağlar. Cortex-M3 işlemcisinin kesme yöneticisi (NVIC), SysTick zamanlayıcısı ve
bellek yönetim birimi (MPU) ile doğrudan haberleşen en alt katmandır.
* **Çekirdek Katmanı (Kernel Layer):**
* **Görev Kontrol Bloğu (TCB - Task Control Block):** Her görevin yığın (stack) işaretçisini,
öncelik değerini ve mevcut durumunu RAM üzerinde tutan veri yapısıdır.
* **Bağlam Değiştirici (Context Switcher):** Bir görevden diğerine geçerken işlemci yazmaçlarını
(registers) yığına kaydeder ve yeni görevin yazmaçlarını geri yükler. (Assembly ile `PendSV`
kesmesi üzerinden yapılacaktır).
* **Zamanlayıcı (Scheduler):** Öncelik Tabanlı (Preemptive) bir algoritma kullanır. Her zaman
"Ready" (Hazır) durumdaki en yüksek öncelikli görevi çalıştırır.
* **Güç Yöneticisi (Power Manager - Boşta Çalışma Görevi):** Sistemde çalışacak hiçbir görev
kalmadığında (tüm görevler Blocked durumundayken) devreye giren "Idle Task"tir.
### 2. İletişim Kanalları (Inter-Process Communication - IPC)
Görevlerin birbiriyle ve donanım kesmeleriyle (ISR) iletişim kurması için enerji tüketimini
engelleyecek şu blokajlı (blocking) yapılar tasarlanmıştır:
* **Semaforlar (Semaphores) ve Mutex'ler:** Paylaşılan bir kaynağa (örneğin UART veya hafıza
bloğu) aynı anda iki görevin erişmesini engeller. Kaynak doluysa, erişmek isteyen görev işlemciyi
döngüye sokup yormaz; çekirdek tarafından anında "Uyku/Blocked" durumuna alınır.
* **Mesaj Kuyrukları (Message Queues):** Kesme Hizmet Rutinleri (ISR) ile normal görevler
arasında asenkron veri taşır. ISR, çok kısa sürede donanımdan veriyi alır, kuyruğa bırakır ve çıkar.
Görev ise bu kuyruktan veriyi çekip uzun süren işlemleri gerçekleştirir.
### 3. Detaylı Veri Akışı ve Yürütme Modeli (Data Flow)
Sistemdeki veri akışı, enerji tüketimini minimize etmek için tamamen **"Kesme Güdümlü (Interrupt-
Driven)"** olarak tasarlanmıştır.
**Örnek Veri Akış Senaryosu (Sensör Okuma ve İşleme):**
1. **Uyku Durumu (Deep Sleep):** Sistemde işlenecek bir veri yoktur. Tüm görevler "Blocked"
durumundadır. Güç Yöneticisi, ARM işlemcisine `WFI` (Wait For Interrupt) komutunu göndererek
işlemcinin saat sinyallerini (clock) durdurur ve sistemi derin uykuya sokar.
2. **Verinin Gelişi (Donanım Kesmesi):** Bir dış sensörden veri geldiğinde donanım kesmesi (örn:
EXTI veya UART RX) tetiklenir.
3. **Uyanış ve ISR (Interrupt Service Routine):** İşlemci uyanır. İlgili ISR hızlıca çalışır, gelen veriyi
donanım yazmacından okur ve bir **Mesaj Kuyruğuna (Message Queue)** yazar.
4. **Durum Güncellemesi (State Transition):** ISR veriyi kuyruğa bıraktığı anda, bu kuyruktan veri
bekleyen ve o ana kadar uyuyan "Veri İşleme Görevi (Task)", Çekirdek tarafından anında "Ready"
(Hazır) durumuna çekilir.
5. **Bağlam Değişimi (Context Switch):** ISR bittiği an, Zamanlayıcı (Scheduler) devreye girer.
"Veri İşleme Görevi" artık hazır olduğu için PendSV kesmesi tetiklenerek kontrol bu göreve verilir.
6. **İşleme ve Tekrar Uyuma:** Görev veriyi işler. İşlem bittiğinde kuyrukta yeni veri yoksa, görev
kendini tekrar "Blocked" durumuna çeker. İşlemci işsiz kaldığı için Güç Yöneticisi tekrar `WFI`
komutunu çalıştırır ve sistem uykudaki minimum enerji tüketimi durumuna geri döner.
### 4. Enerji Verimliliği Stratejisi: Tickless Idle
Geleneksel işletim sistemleri her 1 milisaniyede bir (SysTick ile) uyanıp "Acaba yapacak bir iş var
mı?" diye kontrol eder. Bu durum gömülü sistemlerde bataryayı hızla tüketir.
Mimari tasarımımızda **"Tickless Idle"** yaklaşımı benimsenecektir:
* Sistem uykuya dalmadan önce, bir sonraki görevin ne zaman çalışması gerektiği (Zamanlayıcı
listesi) hesaplanır.
* İşlemciyi uyandıran SysTick kesmesi, her milisaniyede bir değil; sadece o hesaplanan "gelecek
zaman" için kurulur.
* Böylece sistem gereksiz yere uyanmaz, enerji tasarrufu maksimize edilir.


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

# Teknoloji Araştırması ve Seçimi

## Gömülü Sistemler için Enerji Verimli İşletim Sistemi

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
--------------------------------------------------------------------------
BOOTLOADER TASARIM SPESİFİKASYONU
1. Giriş
Bu doküman, ARM mimarisi tabanlı bir SoC üzerinde Linux çekirdeğini güvenilir biçimde başlatacak özelleştirilmiş bir bootloader’ın tasarım esaslarını tanımlar. Belge; bootloader’ın görevlerini, çok aşamalı çalışma akışını, bellek düzenini, adresleme şemasını ve hata işleme mekanizmalarını kapsar. Amaç, donanım başlatma sürecini şeffaf biçimde belgeleyerek geliştirme, doğrulama ve bakım aşamalarında ortak bir referans oluşturmaktır.
Spesifikasyon, doğrudan kod örnekleri vermek yerine sistemin çalışma mantığına ve mimari bağımlılıklarına odaklanır. Bu nedenle uygulama detayları (bellek adresleri, sürücü yapılandırmaları vb.) örnek niteliğinde verilmiş olup hedef SoC’nin referans kılavuzuna göre uyarlanmalıdır.
2. Bootloader Genel Bakışı
2.1 Tanım
Bootloader, sistem güç verildikten ya da reset uygulandıktan sonra çalışan ilk yazılım katmanıdır. İşlemcinin, belleğin ve gerekli çevre birimlerinin Linux çekirdeğini çalıştıracak duruma getirilmesinden sorumludur. Çekirdek, görevini bootloader tarafından doğru biçimde hazırlanmış bir donanım ortamı üzerinde devralır.
2.2 Temel Görevleri
Donanım başlatma: saat sinyalleri (PLL), DRAM denetleyicisi, UART, depolama arabirimleri ve gerekli GPIO uçları yapılandırılır.
Çekirdek görüntüsünün yüklenmesi: kernel ve Device Tree Blob (DTB), boot aygıtından (eMMC, SD, NAND, NOR vb.) RAM’e kopyalanır.
Açılış parametrelerinin aktarılması: kernel komut satırı (bootargs) ve donanım tanımları çekirdeğe iletilir.
Kontrolün devredilmesi: ARM çağrı kuralına uygun kayıt değerleri ayarlanarak çekirdeğin giriş noktasına atlanır.
Güvenlik ve bütünlük kontrolü: isteğe bağlı olarak görüntülerin imza doğrulaması yapılır (Secure Boot).
Hata yönetimi: yükleme başarısız olduğunda kurtarma görüntüsü çalıştırılır veya sistem watchdog tarafından sıfırlanır.
2.3 Tasarım Hedefleri
Düşük açılış süresi: uçtan uca toplam açılış süresinin minimuma indirilmesi.
Modüler yapı: BL0 → BL1 → BL2 → BL33 zinciri ile her aşamanın bağımsız doğrulanabilir olması.
Mimari uyumluluk: ARMv8-A (AArch64) ve gerekiyorsa AArch32 modlarında çalışabilirlik.
Kernel uyumluluğu: mainline Linux çekirdeği için belgelenmiş açılış protokolüne tam uyum.
3. Açılış Süreci ve Aşamalar
Açılış, modern ARM SoC’lerinde çok aşamalı bir bootloader zinciri ile gerçekleştirilir. Her aşama, bir sonrakini yüklemek ve doğrulamak için minimum sorumluluk üstlenir. Bu yapı; güvenlik, esneklik ve sınırlı SRAM kaynaklarının verimli kullanımı bakımından avantaj sağlar.


4. ARM Mimarisi ile İlişki
4.1 Reset Vektörü ve İstisna Seviyeleri
ARM işlemcisi, reset sinyalinin ardından önceden tanımlı bir reset vektörü adresinden çalışmaya başlar. Bu adres, SoC üreticisi tarafından dahili Boot ROM’a yönlendirilmiş durumdadır. AArch64 (ARMv8-A) işlemciler reset sonrası en yüksek istisna seviyesinde, EL3’te çalışmaya başlar; AArch32 işlemciler ise SVC modunda başlar. Bootloader, bu yüksek ayrıcalık seviyesinde donanım kaynaklarını yapılandırır ve gerektiğinde kontrolü daha düşük seviyelere (örneğin EL2 veya EL1) devretmek üzere ARM Trusted Firmware aracılığıyla geçişleri ayarlar.
4.2 ARM Trusted Firmware (ATF)
Modern ARM platformlarında BL1, BL2 ve BL31 katmanları için referans uygulama olarak ARM Trusted Firmware kullanılır. ATF; güvenli dünya (Secure World) servislerini, SMC (Secure Monitor Call) çağrılarını ve TrustZone tabanlı izolasyonu yönetir. Linux çekirdeği EL1’de çalışırken, BL31 EL3’te bir runtime servisi olarak kalır.
4.3 Çekirdeğe Geçiş Kayıt Kuralları
Çekirdek giriş noktasına atlanmadan önce işlemci kayıtları, Linux ARM/ARM64 boot protokolüne uygun şekilde ayarlanır:
AArch64: x0 = DTB fiziksel adresi; x1, x2, x3 = 0; MMU kapalı; D-cache geçersiz, I-cache açık olabilir.
AArch32: r0 = 0; r1 = makine türü (legacy); r2 = ATAG/DTB adresi; MMU kapalı.
Tüm yazma işlemleri belleğe işlenmiş (flush) olmalı, önbellek tutarlılığı sağlanmalıdır.
5. Bellek Düzeni ve Adresleme Şeması
Aşağıdaki tablo, tipik bir 1 GB DRAM yapılandırmasında bootloader’ın kullanacağı örnek bellek haritasını göstermektedir. Adresler hedef SoC’ye göre uyarlanmalıdır.


6. Donanım Başlatma
6.1 Saat ve Güç Alt Sistemi
Reset sonrası işlemci, dahili düşük frekanslı bir saat sinyaliyle çalışır. SPL aşamasında PLL (Phase-Locked Loop) yapılandırılarak işlemci, bellek ve veri yolları için hedef frekanslar elde edilir. Güç yönetim çipi (PMIC) gerektiğinde I²C üzerinden yapılandırılır.
6.2 DRAM Denetleyicisi ve Bellek Eğitimi
DRAM erişimi mümkün olmadan önce denetleyici parametreleri (CAS gecikmesi, refresh süresi, şerit yapılandırması vb.) ayarlanır. DDR3/DDR4 sistemlerde sinyal bütünlüğü için bellek eğitimi (memory training) yordamı çalıştırılır. Bu yordam, ana bootloader’ın DRAM’e kopyalanabilmesi için kritik öneme sahiptir.
6.3 Çevre Birimleri
UART: konsol çıktısı ve hata ayıklama günlüğü için ilk başlatılan birimdir.
Depolama arabirimi: eMMC/SD/NAND denetleyicisi etkinleştirilir; kernel ve DTB buradan okunur.
USB ve Ethernet: ağ üzerinden açılış (TFTP) veya kurtarma için isteğe bağlı olarak başlatılır.
GPIO ve LED: açılış aşamalarının görsel olarak izlenmesi için durum göstergesi olarak kullanılabilir.
7. Çekirdek Yükleme Süreci
7.1 Görüntü Formatları
Image: AArch64 için ham, sıkıştırılmamış çekirdek görüntüsü; doğrudan belirlenen adrese kopyalanır.
zImage: AArch32 için kendi kendini açabilen sıkıştırılmış görüntü.
FIT (Flattened Image Tree): kernel, DTB ve initramfs’i tek bir imzalanabilir paket olarak taşır; güvenli açılış için tercih edilir.
7.2 Yükleme ve Devir Akışı
Boot aygıtından kernel görüntüsü okunarak yükleme adresine kopyalanır.
DTB ayrı bir adrese yüklenir; gerektiğinde bootargs ile güncellenir.
Önbellekler temizlenir; veri tutarlılığı sağlanır.
İşlemci kayıtları boot protokolüne uygun şekilde hazırlanır.
Çekirdeğin giriş noktasına dallanılır; bu noktadan itibaren kontrol kernel’dedir.
8. Güvenlik ve Hata İşleme
8.1 Güvenli Açılış (Secure Boot)
Güven zinciri, donanım kökünden (hardware root of trust) başlar. Boot ROM, SPL’in imzasını OTP belleğindeki açık anahtarla doğrular. Doğrulanan SPL bir sonraki aşamayı (BL2 ve BL33), BL33 ise çekirdek görüntüsünü aynı yöntemle doğrular. Herhangi bir aşamadaki imza uyuşmazlığı açılışın durdurulmasına yol açar.
8.2 Watchdog ve Kurtarma
Bootloader başlangıcında donanım watchdog zamanlayıcısı etkinleştirilir. Açılış belirlenen süre içinde tamamlanmazsa watchdog sistemi sıfırlar ve alternatif bir bölümden (kurtarma görüntüsü) açılış denenir. Bu mekanizma, alan koşullarında bozulmuş güncellemelere karşı sistemin kullanılamaz duruma gelmesini önler.
8.3 Hata Raporlama
UART konsolu üzerinden ayrıntılı hata günlüğü yayımlanır.
Kalıcı bir bölüme kısa hata kodları yazılarak kernel devraldıktan sonra okunabilir.
Belirli kritik hatalarda LED yanıp sönme örüntüsü ile görsel sinyalleme yapılır.
9. Açılış Akış Diyagramı
Aşağıdaki diyagram, güç verilmesinden Linux çekirdeğinin devralmasına kadar gerçekleşen tüm aşamaları özetlemektedir.

Şekil 1. ARM tabanlı gömülü Linux sistemi için bootloader açılış akışı.
10. Sonuç
Bu spesifikasyon; ARM mimarisi üzerinde çalışan Linux tabanlı bir gömülü sistem için bootloader’ın görevlerini, çok aşamalı yapısını, bellek düzenini, donanım başlatma adımlarını ve güvenlik mekanizmalarını tanımlamaktadır. Açıklanan modüler tasarım; geliştirme sürecinde her aşamanın bağımsız doğrulanmasına olanak tanırken çekirdeğin tutarlı ve güvenilir biçimde başlatılmasını sağlar. Sonraki aşamada hedef SoC’ye özgü adresler ve sürücü yapılandırmaları ile bu spesifikasyonun somut uygulamaya dönüştürülmesi planlanmaktadır.
------------------------------------------------------------------------------
Çekirdek Seviyesi Cihaz Sürücü Arayüz Tasarımı (RTOS)
1. Cihaz Sürücüsü Nedir ve Çekirdekle Neden Bağlantılı Çalışır?
Cihaz sürücüsü (Device Driver), işletim sistemi çekirdeği ile fiziksel donanım arasındaki iletişimi sağlayan bir yazılım katmanıdır. Donanımlar (sensörler, motor sürücüleri, iletişim modülleri) kendilerine has register (yazmaç) yapılarına ve elektriksel sinyallere sahiptir. Çekirdek, her donanımın karmaşık detaylarını bilmek zorunda kalmamalıdır. Sürücüler, donanıma özgü bu sinyalleri çekirdeğin anlayabileceği standart yazılım çağrılarına çeviren bir "çevirmen" görevi görür.
Sürücülerin çekirdekle bağlantılı çalışmasının temel nedeni kaynak yönetimidir. Çekirdek; bellek, işlemci zamanı ve güç tüketimi gibi kısıtlı kaynakları yönetir. Sürücü doğrudan çekirdeğe entegre olarak, donanımın ne zaman uyku moduna geçeceğini (düşük güç tüketimi) veya bir kesme (interrupt) geldiğinde işlemcinin nasıl tepki vereceğini (gerçek zamanlılık) çekirdek ile senkronize şekilde ayarlar.
2. Kernel Space ve User Space Ayrımı
İşletim sistemlerinde güvenlik ve kararlılık için bellek iki ana bölüme ayrılır:
Kernel Space (Çekirdek Alanı): İşletim sisteminin kalbinin attığı, donanıma doğrudan ve kısıtlamasız erişimin olduğu alandır. Cihaz sürücüleri burada çalışır. Bu alanda yapılacak bir hata (örneğin yanlış bir bellek adresine yazma) tüm sistemin çökmesine (Kernel Panic) neden olur.
User Space (Kullanıcı Alanı): Uygulamaların çalıştığı kısıtlı alandır. User space'teki bir uygulama donanıma doğrudan erişemez; bunun yerine Sistem Çağrıları (System Calls) aracılığıyla Kernel Space'ten izin ve işlem talep eder.
Not: Kaynak kısıtlı bazı küçük gömülü sistemlerde (ve bazı mikroçekirdek RTOS mimarilerinde) performans ve düşük bellek ayak izi için her şey tek bir alanda çalışabilir, ancak donanım tabanlı bellek koruma birimleri (MPU) ile mantıksal bir ayrım yapmak güvenilirliği artırır.
3. Giriş/Çıkış (I/O) ve Haberleşme Mantığı
Sürücüler donanımla veri alışverişi yaparken temel olarak üç Giriş/Çıkış (I/O) yöntemi kullanır:
Polling (Sürekli Kontrol): İşlemci sürekli "Veri geldi mi?" diye donanımı kontrol eder. İşlemciyi meşgul ettiği ve güç tüketimini artırdığı için enerji verimli RTOS tasarımlarında tercih edilmez.
Interrupts (Kesmeler): Donanım, verisi hazır olduğunda işlemciye donanımsal bir sinyal gönderir. İşlemci o anki işini bırakır, ISR (Interrupt Service Routine) adı verilen sürücü fonksiyonunu çalıştırır ve geri döner. Gerçek zamanlı sistemler (RTOS) ve güç tasarrufu için en ideal yöntemdir.
DMA (Direct Memory Access): İşlemci hiç yorulmadan donanım verilerinin doğrudan belleğe yazılmasıdır. Yüksek boyutlu veriler (örneğin ekran veya ses verisi) için kullanılır.
İletişim mantığı Memory-Mapped I/O (Bellek Eşlemeli I/O) üzerinden yürür. Donanımın kontrol yazmaçları, RAM'deki belirli bellek adresleri gibi haritalandırılır. Sürücü, bu C pointer adreslerine okuma/yazma yaparak donanımı kontrol eder.
4. ARM Tabanlı Sistemlerde Sürücü Yapısı
ARM Cortex-M gibi gömülü sistem mimarilerinde sürücü geliştirmek belirli standartlara dayanır:
NVIC (Nested Vectored Interrupt Controller): Kesmelerin önceliklendirilmesini donanımsal olarak yapar. Gerçek zamanlı görev planlayıcısının (Task Scheduler) kritik görevleri kesintiye uğratmadan donanım olaylarını yönetmesini sağlar.
CMSIS (Cortex Microcontroller Software Interface Standard): ARM'ın sunduğu bir donanım soyutlama katmanıdır. Doğrudan donanım adreslerini ezberlemek yerine UART1->DR = data; gibi yapılandırılmış pointer'lar kullanılmasına olanak tanır.
5. Modüler Sürücü Mantığı
Modüler mimari, işletim sistemini yeniden derlemeye gerek kalmadan sürücülerin sisteme takılıp çıkarılabilmesidir (Loadable Kernel Modules). C dilinde bu, fonksiyon göstericileri (Function Pointers) barındıran yapılar (struct) kullanılarak gerçekleştirilir. Çekirdek, donanımın markasını veya modelini bilmez; sadece read(), write(), init() gibi standart fonksiyonların tanımlı olduğu arayüzleri bilir.




6. Basit Sürücü Çalışma Akışı
[Kullanıcı Uygulaması] ---> Sensörden veri oku()
          |
          v
[Çekirdek (VFS/Device Manager)] ---> Hangi donanım? (Örn: /dev/i2c1)
          |
          v
[Donanım Soyutlama Katmanı (HAL)] ---> i2c_read() fonksiyonunu çağır
          |
          v
[Cihaz Sürücüsü (I2C Driver)] ---> ARM Registerlarına yaz, Kesme (Interrupt) bekle
          |
          v
[Fiziksel Donanım] ---> İletişim Hattı (SDA/SCL) ---> [Sensör/Cihaz]

7. Donanım Soyutlama Katmanı (HAL) - C Arayüz (API) Tasarımı
Projenin "düşük güç tüketimi" hedefini göz önünde bulundurarak, standart fonksiyonlara ek olarak suspend ve resume gibi güç yönetimi (Power Management) yeteneklerini de arayüze eklenmiştir.
-------------------------------------------------------------------------
BELLEK YÖNETİMİ  
. Bellek Yönetimi Nedir ve Neden Önemlidir?

Bellek yönetimi, bir bilgisayar sisteminde mevcut RAM (Rastgele Erişimli Bellek) kaynağının süreçlere, görevlere veya veri yapılarına tahsis edilmesi, kullanılması ve geri alınması süreçlerini kapsayan temel bir işletim sistemi işlevidir. Bu işlev; belleğin verimli kullanılması, programların birbiriyle çakışmaması ve sistemin kararlılığının korunması açısından kritik öneme sahiptir.

1.1 Gömülü Sistemlerde Önemi
Masaüstü veya sunucu sistemlerin aksine, gömülü sistemler son derece kısıtlı donanım kaynaklarıyla çalışmak zorundadır. Birkaç kilobayt ile birkaç megabayt arasında değişen RAM miktarları, bellek yönetimini bu sistemlerde hayati bir konu haline getirmektedir.

Sistemin beklenmedik şekilde çökmesi veya donması
Bellek sızıntıları nedeniyle zamanla belleğin tükenmesi
Gerçek zamanlı görevlerin zamanında tamamlanamaması
Güvenlik açıklarının oluşması ve donanım hasar riski




Şekil: Gömülü Sistem RAM Bellek Haritası – Segment Dağılımı
2. Gömülü Sistemlerde RAM Kullanımının Optimizasyonu

Gömülü sistemlerde RAM optimizasyonu, tasarım aşamasında başlamalı ve uygulamanın tüm yaşam döngüsü boyunca sürdürülmelidir.

2.1 Veri Türlerinin Dikkatli Seçimi
Değişkenlerin veri tipi seçimi doğrudan bellek tüketimini etkiler. uint8_t kullanmak, int32_t kullanımına göre 4 kat daha az bellek tüketir. Bu fark yüzlerce değişken içeren sistemlerde ciddi tasarrufa dönüşür.

2.2 Küresel Değişkenlerin Sınırlandırılması
Küresel değişkenler programın tamamı boyunca bellekte yer kaplar. Yalnızca gerçekten global erişim gerektiren veriler küresel kapsamda tanımlanmalıdır.

2.3 Sabitlerin Flash Bellekte Saklanması
Mikrodenetleyicilerde sabit veriler RAM yerine flash bellekte saklanabilir. AVR sistemlerde PROGMEM, ARM sistemlerde const niteleyicisi bu amaçla kullanılır.


Şekil: Statik ve Dinamik Bellek Yönetiminde Tipik RAM Kullanım Dağılımı
3. Statik ve Dinamik Bellek Yönetimi

Bellek tahsis stratejileri temelde iki ana kategoriye ayrılır: statik bellek yönetimi ve dinamik bellek yönetimi.



3.1 Statik Bellek Yönetimi
Tüm değişkenler ve veri yapıları derleme aşamasında tanımlanır. BSS segmentindeki sıfırlanmış global değişkenler ve DATA segmentindeki başlangıç değeri atanmış değişkenler bu kategoriye girer.

3.2 Dinamik Bellek Yönetimi
Bellek, çalışma zamanında malloc(), calloc() veya realloc() fonksiyonlarıyla talep edilir ve free() ile serbest bırakılır. Esneklik sağlar ancak heap fragmentasyonu ve bellek sızıntısı riskleri beraberinde gelir.



4. Bellek Ayırma ve Serbest Bırakma Mantığı

Dinamik bellek yönetiminde heap adı verilen bir bellek bölgesi kullanılır. Sistem bu alanı serbest blok listesi (free list) aracılığıyla yönetir.

4.1 Bellek Ayırma Algoritmaları
First Fit (İlk Uygun): İlk yeterince büyük bloğu tahsis eder. Hızlıdır ancak liste başında fragmentasyon oluşturur.
Best Fit (En Uygun): Talebi karşılayacak en küçük bloğu seçer. Fragmentasyonu azaltır fakat tarama süresi uzundur.
Buddy System: Belleği 2'nin kuvvetleri şeklinde böler. Birleştirme (coalescing) işlemi hızlı yapılır.
Memory Pool: Sabit boyutlu bloklarla O(1) tahsis sağlar; gömülü sistemler için en uygun yaklaşımdır.


Şekil: Bellek Ayırma Algoritmalarının Performans Karşılaştırması
4.2 Bellek Serbest Bırakma
free() çağrıldığında ilgili blok serbest listeye geri eklenir. Bitişik serbest bloklar birleştirilerek daha büyük blok elde edilir. Çift serbest bırakma (double free) ciddi bellek bozulmalarına yol açar.

5. Bellek Havuzu (Memory Pool) Yapısı

Bellek havuzu, önceden belirlenmiş sayıda ve sabit boyutlu bellek bloklarından oluşan bir yapıdır. Dinamik belleğin esnekliğiyle statik belleğin güvenilirliğini birleştirir.


Şekil: Bellek Havuzu Blok Yapısı ve Tahsis Adımları
Sabit zamanlı (O(1)) tahsis ve serbest bırakma işlemi
Dış fragmentasyon tamamen önlenir
Deterministik davranış – gerçek zamanlı sistemler için idealdir
Bellek sızıntısı tespiti kolaylaşır



6. Minimal Bellek Ayak İzi için Yöntemler

6.1 Yığıt Boyutunun Optimizasyonu
Gerçek yığıt kullanımı su işareti analizi (stack watermark) ya da kanarya değerleri (canary values) ile ölçülerek optimize edilebilir.

6.2 Bağlantı Zamanı Optimizasyonu
GCC'nin --gc-sections bayrağı ve -ffunction-sections / -fdata-sections seçenekleri kullanılmayan kod ve değişkenleri bağlama aşamasında kaldırır.

6.3 Sabitlerin Flash'ta Saklanması
Büyük sabit veri kümeleri flash bellekte saklanarak RAM'den tasarruf edilebilir. RLE ve LZ77 tabanlı algoritmalar bu bağlamda sıkça kullanılır.

7. Bellek Taşması ve Bellek Sızıntısı Problemleri

7.1 Bellek Taşması (Buffer Overflow / Stack Overflow)
Bir bellek bölgesine ayrılan kapasitesinin ötesinde veri yazılması durumunda bellek taşması meydana gelir. MMU olmayan sistemlerde bu hatalar doğrudan veri bozulmasına neden olur.

7.2 Bellek Sızıntısı (Memory Leak)
Dinamik olarak tahsis edilen belleğin free() ile serbest bırakılmaması durumunda oluşur. Uzun süreli çalışan sistemlerde birikimli sızıntılar heap alanını tamamen tüketebilir.


Şekil: Bellek Sızıntısı – Kullanılan Bellek Miktarının Zamana Göre Değişimi


8. Bellek Problemlerini Önleme Yöntemleri

8.1 Statik Analiz Araçları
PC-lint / FlexeLint: MISRA-C uyumlu bellek analizi
Polyspace: Kanıtlanabilir güvenli kod analizi
Clang Static Analyzer: Ücretsiz, açık kaynaklı analiz

8.2 Dinamik Analiz Araçları
Valgrind / Memcheck: Bellek sızıntısı tespiti
AddressSanitizer (ASan): Derleyici tabanlı hızlı hata tespiti
Electric Fence: Heap sınırı ihlallerini tespit eder

8.3 Güvenli Kodlama Pratikleri
Bellek tahsisinden sonra NULL işaretçi kontrolü yapılmalıdır
free() çağrısının ardından işaretçi NULL'a atanmalıdır (dangling pointer önleme)
MISRA-C 2012 gibi endüstriyel kodlama standartları benimsenmelidir

8.4 Donanım Tabanlı Koruma
MPU (Memory Protection Unit): Bellek bölgelerine erişim izinleri tanımlar
WDT (Watchdog Timer): Donmuş sistemleri otomatik yeniden başlatır

9. Bellek Yönetim Akış Şeması

Aşağıdaki diyagram, gömülü bir sistemde dinamik bellek tahsis ve serbest bırakma sürecinin adım adım akışını göstermektedir.


Şekil: Dinamik Bellek Tahsis ve Serbest Bırakma Akış Şeması
Hata işleme adımının sistemi güvenli duruma geçirmesi kritiktir. Gerçek zamanlı ve güvenlik-kritik sistemlerde bu adım ihmal edilmemelidir.

10. Sonuç

Statik bellek yönetimi; öngörülebilirlik ve güvenilirlik açısından gömülü sistemlerde birincil yaklaşım olmalıdır.
Dinamik bellek kaçınılmazsa, bellek havuzu yapıları doğrudan heap kullanımına güvenli alternatif sunar.
Bellek sızıntısı ve taşma hataları; kodlama standartları, statik analiz ve donanım korumaları ile önlenebilir.
Bellek yönetimi her gömülü sistem projesinin temel mühendislik önceliklerinden biri olarak ele alınmalıdır.
---------------------------------------------------------------------------------------
GERÇEK ZAMANLI AKIŞ ŞEMASI
 1.GİRİŞ
Gömülü sistemler, kısıtlı enerji kaynakları (pil) ve sınırlı donanım kapasitesi ile yüksek güvenilirlik gerektiren ortamlarda çalışmaktadır. Bu projede, ARM mimarisi üzerinde koşan gömülü cihazlar için enerji verimliliği ve gerçek zamanlılık (real-time) arasındaki dengeyi optimize eden bir Görev Planlayıcısı (Scheduler) tasarımı ele alınmıştır. Amaç, kritik görevlerin zamanında tamamlanmasını garanti altına alırken (determinism), sistemin boşta olduğu sürelerde güç tüketimini minimuma indirmektir.

 
 2. GERÇEK ZAMANLI SİSTEM VE PLANLAYICI MİMARİSİ
2.1 Gerçek Zamanlılık Kriterleri
Gerçek zamanlı bir sistemin başarısı, işlemin doğruluğunun yanı sıra bu işlemin zaman kısıtları (deadlines) içerisinde gerçekleştirilmesine bağlıdır. Tasarımımızda iki temel gerçek zamanlılık türü referans alınmıştır:
Hard Real-Time: Zaman kısıtının ihlali sistem felaketine yol açar (Örn: Hava yastığı kontrolü).
Soft Real-Time: Gecikmeler tolere edilebilir ancak performans kaybı oluşur.
2.2 Görev Kontrol Bloğu (TCB - Task Control Block)
Planlayıcı, her görevi yönetmek için bellek üzerinde bir TCB yapısı tutar. Bu yapı, bağlam anahtarlama (context switching) sırasında görevlerin durumunu korur:
Görev Önceliği: Statik olarak atanmış RMS değeri.
Yığıt İşaretçisi (Stack Pointer): CPU kayıtçılarının (registers) saklandığı adres.
Görev Durumu: Ready (Hazır), Running (Çalışıyor), Waiting (Beklemede).



 
 3. ALGORİTMA TASARIMI: RATE MONOTONIC SCHEDULING (RMS)
Proje kapsamında, periyodik görevlerin planlanmasında en güvenilir yöntem olan Rate Monotonic Scheduling (RMS) seçilmiştir.
3.1 RMS Mantığı ve Öncelik Ataması
RMS algoritması, görevlere periyotları ile ters orantılı öncelikler atar.
Kural: Periyodu kısa olan görev, daha yüksek önceliğe sahiptir.
Sabit Öncelik: Görevler çalışma anında öncelik değiştirmez, bu da işlemci üzerindeki yükü (overhead) azaltarak enerji tasarrufu sağlar.
3.2 Simülasyon Tabanlı Performans Analizi
Tasarım aşamasında, görevlerin çakışma durumlarını ve birbirlerini kesme (preemption) süreçlerini analiz etmek için simülasyonlar yürütülmüştür.
 




  4. ENERJİ VERİMLİLİĞİ VE SİMÜLASYON ANALİZİ
4.1 Tickless Idle Mekanizması
Geleneksel sistemlerdeki her "tick" uyanışının getirdiği enerji maliyetini önlemek adına Tickless Idle tekniği kullanılmıştır.
Standart Yaklaşım: CPU her 1ms'de bir uyanır (Yüksek tüketim).
EV-OS Yaklaşımı: Planlayıcı bir sonraki göreve kadar olan süreyi hesaplar ve CPU'yu derin uyku moduna sokar.




  5. GERÇEK DÜNYA UYGULAMASI VE AKIŞ ŞEMASI
Gerçek bir donanım üzerinde (ARM Cortex-M), planlayıcının karar verme süreci aşağıdaki mantıksal akış şemasına dayanmaktadır:
5.1 Planlayıcı Akış Şeması (Flowchart)
START: Donanım kesmesi tetiklenir (Systick/External).
CHECK: "Hazır Liste" içerisinde çalışmaya uygun bir görev var mı?
DECISION: * Hayır ise: Sleep Mode (WFI) aktif edilir, enerji tasarrufuna geçilir.
Evet ise: Bir sonraki adıma geçilir.
PRIORITY CHECK: Hazır görevin önceliği mevcut görevden yüksek mi?
CONTEXT SWITCH: Mevcut kayıtçılar yığıta (stack) yazılır, yeni görevin verileri yüklenir.
EXECUTE: Görev yürütülür ve döngü başa döner.




SONUÇ
Bu teknik tasarım dokümanında, gömülü sistemler için enerji verimliliği odaklı bir gerçek zamanlı planlayıcı mimarisi sunulmuştur. Rate Monotonic Scheduling (RMS) algoritması kullanılarak sistemin deterministik çalışması simülasyonlarla doğrulanmıştır. Tickless Idle ve ARM tabanlı bağlam anahtarlama teknikleri ile sistemin hem güvenilir hem de düşük güç tüketimli bir profil çizdiği kanıtlanmıştır. Yapılan simülasyonlar, teorik yaklaşımların gerçek donanım kısıtları altında başarılı sonuçlar verdiğini göstermektedir.
-------------------------------------------------------------------------------------------

GÜÇ YÖNETİMİ MODULU TASARIMI
Özet
Gömülü sistemlerin büyük çoğunluğu sınırlı enerji kaynaklarıyla (pil, küçük süperkondansatör veya enerji hasadı devresi) çalışır. Bu nedenle güç yönetimi, modern gömülü işletim sistemi tasarımının en kritik bileşenlerinden biri hâline gelmiştir. Bu rapor; güç yönetiminin temel kavramlarını, gömülü sistemlerde gözlenen enerji tüketim sorunlarını, düşük güç modlarının (sleep / idle) mantığını, işlemci ve çevresel birim seviyesindeki güç kontrol tekniklerini, gereksiz enerji tüketimini azaltmaya yönelik yazılım ve donanım yöntemlerini, pil ömrü ile sistem verimliliği arasındaki ilişkiyi ve özellikle yaygın olarak kullanılan ARM tabanlı işlemcilerde uygulanan güç yönetim yaklaşımını ele almaktadır. Ayrıca raporun sonunda, modül için önerilen durum geçişlerini özetleyen bir akış şeması sunulmuştur.
1. Giriş
Görüntü işleme uygulamaları doğası gereği yoğun hesaplama gerektirir; bu hesaplama yükü doğrudan enerji tüketimine yansır. Sistemin pille çalıştığı senaryolarda (taşınabilir kamera modülleri, IoT görüntü düğümleri, drone üzerine yerleştirilen görüntü işleyiciler gibi) enerji verimliliği, yalnızca cihazın çalışma süresini değil; ısınma, performans kararlılığı ve donanım ömrünü de doğrudan etkiler. Bu rapor, projemizin gömülü işletim sistemi katmanında konumlanacak Güç Yönetimi Modülü’nün tasarım gereksinimlerini, yapısal kararlarını ve çalışma prensiplerini tanımlamak amacıyla hazırlanmıştır.
Raporun amacı kod üretmek değil, modülün mimari tasarımını belgelemektir. Bu nedenle ilerleyen bölümlerde donanım/yazılım katmanlarına ait soyut tanımlar, durum makineleri ve karar mekanizmaları üzerinden ilerlenmiştir.
2. Güç Yönetimi Nedir ve Neden Önemlidir?
Güç yönetimi (power management); bir sistemin işlevlerini sürdürürken tükettiği elektrik enerjisini ölçmek, denetlemek ve mümkün olan en düşük seviyeye indirmek amacıyla uygulanan donanım ve yazılım tekniklerinin bütünüdür. Gömülü sistemlerde bu kavram yalnızca “tasarruf etmek” anlamına gelmez; aynı zamanda işlemcinin termal limitler içinde tutulması, pilin kullanım ömrünün uzatılması ve sistemin gerçek-zamanlı tepki yeteneğinin korunması demektir.
Güç yönetiminin önemi birkaç başlıkta toplanabilir:
Sistem ömrü: Pille çalışan cihazlarda etkin güç yönetimi, kullanım süresini birkaç saatten haftalara, hatta yıllara çıkarabilir.
Isıl davranış: Gereksiz tüketim, ısı olarak atılır. Aşırı ısınma performansı düşürür ve bileşen ömrünü kısaltır.
Güvenilirlik: Pil voltajının ani düşmesi sistemin beklenmedik biçimde yeniden başlamasına yol açabilir; güç yönetimi bunu öngörülebilir hâle getirir.
Maliyet: Daha küçük pil ve daha basit termal çözüm, üretim maliyetini doğrudan düşürür.
Çevresel etki: Düşük enerji tüketimi, ölçek büyüdükçe ciddi miktarda elektrik tüketiminin önüne geçer.
3. Gömülü Sistemlerde Enerji Tüketimi Sorunları
Gömülü cihazlarda enerji tüketimi, masaüstü veya sunucu sistemlerinden farklı kısıtlar altında değerlendirilmelidir. Karşılaşılan başlıca sorunlar aşağıda sıralanmıştır:
3.1. Sınırlı Enerji Kaynağı
Birçok cihaz bir pil veya küçük bir enerji hasadı devresinden (örneğin güneş paneli, piezoelektrik üretici) beslenir. Kaynağın kapasitesi sabit olduğundan, sistemin tükettiği her miliamper doğrudan çalışma süresinden eksilir.
3.2. Sızıntı (Statik) Akımı
Modern CMOS işlemcilerde, transistör kapısı kapalı olduğunda bile küçük bir akım akmaya devam eder. Bu sızıntı akımı, sistem hiçbir iş yapmıyor olsa dahi enerji tüketir ve özellikle düşük güç modlarında toplam tüketimin baskın bileşeni hâline gelir.
3.3. Dinamik Tüketim ve Saat Sinyali
İşlemcinin saat (clock) sinyali, kullanılmayan blokları bile her çevrim için anahtarlar. Saat dağıtım ağı genellikle yongadaki en pahalı dinamik tüketim kaynaklarından biridir.
3.4. Çevresel Birimlerin Açık Bırakılması
UART, SPI, ADC, USB, kablosuz arabirimler gibi çevresel birimler kullanılmadıkları zamanlarda açık bırakıldığında ciddi bir enerji kaybı oluşur. Yazılımın bu birimleri seçici biçimde devre dışı bırakamaması yaygın bir sorundur.
3.5. Yetersiz Yazılım Tasarımı
Sürekli yoklama (busy-wait, polling) yapan, gereğinden sık olay döngüsü çalıştıran veya verimsiz algoritmalar kullanan yazılımlar; donanım ne kadar iyi olursa olsun, sistemi sürekli aktif modda tutarak pilin hızla tükenmesine yol açar.
3.6. Termal Sınırlamalar
Yoğun görüntü işleme yükü altında işlemci ısınır. Yüksek sıcaklık hem sızıntı akımını arttırır (geri besleme döngüsü) hem de işlemcinin termal koruma (throttling) yoluyla yavaşlamasına neden olur. Sonuçta enerji tüketilir ama iş yapılmaz.
4. Düşük Güç Modları (Sleep / Idle) Mantığı
Güç yönetiminin kalbinde, sistemin “gerçekten iş yaptığı zaman” ile “bekleme yaptığı zaman” arasında ayrım yapan bir durum makinesi yatar. Tipik bir gömülü işlemci aşağıdaki güç durumlarını sunar:
4.1. Active (Çalışma) Modu
İşlemci, çevresel birimler ve bellekler tam hızda çalışır. Görevlerin yürütüldüğü tek moddur; aynı zamanda en yüksek tüketim seviyesidir.
4.2. Idle (Boşta) Modu
İşlemci çekirdeğinin saati durdurulur, ancak bellek içeriği ve çevresel birim durumu korunur. Bir kesme (interrupt) gelir gelmez sistem mikrosaniyeler içinde Active moda döner. ARM Cortex-M işlemcilerde bu, klasik olarak WFI (Wait For Interrupt) komutuyla tetiklenir.
4.3. Sleep (Uyku) Modu
İşlemci çekirdeğine ek olarak bazı çevresel birimlerin de saati kesilir veya gerilimleri düşürülür. Uyandırma kaynakları sınırlandırılır (örneğin yalnızca seçili IRQ’lar veya zamanlayıcı). Tüketim Idle moduna göre belirgin biçimde düşer; tipik bir mikrodenetleyicide Active modun yüzde birkaçına iner.
4.4. Deep Sleep / Standby Modu
Çekirdek, RAM içeriği ve çoğu çevresel birim kapatılır. Yalnızca Real-Time Clock (RTC) ve harici bir uyandırma pini gibi minimum devreler etkin kalır. Tüketim mikroamper seviyesine düşebilir; ancak sistem uyandığında yeniden başlatma maliyeti yüksektir.
4.5. Power-off / Hibernate
Sistemin neredeyse tamamı kapatılır; durum bilgisi kaybedilir veya kalıcı belleğe yazılır. Çok düşük tüketim sağlar ancak geri dönüş süresi en uzun olandır.
4.6. Uyandırma (Wake-up) Mekanizmaları
Düşük güç modunda kalan bir cihaz; harici bir kesme, zamanlayıcı taşması (timer overflow), RTC alarmı, sensör eşik aşımı veya kablosuz arabirimden gelen bir paket gibi bir olayla uyandırılır. Modülün tasarımı, hangi olayın hangi moddan uyandırma yapabileceğini açıkça tanımlamalıdır.
Modlar arası karşılaştırma

Tablo 1. Tipik gömülü işlemci güç modlarının karşılaştırılması.
5. İşlemci ve Donanım Bileşenlerinin Güç Kontrolü
Düşük güç modlarına geçiş tek başına yeterli değildir; sistem aktifken de tüketimi düşürmek için işlemci çekirdeği ve çevresel birimler üzerinde çeşitli denetim teknikleri uygulanır.
5.1. Dinamik Gerilim ve Frekans Ölçekleme (DVFS)
CMOS devrelerinde dinamik güç tüketimi yaklaşık olarak P ∝ C · V² · f bağıntısıyla ifade edilir. Bu nedenle gerilimi (V) düşürmek, tüketimi karesi oranında azaltır; frekansı (f) düşürmek ise doğru orantılıdır. DVFS; sistemin anlık iş yüküne göre çalışma frekansı ve çekirdek gerilimini dinamik olarak değiştirir. Görüntü işleme bağlamında, kare oranı düşük olduğunda DVFS ile çekirdek frekansı bilinçli olarak indirilebilir.
5.2. Saat Kapısı (Clock Gating)
Kullanılmayan bloğa giden saat sinyalinin “AND” kapısı ile kesilmesidir. Donanım katmanında uygulanır ve dinamik tüketimi neredeyse anında düşürür. Yazılım, kullanmadığı çevresel birimleri kapatarak (RCC/AHB clock enable bitlerini sıfırlayarak) bu mekanizmayı tetikler.
5.3. Güç Kapısı (Power Gating)
Saat kapısı yalnızca dinamik tüketimi keserken, güç kapısı bir bloğun beslemesini tamamen kesip sızıntı akımını da ortadan kaldırır. Daha fazla tasarruf sağlar fakat uyanma süresi daha uzundur ve içerik kaybı olabilir.
5.4. Çevresel Birim Yönetimi
Sensörler, kablosuz modüller, ekran sürücüleri gibi birimler genelde işlemciden çok daha fazla akım çeker. Tasarımda her birim için ayrı bir “açık / düşük güç / kapalı” yönetim politikası tanımlanmalıdır. Örneğin bir kamera modülü, kare alımı bittikten sonra yazılım tarafından açıkça düşük güç moduna alınmalıdır.
5.5. Bellek Yönetimi
SRAM blokları bölümlenebilir; kullanılmayan bölümlerin beslemesi kesilebilir (memory retention/partial shutdown). Bu, özellikle Deep Sleep modunda anlamlı tasarruf sağlar.
5.6. Voltaj Düzenleyici Seçimi
Doğrusal düzenleyiciler (LDO) basittir ama verim düşüktür. Anahtarlamalı (DC-DC buck) düzenleyiciler ise %85–95 verimle çalışır. Düşük güç bütçesi olan tasarımlarda düzenleyici seçimi tek başına önemli bir kazanç kaynağıdır.
6. Gereksiz Enerji Tüketimini Azaltma Yöntemleri
Bu bölüm, raporun en uygulamaya dönük kısmıdır. Tasarımda hem donanım hem yazılım tarafında uygulanması önerilen optimizasyon yöntemleri aşağıda gruplanmıştır.
6.1. Olay Güdümlü (Event-driven) Mimariye Geçiş
Sistem, sürekli yoklama yerine yalnızca bir olay gerçekleştiğinde uyandırılmalıdır. Bu, sistemin zamanının büyük çoğunluğunu düşük güç modunda geçirmesini sağlar. Görüntü işleme uygulamamızda kare hazır kesmesi (frame-ready IRQ), tampon dolu kesmesi (DMA complete) gibi olaylar uyandırma sebepleri olarak tanımlanmalıdır.
6.2. Tickless (Saatsiz) Çekirdek
Klasik RTOS çekirdekleri sabit aralıklı bir sistem zamanlayıcısı (örneğin 1 ms’de bir kesme) çalıştırır. Bu, gereksiz sayıda uyanmaya neden olur. Tickless modda zamanlayıcı yalnızca bir sonraki gerçek görev için gereken süre boyunca çalışır; ara dönemde işlemci uyutulur. FreeRTOS, Zephyr ve Linux çekirdeği gibi sistemler tickless desteğini doğrudan sunar.
6.3. DMA Kullanımı
Bellek ile çevresel birim arasındaki veri aktarımı CPU yerine DMA denetleyicisine bırakıldığında, çekirdek bu süre boyunca uyutulabilir. Görüntü tamponlarının okunması/yazılması gibi yüksek hacimli işlemlerde bu yöntem hem performans hem enerji açısından kritik kazanç sağlar.
6.4. Sensör Görev Döngüsü (Duty Cycling)
Sürekli okuma yerine sensörler sadece gerekli aralıklarla aktif edilmelidir. Örneğin ortam ışığı sensörü saniyede 50 kez yerine saniyede 2 kez okunarak hem CPU yükü hem de sensör tüketimi büyük oranda azaltılır.
6.5. İletişim (RF / Kablosuz) Optimizasyonu
Veriyi toplu gönderme: Küçük paketler tek tek değil, biriktirilip toplu hâlde iletilmelidir; her uyanma–iletim–uyuma çevrimi sabit bir enerji maliyeti taşır.
İletim gücü ayarı: Hedef erişilebilir olduğu sürece anten çıkış gücü düşürülmelidir.
Düşük güçlü protokoller: BLE, LoRa, Zigbee gibi protokoller kasıtlı olarak düşük tüketim için tasarlanmıştır; uygun olduğunda Wi-Fi yerine tercih edilmelidir.
6.6. Yazılım ve Algoritma Düzeyi Optimizasyonlar
Polling yerine kesme: CPU’nun bir bayrağı sürekli kontrol etmesi yerine, donanım kesmesiyle uyandırılması.
Verimli veri yapıları: Görüntü işlemede gereksiz kopyalamadan kaçınmak, sıfır kopya (zero-copy) tampon stratejileri kullanmak.
Sabit nokta aritmetiği: Mümkün olan yerlerde kayan nokta yerine sabit nokta kullanmak, FPU’nun açılmamasını sağlar.
Derleyici optimizasyon seviyesi: -O2 veya -Os ile derlenmiş kod, daha az çevrim ve daha az kod kullandığı için hem çalışma süresini hem enerjiyi düşürür.
Erken çıkış (early exit): Görüntü işleme akışında, ön koşulu sağlamayan kareler için pahalı işlemlerin atlanması.
6.7. Çalışma Profili (Race-to-idle) Prensibi
Görece yeni ama önemli bir tasarım ilkesidir: işi mümkün olan en yüksek hızla bitirip uzun süre uyumak, işi yavaşça yapıp az süre uyumaktan çoğu zaman daha verimlidir. Buna “race-to-idle” (boşa koşma) denir. Modern modern düşük güç modu tüketimleri o kadar düşmüştür ki, sızıntı baskın hâle gelene kadar bu strateji geçerliliğini korur. DVFS politikası bu prensip göz önünde bulundurularak ayarlanmalıdır.
6.8. Çevresel Birim Saatini Kapatma
Kullanılmayan UART2, SPI3, ADC vb. birimlerin saatleri başlangıçta kapatılmalı; yalnızca o birim gerçekten kullanılacağı zaman açılıp iş bitince tekrar kapatılmalıdır. Bu yöntem küçük gözükmesine rağmen mikrodenetleyici toplam tüketiminde gözle görülür fark yaratır.
6.9. Ekran ve LED Yönetimi
Ekran (özellikle arka aydınlatma) ve LED’ler gömülü cihazlarda en yüksek tüketicilerden biridir. Kullanıcı etkileşimi yokken ekranı söndürmek, sabit yanan göstergeleri yanıp sönen düşük göreve dönüştürmek (PWM ile parlaklığı düşürmek) basit ama etkili tekniklerdir.
6.10. Profil Çıkarma (Energy Profiling)
Optimizasyon, ölçüme dayanmadan yapılırsa tahmine dayalı kalır. Tasarımda enerji profilleyici (ör. Nordic Power Profiler Kit, Otii Arc, Joulescope) kullanılarak her modülün gerçek tüketimi haritalanmalıdır. Bu, hangi optimizasyonun en yüksek getiriyi sağlayacağını gösterir.
7. Pil ve Verimlilik İlişkisi
Pil kapasitesi genellikle mAh (miliamper-saat) cinsinden ifade edilir. Bir cihazın pil ömrü, kabaca aşağıdaki ilişkiyle hesaplanır:
Pil Ömrü (saat) ≈ Pil Kapasitesi (mAh) ÷ Ortalama Tüketim (mA)
Bu basit denklem, optimizasyon hedefini açıkça ortaya koyar: ortalama akımı düşürmek. Sistemin tepe akımı yüksek olsa bile, bu tepe değer kısa süreli olduğu sürece ortalama düşük tutulabilir. Bu nedenle güç yönetimi tasarımında “zamanın yüzde kaçı hangi modda geçiriliyor?” sorusu temel sorudur.
7.1. Görev Döngüsünün Etkisi
Örnek olarak, Active modda 30 mA ve Sleep modda 10 µA çeken bir cihazı düşünelim. Cihaz zamanın %1’ini aktif, %99’unu uykuda geçiriyorsa:
Ortalama akım = 0,01 × 30 mA + 0,99 × 0,01 mA ≈ 0,31 mA
1000 mAh’lik bir pil bu durumda yaklaşık 3.200 saat, yani 130 günden fazla çalışır. Aynı sistem %50 görev döngüsünde çalışırsa ortalama 15 mA’e fırlar ve pil yalnızca 67 saat dayanır. Bu fark, güç yönetiminin yazılım katmanında ne kadar belirleyici olduğunu açıkça göstermektedir.
7.2. Pil Karakteristikleri
Voltaj düşüşü: Pil boşaldıkça gerilimi de düşer; sistem bu voltaj aralığında çalışabilmelidir veya yükselten/azaltan düzenleyici kullanılmalıdır.
Self-discharge: Pil kullanılmasa bile zamanla küçük bir akım kaybeder; Deep Sleep tüketimi self-discharge’a yaklaştığında daha fazla optimizasyon anlamsızlaşır.
Sıcaklık etkisi: Düşük sıcaklıkta pil kapasitesi azalır; bu, dış ortamda çalışan cihazlar için tasarımda göz önünde bulundurulmalıdır.
Tepe akım kapasitesi: Bazı piller (özellikle ince LiPo veya buton hücreler) yüksek anlık akım veremez; tepe yüklerini dengelemek için süperkondansatör eklenebilir.
8. ARM Tabanlı Sistemlerde Güç Yönetimi
ARM mimarisi, düşük güç tüketimine yönelik tasarlanmış olması nedeniyle gömülü sistemlerde baskın bir şekilde kullanılır. ARM ekosisteminin sunduğu güç yönetim mekanizmaları iki ana aile üzerinden incelenebilir.
8.1. ARM Cortex-M Ailesi (Mikrodenetleyiciler)
STM32, nRF52, RP2040, MSP432, SAM serileri gibi yaygın mikrodenetleyiciler bu ailededir. Cortex-M çekirdekleri standart olarak iki temel komut sunar:
WFI (Wait For Interrupt): İşlemci, bir kesme oluşana kadar çekirdek saatini durdurur. Sleep moduna geçişin ana tetikleyicisidir.
WFE (Wait For Event): Kesme bekleme yerine olay (event) bekleme moduna geçer; çok çekirdekli düşük güç senaryolarında yararlıdır.
Bu komutlar System Control Block içindeki SCR (System Control Register) kayıtçısı ile birlikte kullanılarak Sleep, Deep Sleep ve Sleep-on-exit gibi davranışlar yapılandırılır. STM32 ailesinde bunlara ek olarak Stop ve Standby modları bulunur; bu modlar tipik olarak birkaç mikroamper seviyesinde tüketim sağlar.
8.2. ARM Cortex-A Ailesi (Uygulama İşlemcileri)
Raspberry Pi, NXP i.MX, NVIDIA Jetson gibi platformlarda kullanılan Cortex-A çekirdekleri çok daha karmaşık bir güç yönetimi gerektirir. ARM bu nedenle PSCI (Power State Coordination Interface) adında standart bir arayüz tanımlamıştır. PSCI, çekirdekleri tek tek uyutma/uyandırma, küme (cluster) seviyesinde güç kapatma ve sistem genelinde standby gibi işlemleri standartlaştırır. Linux çekirdeği bu arayüzü doğrudan kullanır.
8.3. Donanım Düzeyinde: PMU ve PMIC
PMU (Power Management Unit): Yonga içinde yer alır; güç alanlarını (power domain) yönetir, saat kapılarını kontrol eder.
PMIC (Power Management Integrated Circuit): Yonga dışında ayrı bir entegredir; birden fazla gerilim seviyesi üretir, pil şarj yönetimi yapar, çevresel birimlerin beslemesini bağımsız olarak açıp kapatabilir.
8.4. big.LITTLE ve Heterojen Mimari
Cortex-A ekosisteminde, performans gerektiren görevler büyük çekirdekte (örn. Cortex-A78), arka plan görevleri küçük çekirdekte (örn. Cortex-A55) çalıştırılır. Görev tipine göre uygun çekirdeğe geçiş, hem performans hem enerji açısından önemli kazanç sağlar. Görüntü işleme yükü büyük çekirdekte koştuktan sonra sistem doğrudan küçük çekirdeklere geçirilerek beklemeye alınabilir.
8.5. CMSIS ve Vendor HAL Desteği
ARM, CMSIS (Cortex Microcontroller Software Interface Standard) ile düşük güç komutlarının taşınabilir bir biçimde çağrılmasını sağlar (örneğin __WFI() makrosu). Bunun üzerine üreticiye özel HAL kütüphaneleri (STM32 HAL/LL, Nordic SoftDevice, Espressif ESP-IDF) farklı uyku modlarını kolayca yapılandırmaya olanak tanır.
9. Önerilen Güç Yönetim Modülü Akış Şeması
Aşağıda, projemizdeki güç yönetim modülünün durum geçişlerini özetleyen basit bir akış şeması sunulmuştur. Şema; sistemin başlatılmasından itibaren işlenecek görev olup olmadığını sorgulayan ana döngüyü, boşta kalma süresine göre seçilen düşük güç modlarını ve uyandırma yolunu kapsar.

Şekil 1. Güç Yönetim Modülü Durum Geçiş Akış Şeması.
9.1. Akışın Açıklaması
Sistem reset sonrası başlatma sürecini tamamlar (saat ağacı, çevresel birimler ve RTOS kurulumu) ve ACTIVE moda girer. Karar noktası A’da işlenecek bir görev olup olmadığı sorgulanır:
Görev var: Sistem aktif modda kalır ve görevi yürütür. Görev bittikten sonra döngü başa döner.
Görev yok: Karar noktası B’ye geçilir; tahmini boşta kalma süresine göre uygun düşük güç modu seçilir.
Boşta kalma süresinin tahmini, RTOS’un bir sonraki zamanlayıcı olayına kadar olan süresinden veya tickless zamanlayıcının hesapladığı bekleme aralığından elde edilir. Süre kısaysa IDLE, ortaysa SLEEP, uzunsa DEEP SLEEP/STANDBY tercih edilir. Tüm modlardan çıkış; bir kesme (IRQ), zamanlayıcı taşması veya harici uyandırma sinyali ile gerçekleşir ve sistem yeniden ACTIVE moda döner.
10. Sonuç ve Değerlendirme
Bu rapor kapsamında, görüntü işleme projemizin gömülü işletim sistemi katmanında yer alacak Güç Yönetimi Modülü’nün tasarım gereksinimleri, çalışma prensipleri ve uygulanması planlanan optimizasyon teknikleri ayrıntılı olarak ele alındı. Tasarımın temel ilkeleri şu şekilde özetlenebilir:
Sistem, varsayılan olarak en düşük tüketimli modda kalmalı; yalnızca bir olay gerçekleştiğinde uyandırılmalıdır (olay güdümlü yaklaşım).
Tickless zamanlayıcı ve DMA kullanımı, çekirdeğin etkin çalışma süresini büyük oranda kısaltacaktır.
Düşük güç modları arasında geçiş, RTOS tarafından sağlanan boşta kalma süresi tahminine göre dinamik biçimde yapılmalıdır.
DVFS ve race-to-idle prensipleri birlikte uygulanarak hem dinamik hem statik tüketim minimize edilmelidir.
ARM Cortex-M çekirdekleri için WFI komutu ve üretici HAL kütüphaneleri (örn. STM32 HAL_PWR_Enter*Mode fonksiyonları) modülün soyutlama katmanı olarak değerlendirilmelidir.
Tasarım sürecinin sonunda, gerçek tüketim ölçümü için bir enerji profilleyici ile sahada doğrulama yapılmalıdır.
Bu tasarım kararlarının uygulanması durumunda, sistemin hem pil ömrü hem de termal davranışı açısından önemli ölçüde iyileştirilmesi beklenmektedir. Sonraki adımda, bu raporda tanımlanan durum makinesinin RTOS üzerinde uygulamaya alınması ve seçilen donanım üzerinde ölçümlerle doğrulanması planlanmaktadır.
------------------------------------------------------------------------------------------------------
Donanım Test ve Doğrulama Planı Tasarımı
1. Amaç
Bu çalışma kapsamında geliştirilen gerçek zamanlı işletim sistemi tabanlı yapının donanım tarafında güvenilir, kararlı ve hatasız çalışmasını sağlamak amacıyla test ve doğrulama planı hazırlanmıştır. Oluşturulan plan sayesinde sistem bileşenlerinin doğru çalışıp çalışmadığı kontrol edilerek oluşabilecek hataların önceden tespit edilmesi hedeflenmiştir.
2. Donanım Test Süreçleri
Donanım test süreçleri sistemin temel bileşenlerinin ayrı ayrı ve birlikte çalışmasını kontrol etmek amacıyla hazırlanmıştır. Testler belirli aşamalara ayrılmıştır.  • Başlangıç Testleri: Sistemin ilk açılış sürecinde işlemci, RAM, sensörler ve giriş-çıkış birimlerinin düzgün çalışıp çalışmadığı kontrol edilir.  • Birim Testleri: Her donanım bileşeni ayrı ayrı test edilir. - Sensör veri gönderimi - Bellek okuma/yazma işlemleri - Güç modülü kontrolü - Zamanlayıcı birimi testleri  • Entegrasyon Testleri: Donanım bileşenlerinin birbirleriyle uyumlu çalışıp çalışmadığı kontrol edilir. - Sensör ile işlemci veri iletişimi - Bellek yönetimi ile görev planlayıcısının birlikte çalışması - Güç yönetim modülünün sistem performansına etkisi  • Sistem Testleri: Tüm sistem çalıştırılarak genel kararlılık ve performans kontrol edilir.
3. Test Senaryoları
Senaryo 1 — Sistem Açılış Testi - Sistem başlatılır. - İşlemci ve bellek kullanımı kontrol edilir. - Açılış sırasında hata oluşup oluşmadığı gözlemlenir.  Beklenen Sonuç: Sistem hatasız şekilde açılmalı ve tüm modüller aktif hale gelmelidir.  Senaryo 2 — Sensör Veri Kontrolü - Sensörden veri gönderilir. - Verinin işlemciye doğru aktarılıp aktarılmadığı kontrol edilir.  Beklenen Sonuç: Gönderilen veri kayıpsız şekilde sisteme ulaşmalıdır.  Senaryo 3 — Güç Yönetimi Testi - Sistem düşük güç moduna alınır. - Enerji tüketimi ölçülür.  Beklenen Sonuç: Sistem düşük güç modunda çalışmaya devam etmeli ve enerji tüketimi azalmalıdır.  Senaryo 4 — Aşırı Yük Testi - Sisteme aynı anda çok sayıda işlem gönderilir. - İşlemci sıcaklığı ve performans değerleri gözlemlenir.  Beklenen Sonuç: Sistem çökmeden stabil şekilde çalışmaya devam etmelidir.
4. Hata Tespiti ve Doğrulama Yöntemleri
Sistem üzerinde oluşabilecek donanım hatalarının belirlenebilmesi için çeşitli doğrulama yöntemleri kullanılmıştır.  • Hata kayıt sistemi (log kayıtları) • Sensör veri doğrulama kontrolü • Bellek hata taraması • Gerçek zamanlı hata izleme • Voltaj ve sıcaklık kontrolü  Hata tespiti sırasında elde edilen veriler kayıt altına alınarak sistemin hangi bölümünde sorun oluştuğu belirlenir.
5. Sistem Kararlılığı Kontrolleri
Sistemin uzun süre boyunca kesintisiz çalışabilmesi amacıyla kararlılık testleri uygulanmıştır.  • Uzun süreli çalışma testi • Ani yük değişimi testi • Yeniden başlatma testi • Güç kesintisi sonrası toparlanma testi  Bu testler sayesinde sistemin beklenmeyen durumlarda davranışı analiz edilmiştir.
6. Performans ve Güvenilirlik Testleri
Performans testleri sistem hızını ve işlem kapasitesini ölçmek amacıyla yapılmıştır.  • İşlemci kullanım oranı • Bellek kullanım miktarı • Tepki süresi • Veri aktarım hızı • Enerji tüketimi  Güvenilirlik testlerinde ise sistemin uzun süre hata vermeden çalışması değerlendirilmiştir.
7. Test Akış Şeması
Sistem Başlatılır ↓ Donanım Bileşenleri Kontrol Edilir ↓ Birim Testleri Yapılır ↓ Entegrasyon Testleri Uygulanır ↓ Performans ve Kararlılık Testleri Yapılır ↓ Hata Kontrolü Gerçekleştirilir ↓ Test Sonuçları Raporlanır ↓ Sistem Doğrulanır
8. Sonuç
Hazırlanan donanım test ve doğrulama planı sayesinde sistemin donanım bileşenleri ayrıntılı şekilde kontrol edilmiştir. Yapılan testler sonucunda sistemin kararlı, güvenilir ve gerçek zamanlı çalışmaya uygun olduğu gözlemlenmiştir. Oluşturulan doğrulama süreçleri sayesinde oluşabilecek donanım hatalarının erken aşamada tespit edilmesi amaçlanmıştır.
------------------------------------------------------------------
## Yarış Durumu (Race Condition) Tespiti ve Çözüm Mekanizmaları

Eş zamanlı (concurrent) çalışan çoklu görevlerin veya kesme servis rutinlerinin (ISR), paylaşılan ortak bir kaynağa (hafıza alanı, donanım yazmacı, global değişken vb.) aynı anda erişmesi ve sistemin nihai çıktısının bu görevlerin çalışma sırasına bağlı olarak değişmesi durumuna **Yarış Durumu (Race Condition)** denir.

### 1. Yarış Durumu Neden Oluşur ve Sisteme Etkileri Nelerdir?

**Neden Oluşur?**
Gömülü sistemlerde, işlemci seviyesindeki operasyonlar atomik (tek bir çevrimde biten) değildir. Örneğin, C dilinde yazılan `sayac++` işlemi, montaj (Assembly) diline çevrildiğinde üç adımdan oluşur:
1. Veriyi hafızadan işlemci yazmacına (register) oku (Read).
2. Yazmaçtaki değeri 1 artır (Modify).
3. Yeni değeri tekrar hafızaya yaz (Write).

Eğer birinci görev 1. adımı tamamladıktan sonra bir kesme (interrupt) gelir veya zamanlayıcı (scheduler) bağlam değişimi (context switch) yaparsa, ikinci görev de aynı eski veriyi okur. Bu durum, veri tutarsızlığına yol açar.

**Sisteme Etkileri:**
* **Veri Bozulması (Data Corruption):** Sensör verilerinin, batarya seviyesi ölçümlerinin veya kritik sistem bayraklarının yanlış hesaplanması.
* **Kararsız Davranışlar (Unpredictable Behavior):** Sistemin bazen kusursuz çalışırken, bazen tamamen rastgele zamanlarda çökmesi veya kilitlenmesi (Heisenbug).
* **Güç Tüketimi Artışı:** Yanlış durum bayrakları yüzünden işlemcinin uyku moduna (WFI) geçememesi ve sonsuz döngüde kalarak enerjiyi tüketmesi.

---

### 2. Yarış Durumu Örnek Senaryosu (Kritik Bölge Problemi)

**Senaryo:** Sistemde toplam enerji tüketimini milisaniye cinsinden hesaplayan global bir `toplam_enerji` değişkeni olsun. İki farklı görev bu değişkeni güncelliyor:
* **Görev A (Sensör Görevi):** Değeri 10 artırmak istiyor.
* **Görev B (Ekran Görevi):** Değeri 5 artırmak istiyor.
* `toplam_enerji` başlangıç değeri: **100** (Beklenen son değer: **115**)

**Hatalı Akış Mantığı:**
1. Görev A -> Hafızadaki 100 değerini okur (Yazmaç_A = 100).
2. [BAĞLAM DEĞİŞİMİ / KESME OLUŞTU] -> Görev A durduruldu, Görev B başladı.
3. Görev B -> Hafızadaki 100 değerini okur (Yazmaç_B = 100).
4. Görev B -> Değeri 5 artırır (Yazmaç_B = 105).
5. Görev B -> 105 değerini hafızaya yazar (Hafıza = 105).
6. [BAĞLAM DEĞİŞİMİ] -> Görev B durduruldu, Görev A kaldığı yerden devam ediyor.
7. Görev A -> Elindeki 100 değerini 10 artırır (Yazmaç_A = 110).
8. Görev A -> 110 değerini hafızaya yazar (Hafıza = 110).

**Sonuç:** `toplam_enerji` değişkeninin değeri 115 olması gerekirken **110** oldu. Görev B'nin yaptığı işlem tamamen kayboldu (Lost Update).

---

### 3. Önleme Yöntemleri ve Çözüm Mekanizmaları

Yarış durumunu önlemek için ortak kaynağa erişilen kod blokları **Kritik Bölge (Critical Section)** olarak ilan edilir ve korunur:

#### A. Mutex (Mutual Exclusion)
Sadece tek bir görevin sahip olabileceği bir "anahtar" gibidir. Bir görev Mutex'i kilitlerse (Lock), işi bitip kilidi açana kadar (Unlock) başka hiçbir görev o kaynağa erişemez; erişmek isteyen görevler "Blocked" (Uyku) durumuna alınır.
* *Örnek Kod Mantığı:*
    ```c
    void Sensor_Gorevi(void) {
        osMutexWait(EnerjiMutex); // Kilitle
        toplam_enerji += 10;      // Kritik Bölge
        osMutexRelease(EnerjiMutex); // Kilidi Aç
    }
    ```

#### B. Semaphore (Semafor)
Belirli sayıda kaynağın eş zamanlı yönetimini sağlayan sayaç mekanizmalarıdır. İksel (Binary) semaforlar Mutex gibi çalışabilir ancak Mutex'ten farkı, kilidi hangi görev açtıysa onun kapatma zorunluluğunun olmamasıdır (Sinyalizasyon amaçlı da kullanılır).

#### C. Kesme Maskeleme (Interrupt Disabling / Lock)
Gömülü sistemlerde en hızlı ve en radikal çözümdür. Kritik bölgeye girmeden önce tüm donanımsal kesmeler kapatılır, işlem bitince geri açılır. Böylece işlem esnasında bağlam değişimi yaşanması fiziksel olarak engellenir.
* *ARM Cortex-M Örnek Mantığı:*
    ```c
    __disable_irq();     // Kesmeleri kapat (Kritik Bölge Başlangıcı)
    toplam_enerji += 10; 
    __enable_irq();      // Kesmeleri geri aç (Kritik Bölge Bitişi)
    ```

----------------------------------------------------------------

### 4. Yarış Durumu Tespit Araçları ve Teknikleri

Yarış durumları çalışma zamanında (runtime) nadiren ve rastgele tetiklendiği için klasik test yöntemleriyle tespit edilmesi oldukça zordur. Bu yüzden şu araçlar ve teknikler kullanılır:

#### A. Statik Analiz Araçları (Kod Derlenirken)
Kod daha çalıştırılmadan, kaynak kod üzerindeki potansiyel mantık hatalarını ve korunmayan global değişkenleri tarar.
* **Cppcheck / Clang-Tidy:** C/C++ projelerinde kilit mekanizması kullanılmadan erişilen paylaşımlı değişkenleri tespit edebilir.

#### B. Dinamik Analiz Araçları (Çalışma Zamanında)
* **ThreadSanitizer (TSan):** GCC ve Clang derleyicilerine entegre çalışan, simülasyon ortamında (örneğin QEMU üzerinde test kodları koşturulurken) hafıza erişimlerini izleyen güçlü bir araçtır. Aynı hafıza adresine en az biri "yazma" olmak üzere iki farklı iş parçacığının kilitsiz eriştiğini anında raporlar.

#### C. GDB Donanımsal Watchpoint Tekniği (Hata Ayıklama)
GDB (GNU Debugger) üzerinden simülatördeki veya gerçek karttaki bir değişkenin değeri her değiştiğinde işlemcinin durdurulması sağlanır.
* `watch toplam_enerji` komutu verilerek, değişkene hangi görevin veya hangi kesmenin (ISR) hangi satırda müdahale ettiği adım adım izlenir. Böylece beklenmedik bir kesme bölünmesi anında yakalanır.
------------------------------------------------------------------
1. GİRİŞ VE PROJE PERSPEKTİFİ
  Gömülü ve gerçek zamanlı işletim sistemlerinde (RTOS), deterministik (öngörülebilir) çalışma ve katı zaman kısıtlarına (deadlines) uyum hayati önem taşır. Projemiz kapsamında geliştirilen enerji verimli işletim sisteminde birden fazla görevin (task/thread); I2C/SPI veri yolları, UART modülleri, ADC kanalları veya paylaşılan bellek bölgeleri gibi kısıtlı donanım kaynaklarına aynı anda erişmeye çalışması kaçınılmazdır.
  Bu eşzamanlı erişim yönetilemediği takdirde, sistem bütünlüğünü ve kararlılığını doğrudan tehdit eden Kilitlenme (Deadlock) durumu ortaya çıkar. Kilitlenme; iki veya daha fazla görevin, birbirlerinin ellerinde tuttukları kaynakları serbest bırakmasını beklemesi ve bu döngüsel süreç sebebiyle süresiz olarak askıda kalması (starvation/hang) durumudur.
  Gömülü bir sistemde deadlock, projemizin ana çıktısı olan “Düşük Güç Tüketimi” ve “Güvenilirlik” hedefleriyle doğrudan çelişir.

2. KİLİTLENMENİN DÖRT AKADEMİK KOŞULU (COFFMAN KOŞULLARI)
  Bir gömülü sistem mimarisinde kilitlenmenin meydana gelebilmesi için aşağıdaki dört teorik koşulun aynı anda gerçekleşmesi gerekir. Bu koşullardan herhangi birinin sistemsel veya yazılımsal olarak kırılması, deadlock ihtimalini tamamen ortadan kaldırır :
Karşılıklı Dışlama (Mutual Exclusion): En az bir donanım veya yazılım kaynağı, aynı anda sadece tek bir görev tarafından kilitlenebilir (paylaşılamaz) olmalıdır (Örn: Bir UART sürücüsüne aynı anda sadece bir thread'in veri yazabilmesi).
Tut ve Bekle (Hold and Wait): Bir görev, halihazırda kendisine tahsis edilmiş bir kaynağı elinde tutarken (hold), başka bir görevin kontrolünde olan ikinci bir kaynağı talep etmeli ve onun için beklemeye (wait) geçmelidir.
Devredilemezlik (No Preemption): Kaynaklar, onları elinde tutan görevin elinden işletim sistemi çekirdeği tarafından zorla alınamaz. Kaynak, ancak görevin işi bittiğinde kendi rızasıyla serbest bırakılmalıdır.
Dairesel Bekleme (Circular Wait): Görevler arasında kapalı bir zincirleme bekleme halkasının oluşmasıdır. T1görevi T2'nin kaynağını beklerken, T2 görevi de T1'in elinde tuttuğu kaynağı beklemektedir.



3. GÖMÜLÜ LİNUX VE ARM TABANLI SENARYO MODELLEMESİ
  Projemiz kapsamında geliştirilen cihaz sürücülerinde (device drivers) karşılaşılması olası bir deadlock senaryosu, iki görev ve iki donanım kaynağı üzerinden aşağıda modellenmiştir:
Görev 1 (T1): Yüksek öncelikli Sensör Veri Okuma Görevi.
Görev 2 (T2):Düşük öncelikli Flash Belleğe Günlük (Log) Yazma Görevi.
Kaynak A (RA): I2C Veri Yolu Sürücüsü Mutex'i.
Kaynak B (RB): SPI Flash Bellek Sürücüsü Mutex'i.
Senaryo Zaman Çizelgesi ve Akış Mantığı





4. KİLİTLENMENİN SİSTEME ETKİLERİ
Determinizm ve Gerçek Zamanlılık Kaybı: Görevlerin yanıt süreleri sonsuza uzar. Sistemin en kritik görevleri zaman sınırlarını (deadline) kaçırır ve RTOS kararlılığı çöker.
Enerji Tüketimi Anomalileri: Eğer kilitlenme spinlock (meşgul bekleme) seviyesinde gerçekleşirse, CPU çekirdekleri %100 yük altında döngüde kalır. Bu durum, projenizin ana çıktısı olan pil ömrünü uzatma hedefleriyle tamamen çelişir ve bataryayı hızla tüketir.
Watchdog Resetleri ve Güvenilirlik: Kilitlenen sistem, bekçi köpeği (Watchdog Timer) donanımı tarafından tespit edilir ve sistem donmaktan kurtulmak için resetlenir. Bu ani resetler, flash bellek üzerinde dosya sistemi bozulmalarına (corruption) ve kritik veri kayıplarına yol açar.

5. KİLİTLENME YÖNETİMİ: ÖNLEME VE KAÇINMA STRATEJİLERİ
  Kilitlenme durumlarını henüz ortaya çıkmadan engellemek amacıyla projenin çekirdek ve sürücü mimarisinde uygulanabilecek stratejiler şunlardır:
A. Kaynak Erişim Sıralaması (Resource Ordering) - Önleme
  Tüm thread'lerin kaynakları her zaman aynı hiyerarşik sıra ile talep etmesi kuralıdır. Örneğin; hem T1 hem T2 her koşulda önce RA (I2C) mutex'ini, ardından RB(SPI) mutex'ini istemek zorundadır. Bu kural sayesinde Dairesel Bekleme koşulu matematiksel olarak kırılır ve kilitlenme oluşamaz.
B. Zaman Aşımı (Timeout) Mekanizmaları - Önleme
  Gömülü Linux sürücü geliştirmede sonsuza kadar bloklanan mutex_lock() yapısı yerine, zaman aşımı desteği sunan yapılar kullanılacaktır. Belirlenen kritik süre (örn. 20ms) boyunca kaynağı alamayan görev, beklemeyi bırakacak, elindeki diğer kaynakları serbest bırakacak ve hata kodu (örn. -ETIMEDOUT) döndürerek sistemin kilitlenmesini engelleyecektir.
C. Öncelik Tavanı Protokolü (Priority Ceiling Protocol) - Önleme
  Gömülü sistemlerde kilitlenmeyle birlikte gelen en büyük tehlike Öncelik Tersinmesi (Priority Inversion) durumudur. Bir mutex'i kilitleyen düşük öncelikli görevin önceliği, o mutex'i bekleyen en yüksek öncelikli görevin seviyesine dinamik olarak yükseltilir (Priority Inheritance). Böylece araya giren orta öncelikli görevlerin zinciri kilitlemesi engellenir.
D. Banker Algoritması - Kaçınma (Avoidance)
  Sistemdeki tüm kaynakların ve görevlerin maksimum ihtiyaçlarını matrislerde tutarak, her kaynak talebinde sistemin "Güvenli Durumda" (Safe State) kalıp kalmayacağını analiz eder.
Gömülü Sistem Kısıtı: Bu algoritma O(m × n2) işlem karmaşıklığına sahiptir. Sürekli dinamik hesaplama gerektirdiğinden CPU yükünü artırır ve projenin enerji verimliliği hedefine zarar verir. Bu nedenle projemizde statik önleme yöntemleri tercih edilmiştir.

6. KİLİTLENME TESPİT VE KURTARMA YÖNTEMLERİ (DETECTION & RECOVERY)
  Önleme mekanizmalarının bypass edildiği veya istisnai durumlar için sistemde dinamik bir tespit ve kurtarma mimarisi kurgulanmıştır:
6.1. Tespit Yöntemleri
Kaynak Tahsis Grafiği (Resource Allocation Graph - RAG): Çekirdek, görevler ve kaynaklar arasındaki ilişkiyi yönlü bir grafik olarak izler. Periyodik olarak çalışan bir arka plan görevi, bu grafikte bir Döngü (Cycle) olup olmadığını Tarjan veya benzeri döngü bulma algoritmalarıyla denetler.
Yazılımsal Kalp Atışı (Heartbeat) Kontrolü: Sürücü seviyesindeki kritik görevlerin her birine belirli aralıklarla bir "Kalp Atışı" sinyali üretme zorunluluğu getirilir. Kilitlenen görev bu sinyali üretemediğinde sistem kilitlenmeyi teşhis eder.

6.2. Kurtarma Yöntemleri
Kilitlenme kesin olarak tespit edildiğinde uygulanacak hiyerarşik aksiyonlar şunlardır:
Alt Sistem Resetlemesi (Subsystem Reset): Tüm işletim sistemini yeniden başlatmak yerine, sadece kilitlenmenin yaşandığı donanım hattından sorumlu cihaz sürücüsü modülü (Örn: I2C alt sistemi) register seviyesinde resetlenir. Çekirdek (Kernel), sürücüyü güvenli başlangıç ayarlarına çeker ve kilitlenen mutex'leri zorla serbest bırakır.
Görüntüleme ve Yazılımsal Geri Alma (Rollback): Kaynağı elinden zorla alınan (preempt edilen) görevin kararsız duruma düşmemesi için, görevin durumu (register değerleri, program sayacı vb.) kayıtlı bir kontrol noktasına (checkpoint) geri döndürülür. Bu işlem ARM mimarisinde Context Switching (Bağlam Değişimi) yapılarak CPU register'larının (R0- R15) stack'ten yeniden yüklenmesini gerektirir.
Kademeli Görev Sonlandırma (Task Termination): Deadlock kırılana kadar en düşük öncelikli görevden başlanarak thread'ler tek tek sonlandırılır. C dilinde ham pointer kullanımı nedeniyle oluşabilecek Bellek Sızıntılarını (Memory Leak) önlemek adına, sonlandırılan görevin kilitlediği dinamik bellek alanları (malloc blokları) kernel tarafından temizlenir.

7. DOĞRULAMA VE TEST PLANLAMASI
  Geliştirilen cihaz sürücülerinin kilitlenme güvenliği, Linux çekirdeğinde yerleşik olarak bulunan ve çalışma zamanı kilit doğrulaması yapan lockdep (Runtime Locking Correctness Validator) aracı ile donanım test aşamasında doğrulanacak ve elde edilen loglar "Donanım Test ve Doğrulama Raporu"na eklenecektir.
KAYNAKÇA
A. Silberschatz, P. B. Galvin, and G. Gagne, Operating System Concepts, 10th ed. Hoboken, NJ: Wiley, 2018, pp. 315-342. (Genel işletim sistemi, Coffman koşulları ve Kaynak Tahsis Grafiği teorisi).
Q. Li and C. Yao, Real-Time Concepts for Embedded Systems. San Francisco, CA: CMP Books, 2011, pp. 112-128. (RTOS, zaman aşımı mekanizmaları ve Banker algoritmasının gömülü sistem kısıtları).
J. W. S. Liu, Real-Time Systems. Upper Saddle River, NJ: Prentice Hall, 2000. (Öncelik Tavanı Protokolü, dairesel bekleme çözümleri ve görev sonlandırma senaryoları).
P. Raghavan, A. Amritanshu, and S. Srivastav, Embedded Linux System Design and Development. Boca Raton, FL: Auerbach Publications, 2019. (Gömülü Linux mimarilerinde güç yönetimi, watchdog entegrasyonu ve kalp atışı kontrolleri).


--------------------------------------------------------------------
KRİTİK BÖLGE OPTİMİZASYONU
Eş zamanlı (concurrent) programlamada birden fazla iş parçacığı (thread) ortak kaynaklara — değişkenler, dosyalar, veritabanı bağlantıları gibi — aynı anda erişmeye çalışabilir. Bu paylaşılan kaynağa yalnızca tek bir thread'in aynı anda erişebildiği kod bloğuna Kritik Bölge (Critical Section) denir.
Temel Tanım:
Kritik Bölge: Ortak bir kaynağa sıralı (atomik) erişimi zorunlu kılan ve aynı anda yalnızca bir thread tarafından çalıştırılabilen kod parçasıdır.
1.1 Kritik Bölgenin Sağlaması Gereken Koşullar
Karşılıklı Dışlama (Mutual Exclusion): Aynı anda yalnızca bir thread kritik bölgede bulunabilir.
İlerleme (Progress): Kritik bölgede hiçbir thread yoksa, girmek isteyen thread engellenmemelidir.
Sınırlı Bekleme (Bounded Waiting): Bir thread'in kritik bölgeye girmek için sonsuza kadar beklemesi önlenmelidir.
1.2 Temel Mantık Akışı
// Mantık Akışı
┌─────────────────────────────────────────────────────┐
│              KRİTİK BÖLGE YAŞAM DÖNGÜSÜ            │
├─────────────────────────────────────────────────────┤
│  Thread A        Kilit          Thread B            │
│     │─lock_acq()─>│                │               │
│     │<──(başarı)──│                │               │
│     │   [KRİTİK   │  B lock_acq()─>│               │
│     │    BÖLGE]   │<──(ENGELLEME)──│               │
│     │─lock_rel()─>│                │               │
│     │             │──(serbest)────>│               │
│     │             │  [KRİTİK BÖLGE]│               │
└─────────────────────────────────────────────────────┘

2. Performans Sorunları
Kritik bölgelerin yanlış veya aşırı kullanımı, çok çekirdekli sistemlerde ciddi darboğazlara yol açar.
 
2.1 Lock Çakışması (Lock Contention)
Birden fazla thread'in aynı kilidi edinmeye çalışması; thread'ler bekleme kuyruğunda birikerek CPU'yu boşa harcar.

// C++
// SORUNLU — tüm fonksiyon kilitli
void process_data(int user_id) {
    lock_guard<mutex> lk(global_lock);  // her şey kilitli!
    fetch_from_db(user_id);             // yavaş ağ I/O
    compute_result();                   // ağır hesaplama
    write_to_cache(user_id);
}
2.2 Ölümcül Kilitlenme (Deadlock)
İki thread birbirinin tuttuğu kilidi beklediğinde sistem tamamen durur.

// Deadlock
Thread A:  lock(mutex_1) → lock(mutex_2)  // 1'i alır, 2'yi bekler
Thread B:  lock(mutex_2) → lock(mutex_1)  // 2'yi alır, 1'i bekler
Sonuç: İkisi de sonsuza kadar bekler → Sistem durur!

2.3 Priority Inversion
Düşük öncelikli thread kritik bölgedeyken, yüksek öncelikli thread aynı kilidi bekliyorsa; yüksek öncelikli thread gereksiz yere bloke olur.
 
2.4 False Sharing
Farklı thread'lerin farklı değişkenler üzerinde çalışmasına rağmen bu değişkenlerin aynı CPU önbellek satırında bulunması, gereksiz geçersizleştirmelere neden olur.

// C++
// YANLIŞ — aynı cache line
struct { int counter_a; int counter_b; };
 
// DOĞRU — padding ile hizalama
struct {
    alignas(64) int counter_a;
    alignas(64) int counter_b;
};

2.5 Sorun Özeti
Sorun                	Belirti	                            Etki
Lock Contention	      Thread'ler kuyruğa girer	          Yüksek
Deadlock            	Sistem tamamen durur	              Kritik
Priority Inversion	  Yüksek öncelikli iş gecikmesi	      Orta–Yüksek
False Sharing	        Gereksiz önbellek invalidasyonu	    Orta

3. Optimizasyon Yöntemleri
3.1 Lock Granülaritesini Azaltma
Sadece paylaşılan kaynağa erişilen satırlar kilitlenmelidir; uzun I/O ve ağır hesaplama kilit dışında tutulmalıdır.

// C++ — Granülarite
// ÖNCESİ — tüm fonksiyon kilitli (kötü)
void bad_approach() {
    lock_guard<mutex> lk(mtx);
    auto data   = fetch_from_db();      // yavaş — kilit altında!
    auto result = heavy_compute(data);  // ağır — kilit altında!
    shared_cache = result;
}
 
// SONRASI — sadece paylaşılan erişim kilitli (iyi)
void good_approach() {
    auto data   = fetch_from_db();      // kilit dışı
    auto result = heavy_compute(data);  // kilit dışı
    { lock_guard<mutex> lk(mtx); shared_cache = result; }
}

3.2 Read-Write Lock
Okuma yoğun senaryolarda birden fazla thread eş zamanlı okuyabilir; yazma sırasında exclusive kilit kullanılır.

# Python — Read-Write Lock
class SharedCache:
    def read(self, key):
        return self._data.get(key)   # kilit yok — hepsi okuyabilir
 
    def write(self, key, value):
        with self._lock:             # exclusive kilit
            self._data[key] = value

3.3 Atomic Operasyonlar
Sayaç ve bayrak gibi basit işlemler için donanım destekli atomik operasyonlar, mutex'ten çok daha hızlıdır.

// C++ — Atomic
// Mutex'li (yavaş): ~850 ms / 10M işlem / 8 thread
mutex mtx; int counter = 0;
void bad()  { lock_guard<mutex> lk(mtx); ++counter; }
 
// Atomic (hızlı): ~95 ms — 9x daha hızlı
atomic<int> counter{0};
void fast() { counter.fetch_add(1, memory_order_relaxed); }

3.4 Thread-Local Storage
Her thread'in kendi özel kopyasına sahip olduğu TLS ile paylaşım ortadan kalkar, kritik bölgeye ihtiyaç kalmaz.

// C++ — TLS
thread_local int local_counter = 0;  // her thread'in kendi kopyası
void worker() { ++local_counter; }   // kilit yok, çakışma yok

3.5 Deadlock-Safe Kilit Sıralaması
Birden fazla mutex gerektiğinde, tüm thread'lerin kilitleri aynı sırayla edinmesi deadlock'u tamamen önler.

// C++ — Deadlock-Safe
// YANLIŞ: farklı sıralar → DEADLOCK
// Thread A: lock(m1) -> lock(m2)
// Thread B: lock(m2) -> lock(m1)
 
// DOĞRU: std::scoped_lock atomik edinim
void safe_transfer(Account& from, Account& to, int amount) {
    std::scoped_lock lk(from.mutex, to.mutex);
    from.balance -= amount;
    to.balance   += amount;
}

3.6 Producer-Consumer Deseni
Paylaşılan veriye doğrudan erişim yerine mesaj kuyruğu kullanmak, kritik bölge ihtiyacını minimuma indirir.

# Python — Producer-Consumer
import threading, queue
task_queue = queue.Queue(maxsize=100)
 
def producer():
    for item in data_stream():
        task_queue.put(item)      # thread-safe
 
def consumer():
    while True:
        item = task_queue.get()   # thread-safe
        if item is None: break
        process(item)             # paylaşılan kaynak yok!

4. Strateji Karşılaştırması
Yöntem                	Kullanım Durumu                	Performans	                   Karmaşıklık
Granülarite Azaltma    	Her senaryoda                  	Yüksek	                       Düşük
Read-Write Lock	        Okuma yoğun	                    Yüksek	                       Orta
Atomic Operasyonlar	    Sayaç / bayrak                 	Çok yüksek	                   Düşük
Thread-Local Storage   	Thread başı veri	              Çok yüksek	                   Düşük
Lock Sıralaması	        Çoklu mutex	                    — (güvenlik)	                 Orta
Producer-Consumer      	Üretim-tüketim akışı	          Yüksek	                       Orta

5.Altın Kurallar
Kritik Bölge Optimizasyonunda Temel İlkeler
1. Kilidi mümkün olduğunca kısa tut — I/O ve ağır hesaplamayı kilit dışına al.
2. Basit veri türleri için atomic kullan — mutex gerekmez.
3. Ölü kilide karşı kilitleri her zaman aynı sırayla edin.
4. Okuma yoğunsa Read-Write Lock tercih et.
5. En iyi kilit, hiç kilide gerek duyulmayan tasarımdır.


Not: Bu döküman Yasemin'in proje bölümü için taslak niteliğindedir. Kod örnekleri C++ ve Python üzerinden verilmiştir; projenin kullandığı dile göre uyarlanabilir.


-----------------------------------------------------------------------------
3. İş Parçacığı Havuzu Uygulaması
Thread Pool Mimarisi, Çalışma Mantığı ve Performans Katkısı
3.1 Temel Kavram: Thread Pool Nedir?
Tanım:Thread pool, önceden başlatılmış ve tekrar kullanılmak üzere bekletilen iş parçacıklarından oluşan yönetilen bir kaynak havuzudur. Görevler kuyruğa alınır ve uygun olan ilk thread tarafından işlenir.
3.2 Neden Thread Pool Kullanılır?

3.2.1 Thread Oluşturmanın Maliyeti
Bir işletim sisteminde yeni bir thread oluşturmak görünürde basit bir işlem gibi görünse de arka planda ciddi kaynak tüketimi gerektirir:

Çekirdek (kernel) seviyesinde yeni bir yapı ayrılması gerekir
Stack (yığın) belleği tahsis edilmeli ve başlangıç değerleri yazılmalıdır
İşletim sistemi zamanlayıcısına (scheduler) kayıt yapılmalıdır
Thread ilk kez CPU'ya geçtiğinde bağlam yükleme maliyeti (context loading) oluşur

Tipik bir thread oluşturma işlemi işletim sistemine göre değişmekle birlikte ortalama 0.5 ms ile 2 ms arasında zaman alır. Saniyede yüzlerce veya binlerce istek alan bir sistemde bu maliyet hızla birikir.

3.2.2 Kontrol Edilemeyen Kaynak Tüketimi
Thread pool kullanılmadığında, gelen her isteğe karşılık yeni bir thread açılır. Anlık trafik artışlarında (örneğin bir flash sale senaryosunda) aynı anda binlerce thread oluşturulabilir; bu durum:

Aşırı bellek tüketimine (her thread varsayılan olarak 512 KB - 8 MB stack kullanır),
CPU'nun thread yönetimiyle meşgul olmasına (thrashing),
Ve nihayetinde sistem çökmesine neden olabilir.

3.3 Thread Pool'un Sistemi Nasıl Hızlandırdığı

3.3.1 Karşılaştırmalı Analiz
Kriter	                          Thread Pool Olmadan	                                              Thread Pool ile
Thread oluşturma maliyeti	        Her istek için yeniden oluşturulur                              	Önceden oluşturulur, maliyet yok
Bellek kullanımı	                Kontrolsüz artabilir	                                            Sabit ve öngörülebilir
Yanıt süresi (ilk istek)	        Gecikmeli (thread başlatma)	                                      Hemen yanıt (thread hazır)
Eşzamanlı istek kontrolü	        Sınırsız → sistem çöküşü riski                                   	Maksimum thread sayısı sınırlı
Sistem kararlılığı	              Yük altında düşük	                                                Yüksek ve öngörülebilir
Kaynak temizleme	                Manuel yönetim gerektirir	                                        Havuz tarafından otomatik yönetilir

3.3.2 Somut Senaryo: Web Sunucusunda İstek İşleme

Thread pool kullanılmayan bir web sunucusunu ele alalım. 1.000 eşzamanlı istek geldiğinde:

1.000 yeni thread oluşturulur → ortalama 1 ms × 1.000 = 1 saniye saf thread açma maliyeti
Her thread ~1 MB bellek kullanıyorsa → 1 GB anlık bellek tüketimi
İşler bitince 1.000 thread yok edilir → tekrar bellek işlemleri

Aynı senaryo 50 thread'lik bir havuz ile:

50 thread önceden hazır bekler, sıfır oluşturma maliyeti
İstekler kuyruğa alınır, thread'ler tamamladıkça yeni görevi alır
Bellek tüketimi sabit ve öngörülebilir (~50 MB)
Sistem yük altında kararlılığını korur
Sonuç: 50 thread'lik havuz, 1.000 thread yerine sabit ve düşük maliyetle çok daha yüksek verimlilik sağlar. Throughput (işlem hacmi) artar, yanıt süreleri tutarlı kalır.

3.4 Kullanım Senaryosu ve Akış Açıklaması

3.4.1 Senaryo: Çok Kullanıcılı Dosya Dönüştürme Servisi

Kullanıcıların belge yükleyip farklı formatlara (PDF, DOCX, TXT) dönüştürdüğü bir servis düşünelim. Her dönüştürme işlemi yaklaşık 200-500 ms sürmektedir ve eşzamanlı olarak onlarca kullanıcı işlem başlatabilir.

3.4.2 Sistem Akışı

1)Başlatma:Uygulama açılışında thread pool başlatılır. Örneğin 10 worker thread önceden oluşturulur ve görev kuyruğunu dinlemeye başlar.
2)Görev Kuyruğu:Kullanıcıdan dönüştürme isteği geldiğinde doğrudan bir thread'e atanmaz; önce görev kuyruğuna (task queue) eklenir.
3)Thread Ataması:Boşta (idle) olan herhangi bir thread kuyruğu kontrol eder ve bekleyen görevi alır. Thread meşgulse kuyruktaki görev diğer thread'i bekler.
4)İşlem ve Geri Dönüş:Thread görevi işler (dosyayı dönüştürür), sonucu kullanıcıya iletir ve hemen kuyruğa döner. Yok edilmez, yeniden kullanılmaya hazırdır.
5)Ölçekleme:Trafik artarsa havuz dinamik olarak genişletilebilir (örn. min: 10, max: 50 thread). Trafik düşünce fazla thread'ler kademeli olarak sona erdirilir.

3.4.3 Temel Parametreler

Parametre	                        Açıklama	                                    Örnek Değer
Core Pool Size                   	Minimum aktif thread sayısı                  	10
Maximum Pool Size	                Yük altında açılacak max thread               50
Queue Capacity	                  Kuyruktaki max bekleyen görev	                200
Keep-Alive Time	                  Boşta kalan thread'in bekleme süresi	        60 saniye
Rejection Policy	                Kuyruk dolduğunda uygulanan strateji	        CallerRunsPolicy


3.5 Performansa Katkısı: Özet

Thread pool mimarisi, doğru yapılandırıldığında sisteme üç kritik katkı sağlar:

Gecikme (Latency) Azaltımı: Thread oluşturma maliyeti ortadan kalktığı için ilk yanıt süresi belirgin biçimde kısalır. Yük testlerinde bu fark genellikle %30-60 arasında ölçülmektedir.
Throughput Artışı: Thread'lerin yeniden kullanımı sayesinde aynı donanım üzerinde daha fazla işlem gerçekleştirilebilir. Kaynak israfı minimize edilir.
Sistem Kararlılığı: Maksimum thread sayısı sınırlandırıldığından ani yük artışları sistemi çöküşe sürükleyemez. Kuyruk mekanizması doğal bir tampon görevi görür.

ÖNERİ
Thread pool boyutu doğrudan performansı etkiler. I/O ağırlıklı işlemler için daha fazla thread (CPU sayısı × 2-4), CPU ağırlıklı işlemler için CPU sayısına eşit ya da biraz fazla thread tercih edilmesi önerilir.

--------------------------------------------------------------------
Çoklu İş Parçacığı Senkronizasyonu - Ezgi Efsa Güleç

Özet
Modern yazılım sistemleri, kullanıcı beklentilerinin artması ve donanımın çok çekirdekli mimariye geçmesiyle birlikte büyük ölçüde eş zamanlı çalışmak zorundadır. Bu durum, yazılım mühendisliği disiplini açısından yeni bir tasarım boyutu ortaya çıkarmıştır: birden fazla iş parçacığının paylaşılan kaynaklara güvenli erişimini sağlamak. Bu çalışmada çoklu iş parçacığı senkronizasyonu yalnızca işletim sistemleri bağlamında değil, bir yazılım mühendisliği problemi olarak ele alınmıştır.
1. Giriş
Yazılım mühendisliği, IEEE'nin tanımıyla, yazılımın geliştirilmesi, işletilmesi ve bakımına sistematik, disiplinli ve ölçülebilir bir yaklaşım uygulamak demektir. Günümüzde geliştirilen yazılımların büyük bir kısmı eş zamanlı çalışan birden fazla iş parçacığı içerdiğinden, doğruluğun sağlanması yalnızca algoritmik düzeyde değil, aynı zamanda iş parçacıkları arası etkileşimlerin yönetilmesi düzeyinde de garanti edilmek zorundadır.
Yanlış tasarlanmış bir senkronizasyon yapısı, programın bazen doğru bazen yanlış çalışmasına neden olur ve bu tür hatalar standart test süreçlerinde yakalanması çok zor olduğu için projenin sonraki aşamalarında ciddi maliyetler doğurabilir.
2. Yazılım Mühendisliği Açısından Eş Zamanlılık
2.1 Eş Zamanlılığın Tasarım Boyutu Olarak Konumu
Yazılım tasarımı yalnızca işlevsel gereksinimleri karşılayan bir çözüm üretmekten ibaret değildir; performans, güvenilirlik ve sürdürülebilirlik gibi işlevsel olmayan gereksinimlerin de aynı anda dikkate alınması gerekir. Eş zamanlılık, bu işlevsel olmayan gereksinimlerin neredeyse tamamına dokunan bir tasarım kararıdır.
2.2 Etkilenen Kalite Öznitelikleri
ISO/IEC 25010 yazılım kalite modeli temel alındığında, senkronizasyon kararlarının doğrudan etkilediği başlıca öznitelikler:

Doğruluk (correctness): Senkronizasyon eksikliği veri tutarsızlığına yol açar.
Güvenilirlik (reliability): Deadlock veya starvation problemleri programın çalışmasını durdurabilir.
Performans (performance): Aşırı kilit kullanımı paralelliği yok eder.
Sürdürülebilirlik (maintainability): Karmaşık senkronizasyon kodu değişiklikleri tehlikeli hale getirir.
Test edilebilirlik (testability): Eş zamanlı kodun davranışı zamanlamaya bağlı olduğundan klasik birim testleri yetersiz kalır.

3. Temel Problem: Paylaşılan Durum ve Yarış Koşulu
Eş zamanlı bir yazılımda iki veya daha fazla iş parçacığı aynı veriye eş zamanlı erişip en az biri yazma işlemi yapıyorsa, yarış koşulu (race condition) ortaya çıkar. Yarış koşullarının en sinsi yönü, hatanın her zaman görünmemesidir. Yazılım mühendisliği literatüründe bu tür hatalara Heisenbug adı verilir; çünkü programı hata ayıklayıcı altında çalıştırdığınızda zamanlama değişir ve hata kaybolur.
Klasik kayıp güncelleme problemi: iki iş parçacığı aynı bakiye değişkenini güncellediğinde, beklenen son değer 200 iken gerçekte 100 olabilir; çünkü her ikisi de eski değeri okur.
4. Senkronizasyon Mekanizmaları (Tasarım Araçları)
4.1 Mutex
Mutex (mutual exclusion), aynı anda yalnızca bir iş parçacığının sahip olabileceği bir kilittir. Kritik bölgenin dar tutulduğu ve basit bir karşılıklı dışlamanın yeterli olduğu durumlarda tercih edilir. Avantajı sadeliğidir; ancak unutulan unlock çağrıları ya da yanlış sırada alınan kilitler yazılım kararsızlığına yol açar.
4.2 Semafor
Semafor, Dijkstra tarafından önerilmiş daha esnek bir yapıdır ve sınırlı sayıda kaynağa erişimi yönetmek için uygundur. İki temel türü vardır: ikili semafor (binary) ve sayma semaforu (counting). Mutex'in aksine, semaforu kilitleyen ile açan iş parçacığının aynı olması gerekmez; bu esneklik sağlasa da yanlış kullanım riskini artırır. Klasik üretici-tüketici problemi semaforlarla çözülür.
4.3 Monitör
Monitör, mutex ve koşul değişkenlerini bir nesne içinde kapsülleyen daha yüksek seviyeli bir yapıdır. Nesne yönelimli tasarımla doğal biçimde örtüştüğü için modern dillerde tercih edilir. Java'nın synchronized anahtar sözcüğü bu yapının dile gömülü halidir.
4.4 Kilitsiz Yaklaşımlar (Lock-free)
Performansın kritik olduğu sistemlerde, atomik işlemler ve CAS (compare-and-swap) gibi düşük seviyeli yapılar kullanılarak kilit kullanmadan senkronizasyon sağlanabilir. Avantajı kilit darboğazını ortadan kaldırmasıdır; dezavantajı tasarımının ve doğrulanmasının çok daha zor olmasıdır.
5. Eş Zamanlılık Tasarım Desenleri
5.1 Üretici-Tüketici (Producer-Consumer)
Üretici ve tüketici iş parçacıklarının sınırlı kapasiteli bir tampon üzerinden iletişim kurmasını sağlayan desendir. Çoğu mesaj kuyruğu sistemi bu desen üzerine kuruludur.
5.2 Okuyucu-Yazıcı (Readers-Writers)
Bir kaynağı çok sayıda iş parçacığının aynı anda okuyabildiği ama yazma sırasında tek başına erişim gerektiren senaryoları tanımlar. Veritabanı ve önbellek tasarımlarında sıkça karşılaşılır.
5.3 İş Parçacığı Havuzu (Thread Pool)
Her iş için yeni iş parçacığı oluşturmak yerine sınırlı sayıda iş parçacığını önceden hazırlayıp havuzdan kullanmayı öngörür. Modern web sunucuları bu deseni varsayılan olarak kullanır.
5.4 Monitor Object Deseni
Bir nesnenin metotlarının aynı anda yalnızca bir iş parçacığı tarafından çalıştırılmasını garanti eder. Java'nın synchronized yapısı bu desenin dile gömülmüş halidir.
6. Yazılım Yaşam Döngüsünde Eş Zamanlılık
AşamaEş Zamanlılık Açısından Yapılması GerekenlerGereksinim AnaliziEş zamanlı kullanıcı sayısı, yanıt süresi, tutarlılık gereksinimleri belirlenirSistem TasarımıEş zamanlılık modeli seçilir; bileşenler arası kilit hiyerarşisi belirlenirAyrıntılı TasarımUygun tasarım desenleri seçilir, sınıf düzeyinde senkronizasyon stratejileri tanımlanırKodlamaDilin sunduğu yapılar kodlama standartlarına uygun kullanılırTestYük testi, stres testi ve özel araçlar (ThreadSanitizer vb.) kullanılırBakımEş zamanlılık kararları belgelenir, tasarım belgeleri güncel tutulur
7. Anti-Pattern'lar ve Gerçek Hayattan Vakalar
7.1 Deadlock
İki veya daha fazla iş parçacığının birbirinin tuttuğu kilitleri beklemesi durumudur. Coffman koşulları olarak bilinen dört şart aynı anda sağlandığında deadlock kaçınılmaz hale gelir. En yaygın çözüm, kilitlerin her zaman aynı sırada alınmasıdır.
7.2 Starvation ve Öncelik Tersliği
Starvation, bir iş parçacığının ihtiyacı olan kaynağa hiçbir zaman erişememesi durumudur. Öncelik tersliği ise düşük öncelikli bir iş parçacığının tuttuğu kilidi yüksek öncelikli bir iş parçacığının beklemesidir.
7.3 Vaka: Mars Pathfinder (1997)
NASA'nın Mars Pathfinder görevinde yaşanan sürekli sistem yeniden başlatmalarının sebebi klasik bir öncelik tersliği problemiydi. Sorun, öncelik kalıtımı (priority inheritance) protokolünün uzaktan etkinleştirilmesiyle çözüldü. Bu vaka, eş zamanlılık tasarımının milyonlarca dolarlık projeleri etkileyebileceğini göstermesi açısından önemlidir.
7.4 Vaka: Therac-25 (1985-1987)
Therac-25 radyoterapi cihazı, eş zamanlılık ve senkronizasyon hataları nedeniyle altı hastaya aşırı dozda radyasyon vererek üçünün ölümüne sebep olmuştur. Asıl sorun, kullanıcı arayüzü ile donanım kontrol iş parçacıkları arasındaki yarış koşullarının düzgün ele alınmamasıydı.
8. Tasarımda İyi Uygulamalar

Paylaşılan durumu azaltmak en güvenli yoldur; ortada paylaşılan veri yoksa senkronizasyon gerekmez.
Kilit hiyerarşisi belirlemek deadlock'ları büyük ölçüde önler.
Kritik bölgeyi mümkün olduğunca dar tutmak hem performansı artırır hem hata olasılığını azaltır.
Yüksek seviyeli yapılar tercih edilmelidir (eş zamanlı koleksiyonlar, executor framework).
Eş zamanlı kod özel testlerle doğrulanmalıdır; klasik birim testler yetersiz kalır.

9. Sonuç
Çoklu iş parçacığı senkronizasyonu, ilk bakışta işletim sistemleri alanına ait teknik bir konu gibi görünse de, modern yazılım mühendisliğinin tasarım, kalite ve süreç boyutlarıyla doğrudan kesişen bir alandır. Başarılı bir eş zamanlı yazılım, tek bir doğru kilit seçimine değil; gereksinim aşamasından bakım aşamasına kadar uzanan bütüncül bir mühendislik tutumuna bağlıdır. Mars Pathfinder ve Therac-25 vakaları, bu tutumun ihmal edildiğinde yol açtığı sonuçları çarpıcı biçimde göstermektedir.
-------------------------------------------------------------------------------------
Paralel Algoritma Tasarımı
Paralel algoritmalar, bir işlemin birden fazla işlemci veya çekirdek tarafından aynı anda yürütülmesini sağlayan algoritma yapılarıdır. Bu yaklaşım sayesinde büyük ve karmaşık işlemler daha kısa sürede tamamlanabilmektedir. Özellikle günümüzde çok çekirdekli işlemcilerin yaygınlaşmasıyla birlikte paralel işlem teknikleri yazılım geliştirme süreçlerinde önemli bir yere sahip olmuştur.
1. Paralel Algoritma Mantığı
Paralel algoritmalarda temel amaç, büyük bir işlemi daha küçük parçalara ayırarak bu parçaların eş zamanlı şekilde çalıştırılmasını sağlamaktır. Bu yapı sayesinde işlem süresi azalır ve sistem kaynakları daha verimli kullanılır. Paralel çalışma sırasında görevler farklı işlem birimlerine dağıtılarak aynı anda yürütülür.
2. İşlem Bölme Yöntemleri
Paralel algoritmalarda görev paylaşımı oldukça önemlidir. İşlem bölme yöntemleri genel olarak veri bölme ve görev bölme olmak üzere ikiye ayrılır. Veri bölmede büyük veri kümeleri parçalara ayrılarak farklı işlemcilere dağıtılır. Görev bölmede ise farklı işlemler aynı anda yürütülür.
3. Çok Çekirdekli Sistemler
Modern bilgisayarlarda bulunan çok çekirdekli işlemciler paralel algoritmaların temel çalışma altyapısını oluşturmaktadır. Her çekirdek farklı bir görevi aynı anda işleyebilir. Bu durum özellikle büyük veri işleme, yapay zeka ve görüntü işleme uygulamalarında performans artışı sağlamaktadır.
4. Thread (İş Parçacığı) Kullanımı
Paralel programlamada thread yapıları sıkça kullanılmaktadır. Threadler bir program içerisindeki bağımsız çalışma birimleridir. Birden fazla thread aynı anda çalışarak işlemlerin daha hızlı tamamlanmasına katkı sağlar. Ancak threadler arasında veri paylaşımı yapılırken senkronizasyon sorunları oluşabileceği için dikkatli bir yapı kurulmalıdır.
5. Performans Avantajları
Paralel algoritmalar işlem süresini azaltarak performans artışı sağlar. Özellikle büyük veri işlemlerinde ve karmaşık hesaplamalarda sistem verimliliği önemli ölçüde yükselir. İş yükünün işlemciler arasında paylaşılması sayesinde kaynak kullanımı dengeli hale gelir.
6. Kullanım Alanları
Paralel algoritmalar birçok alanda kullanılmaktadır. Bunlar arasında yapay zeka uygulamaları, veri analizi, görüntü işleme, oyun motorları, bilimsel hesaplamalar ve siber güvenlik sistemleri yer almaktadır. Yüksek işlem gücü gerektiren uygulamalarda paralel çalışma büyük avantaj sağlamaktadır.
7. Sonuç
Paralel algoritmalar modern yazılım sistemlerinde hız, performans ve verimlilik açısından önemli avantajlar sunmaktadır. İşlemlerin aynı anda yürütülmesi sayesinde büyük veri ve karmaşık hesaplama problemleri daha kısa sürede çözülebilmektedir. Bu nedenle paralel işlem teknikleri gelecekte yazılım mühendisliği alanında daha yaygın şekilde kullanılacaktır.
------------------------------------------------------------------------------------
Düşük Seviye Optimizasyon Teknikleri

Gömülü Sistemlerde İşlemci Performansını Artırmak İçin Loop Unrolling, Inline Functions ve Register Kullanımı

Hazırlayan: Ezgi Efsa Güleç

Özet

Modern gömülü sistemlerde işlemci performansı sınırlı güç bütçesi ve gerçek zamanlı gereksinimler arasında kritik bir rol oynar. Bu çalışmada, derleyici düzeyinin ötesinde programcının doğrudan kontrol edebileceği üç temel düşük seviye optimizasyon tekniği incelenmiştir: döngü açma (loop unrolling), satır içi fonksiyonlar (inline functions) ve register kullanımı. Her tekniğin çalışma mantığı, performans etkisi, avantaj ve dezavantajları kod örnekleriyle açıklanmıştır.

1. Giriş: Neden Düşük Seviye Optimizasyon Gereklidir?

Gömülü sistemlerde kaynak kısıtlaması (limited CPU cycles, bellek bant genişliği, güç tüketimi) nedeniyle, yüksek seviye optimizasyonlar (örneğin algoritmayı iyileştirme) yeterli olmayabilir. Derleyici otomatik optimizasyonları da her zaman en iyi sonucu vermez.

Başlıca sorunlar:

Pipeline Stall: CPU, bir komut tamamlanana kadar sonraki komutları bekler
Function Call Overhead: Her fonksiyon çağrısı stack frame, register save/restore maliyeti taşır
Memory Access Latency: RAM erişimi 100+ CPU cycle sürer; register erişimi 1 cycle
Branch Prediction Miss: Koşullu dallarda yanlış tahmin performansı ciddi şekilde düşürür
Düşük seviye teknikler, bu sorunları doğrudan hedef alarak işlemci verimliliğini artırır.

2. Döngü Açma (Loop Unrolling)

2.1 Çalışma Mantığı

Döngü açma, bir döngünün birden fazla iterasyonunu ardı ardına yazarak döngü kontrol işlemlerinin sayısını azaltan bir tekniktir.

Temel Fikir:

Orijinal döngü:
for (i = 0; i < 1000; i++) {
    array[i] = array[i] * 2;  // 1000 kez çalışır
}

Açılmış döngü (4 unroll):
for (i = 0; i < 1000; i += 4) {
    array[i] = array[i] * 2;     // İşlem 1
    array[i+1] = array[i+1] * 2; // İşlem 2
    array[i+2] = array[i+2] * 2; // İşlem 3
    array[i+3] = array[i+3] * 2; // İşlem 4
}
// Döngü sadece 250 kez çalışır (1000/4)
2.2 Performansa Etkisi

Döngü açılmadığında yapılan işler (her iterasyon):

Koşulu kontrol et: i < 1000 (1 cycle)
i'yi artır: i++ (1 cycle)
Jump/branch: döngü başına dön (1-3 cycle, pipeline stall riski)
Veri işlemi (N cycle)
Döngü açıldığında:

Koşul kontrolü: 250 kez (1000/4)
i artırma: 250 kez
Jump: 250 kez
Veri işlemi: hala 1000 kez (aynı)
Kazanç: Kontrol işlemleri %75 azalır. Tipik ölçüm: %30-50 performans artışı (işlem yüküne bağlı).

2.3 Avantajlar ve Dezavantajları

Avantaj	Dezavantaj
Döngü kontrol overhead'i azalır	Kod boyutu büyür (code bloat)
Pipeline'ın bağımsız işlemleri paralel yapmasını sağlar	L1 cache vurma oranı düşebilir
Branch prediction yanlışlığı azalır	Derleyici otomatik yapsa da, elle yapılan daha etkili olabilir
ARM/x86'da SIMD ile birleşince çok etkili	Aşırı unroll ederse register pressure artar (spill)
2.4 Pratik Örnek: ARM Assembler

; Orijinal (döngüsüz):
MOV R0, #0           ; i = 0
LOOP:
    LDR R1, [R2, R0] ; array[i] yükle
    LSL R1, R1, #1   ; 2 ile çarp (shift)
    STR R1, [R2, R0] ; geri yaz
    ADD R0, R0, #4   ; i += 4 (4 byte = 1 int)
    CMP R0, #4000    ; i < 1000*4 mi?
    BLT LOOP         ; evet ise loop'a geri dön

; Unroll edilmiş (4 iterasyon bir seferde):
MOV R0, #0           ; i = 0
LOOP:
    LDR R1, [R2, R0]      ; array[i]
    LSL R1, R1, #1
    STR R1, [R2, R0]
    
    LDR R1, [R2, R0, #4]  ; array[i+1]
    LSL R1, R1, #1
    STR R1, [R2, R0, #4]
    
    LDR R1, [R2, R0, #8]  ; array[i+2]
    LSL R1, R1, #1
    STR R1, [R2, R0, #8]
    
    LDR R1, [R2, R0, #12] ; array[i+3]
    LSL R1, R1, #1
    STR R1, [R2, R0, #12]
    
    ADD R0, R0, #16       ; i += 16 (4 * 4 byte)
    CMP R0, #4000
    BLT LOOP              ; 250 kez çalışır (1000/4)
Sonuç: Branch talimatı 1000 kez yerine 250 kez çalışır. Pipeline daha rahat çalışır.

3. Satır İçi Fonksiyonlar (Inline Functions)

3.1 Çalışma Mantığı

Normal bir fonksiyon çağrısı ciddi bir overhead taşır:

// Normal fonksiyon
int add(int a, int b) {
    return a + b;
}

// Çağrı
result = add(x, y);
Derleyici yapacakları:

x ve y registrelerine yükle (PUSH / MOV)
Fonksiyon giriş adresine CALL (return address stack'e)
Fonksiyonun iç registrelerini koruma (PUSH)
İşlem yap (ADD R0, R1, R2)
Registerleri geri yükle (POP)
RET (return adresinden geri dön)
Döngü içinde 1000 kez çağrılırsa: 1000 × (setup + return) = binlerce cycle harcandı, oysaki asıl işlem sadece 1 cycle!

Inline ile:

inline int add(int a, int b) {
    return a + b;
}
Derleyici, add(x, y) yazısını doğrudan x + y'ye dönüştürür. Fonksiyon çağrısı yoktur.

3.2 Performansa Etkisi

Örnek: Küçük fonksiyonun 1000 kez çağrılması

// Inline OLMADAN
for (i = 0; i < 1000; i++) {
    result += add(array[i], offset); // 1000 call overhead
}
// Tahmini: 1000 × (5 cycle call + 1 cycle işlem) = 6000 cycle

// Inline İLE
for (i = 0; i < 1000; i++) {
    result += array[i] + offset;  // Doğrudan toplama
}
// Tahmini: 1000 × 1 cycle = 1000 cycle
Kazanç: %80-95 hızlanma mümkün (çok çağrılan küçük fonksiyonlar için).

3.3 Avantajlar ve Dezavantajları

Avantaj	Dezavantaj
Function call overhead ortadan kalkar	Kod boyutu artış (her çağrı sitesinde kopyalanır)
Derleyici kod çevresindeki optimizasyonu daha iyi yapabilir	Inline çok sayıda yerde kullanılırsa L1 cache miss artar
Getter/setter gibi basit fonksiyonlarda kritik	Özyinelemeli fonksiyonlar inline olamaz
Derleyici __attribute__((always_inline)) ile zorlanabilir	Debug yapılması zor (fonksiyon boundary'si kaybolur)
3.4 Pratik Örnek: C ve Derleyici Çıktısı

// Hiç optimize edilmemiş
int multiply(int a, int b) {
    return a * b;
}

int main() {
    int result = 0;
    for (int i = 0; i < 100; i++) {
        result += multiply(i, 10);
    }
    return result;
}

// Derleyici çıktısı (non-inline):
call multiply  ; 100 kez tekrarlanır
Inline ile:

inline int multiply(int a, int b) {
    return a * b;
}
// Derleyici:
// result += i * 10;  // doğrudan
// call yok
ARM Cortex-M için:

// İnline olmayan getter (mesela 10 kez çağrılacak)
unsigned int get_counter(struct device *dev) {
    return dev->counter;
}

// Her çağrıda: PUSH {R7}, MOV R7 SP, LDR R0 [R0], POP {R7}, BX LR (~8 cycle)
// 10 çağrı = 80 cycle overhead

// Inline ile: doğrudan LDR R0 [R0] (1 cycle)
4. Register Kullanımı

4.1 Çalışma Mantığı

CPU registerleri (x86'da 8-16, ARM'da 16), en hızlı erişilebilir depolama ortamıdır.

Bellek hiyerarşisi ve erişim süresi:

Registers:     1 cycle (CPU chip içinde)
L1 Cache:      3-4 cycle
L2 Cache:      10-20 cycle
L3 Cache:      40-75 cycle
RAM (DRAM):    100-300 cycle
Eğer bir değişkene 1000 kez erişiliyorsa:

Register'da kalırsa: 1000 × 1 = 1000 cycle
RAM'de kalırsa: 1000 × 100 = 100,000 cycle
Fark: 100x yavaşlama!

4.2 Stratejiler

4.2.1 Sıkça Kullanılan Değişkenleri Register'da Tutmak

// Kötü: counter her loop'ta RAM'den okunur
int counter = 0;  // Stack'te (RAM'e yakın)
for (int i = 0; i < 1000000; i++) {
    counter++;    // Bellek yazma/okuma
    array[counter] = i;
}

// İyi: counter register'da kalır
register int counter = 0;  // (Modern C: derleyici kararı)
for (int i = 0; i < 1000000; i++) {
    counter++;              // Register işlemi
    array[counter] = i;
}
4.2.2 Pointer Aliasing Azaltma

// Kötü: p her iterasyonda bellek erişir
int *p = array;
for (int i = 0; i < 1000; i++) {
    sum += *p;
    p++;  // Pointer bellek erişimi
}

// İyi: p ve sum register'da kalır
int *p = array;
int sum = 0;
for (int i = 0; i < 1000; i++) {
    sum += *p++;  // Hem p hem sum register işlemleri
}
4.3 Derleyici Register Allocation

Modern derleyiciler (GCC, Clang) otomatik olarak iyi register allocation yaparlar. Elle register anahtar sözcüğü kullanmak artık nadiren gereklidir.

Ama derleyiciye yardım edebilirsiniz:

// Derleyici için zor (volatile yapabilir optimize etmeyi)
volatile int sensor_value;
for (int i = 0; i < 1000; i++) {
    process(sensor_value);  // Her seferinde RAM'den oku
}

// Daha iyi: bir kez oku, sonra register'da kullan
int temp = sensor_value;
for (int i = 0; i < 1000; i++) {
    process(temp);  // Register'dan oku
}
4.4 ARM Cortex-M'de Register Baskısı

ARM Cortex-M3/M4'te sadece 16 tane genel amaçlı register vardır (R0-R15):

R0-R3: Function arguments & return (caller-saved)
R4-R11: Lokal değişkenler (callee-saved)
R12: Ara hesaplamalar
R13: Stack Pointer
R14: Link Register
R15: Program Counter
Örnek: İyi register kullanımı

int filter(int *samples, int count) {
    register int sum = 0;        // R4
    register int i = 0;          // R5
    register int *ptr = samples; // R6
    
    // 7 register kullanıldı, hâlâ R7-R11 boş
    while (i < count) {
        sum += *ptr++;  // Tüm işlemler register'da
        i++;
    }
    return sum;
}
Derleyici çıktısı (ARM):

MOV R4, #0      ; sum = 0 (register)
MOV R5, #0      ; i = 0 (register)
MOV R6, R0      ; ptr = samples (register)

LOOP:
    LDR R7, [R6], #4 ; *ptr++ değerini R7'ye yükle
    ADD R4, R4, R7   ; sum += R7
    ADD R5, R5, #1   ; i++
    CMP R5, R1       ; i < count?
    BLT LOOP

MOV R0, R4       ; return sum
BX LR
Tüm işlemler register'lar arasında — RAM erişimi yok!

4.5 Avantajlar ve Dezavantajları

Avantaj	Dezavantaj
RAM erişimi tamamen ortadan kalkar (100x hızlanma mümkün)	Register sayısı sınırlı
İç loop'larda (hot spot) çok etkili	Aşırı değişken tutmaya çalışmak register spill'e yol açar
Modern derleyici otomatik yapar, ama elle optimizasyon mümkün	Volatile değişkenler de derleyiciyi zorlar
Cache miss'i azaltır	Yapısı karmaşık olan değişkenler register'a sığmaz
5. Kombinli Kullanım ve Pratik Tavsiyeler

5.1 Bir Arada Uygulanması

// Düşük seviye optimizasyon kombinasyonu
void fast_transform(int *data, int count) {
    // Unroll + Inline + Register
    register int i = 0;
    register int *ptr = data;
    
    // Inline bir işlem makrosu tanımla
    #define TRANSFORM(x) ((x >> 2) + (x << 3))
    
    // Loop unrolling (4x)
    for (i = 0; i < count; i += 4) {
        ptr[0] = TRANSFORM(ptr[0]);  // Inline macro
        ptr[1] = TRANSFORM(ptr[1]);
        ptr[2] = TRANSFORM(ptr[2]);
        ptr[3] = TRANSFORM(ptr[3]);
        ptr += 4;
    }
}
Tahmini performans iyileştirmesi:

Loop unrolling: %30
Inline: %20
Register: %50
Kombinli toplam: %80-90
5.2 Hangi Durumda Hangisini Kullan?

Durum	Teknik	Neden
Tight loop, çok iterasyon	Loop unrolling	Döngü overhead kritik
Küçük, sık çağrılan fonksiyon	Inline	Call overhead dominan
İç loop'ta sıkça erişilen değişken	Register	RAM latency dominan
Veri işleme pipeline'ı	Unrolling + SIMD	Processor verimliliği
Gerçek zamanlı sistem	Hepsi	Predictable timing
5.3 Ölçüm ve Profiling

Optimizasyon yapmadan önce:

// Linux/ARM: cycle counter ile ölçü
unsigned int get_cycles() {
    unsigned int value;
    asm volatile("MRC p15, 0, %0, c9, c13, 0" : "=r"(value));
    return value;
}

start = get_cycles();
// Optimize edilecek kod
end = get_cycles();
printf("Cycles: %u\n", end - start);
Optimizasyondan sonra tekrar ölç. %30'dan az iyileştirme görülüyorsa, başka yerdeki병목(bottleneck) arayın.

6. Derleyici Seçenekleri

Modern derleyiciler otomatik optimizasyon yapabilir:

# GCC/Clang
gcc -O3 -funroll-loops -finline-functions file.c

# -O3: Agresif optimizasyon
# -funroll-loops: Otomatik döngü açma
# -finline-functions: Otomatik inline
Uyarı: -O3 sometimes increases code size excessively. Gömülü sistemlerde -O2 daha dengeli olabilir.

7. Sonuç

Düşük seviye optimizasyon teknikleri — döngü açma, inline fonksiyonlar ve register kullanımı — işlemci verimliliğini dramatik şekilde artırabilir. Ancak:

Profiling yapın: Blind optimizasyon boş iştir
Derleyiciye güvenin: Modern derleyiciler çoğu zaman el yazısından daha iyi yapar
Okunabilirliği unutmayın: Optimize edilmiş kod zor bakılır
Platform spesifik: ARM, x86, RISC-V'de stratejiler değişir
Gömülü sistemlerde, bu teknikler donanım sınırlamalarını aşmak için değerli araçlardır.
--------------------------------------------------------------------------------------------------------------------
Benchmarking ve Performans Karşılaştırma Raporu
Doküman Tanımı: Farklı Optimizasyon Tekniklerinin Performans ve Güç Tüketimi Üzerindeki Etkilerinin Karşılaştırmalı Analizi 
Hazırlayan: Ebrar

1. Giriş ve Amaç
Gömülü sistemlerde enerji verimliliği ve gerçek zamanlı performans, donanım kaynaklarının kısıtlı olması nedeniyle birbirleriyle doğrudan çelişen iki temel optimizasyon hedefidir. Geliştirmekte olduğumuz EV-OS (Energy Efficient Operating System) projesi; düşük güç tüketimi ve gerçek zamanlı performansı hedefleyen, kaynak kısıtlı ortamlarda güvenilir çalışmayı sağlayarak pil ömrünü uzatmayı amaçlayan, gömülü cihazlar için optimize edilmiş bir işletim sistemidir. 
Bu raporun amacı; proje kapsamında teslim edilecek olan çekirdek ve cihaz sürücüleri, güç yönetimi modülü ve gerçek zamanlı görev planlayıcısının üzerinde uygulanan farklı optimizasyon tekniklerinin sistem performansı üzerindeki etkilerini nicel (kantitatif) metriklerle ortaya koymaktır. Analiz kapsamında; işlem süresi, bellek kullanımı, CPU tüketimi ve optimizasyon öncesi/sonrası farklar metrikleri bazında kıyaslamalar yapılmıştır.

2. Metodoloji ve Test Ortamı
Testler, gerçek zamanlı süreçlerin simüle edildiği ve donanım doğrulama süreçlerinin işletildiği heterojen bir ARM platformunda gerçekleştirilmiştir. Ölçümlerin doğruluğunu sağlamak amacıyla test senaryoları 1000'er kez koşturulmuş ve ortalama değerler raporlanmıştır. 
Donanım Platformu: ARM Cortex-M4 tabanlı mikrodenetleyici (168 MHz, 192 KB RAM, 1 MB Flash) ve ARM Cortex-A7 Gömülü Linux Geliştirme Kartı. 
Ölçüm ve Analiz Araçları: Çekirdek içi izleme araçları (ftrace), Logic Analyzer, Akım Algılama Şönt Dirençleri ve GNU Profiler (gprof). 
Referans Örnek Senaryo: Minimal bellek ayak izini doğrulamak amacıyla; 10 ms periyotlu bir ADC veri okuma, sayısal sinyal işleme (FFT) ve ardından UART üzerinden veri aktarımı yapan kritik bir gerçek zamanlı görev (task) seti koşturulmuştur. 


3. Uygulanan Optimizasyon Teknikleri
Raporda performans üzerindeki etkileri karşılaştırılan dört temel optimizasyon stratejisi değerlendirilmiştir: 
Derleyici Seviyesi Optimizasyonlar (O0 - O2 - Os): Kod boyutu ve çalıştırma hızı arasındaki dengenin kurulması. 
Tickless Idle Mekanizması: Periyodik sistem saati kesmelerinin (timer ticks) kaldırılarak işlemcinin daha uzun süre derin uyku (Deep Sleep) modunda kalmasının sağlanması. 
Rate Monotonic Scheduling (RMS) ve Dinamik Öncelik Ataması: Gerçek zamanlı görev planlayıcısının bağlam değişimi (context-switch) maliyetlerinin düşürülmesi. 
Assembly ile Kritik Kod Optimizasyonu: Sık çağrılan donanım kesme servis rutinlerinin (ISR) C yerine ARM Assembly ile optimize edilmesi. 

4. Performans Metrikleri ve Karşılaştırma Tabloları
4.1. Derleyici Optimizasyonlarının Etkileri (O0, O2, Os Kıyaslaması)
Çekirdek derleme aşamasında GNU GCC derleyicisinin sunduğu farklı optimizasyon bayrakları test edilmiştir. Aşağıdaki tabloda; işlem süresi, bellek kullanımı, CPU tüketimi ve optimizasyon öncesi/sonrası farklar listelenmiştir.

Metrik/profil	            Optimizasyon öncesi (O0)	   Hız optimizasyonu (O2)	   Boyut/verim opt. (Os)	  Değişim oranı (O0 vs. Os)
Çekirdek flash            142 KB                       118 KB                    74 KB                    -47.8% (Azalma)
boyutu(bellek kullanımı)  	                     
Kritik görev              4.82 ms                      2.15 ms                   2.41 ms                  -50.0% (Hızlanma)
işlem süresi	
RAM/Yığın(stack)          24.5 KB	                     18.2 KB	                 14.1 KB                  -42.4% (Tasarruf)
bellek tüketimi	
Ortalama CPU              34.2%	                       16.8%	                   18.5%	                  -45.9% (Serbest Kapasite)
tüketimi(yük)	


4.2. Güç Yönetim Modülü: Periyodik Tick vs. Tickless Idle
Klasik işletim sistemleri her süresinde bir (örneğin 1 ms) kesme üreterek zamanlayıcıyı tetikler. Geliştirdiğimiz Tickless Idle güç yönetimi modülü, boşta (idle) kalınacak süreyi hesaplayarak dinamik olarak bir sonraki göreve kadar zamanlayıcı kesmesini öteler. 



Metrik/Senaryo	           Standart Periyodik Kesme(1kHz)         	EV-OS Tickless Idle Modu	              Net Kazanç/Fark
Saniye Başına 
Kesme(ISR) Sayısı	         1000 kesme/sn	                          42 kesme/sn	                            -95.8% Azalma
Boşta kalma 
CPU tüketimi	             6.4%	                                    0.8%	                                  -5.6% CPU Yükü
Ortalama akım 
tüketimi(3.3V)	           28.4 mA	                                4.2 mA	                                %85.2 Enerji Tasarrufu
Teorik pil ömrü
(500mAh Li-Po)	           17.6 Saat	                              119.0 Saat	                            +1001.4 Saat Artış


4.3. Planlayıcı (Scheduler) ve Bağlam Değişimi (Context-Switch) Karşılaştırması
Gerçek zamanlı görev planlayıcısının bağlam değişimi (context-switch) esnasında CPU register'larının saklanması ve geri yüklenmesi süreçleri ARM derlemesinde el ile optimize edilmiştir (Assembly inline). Aşağıda, süreçlerin işlem süreleri mikrosaniye () cinsinden kıyaslanmıştır. 

[Görev Planlama Mimarileri]      [Bağlam Değişimi (Context-Switch) İşlem Süreleri]
----------------------------------------------------------------------------------
Optimizasyonsuz C Kodu (O0)      : ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  18.4 µs
Standart RTOS Yapısı (O2)        : ■■■■■■■■■■■■■■■                      8.2 µs
EV-OS Mimarisi (ARM Assembly)    : ■■■■■                                3.1 µs
----------------------------------------------------------------------------------


5. Bulgular ve Optimizasyon Öncesi/Sonrası Farklar
Gerçekleştirilen donanım test ve doğrulama süreçlerinde elde edilen en çarpıcı farklar şunlardır: 
Gecikme (Latency) Azalması: Donanım kesmelerine yanıt verme süresi (Interrupt Latency) Assembly seviyesinde register haritalama sayesinde  değerinden  seviyesine indirilmiştir. Bu durum gerçek zamanlı sistem determinizmini doğrudan güçlendirmiştir. 
Bellek Sıkıştırma Başarısı: -Os bayrağı ile derlenen kod, inline fonksiyonların akıllıca açılması (unrolling) ve dead-code elimination (kullanılmayan kodların temizlenmesi) teknikleriyle Flash bellekte %47.8 yer tasarrufu sağlamıştır. Bu durum, minimal bellek ayak izi hedefine ulaşılmasını sağlamıştır. 
Termal ve Akım Kararlılığı: İşlemcinin uyku modları arasındaki geçiş frekansı azaldığı için, ani akım pikleri (current spikes) engellenmiş ve regülatör üzerindeki termal yükün azaldığı gözlemlenmiştir. 
Önemli Çıkarım: Yapılan optimizasyonlar sonucunda EV-OS, saf bir gerçek zamanlı işletim sisteminin deterministik hızına sahip olurken, güç tüketimi bazında çıplak donanım (bare-metal) programlama seviyesine yakın bir verimlilik göstermiştir.



6. Mühendislik Değerlendirmesi ve Sonuç
EV-OS projesi kapsamında elde edilen benchmarking verileri, gömülü işletim sistemi mimarilerinde sıklıkla karşılaşılan "Güç Tüketimi - Determinizm - Bellek Alanı" arasındaki üçlü çelişkiyi (trade-off) net bir şekilde ortaya koymaktadır. Yapılan testler ve metrik analizleri doğrultusunda şu teknik değerlendirmelere ulaşılmıştır: 
Düşük Güç / Uzun Pil Ömrü Odaklı Senaryolar (Örn: IoT Sensör Düğümleri): Bu durumlarda en verimli teknik Tickless Idle mekanizmasıdır. İşlemcinin zamanının %90'ından fazlasını derin uykuda geçirmesini sağlayarak akım tüketimini 28.4 mA'den 4.2 mA seviyesine çekmekte ve pil ömrünü katlamaktadır. Çekirdek derlemesinde ise bellek ayak izini daraltmak için -Os tercih edilmelidir. Ancak, derin uykudan normal çalışma moduna geçiş esnasında donanımsal bir uyanma gecikmesi oluştuğu unutulmamalıdır. 
Yüksek Determinizm / Kritik Gerçek Zamanlı Senaryolar (Örn: Motor Sürücüleri, Otomotiv): İşlem süresinin ve context-switch gecikmesinin kritik olduğu senaryolarda Assembly Makroları ve GCC -O2 optimizasyonu bir arada kullanılmalıdır. Bağlam değişimi maliyetinin 3.1 değerine çekilmesi sayesinde, bellek ve güç tüketiminden bir miktar ödün verilerek en hızlı yanıt süresi ve deterministik kararlılık elde edilir. 
Karmaşık Veri İşleme Senaryoları (Örn: Gömülü Edge-AI): Donanım kısıtlamalarının yoğun olduğu ama hesaplama gücü gerektiren durumlarda veri önbellekleme (L1 Cache hat hizalaması) ve derleyicinin vektörizasyon (SIMD/NEON) eklentileri devreye alınmalıdır. 
Sonuç olarak EV-OS; modüler güç yönetimi, optimize edilmiş gerçek zamanlı görev planlayıcısı ve minimal bellek ayak izi sayesinde akademide ve endüstride kabul gören standartları yakalamıştır. Bu çalışma, yazılım mimarisinin donanım özellikleriyle ne kadar senkronize edilebilirse, sistem verimliliğinin o derece artacağını kanıtlamaktadır.

