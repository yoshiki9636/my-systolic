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
; clear LED to black
addi x1, x0, 7 ; LED value
lui x2, 0xc0010 ; LED address +1
addi x2, x2, 0xe00 ;
sh x1, 0x0(x2) ; set LED
; setup dma registers
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe4 ;
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x3 ; systolic max cntr
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x3 ; systolic run cntr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; systolic start bit
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop0
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop0

;read data from sbuf 0
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00008 ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x0 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x3 ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop1
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop1

;read data from sabuf 0
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00008 ; DMA base address
addi x4, x4, 0x400 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x10 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; read start 1
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop2
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop2

;read data from sbuf 1
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00009 ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x20 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x3 ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop3
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop3

;read data from sabuf 1
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00009 ; DMA base address +1
addi x4, x4, 0xc00 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x30 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; read start 1
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop4
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop4

;read data from sbuf 2
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00009 ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x40 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x3 ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop5
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop5

;read data from sabuf 2
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00009 ; DMA base address
ori x4, x4, 0x400 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x50 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; read start 1
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop6
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop6

;read data from sbuf 2
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000a ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x60 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x3 ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop7
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop7

;read data from sabuf 2
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000a ; DMA base address + 1
addi x4, x4, 0xc00 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x70 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x1 ; read start 1
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop8
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop8

nop
nop
nop
nop
;lui x2, 01000 ; loop max
ori x2, x0, 10 ; small loop for sim
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
sh x3, 0x0(x4)
jalr x0, x0, label_led
nop
nop
nop
nop
