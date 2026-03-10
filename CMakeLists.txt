cmake_minimum_required(VERSION 3.10)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_OSX_ARCHITECTURES "")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

project(MinimalKernel C ASM) 

set(CMAKE_C_FLAGS "-mcpu=cortex-m3 -mthumb -O0 -g -nostdlib -T ${CMAKE_CURRENT_SOURCE_DIR}/linker.ld")

add_executable(kernel.elf startup.s main.c)