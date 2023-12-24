/*
 * My RISC-V RV32I CPU
 *   Systolic Top Module for 36 PE version
 *    Verilog code
 * 		Yoshiki Kurokawa <yoshiki.k963.com>
 * 	2021 Yoshiki Kurokawa
 * 		https://opensource.org/licenses/MIT     MIT license
 * 		0.1
 */

module systolic36(
	input clk,
	input rst_n,

	// io register interface
	input dma_io_we,
	input [15:2] dma_io_wadr,
	input [31:0] dma_io_wdata,
	input [15:2] dma_io_radr,
	input [31:0] dma_io_rdata_in,
	output [31:0] dma_io_rdata,
	// buffers ram interface
	input ibus_ren,
	input [19:2] ibus_radr,
	output [15:0] ibus_rdata,
	input ibus_wen,
	input [19:2] ibus_wadr,
	input [15:0] ibus_wdata

	);
wire aff0_0; // output
wire bff0_0; // output
wire aff1_0; // output
wire bff1_0; // output
wire aff2_0; // output
wire bff2_0; // output
wire aff3_0; // output
wire bff3_0; // output
wire aff4_0; // output
wire bff4_0; // output
wire aff5_0; // output
wire bff5_0; // output
wire aff0_1; // output
wire bff0_1; // output
wire aff1_1; // output
wire bff1_1; // output
wire aff2_1; // output
wire bff2_1; // output
wire aff3_1; // output
wire bff3_1; // output
wire aff4_1; // output
wire bff4_1; // output
wire aff5_1; // output
wire bff5_1; // output
wire aff0_2; // output
wire bff0_2; // output
wire aff1_2; // output
wire bff1_2; // output
wire aff2_2; // output
wire bff2_2; // output
wire aff3_2; // output
wire bff3_2; // output
wire aff4_2; // output
wire bff4_2; // output
wire aff5_2; // output
wire bff5_2; // output
wire aff0_3; // output
wire bff0_3; // output
wire aff1_3; // output
wire bff1_3; // output
wire aff2_3; // output
wire bff2_3; // output
wire aff3_3; // output
wire bff3_3; // output
wire aff4_3; // output
wire bff4_3; // output
wire aff5_3; // output
wire bff5_3; // output
wire aff0_4; // output
wire bff0_4; // output
wire aff1_4; // output
wire bff1_4; // output
wire aff2_4; // output
wire bff2_4; // output
wire aff3_4; // output
wire bff3_4; // output
wire aff4_4; // output
wire bff4_4; // output
wire aff5_4; // output
wire bff5_4; // output
wire aff0_5; // output
wire bff0_5; // output
wire aff1_5; // output
wire bff1_5; // output
wire aff2_5; // output
wire bff2_5; // output
wire aff3_5; // output
wire bff3_5; // output
wire aff4_5; // output
wire bff4_5; // output
wire aff5_5; // output
wire bff5_5; // output
wire [15:0] a_in0; // output
wire [15:0] b_in0; // output
wire [15:0] a_in1; // output
wire [15:0] b_in1; // output
wire [15:0] a_in2; // output
wire [15:0] b_in2; // output
wire [15:0] a_in3; // output
wire [15:0] b_in3; // output
wire [15:0] a_in4; // output
wire [15:0] b_in4; // output
wire [15:0] a_in5; // output
wire [15:0] b_in5; // output

wire [7:0] max_cntr; // output
wire start; // output
wire awe0; // output
wire bwe0; // output
wire awe1; // output
wire bwe1; // output
wire awe2; // output
wire bwe2; // output
wire awe3; // output
wire bwe3; // output
wire awe4; // output
wire bwe4; // output
wire awe5; // output
wire bwe5; // output
wire fout0_0; // output
wire start_next0_0; // output
wire [15:0] a_out0_0; // output
wire [15:0] b_out0_0; // output
wire [15:0] s_out0_0; // output
wire sat0_0; // output
wire se0_0; // output
wire fout1_0; // output
wire start_next1_0; // output
wire [15:0] a_out1_0; // output
wire [15:0] b_out1_0; // output
wire [15:0] s_out1_0; // output
wire sat1_0; // output
wire se1_0; // output
wire fout2_0; // output
wire start_next2_0; // output
wire [15:0] a_out2_0; // output
wire [15:0] b_out2_0; // output
wire [15:0] s_out2_0; // output
wire sat2_0; // output
wire se2_0; // output
wire fout3_0; // output
wire start_next3_0; // output
wire [15:0] a_out3_0; // output
wire [15:0] b_out3_0; // output
wire [15:0] s_out3_0; // output
wire sat3_0; // output
wire se3_0; // output
wire fout4_0; // output
wire start_next4_0; // output
wire [15:0] a_out4_0; // output
wire [15:0] b_out4_0; // output
wire [15:0] s_out4_0; // output
wire sat4_0; // output
wire se4_0; // output
wire fout5_0; // output
wire start_next5_0; // output
wire [15:0] a_out5_0; // output
wire [15:0] b_out5_0; // output
wire [15:0] s_out5_0; // output
wire sat5_0; // output
wire se5_0; // output
wire fout0_1; // output
wire start_next0_1; // output
wire [15:0] a_out0_1; // output
wire [15:0] b_out0_1; // output
wire [15:0] s_out0_1; // output
wire sat0_1; // output
wire se0_1; // output
wire fout1_1; // output
wire start_next1_1; // output
wire [15:0] a_out1_1; // output
wire [15:0] b_out1_1; // output
wire [15:0] s_out1_1; // output
wire sat1_1; // output
wire se1_1; // output
wire fout2_1; // output
wire start_next2_1; // output
wire [15:0] a_out2_1; // output
wire [15:0] b_out2_1; // output
wire [15:0] s_out2_1; // output
wire sat2_1; // output
wire se2_1; // output
wire fout3_1; // output
wire start_next3_1; // output
wire [15:0] a_out3_1; // output
wire [15:0] b_out3_1; // output
wire [15:0] s_out3_1; // output
wire sat3_1; // output
wire se3_1; // output
wire fout4_1; // output
wire start_next4_1; // output
wire [15:0] a_out4_1; // output
wire [15:0] b_out4_1; // output
wire [15:0] s_out4_1; // output
wire sat4_1; // output
wire se4_1; // output
wire fout5_1; // output
wire start_next5_1; // output
wire [15:0] a_out5_1; // output
wire [15:0] b_out5_1; // output
wire [15:0] s_out5_1; // output
wire sat5_1; // output
wire se5_1; // output
wire fout0_2; // output
wire start_next0_2; // output
wire [15:0] a_out0_2; // output
wire [15:0] b_out0_2; // output
wire [15:0] s_out0_2; // output
wire sat0_2; // output
wire se0_2; // output
wire fout1_2; // output
wire start_next1_2; // output
wire [15:0] a_out1_2; // output
wire [15:0] b_out1_2; // output
wire [15:0] s_out1_2; // output
wire sat1_2; // output
wire se1_2; // output
wire fout2_2; // output
wire start_next2_2; // output
wire [15:0] a_out2_2; // output
wire [15:0] b_out2_2; // output
wire [15:0] s_out2_2; // output
wire sat2_2; // output
wire se2_2; // output
wire fout3_2; // output
wire start_next3_2; // output
wire [15:0] a_out3_2; // output
wire [15:0] b_out3_2; // output
wire [15:0] s_out3_2; // output
wire sat3_2; // output
wire se3_2; // output
wire fout4_2; // output
wire start_next4_2; // output
wire [15:0] a_out4_2; // output
wire [15:0] b_out4_2; // output
wire [15:0] s_out4_2; // output
wire sat4_2; // output
wire se4_2; // output
wire fout5_2; // output
wire start_next5_2; // output
wire [15:0] a_out5_2; // output
wire [15:0] b_out5_2; // output
wire [15:0] s_out5_2; // output
wire sat5_2; // output
wire se5_2; // output
wire fout0_3; // output
wire start_next0_3; // output
wire [15:0] a_out0_3; // output
wire [15:0] b_out0_3; // output
wire [15:0] s_out0_3; // output
wire sat0_3; // output
wire se0_3; // output
wire fout1_3; // output
wire start_next1_3; // output
wire [15:0] a_out1_3; // output
wire [15:0] b_out1_3; // output
wire [15:0] s_out1_3; // output
wire sat1_3; // output
wire se1_3; // output
wire fout2_3; // output
wire start_next2_3; // output
wire [15:0] a_out2_3; // output
wire [15:0] b_out2_3; // output
wire [15:0] s_out2_3; // output
wire sat2_3; // output
wire se2_3; // output
wire fout3_3; // output
wire start_next3_3; // output
wire [15:0] a_out3_3; // output
wire [15:0] b_out3_3; // output
wire [15:0] s_out3_3; // output
wire sat3_3; // output
wire se3_3; // output
wire fout4_3; // output
wire start_next4_3; // output
wire [15:0] a_out4_3; // output
wire [15:0] b_out4_3; // output
wire [15:0] s_out4_3; // output
wire sat4_3; // output
wire se4_3; // output
wire fout5_3; // output
wire start_next5_3; // output
wire [15:0] a_out5_3; // output
wire [15:0] b_out5_3; // output
wire [15:0] s_out5_3; // output
wire sat5_3; // output
wire se5_3; // output
wire fout0_4; // output
wire start_next0_4; // output
wire [15:0] a_out0_4; // output
wire [15:0] b_out0_4; // output
wire [15:0] s_out0_4; // output
wire sat0_4; // output
wire se0_4; // output
wire fout1_4; // output
wire start_next1_4; // output
wire [15:0] a_out1_4; // output
wire [15:0] b_out1_4; // output
wire [15:0] s_out1_4; // output
wire sat1_4; // output
wire se1_4; // output
wire fout2_4; // output
wire start_next2_4; // output
wire [15:0] a_out2_4; // output
wire [15:0] b_out2_4; // output
wire [15:0] s_out2_4; // output
wire sat2_4; // output
wire se2_4; // output
wire fout3_4; // output
wire start_next3_4; // output
wire [15:0] a_out3_4; // output
wire [15:0] b_out3_4; // output
wire [15:0] s_out3_4; // output
wire sat3_4; // output
wire se3_4; // output
wire fout4_4; // output
wire start_next4_4; // output
wire [15:0] a_out4_4; // output
wire [15:0] b_out4_4; // output
wire [15:0] s_out4_4; // output
wire sat4_4; // output
wire se4_4; // output
wire fout5_4; // output
wire start_next5_4; // output
wire [15:0] a_out5_4; // output
wire [15:0] b_out5_4; // output
wire [15:0] s_out5_4; // output
wire sat5_4; // output
wire se5_4; // output
wire fout0_5; // output
wire start_next0_5; // output
wire [15:0] a_out0_5; // output
wire [15:0] b_out0_5; // output
wire [15:0] s_out0_5; // output
wire sat0_5; // output
wire se0_5; // output
wire fout1_5; // output
wire start_next1_5; // output
wire [15:0] a_out1_5; // output
wire [15:0] b_out1_5; // output
wire [15:0] s_out1_5; // output
wire sat1_5; // output
wire se1_5; // output
wire fout2_5; // output
wire start_next2_5; // output
wire [15:0] a_out2_5; // output
wire [15:0] b_out2_5; // output
wire [15:0] s_out2_5; // output
wire sat2_5; // output
wire se2_5; // output
wire fout3_5; // output
wire start_next3_5; // output
wire [15:0] a_out3_5; // output
wire [15:0] b_out3_5; // output
wire [15:0] s_out3_5; // output
wire sat3_5; // output
wire se3_5; // output
wire fout4_5; // output
wire start_next4_5; // output
wire [15:0] a_out4_5; // output
wire [15:0] b_out4_5; // output
wire [15:0] s_out4_5; // output
wire sat4_5; // output
wire se4_5; // output
wire fout5_5; // output
wire start_next5_5; // output
wire [15:0] a_out5_5; // output
wire [15:0] b_out5_5; // output
wire [15:0] s_out5_5; // output
wire sat5_5; // output
wire se5_5; // output


// io buffers and controller

iobuf iobuf (
	.clk(clk),
	.rst_n(rst_n),
	.dma_io_we(dma_io_we),
	.dma_io_wadr(dma_io_wadr),
	.dma_io_wdata(dma_io_wdata),
	.dma_io_radr(dma_io_radr),
	.dma_io_rdata_in(dma_io_rdata_in),
	.dma_io_rdata(dma_io_rdata),
	.ibus_ren(ibus_ren),
	.ibus_radr(ibus_radr),
	.ibus_rdata(ibus_rdata),
	.ibus_wen(ibus_wen),
	.ibus_wadr(ibus_wadr),
	.ibus_wdata(ibus_wdata),
	.aff0(aff0_0),
	.aff1(aff0_1),
	.aff2(aff0_2),
	.aff3(aff0_3),
	.aff4(aff0_4),
	.aff5(aff0_5),
	.bff0(bff0_0),
	.bff1(bff1_0),
	.bff2(bff2_0),
	.bff3(bff3_0),
	.bff4(bff4_0),
	.bff5(bff5_0),
	.a_in0(a_in0),
	.b_in0(b_in0),
	.a_in1(a_in1),
	.b_in1(b_in1),
	.a_in2(a_in2),
	.b_in2(b_in2),
	.a_in3(a_in3),
	.b_in3(b_in3),
	.a_in4(a_in4),
	.b_in4(b_in4),
	.a_in5(a_in5),
	.b_in5(b_in5),

	.max_cntr(max_cntr),
	.start(start),
	.awe0(awe0),
	.bwe0(bwe0),
	.awe1(awe1),
	.bwe1(bwe1),
	.awe2(awe2),
	.bwe2(bwe2),
	.awe3(awe3),
	.bwe3(bwe3),
	.awe4(awe4),
	.bwe4(bwe4),
	.awe5(awe5),
	.bwe5(bwe5),
	.s_out0_0(s_out0_0),
	.sat0_0(sat0_0),
	.sw0_0(se0_0),
	.s_out1_0(s_out1_0),
	.sat1_0(sat1_0),
	.sw1_0(se1_0),
	.s_out2_0(s_out2_0),
	.sat2_0(sat2_0),
	.sw2_0(se2_0),
	.s_out3_0(s_out3_0),
	.sat3_0(sat3_0),
	.sw3_0(se3_0),
	.s_out4_0(s_out4_0),
	.sat4_0(sat4_0),
	.sw4_0(se4_0),
	.s_out5_0(s_out5_0),
	.sat5_0(sat5_0),
	.sw5_0(se5_0),
	.s_out0_1(s_out0_1),
	.sat0_1(sat0_1),
	.sw0_1(se0_1),
	.s_out1_1(s_out1_1),
	.sat1_1(sat1_1),
	.sw1_1(se1_1),
	.s_out2_1(s_out2_1),
	.sat2_1(sat2_1),
	.sw2_1(se2_1),
	.s_out3_1(s_out3_1),
	.sat3_1(sat3_1),
	.sw3_1(se3_1),
	.s_out4_1(s_out4_1),
	.sat4_1(sat4_1),
	.sw4_1(se4_1),
	.s_out5_1(s_out5_1),
	.sat5_1(sat5_1),
	.sw5_1(se5_1),
	.s_out0_2(s_out0_2),
	.sat0_2(sat0_2),
	.sw0_2(se0_2),
	.s_out1_2(s_out1_2),
	.sat1_2(sat1_2),
	.sw1_2(se1_2),
	.s_out2_2(s_out2_2),
	.sat2_2(sat2_2),
	.sw2_2(se2_2),
	.s_out3_2(s_out3_2),
	.sat3_2(sat3_2),
	.sw3_2(se3_2),
	.s_out4_2(s_out4_2),
	.sat4_2(sat4_2),
	.sw4_2(se4_2),
	.s_out5_2(s_out5_2),
	.sat5_2(sat5_2),
	.sw5_2(se5_2),
	.s_out0_3(s_out0_3),
	.sat0_3(sat0_3),
	.sw0_3(se0_3),
	.s_out1_3(s_out1_3),
	.sat1_3(sat1_3),
	.sw1_3(se1_3),
	.s_out2_3(s_out2_3),
	.sat2_3(sat2_3),
	.sw2_3(se2_3),
	.s_out3_3(s_out3_3),
	.sat3_3(sat3_3),
	.sw3_3(se3_3),
	.s_out4_3(s_out4_3),
	.sat4_3(sat4_3),
	.sw4_3(se4_3),
	.s_out5_3(s_out5_3),
	.sat5_3(sat5_3),
	.sw5_3(se5_3),
	.s_out0_4(s_out0_4),
	.sat0_4(sat0_4),
	.sw0_4(se0_4),
	.s_out1_4(s_out1_4),
	.sat1_4(sat1_4),
	.sw1_4(se1_4),
	.s_out2_4(s_out2_4),
	.sat2_4(sat2_4),
	.sw2_4(se2_4),
	.s_out3_4(s_out3_4),
	.sat3_4(sat3_4),
	.sw3_4(se3_4),
	.s_out4_4(s_out4_4),
	.sat4_4(sat4_4),
	.sw4_4(se4_4),
	.s_out5_4(s_out5_4),
	.sat5_4(sat5_4),
	.sw5_4(se5_4),
	.s_out0_5(s_out0_5),
	.sat0_5(sat0_5),
	.sw0_5(se0_5),
	.s_out1_5(s_out1_5),
	.sat1_5(sat1_5),
	.sw1_5(se1_5),
	.s_out2_5(s_out2_5),
	.sat2_5(sat2_5),
	.sw2_5(se2_5),
	.s_out3_5(s_out3_5),
	.sat3_5(sat3_5),
	.sw3_5(se3_5),
	.s_out4_5(s_out4_5),
	.sat4_5(sat4_5),
	.sw4_5(se4_5),
	.s_out5_5(s_out5_5),
	.sat5_5(sat5_5),
	.sw5_5(se5_5)

	);

// processor elements

pe pe0_0 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_in0),
	.b_in(b_in0),
	.start(start),
	.awe(awe0),
	.bwe(bwe0),
	.ais(aff1_0),
	.bis(bff0_1),
	.aff(aff0_0),
	.bff(bff0_0),
	.se(se0_0),
	.fout(fout0_0),
	.sat(sat0_0),
	.s_out(s_out0_0),
	.a_out(a_out0_0),
	.b_out(b_out0_0),
	.start_next(start_next0_0),
	.max_cntr(max_cntr)
	);

pe pe1_0 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out0_0),
	.b_in(b_in1),
	.start(start),
	.awe(fout0_0),
	.bwe(bwe1),
	.ais(aff2_0),
	.bis(bff1_1),
	.aff(aff1_0),
	.bff(bff1_0),
	.se(se1_0),
	.fout(fout1_0),
	.sat(sat1_0),
	.s_out(s_out1_0),
	.a_out(a_out1_0),
	.b_out(b_out1_0),
	.start_next(start_next1_0),
	.max_cntr(max_cntr)
	);

pe pe2_0 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out1_0),
	.b_in(b_in2),
	.start(start),
	.awe(fout1_0),
	.bwe(bwe2),
	.ais(aff3_0),
	.bis(bff2_1),
	.aff(aff2_0),
	.bff(bff2_0),
	.se(se2_0),
	.fout(fout2_0),
	.sat(sat2_0),
	.s_out(s_out2_0),
	.a_out(a_out2_0),
	.b_out(b_out2_0),
	.start_next(start_next2_0),
	.max_cntr(max_cntr)
	);

pe pe3_0 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out2_0),
	.b_in(b_in3),
	.start(start),
	.awe(fout2_0),
	.bwe(bwe3),
	.ais(aff4_0),
	.bis(bff3_1),
	.aff(aff3_0),
	.bff(bff3_0),
	.se(se3_0),
	.fout(fout3_0),
	.sat(sat3_0),
	.s_out(s_out3_0),
	.a_out(a_out3_0),
	.b_out(b_out3_0),
	.start_next(start_next3_0),
	.max_cntr(max_cntr)
	);

pe pe4_0 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out3_0),
	.b_in(b_in4),
	.start(start),
	.awe(fout3_0),
	.bwe(bwe4),
	.ais(aff5_0),
	.bis(bff4_1),
	.aff(aff4_0),
	.bff(bff4_0),
	.se(se4_0),
	.fout(fout4_0),
	.sat(sat4_0),
	.s_out(s_out4_0),
	.a_out(a_out4_0),
	.b_out(b_out4_0),
	.start_next(start_next4_0),
	.max_cntr(max_cntr)
	);

pe pe5_0 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out4_0),
	.b_in(b_in5),
	.start(start),
	.awe(fout4_0),
	.bwe(bwe5),
	.ais(1'b0),
	.bis(bff5_1),
	.aff(aff5_0),
	.bff(bff5_0),
	.se(se5_0),
	.fout(fout5_0),
	.sat(sat5_0),
	.s_out(s_out5_0),
	.a_out(a_out5_0),
	.b_out(b_out5_0),
	.start_next(start_next5_0),
	.max_cntr(max_cntr)
	);

pe pe0_1 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_in1),
	.b_in(b_out0_0),
	.start(start),
	.awe(awe1),
	.bwe(fout0_0),
	.ais(aff1_1),
	.bis(bff0_2),
	.aff(aff0_1),
	.bff(bff0_1),
	.se(se0_1),
	.fout(fout0_1),
	.sat(sat0_1),
	.s_out(s_out0_1),
	.a_out(a_out0_1),
	.b_out(b_out0_1),
	.start_next(start_next0_1),
	.max_cntr(max_cntr)
	);

pe pe1_1 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out0_1),
	.b_in(b_out1_0),
	.start(start),
	.awe(fout0_1),
	.bwe(fout1_0),
	.ais(aff2_1),
	.bis(bff1_2),
	.aff(aff1_1),
	.bff(bff1_1),
	.se(se1_1),
	.fout(fout1_1),
	.sat(sat1_1),
	.s_out(s_out1_1),
	.a_out(a_out1_1),
	.b_out(b_out1_1),
	.start_next(start_next1_1),
	.max_cntr(max_cntr)
	);

pe pe2_1 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out1_1),
	.b_in(b_out2_0),
	.start(start),
	.awe(fout1_1),
	.bwe(fout2_0),
	.ais(aff3_1),
	.bis(bff2_2),
	.aff(aff2_1),
	.bff(bff2_1),
	.se(se2_1),
	.fout(fout2_1),
	.sat(sat2_1),
	.s_out(s_out2_1),
	.a_out(a_out2_1),
	.b_out(b_out2_1),
	.start_next(start_next2_1),
	.max_cntr(max_cntr)
	);

pe pe3_1 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out2_1),
	.b_in(b_out3_0),
	.start(start),
	.awe(fout2_1),
	.bwe(fout3_0),
	.ais(aff4_1),
	.bis(bff3_2),
	.aff(aff3_1),
	.bff(bff3_1),
	.se(se3_1),
	.fout(fout3_1),
	.sat(sat3_1),
	.s_out(s_out3_1),
	.a_out(a_out3_1),
	.b_out(b_out3_1),
	.start_next(start_next3_1),
	.max_cntr(max_cntr)
	);

pe pe4_1 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out3_1),
	.b_in(b_out4_0),
	.start(start),
	.awe(fout3_1),
	.bwe(fout4_0),
	.ais(aff5_1),
	.bis(bff4_2),
	.aff(aff4_1),
	.bff(bff4_1),
	.se(se4_1),
	.fout(fout4_1),
	.sat(sat4_1),
	.s_out(s_out4_1),
	.a_out(a_out4_1),
	.b_out(b_out4_1),
	.start_next(start_next4_1),
	.max_cntr(max_cntr)
	);

pe pe5_1 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out4_1),
	.b_in(b_out5_0),
	.start(start),
	.awe(fout4_1),
	.bwe(fout5_0),
	.ais(1'b0),
	.bis(bff5_2),
	.aff(aff5_1),
	.bff(bff5_1),
	.se(se5_1),
	.fout(fout5_1),
	.sat(sat5_1),
	.s_out(s_out5_1),
	.a_out(a_out5_1),
	.b_out(b_out5_1),
	.start_next(start_next5_1),
	.max_cntr(max_cntr)
	);

pe pe0_2 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_in2),
	.b_in(b_out0_1),
	.start(start),
	.awe(awe2),
	.bwe(fout0_1),
	.ais(aff1_2),
	.bis(bff0_3),
	.aff(aff0_2),
	.bff(bff0_2),
	.se(se0_2),
	.fout(fout0_2),
	.sat(sat0_2),
	.s_out(s_out0_2),
	.a_out(a_out0_2),
	.b_out(b_out0_2),
	.start_next(start_next0_2),
	.max_cntr(max_cntr)
	);

pe pe1_2 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out0_2),
	.b_in(b_out1_1),
	.start(start),
	.awe(fout0_2),
	.bwe(fout1_1),
	.ais(aff2_2),
	.bis(bff1_3),
	.aff(aff1_2),
	.bff(bff1_2),
	.se(se1_2),
	.fout(fout1_2),
	.sat(sat1_2),
	.s_out(s_out1_2),
	.a_out(a_out1_2),
	.b_out(b_out1_2),
	.start_next(start_next1_2),
	.max_cntr(max_cntr)
	);

pe pe2_2 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out1_2),
	.b_in(b_out2_1),
	.start(start),
	.awe(fout1_2),
	.bwe(fout2_1),
	.ais(aff3_2),
	.bis(bff2_3),
	.aff(aff2_2),
	.bff(bff2_2),
	.se(se2_2),
	.fout(fout2_2),
	.sat(sat2_2),
	.s_out(s_out2_2),
	.a_out(a_out2_2),
	.b_out(b_out2_2),
	.start_next(start_next2_2),
	.max_cntr(max_cntr)
	);

pe pe3_2 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out2_2),
	.b_in(b_out3_1),
	.start(start),
	.awe(fout2_2),
	.bwe(fout3_1),
	.ais(aff4_2),
	.bis(bff3_3),
	.aff(aff3_2),
	.bff(bff3_2),
	.se(se3_2),
	.fout(fout3_2),
	.sat(sat3_2),
	.s_out(s_out3_2),
	.a_out(a_out3_2),
	.b_out(b_out3_2),
	.start_next(start_next3_2),
	.max_cntr(max_cntr)
	);

pe pe4_2 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out3_2),
	.b_in(b_out4_1),
	.start(start),
	.awe(fout3_2),
	.bwe(fout4_1),
	.ais(aff5_2),
	.bis(bff4_3),
	.aff(aff4_2),
	.bff(bff4_2),
	.se(se4_2),
	.fout(fout4_2),
	.sat(sat4_2),
	.s_out(s_out4_2),
	.a_out(a_out4_2),
	.b_out(b_out4_2),
	.start_next(start_next4_2),
	.max_cntr(max_cntr)
	);

pe pe5_2 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out4_2),
	.b_in(b_out5_1),
	.start(start),
	.awe(fout4_2),
	.bwe(fout5_1),
	.ais(1'b0),
	.bis(bff5_3),
	.aff(aff5_2),
	.bff(bff5_2),
	.se(se5_2),
	.fout(fout5_2),
	.sat(sat5_2),
	.s_out(s_out5_2),
	.a_out(a_out5_2),
	.b_out(b_out5_2),
	.start_next(start_next5_2),
	.max_cntr(max_cntr)
	);

pe pe0_3 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_in3),
	.b_in(b_out0_2),
	.start(start),
	.awe(awe3),
	.bwe(fout0_2),
	.ais(aff1_3),
	.bis(bff0_4),
	.aff(aff0_3),
	.bff(bff0_3),
	.se(se0_3),
	.fout(fout0_3),
	.sat(sat0_3),
	.s_out(s_out0_3),
	.a_out(a_out0_3),
	.b_out(b_out0_3),
	.start_next(start_next0_3),
	.max_cntr(max_cntr)
	);

pe pe1_3 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out0_3),
	.b_in(b_out1_2),
	.start(start),
	.awe(fout0_3),
	.bwe(fout1_2),
	.ais(aff2_3),
	.bis(bff1_4),
	.aff(aff1_3),
	.bff(bff1_3),
	.se(se1_3),
	.fout(fout1_3),
	.sat(sat1_3),
	.s_out(s_out1_3),
	.a_out(a_out1_3),
	.b_out(b_out1_3),
	.start_next(start_next1_3),
	.max_cntr(max_cntr)
	);

pe pe2_3 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out1_3),
	.b_in(b_out2_2),
	.start(start),
	.awe(fout1_3),
	.bwe(fout2_2),
	.ais(aff3_3),
	.bis(bff2_4),
	.aff(aff2_3),
	.bff(bff2_3),
	.se(se2_3),
	.fout(fout2_3),
	.sat(sat2_3),
	.s_out(s_out2_3),
	.a_out(a_out2_3),
	.b_out(b_out2_3),
	.start_next(start_next2_3),
	.max_cntr(max_cntr)
	);

pe pe3_3 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out2_3),
	.b_in(b_out3_2),
	.start(start),
	.awe(fout2_3),
	.bwe(fout3_2),
	.ais(aff4_3),
	.bis(bff3_4),
	.aff(aff3_3),
	.bff(bff3_3),
	.se(se3_3),
	.fout(fout3_3),
	.sat(sat3_3),
	.s_out(s_out3_3),
	.a_out(a_out3_3),
	.b_out(b_out3_3),
	.start_next(start_next3_3),
	.max_cntr(max_cntr)
	);

pe pe4_3 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out3_3),
	.b_in(b_out4_2),
	.start(start),
	.awe(fout3_3),
	.bwe(fout4_2),
	.ais(aff5_3),
	.bis(bff4_4),
	.aff(aff4_3),
	.bff(bff4_3),
	.se(se4_3),
	.fout(fout4_3),
	.sat(sat4_3),
	.s_out(s_out4_3),
	.a_out(a_out4_3),
	.b_out(b_out4_3),
	.start_next(start_next4_3),
	.max_cntr(max_cntr)
	);

pe pe5_3 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out4_3),
	.b_in(b_out5_2),
	.start(start),
	.awe(fout4_3),
	.bwe(fout5_2),
	.ais(1'b0),
	.bis(bff5_4),
	.aff(aff5_3),
	.bff(bff5_3),
	.se(se5_3),
	.fout(fout5_3),
	.sat(sat5_3),
	.s_out(s_out5_3),
	.a_out(a_out5_3),
	.b_out(b_out5_3),
	.start_next(start_next5_3),
	.max_cntr(max_cntr)
	);

pe pe0_4 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_in4),
	.b_in(b_out0_3),
	.start(start),
	.awe(awe4),
	.bwe(fout0_3),
	.ais(aff1_4),
	.bis(bff0_5),
	.aff(aff0_4),
	.bff(bff0_4),
	.se(se0_4),
	.fout(fout0_4),
	.sat(sat0_4),
	.s_out(s_out0_4),
	.a_out(a_out0_4),
	.b_out(b_out0_4),
	.start_next(start_next0_4),
	.max_cntr(max_cntr)
	);

pe pe1_4 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out0_4),
	.b_in(b_out1_3),
	.start(start),
	.awe(fout0_4),
	.bwe(fout1_3),
	.ais(aff2_4),
	.bis(bff1_5),
	.aff(aff1_4),
	.bff(bff1_4),
	.se(se1_4),
	.fout(fout1_4),
	.sat(sat1_4),
	.s_out(s_out1_4),
	.a_out(a_out1_4),
	.b_out(b_out1_4),
	.start_next(start_next1_4),
	.max_cntr(max_cntr)
	);

pe pe2_4 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out1_4),
	.b_in(b_out2_3),
	.start(start),
	.awe(fout1_4),
	.bwe(fout2_3),
	.ais(aff3_4),
	.bis(bff2_5),
	.aff(aff2_4),
	.bff(bff2_4),
	.se(se2_4),
	.fout(fout2_4),
	.sat(sat2_4),
	.s_out(s_out2_4),
	.a_out(a_out2_4),
	.b_out(b_out2_4),
	.start_next(start_next2_4),
	.max_cntr(max_cntr)
	);

pe pe3_4 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out2_4),
	.b_in(b_out3_3),
	.start(start),
	.awe(fout2_4),
	.bwe(fout3_3),
	.ais(aff4_4),
	.bis(bff3_5),
	.aff(aff3_4),
	.bff(bff3_4),
	.se(se3_4),
	.fout(fout3_4),
	.sat(sat3_4),
	.s_out(s_out3_4),
	.a_out(a_out3_4),
	.b_out(b_out3_4),
	.start_next(start_next3_4),
	.max_cntr(max_cntr)
	);

pe pe4_4 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out3_4),
	.b_in(b_out4_3),
	.start(start),
	.awe(fout3_4),
	.bwe(fout4_3),
	.ais(aff5_4),
	.bis(bff4_5),
	.aff(aff4_4),
	.bff(bff4_4),
	.se(se4_4),
	.fout(fout4_4),
	.sat(sat4_4),
	.s_out(s_out4_4),
	.a_out(a_out4_4),
	.b_out(b_out4_4),
	.start_next(start_next4_4),
	.max_cntr(max_cntr)
	);

pe pe5_4 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out4_4),
	.b_in(b_out5_3),
	.start(start),
	.awe(fout4_4),
	.bwe(fout5_3),
	.ais(1'b0),
	.bis(bff5_5),
	.aff(aff5_4),
	.bff(bff5_4),
	.se(se5_4),
	.fout(fout5_4),
	.sat(sat5_4),
	.s_out(s_out5_4),
	.a_out(a_out5_4),
	.b_out(b_out5_4),
	.start_next(start_next5_4),
	.max_cntr(max_cntr)
	);

pe pe0_5 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_in5),
	.b_in(b_out0_4),
	.start(start),
	.awe(awe5),
	.bwe(fout0_4),
	.ais(aff1_5),
	.bis(1'b0),
	.aff(aff0_5),
	.bff(bff0_5),
	.se(se0_5),
	.fout(fout0_5),
	.sat(sat0_5),
	.s_out(s_out0_5),
	.a_out(a_out0_5),
	.b_out(b_out0_5),
	.start_next(start_next0_5),
	.max_cntr(max_cntr)
	);

pe pe1_5 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out0_5),
	.b_in(b_out1_4),
	.start(start),
	.awe(fout0_5),
	.bwe(fout1_4),
	.ais(aff2_5),
	.bis(1'b0),
	.aff(aff1_5),
	.bff(bff1_5),
	.se(se1_5),
	.fout(fout1_5),
	.sat(sat1_5),
	.s_out(s_out1_5),
	.a_out(a_out1_5),
	.b_out(b_out1_5),
	.start_next(start_next1_5),
	.max_cntr(max_cntr)
	);

pe pe2_5 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out1_5),
	.b_in(b_out2_4),
	.start(start),
	.awe(fout1_5),
	.bwe(fout2_4),
	.ais(aff3_5),
	.bis(1'b0),
	.aff(aff2_5),
	.bff(bff2_5),
	.se(se2_5),
	.fout(fout2_5),
	.sat(sat2_5),
	.s_out(s_out2_5),
	.a_out(a_out2_5),
	.b_out(b_out2_5),
	.start_next(start_next2_5),
	.max_cntr(max_cntr)
	);

pe pe3_5 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out2_5),
	.b_in(b_out3_4),
	.start(start),
	.awe(fout2_5),
	.bwe(fout3_4),
	.ais(aff4_5),
	.bis(1'b0),
	.aff(aff3_5),
	.bff(bff3_5),
	.se(se3_5),
	.fout(fout3_5),
	.sat(sat3_5),
	.s_out(s_out3_5),
	.a_out(a_out3_5),
	.b_out(b_out3_5),
	.start_next(start_next3_5),
	.max_cntr(max_cntr)
	);

pe pe4_5 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out3_5),
	.b_in(b_out4_4),
	.start(start),
	.awe(fout3_5),
	.bwe(fout4_4),
	.ais(aff5_5),
	.bis(1'b0),
	.aff(aff4_5),
	.bff(bff4_5),
	.se(se4_5),
	.fout(fout4_5),
	.sat(sat4_5),
	.s_out(s_out4_5),
	.a_out(a_out4_5),
	.b_out(b_out4_5),
	.start_next(start_next4_5),
	.max_cntr(max_cntr)
	);

pe pe5_5 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_out4_5),
	.b_in(b_out5_4),
	.start(start),
	.awe(fout4_5),
	.bwe(fout5_4),
	.ais(1'b0),
	.bis(1'b0),
	.aff(aff5_5),
	.bff(bff5_5),
	.se(se5_5),
	.fout(fout5_5),
	.sat(sat5_5),
	.s_out(s_out5_5),
	.a_out(a_out5_5),
	.b_out(b_out5_5),
	.start_next(start_next5_5),
	.max_cntr(max_cntr)
	);
endmodule
