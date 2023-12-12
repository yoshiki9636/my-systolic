/*
 * My RISC-V RV32I CPU
 *   Systolic Top Module for 16 PE version
 *    Verilog code
 * 		Yoshiki Kurokawa <yoshiki.k963.com>
 * 	2021 Yoshiki Kurokawa
 * 		https://opensource.org/licenses/MIT     MIT license
 * 		0.1
 */

module systolic16(
	input clk,
	input rst_n,

	// ram interface
	input ren,
	input [15:0] ibus_radr,
	output [15:0] ibus_rdata,
	input wen,
	input [15:0] ibus_wadr,
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
wire aff0_1; // output
wire bff0_1; // output
wire aff1_1; // output
wire bff1_1; // output
wire aff2_1; // output
wire bff2_1; // output
wire aff3_1; // output
wire bff3_1; // output
wire aff0_2; // output
wire bff0_2; // output
wire aff1_2; // output
wire bff1_2; // output
wire aff2_2; // output
wire bff2_2; // output
wire aff3_2; // output
wire bff3_2; // output
wire aff0_3; // output
wire bff0_3; // output
wire aff1_3; // output
wire bff1_3; // output
wire aff2_3; // output
wire bff2_3; // output
wire aff3_3; // output
wire bff3_3; // output
wire [15:0] a_in0; // output
wire [15:0] b_in0; // output
wire [15:0] a_in1; // output
wire [15:0] b_in1; // output
wire [15:0] a_in2; // output
wire [15:0] b_in2; // output
wire [15:0] a_in3; // output
wire [15:0] b_in3; // output

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


// io buffers and controller

iobuf iobuf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ren),
	.ibus_radr(ibus_radr),
	.ibus_rdata(ibus_rdata),
	.wen(wen),
	.ibus_wadr(ibus_wadr),
	.ibus_wdata(ibus_wdata),
	.aff0(aff0_0),
	.aff1(aff0_1),
	.aff2(aff0_2),
	.aff3(aff0_3),
	.bff0(bff0_0),
	.bff1(bff1_0),
	.bff2(bff2_0),
	.bff3(bff3_0),
	.a_in0(a_in0),
	.b_in0(b_in0),
	.a_in1(a_in1),
	.b_in1(b_in1),
	.a_in2(a_in2),
	.b_in2(b_in2),
	.a_in3(a_in3),
	.b_in3(b_in3),

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
	.sw3_3(se3_3)

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
	.ais(1'b0),
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
	.ais(1'b0),
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
	.ais(1'b0),
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

pe pe0_3 (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_in3),
	.b_in(b_out0_2),
	.start(start),
	.awe(awe3),
	.bwe(fout0_2),
	.ais(aff1_3),
	.bis(1'b0),
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
	.bis(1'b0),
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
	.bis(1'b0),
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
	.ais(1'b0),
	.bis(1'b0),
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
endmodule
