;*
;* My RISC-V RV32I CPU
;*   Test Code IF/ID Instructions : No.1
;*    RV32I code
;* @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
;* @copylight	2021 Yoshiki Kurokawa
;* @license		https://opensource.org/licenses/MIT     MIT license
;* @version		0.1
;*


nop
nop
nop
nop
nop
nop
; clear LED to black
addi x1, x0, 7 ; LED value
lui x2, 0xc0010 ; LED address +1
addi x2, x2, 0xe00 ;
sw x1, 0x0(x2) ; set LED

addi x10, x0, 1
:matrix_multi_loop
addi x10, x10, 0xfff

; parameter read pointer
and x11, x0, x0 ; 
; dma write itteration
lw x12, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
; dma read itteration
lw x13, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer

:label_dma_write
;write data to abbuf 
; DMA IO start adr
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sw x4, 0x0(x3) ; set IO start adr
; DMA mem start adr
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sw x4, 0x0(x3) ; set IO start adr
; DMA data counter
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sw x4, 0x0(x3) ; set IO start adr
; DMA write start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x2 ; write write bit
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sw x4, 0x0(x3) ; set IO start adr

; wait finish
:label_write_loop1
lw x5, 0x0(x3) ; set IO start adr
beq x5, x4, label_write_loop1

addi x12, x12, 0xfff; -1
nop ; just for marking
nop
nop
nop
bne x12, x0, label_dma_write

; clear LED to black
addi x1, x0, 1 ; LED value
lui x2, 0xc0010 ; LED address +1
addi x2, x2, 0xe00 ;
sw x1, 0x0(x2) ; set LED

nop ; just for marking
nop
nop
nop

; setup systolic aray registers
; DMA max cntr
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe4 ;
sw x4, 0x0(x3) ; set IO start adr
; DMA run cntr
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe8 ;
sw x4, 0x0(x3) ; set IO start adr
; start systolic array
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; systolic start bit
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe0 ;
sw x4, 0x0(x3) ; set IO start adr
nop ; just for marking
nop
nop
nop
nop ; just for marking
nop
nop
nop
; wait finish
:label_read_loop0
lw x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop0

nop ; just for marking
nop
nop
nop

; clear LED to black
addi x1, x0, 2 ; LED value
lui x2, 0xc0010 ; LED address +1
addi x2, x2, 0xe00 ;
sw x1, 0x0(x2) ; set LED


bne x10, x0, matrix_multi_loop
nop ; just for marking
nop
nop
nop

; dma read itteration for s buffers
add x12, x0, x13 ; 

:label_dma_read1
;read data from sbuf 0
; DMA IO start adr
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sw x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sw x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sw x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; write read bit
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sw x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop1
lw x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop1

addi x12, x12, 0xfff; -1
nop ; just for marking
nop
nop
nop
bne x12, x0, label_dma_read1
nop ; just for marking
nop
nop
nop
; clear LED to black
addi x1, x0, 4 ; LED value
lui x2, 0xc0010 ; LED address +1
addi x2, x2, 0xe00 ;
sw x1, 0x0(x2) ; set LED

; dma read itteration for s buffers
add x12, x0, x13 ; 

:label_dma_read2
;read data from sabuf 0
; DMA IO start adr
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sw x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sw x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sw x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; write read bit
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sw x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop2
lw x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop2

addi x12, x12, 0xfff; -1
nop ; just for marking
nop
nop
nop
bne x12, x0, label_dma_read2
nop ; just for marking
nop
nop
nop
; clear LED to black
addi x1, x0, 5 ; LED value
lui x2, 0xc0010 ; LED address +1
addi x2, x2, 0xe00 ;
sw x1, 0x0(x2) ; set LED


; checker if not passed, loop the part
; answer data address 
; calculated data address 
; loop 16
lw x3, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lw x4, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
lw x5, 0x0(x11) ; load data from pointer
addi x11, x11, 4 ; +4 pointer
:label_check_loop
lw x6, 0x0(x3) ; set IO start adr offset 0x4
lw x7, 0x0(x4) ; set IO start adr offset 0x4
bne x6, x7, label_failed_loop
addi x3, x3, 0x4 ;
addi x4, x4, 0x4 ;
addi x5, x5, 0xfff ; -1
bne x5, x0, label_check_loop
nop
nop
nop
nop
jalr x0, x0, label_start_led
nop
nop
nop
nop
:label_failed_loop
nop
nop
nop
nop
jalr x0, x0, label_failed_loop
nop
nop
nop
nop
:label_start_led
lui x2, 01000 ; loop max
;ori x2, x0, 10 ; small loop for sim
and x3, x0, x3 ; LED value
and x4, x0, x4 ;
lui x4, 0xc0010 ; LED address + 1
addi x4, x4, 0xe00 ;
:label_led
and x1, x0, x1 ; loop counter
:label_waitloop
addi x1, x1, 1
blt x1, x2, label_waitloop
addi x3, x3, 1
sw x3, 0x0(x4)
jalr x0, x0, label_led
nop
nop
nop
nop
