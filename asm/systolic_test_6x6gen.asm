;*
;* My RISC-V RV32I CPU
;*   Test Code IF/ID Instructions : No.1
;*    RV32I code
;* @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
;* @copylight	2021 Yoshiki Kurokawa
;* @license		https://opensource.org/licenses/MIT     MIT license
;* @version		0.1
;*


#immdefine imm_dma_dc 0x005
#immdefine imm_mem_start0 0x000
#immdefine imm_mem_start1 0x018
#immdefine imm_mem_start2 0x030
#immdefine imm_mem_start3 0x048
#immdefine imm_mem_start4 0x060
#immdefine imm_mem_start5 0x078
#immdefine imm_mem_start6 0x090
#immdefine imm_mem_start7 0x0a8
#immdefine imm_mem_start8 0x0c0
#immdefine imm_mem_start9 0x0d8
#immdefine imm_mem_start10 0x0f0
#immdefine imm_mem_start11 0x108
#immdefine imm_max_cntr 0x005
#immdefine imm_run_cntr 0x001
#immdefine imm_answer_start 0x120
#immdefine imm_result_start 0x1b0
#immdefine imm_check_cntr 0x023
#immdefine imm_dma_dc_s 0x001
#immdefine imm_dma_dc_s_2 0x001
#immdefine imm_mem_start_s0 0x1b0
#immdefine imm_mem_start_s1 0x1b4
#immdefine imm_mem_start_s2 0x1b8
#immdefine imm_mem_start_s3 0x1bc
#immdefine imm_mem_start_s4 0x1c0
#immdefine imm_mem_start_s5 0x1c4
#immdefine imm_mem_start_s6 0x1c8
#immdefine imm_mem_start_s7 0x1cc
#immdefine imm_mem_start_s8 0x1d0
#immdefine imm_mem_start_s9 0x1d4
#immdefine imm_mem_start_s10 0x1d8
#immdefine imm_mem_start_s11 0x1dc
#immdefine imm_mem_start_s12 0x1e0
#immdefine imm_mem_start_s13 0x1e4
#immdefine imm_mem_start_s14 0x1e8
#immdefine imm_mem_start_s15 0x1ec
#immdefine imm_mem_start_s16 0x1f0
#immdefine imm_mem_start_s17 0x1f4
#immdefine imm_mem_start_s18 0x1f8
#immdefine imm_mem_start_s19 0x1fc
#immdefine imm_mem_start_s20 0x200
#immdefine imm_mem_start_s21 0x204
#immdefine imm_mem_start_s22 0x208
#immdefine imm_mem_start_s23 0x20c
#immdefine imm_mem_start_s24 0x210
#immdefine imm_mem_start_s25 0x214
#immdefine imm_mem_start_s26 0x218
#immdefine imm_mem_start_s27 0x21c
#immdefine imm_mem_start_s28 0x220
#immdefine imm_mem_start_s29 0x224
#immdefine imm_mem_start_s30 0x228
#immdefine imm_mem_start_s31 0x22c
#immdefine imm_mem_start_s32 0x230
#immdefine imm_mem_start_s33 0x234
#immdefine imm_mem_start_s34 0x238
#immdefine imm_mem_start_s35 0x23c
#immdefine imm_mem_start_s0s 0x240
#immdefine imm_mem_start_s1s 0x248
#immdefine imm_mem_start_s2s 0x250
#immdefine imm_mem_start_s3s 0x258
#immdefine imm_mem_start_s4s 0x260
#immdefine imm_mem_start_s5s 0x268
#immdefine imm_mem_start_s6s 0x270
#immdefine imm_mem_start_s7s 0x278
#immdefine imm_mem_start_s8s 0x280
#immdefine imm_mem_start_s9s 0x288
#immdefine imm_mem_start_s10s 0x290
#immdefine imm_mem_start_s11s 0x298
#immdefine imm_mem_start_s12s 0x2a0
#immdefine imm_mem_start_s13s 0x2a8
#immdefine imm_mem_start_s14s 0x2b0
#immdefine imm_mem_start_s15s 0x2b8
#immdefine imm_mem_start_s16s 0x2c0
#immdefine imm_mem_start_s17s 0x2c8
#immdefine imm_mem_start_s18s 0x2d0
#immdefine imm_mem_start_s19s 0x2d8
#immdefine imm_mem_start_s20s 0x2e0
#immdefine imm_mem_start_s21s 0x2e8
#immdefine imm_mem_start_s22s 0x2f0
#immdefine imm_mem_start_s23s 0x2f8
#immdefine imm_mem_start_s24s 0x300
#immdefine imm_mem_start_s25s 0x308
#immdefine imm_mem_start_s26s 0x310
#immdefine imm_mem_start_s27s 0x318
#immdefine imm_mem_start_s28s 0x320
#immdefine imm_mem_start_s29s 0x328
#immdefine imm_mem_start_s30s 0x330
#immdefine imm_mem_start_s31s 0x338
#immdefine imm_mem_start_s32s 0x340
#immdefine imm_mem_start_s33s 0x348
#immdefine imm_mem_start_s34s 0x350
#immdefine imm_mem_start_s35s 0x358
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
sh x1, 0x0(x2) ; set LED

addi x10, x0, 10
:matrix_multi_loop
addi x10, x10, 0xfff

;write data to abuf 0
; DMA IO start adr
and x4, x0, x0 ; io start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : a_0 register
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop1
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop1

;write data to abuf 1
; DMA IO start adr
lui x4, 0x00001 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start1 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop2
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop2

;write data to abuf 2
; DMA IO start adr
lui x4, 0x00002 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start2 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop3
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop3

;write data to abuf 3
; DMA IO start adr
lui x4, 0x00003 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start3 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop4
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop4

;write data to abuf 4
; DMA IO start adr
lui x4, 0x00004 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start4 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop5
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop5

;write data to abuf 5
; DMA IO start adr
lui x4, 0x00005 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start5 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop6
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop6

;write data to bbuf 0
; DMA IO start adr
lui x4, 0x00006 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start6 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop7
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop7

;write data to bbuf 7
; DMA IO start adr
lui x4, 0x00007 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start7 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop8
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop8

;write data to bbuf 8
; DMA IO start adr
lui x4, 0x00008 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start8 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop9
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop9

;write data to bbuf 9
; DMA IO start adr
lui x4, 0x00009 ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start9 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop10
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop10

;write data to bbuf 10
; DMA IO start adr
lui x4, 0x0000a ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start10 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop11
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop11

;write data to bbuf 11
; DMA IO start adr
lui x4, 0x0000b ; a_1 register
addi x4, x4, 0x000 ;
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_mem_start11 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
xor x4, x4, x4 ; clear : start 0
ori x4, x4, 0x2 ; write start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_write_loop12
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_write_loop12

nop ; just for marking
nop
nop
nop

; setup systolic aray registers
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe4 ;
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_max_cntr ; systolic max cntr
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_run_cntr ; systolic run cntr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; systolic start bit
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfe0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
nop
nop
nop
nop
bne x10, x0, matrix_multi_loop
nop
nop
nop
nop
:label_read_loop0
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop0

nop ; just for marking
nop
nop
nop

;read data from sbuf 0
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00008 ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s0 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop0
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop0

;read data from sbuf 1
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00009 ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s1 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop1
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop1

;read data from sbuf 2
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00009 ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s2 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop2
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop2

;read data from sbuf 3
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000a ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s3 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop3
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop3

;read data from sbuf 4
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000a ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s4 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop4
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop4

;read data from sbuf 5
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000b ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s5 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop5
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop5

;read data from sbuf 6
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000b ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s6 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop6
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop6

;read data from sbuf 7
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000c ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s7 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop7
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop7

;read data from sbuf 8
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000c ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s8 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop18
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop18

;read data from sbuf 9
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000d ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s9 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop9
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop9

;read data from sbuf 10
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000d ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s10 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop10
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop10

;read data from sbuf 11
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000e ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s11 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop11
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop11

;read data from sbuf 12
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000e ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s12 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop12
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop12

;read data from sbuf 13
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000f ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s13 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop13
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop13

;read data from sbuf 14
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0000f ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s14 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop14
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop14

;read data from sbuf 15
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00010 ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s15 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop15
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop15

;read data from sbuf 16
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00010 ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s16 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop16
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop16

;read data from sbuf 17
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00011 ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s17 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop17
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop17

;read data from sbuf 18
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00011 ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s18 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop18
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop18

;read data from sbuf 19
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00012 ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s19 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop19
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop19

;read data from sbuf 20
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00012 ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s20 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop20
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop20

;read data from sbuf 21
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00013 ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s21 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop21
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop21

;read data from sbuf 22
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00013 ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s22 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop22
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop22

;read data from sbuf 23
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00014 ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s23 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop23
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop23

;read data from sbuf 24
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00014 ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s24 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop24
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop24

;read data from sbuf 25
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00015 ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s25 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop25
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop25

;read data from sbuf 26
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00015 ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s26 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop26
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop26

;read data from sbuf 27
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00016 ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s27 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop27
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop27

;read data from sbuf 28
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00016 ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s28 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop28
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop28

;read data from sbuf 29
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00017 ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s29 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop29
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop29

;read data from sbuf 30
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00017 ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s30 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop30
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop30

;read data from sbuf 31
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00018 ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s31 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop31
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop31

;read data from sbuf 32
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00018 ; DMA base address
ori x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s32 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
ori x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
ori x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop32
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop32

;read data from sbuf 33
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00019 ; DMA base address +1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s33 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop33
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop33

;read data from sbuf 34
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x00019 ; DMA base address
addi x4, x4, 0x0 ; memory start 0
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s34 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop34
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop34

;read data from sbuf 35
; DMA IO start adr
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc4 ;
lui x4, 0x0001a ; DMA base address + 1
addi x4, x4, 0x800 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA mem start adr
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_mem_start_s35 ; memory start 0
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc8 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA data counter
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_dma_dc_s ; DMA data counter
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfcc ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; DMA read start
and x4, x0, x0 ; clear : start 0
addi x4, x4, 0x1 ; read start 100
lui x3, 0xc0010 ; DMA base address +1
addi x3, x3, 0xfc0 ;
sh x4, 0x0(x3) ; set IO start adr offset 0x4
; wait finish
:label_read_loop35
lh x5, 0x0(x3) ; set IO start adr offset 0x4
beq x5, x4, label_read_loop35

; checker if not passed, loop the part
; answer data address 0x200
; calculated data address 0x300
; loop 16
and x3, x0, x0 ; clear : start 0
addi x3, x3, imm_answer_start ;
and x4, x0, x0 ; clear : start 0
addi x4, x4, imm_result_start ;
and x5, x0, x0 ; clear : start 0
addi x5, x5, imm_check_cntr ;
:label_check_loop
lh x6, 0x0(x3) ; set IO start adr offset 0x4
lh x7, 0x0(x4) ; set IO start adr offset 0x4
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
sh x3, 0x0(x4)
jalr x0, x0, label_led
nop
nop
nop
nop
