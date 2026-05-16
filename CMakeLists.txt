cmake_minimum_required(VERSION 3.10)

project(EnergyEfficientOS VERSION 1.0.0 LANGUAGES C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Çekirdek ve Gömülü Sistem Derleyici Bayrakları (Compiler Flags)
# -ffreestanding: Standart kütüphanelerin (printf, malloc vb.) işletim sistemi tarafından sağlanmayacağını belirtir.
# -nostdlib: Standart başlangıç dosyalarını ve kütüphaneleri bağlamaz.
# -O2: Enerji ve performans verimliliği için optimizasyon açar.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -O2 -ffreestanding -nostdlib")

# header
# buraya API arayüzleri gelecek
include_directories(include)

# Kaynak (source) kodlarını topla
# çekirdek ve sürücü
file(GLOB SOURCES "src/*.c" "drivers/*.c")

# imaj alınacak
add_executable(os_kernel.elf ${SOURCES})
