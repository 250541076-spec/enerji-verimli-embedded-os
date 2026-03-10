ENTRY(Reset_Handler)

MEMORY
{
  FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 256K
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 64K
}

SECTIONS
{
  .text : {
    *(.isr_vector)
    *(.text)
  } > FLASH

  .data : {
    *(.data)
  } > RAM AT > FLASH

  .bss : {
    *(.bss)
  } > RAM
}