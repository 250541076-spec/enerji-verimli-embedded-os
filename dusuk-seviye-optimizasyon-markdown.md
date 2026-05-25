---

# Düşük Seviye Optimizasyon Teknikleri

*Gömülü Sistemlerde İşlemci Performansını Artırmak İçin Loop Unrolling, Inline Functions ve Register Kullanımı*

**Hazırlayan:** Ezgi Efsa Güleç

## Özet

Modern gömülü sistemlerde işlemci performansı sınırlı güç bütçesi ve gerçek zamanlı gereksinimler arasında kritik bir rol oynar. Bu çalışmada, derleyici düzeyinin ötesinde programcının doğrudan kontrol edebileceği üç temel düşük seviye optimizasyon tekniği incelenmiştir: döngü açma (loop unrolling), satır içi fonksiyonlar (inline functions) ve register kullanımı. Her tekniğin çalışma mantığı, performans etkisi, avantaj ve dezavantajları kod örnekleriyle açıklanmıştır.

## 1. Giriş: Neden Düşük Seviye Optimizasyon Gereklidir?

Gömülü sistemlerde kaynak kısıtlaması (limited CPU cycles, bellek bant genişliği, güç tüketimi) nedeniyle, yüksek seviye optimizasyonlar (örneğin algoritmayı iyileştirme) yeterli olmayabilir. Derleyici otomatik optimizasyonları da her zaman en iyi sonucu vermez.

Başlıca sorunlar:

- **Pipeline Stall:** CPU, bir komut tamamlanana kadar sonraki komutları bekler
- **Function Call Overhead:** Her fonksiyon çağrısı stack frame, register save/restore maliyeti taşır
- **Memory Access Latency:** RAM erişimi 100+ CPU cycle sürer; register erişimi 1 cycle
- **Branch Prediction Miss:** Koşullu dallarda yanlış tahmin performansı ciddi şekilde düşürür

Düşük seviye teknikler, bu sorunları doğrudan hedef alarak işlemci verimliliğini artırır.

## 2. Döngü Açma (Loop Unrolling)

### 2.1 Çalışma Mantığı

Döngü açma, bir döngünün birden fazla iterasyonunu ardı ardına yazarak döngü kontrol işlemlerinin sayısını azaltan bir tekniktir.

**Temel Fikir:**
```
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
```

### 2.2 Performansa Etkisi

**Döngü açılmadığında yapılan işler (her iterasyon):**
1. Koşulu kontrol et: `i < 1000` (1 cycle)
2. i'yi artır: `i++` (1 cycle)
3. Jump/branch: döngü başına dön (1-3 cycle, pipeline stall riski)
4. Veri işlemi (N cycle)

**Döngü açıldığında:**
1. Koşul kontrolü: 250 kez (1000/4)
2. i artırma: 250 kez
3. Jump: 250 kez
4. Veri işlemi: hala 1000 kez (aynı)

**Kazanç:** Kontrol işlemleri %75 azalır. Tipik ölçüm: **%30-50 performans artışı** (işlem yüküne bağlı).

### 2.3 Avantajlar ve Dezavantajları

| Avantaj | Dezavantaj |
|---------|-----------|
| Döngü kontrol overhead'i azalır | Kod boyutu büyür (code bloat) |
| Pipeline'ın bağımsız işlemleri paralel yapmasını sağlar | L1 cache vurma oranı düşebilir |
| Branch prediction yanlışlığı azalır | Derleyici otomatik yapsa da, elle yapılan daha etkili olabilir |
| ARM/x86'da SIMD ile birleşince çok etkili | Aşırı unroll ederse register pressure artar (spill) |

### 2.4 Pratik Örnek: ARM Assembler

```arm
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
```

**Sonuç:** Branch talimatı 1000 kez yerine 250 kez çalışır. Pipeline daha rahat çalışır.

---

## 3. Satır İçi Fonksiyonlar (Inline Functions)

### 3.1 Çalışma Mantığı

Normal bir fonksiyon çağrısı ciddi bir overhead taşır:

```c
// Normal fonksiyon
int add(int a, int b) {
    return a + b;
}

// Çağrı
result = add(x, y);
```

**Derleyici yapacakları:**
1. `x` ve `y` registrelerine yükle (PUSH / MOV)
2. Fonksiyon giriş adresine CALL (return address stack'e)
3. Fonksiyonun iç registrelerini koruma (PUSH)
4. İşlem yap (`ADD R0, R1, R2`)
5. Registerleri geri yükle (POP)
6. RET (return adresinden geri dön)

**Döngü içinde 1000 kez çağrılırsa:** 1000 × (setup + return) = **binlerce cycle harcandı**, oysaki asıl işlem sadece 1 cycle!

**Inline ile:**
```c
inline int add(int a, int b) {
    return a + b;
}
```

Derleyici, `add(x, y)` yazısını doğrudan `x + y`'ye dönüştürür. Fonksiyon çağrısı yoktur.

### 3.2 Performansa Etkisi

**Örnek: Küçük fonksiyonun 1000 kez çağrılması**

```c
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
```

**Kazanç:** %80-95 hızlanma mümkün (çok çağrılan küçük fonksiyonlar için).

### 3.3 Avantajlar ve Dezavantajları

| Avantaj | Dezavantaj |
|---------|-----------|
| Function call overhead ortadan kalkar | Kod boyutu artış (her çağrı sitesinde kopyalanır) |
| Derleyici kod çevresindeki optimizasyonu daha iyi yapabilir | Inline çok sayıda yerde kullanılırsa L1 cache miss artar |
| Getter/setter gibi basit fonksiyonlarda kritik | Özyinelemeli fonksiyonlar inline olamaz |
| Derleyici `__attribute__((always_inline))` ile zorlanabilir | Debug yapılması zor (fonksiyon boundary'si kaybolur) |

### 3.4 Pratik Örnek: C ve Derleyici Çıktısı

```c
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
```

**Inline ile:**
```c
inline int multiply(int a, int b) {
    return a * b;
}
// Derleyici:
// result += i * 10;  // doğrudan
// call yok
```

**ARM Cortex-M için:**
```c
// İnline olmayan getter (mesela 10 kez çağrılacak)
unsigned int get_counter(struct device *dev) {
    return dev->counter;
}

// Her çağrıda: PUSH {R7}, MOV R7 SP, LDR R0 [R0], POP {R7}, BX LR (~8 cycle)
// 10 çağrı = 80 cycle overhead

// Inline ile: doğrudan LDR R0 [R0] (1 cycle)
```

---

## 4. Register Kullanımı

### 4.1 Çalışma Mantığı

CPU registerleri (x86'da 8-16, ARM'da 16), en hızlı erişilebilir depolama ortamıdır.

**Bellek hiyerarşisi ve erişim süresi:**
```
Registers:     1 cycle (CPU chip içinde)
L1 Cache:      3-4 cycle
L2 Cache:      10-20 cycle
L3 Cache:      40-75 cycle
RAM (DRAM):    100-300 cycle
```

Eğer bir değişkene 1000 kez erişiliyorsa:
- Register'da kalırsa: 1000 × 1 = 1000 cycle
- RAM'de kalırsa: 1000 × 100 = 100,000 cycle

**Fark: 100x yavaşlama!**

### 4.2 Stratejiler

**4.2.1 Sıkça Kullanılan Değişkenleri Register'da Tutmak**

```c
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
```

**4.2.2 Pointer Aliasing Azaltma**

```c
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
```

### 4.3 Derleyici Register Allocation

**Modern derleyiciler (GCC, Clang) otomatik olarak iyi register allocation yaparlar.** Elle `register` anahtar sözcüğü kullanmak artık nadiren gereklidir.

Ama **derleyiciye yardım edebilirsiniz:**

```c
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
```

### 4.4 ARM Cortex-M'de Register Baskısı

ARM Cortex-M3/M4'te sadece **16 tane genel amaçlı register** vardır (R0-R15):
- R0-R3: Function arguments & return (caller-saved)
- R4-R11: Lokal değişkenler (callee-saved)
- R12: Ara hesaplamalar
- R13: Stack Pointer
- R14: Link Register
- R15: Program Counter

**Örnek: İyi register kullanımı**

```c
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
```

**Derleyici çıktısı (ARM):**
```arm
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
```

**Tüm işlemler register'lar arasında — RAM erişimi yok!**

### 4.5 Avantajlar ve Dezavantajları

| Avantaj | Dezavantaj |
|---------|-----------|
| RAM erişimi tamamen ortadan kalkar (100x hızlanma mümkün) | Register sayısı sınırlı |
| İç loop'larda (hot spot) çok etkili | Aşırı değişken tutmaya çalışmak register spill'e yol açar |
| Modern derleyici otomatik yapar, ama elle optimizasyon mümkün | Volatile değişkenler de derleyiciyi zorlar |
| Cache miss'i azaltır | Yapısı karmaşık olan değişkenler register'a sığmaz |

---

## 5. Kombinli Kullanım ve Pratik Tavsiyeler

### 5.1 Bir Arada Uygulanması

```c
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
```

**Tahmini performans iyileştirmesi:**
- Loop unrolling: %30
- Inline: %20
- Register: %50
- **Kombinli toplam: %80-90**

### 5.2 Hangi Durumda Hangisini Kullan?

| Durum | Teknik | Neden |
|-------|--------|-------|
| Tight loop, çok iterasyon | Loop unrolling | Döngü overhead kritik |
| Küçük, sık çağrılan fonksiyon | Inline | Call overhead dominan |
| İç loop'ta sıkça erişilen değişken | Register | RAM latency dominan |
| Veri işleme pipeline'ı | Unrolling + SIMD | Processor verimliliği |
| Gerçek zamanlı sistem | Hepsi | Predictable timing |

### 5.3 Ölçüm ve Profiling

Optimizasyon yapmadan önce:
```c
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
```

Optimizasyondan sonra **tekrar ölç.** %30'dan az iyileştirme görülüyorsa, başka yerdeki병목(bottleneck) arayın.

---

## 6. Derleyici Seçenekleri

Modern derleyiciler otomatik optimizasyon yapabilir:

```bash
# GCC/Clang
gcc -O3 -funroll-loops -finline-functions file.c

# -O3: Agresif optimizasyon
# -funroll-loops: Otomatik döngü açma
# -finline-functions: Otomatik inline
```

**Uyarı:** `-O3` sometimes increases code size excessively. Gömülü sistemlerde `-O2` daha dengeli olabilir.

---

## 7. Sonuç

Düşük seviye optimizasyon teknikleri — **döngü açma, inline fonksiyonlar ve register kullanımı** — işlemci verimliliğini dramatik şekilde artırabilir. Ancak:

- **Profiling yapın:** Blind optimizasyon boş iştir
- **Derleyiciye güvenin:** Modern derleyiciler çoğu zaman el yazısından daha iyi yapar
- **Okunabilirliği unutmayın:** Optimize edilmiş kod zor bakılır
- **Platform spesifik:** ARM, x86, RISC-V'de stratejiler değişir

Gömülü sistemlerde, bu teknikler donanım sınırlamalarını aşmak için değerli araçlardır.

---

## Kaynakça

- Gorelick, M. ve Aharoni, D. (2020). High Performance in-Memory Computing. Springer.
- Drepper, U. (2007). What Every Programmer Should Know About Memory. RedHat.
- Agner Fog. (2023). Optimizing Software in C++. Copenhagen University College of Engineering.
- ARM Cortex-M3/M4 Processor Generic User Guide. ARM Holdings.
- Meyers, S. (2011). Effective C++: 55 Specific Ways to Improve Your Programs and Designs (3. ed.). Addison-Wesley.
- GCC Optimization Levels Documentation. https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
- LLVM Loop Unrolling Pass. https://llvm.org/docs/Passes/#loop-unroll
