.syntax unified
.cpu cortex-m3
.thumb

.global Reset_Handler

.section .isr_vector, "a", %progbits
.word 0x20010000  /* Stack Pointer başlangıç adresi (RAM'in sonu) */
.word Reset_Handler /* Reset olunca gidilecek ilk fonksiyon */

.section .text
.thumb_func
Reset_Handler:
    bl main
    
    b .