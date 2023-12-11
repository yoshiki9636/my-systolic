/*
 * My RISC-V RV32I CPU
 *   Systolic Top Module for 4 PE version
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2021 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

module systolic4(
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
wire aff1_0; // output
wire aff0_1; // output
wire aff1_1; // output
wire bff0_0; // output
wire bff1_0; // output
wire bff0_1; // output
wire bff1_1; // output
wire [15:0] a_in0; // output
wire [15:0] b_in0; // output
wire [15:0] a_in1; // output
wire [15:0] b_in1; // output
wire [7:0] max_cntr; // output
wire start; // output
wire awe0; // output
wire bwe0; // output
wire awe1; // output
wire bwe1; // output
wire fout0_0; // output
wire fout1_0; // output
wire fout0_1; // output
wire fout1_1; // output
wire start_next0_0; // output
wire start_next1_0; // output
wire start_next0_1; // output
wire start_next1_1; // output
wire [15:0] a_out0_0; // output
wire [15:0] a_out1_0; // output
wire [15:0] a_out0_1; // output
wire [15:0] a_out1_1; // output
wire [15:0] b_out0_0; // output
wire [15:0] b_out1_0; // output
wire [15:0] b_out0_1; // output
wire [15:0] b_out1_1; // output
wire [15:0] s_out0_0; // output
wire [15:0] s_out1_0; // output
wire [15:0] s_out0_1; // output
wire [15:0] s_out1_1; // output
wire sat0_0; // output
wire sat1_0; // output
wire sat0_1; // output
wire sat1_1; // output
wire se0_0; // output
wire se1_0; // output
wire se0_1; // output
wire se1_1; // output

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
	.bff0(bff0_0),
	.bff1(bff1_0),
	.a_in0(a_in0),
	.b_in0(b_in0),
	.a_in1(a_in1),
	.b_in1(b_in1),
	.max_cntr(max_cntr),
	.start(start),
	.awe0(awe0),
	.bwe0(bwe0),
	.awe1(awe1),
	.bwe1(bwe1),
	.s_out0_0(s_out0_0),
	.s_out1_0(s_out1_0),
	.s_out0_1(s_out0_1),
	.s_out1_1(s_out1_1),
	.sat0_0(sat0_0),
	.sat1_0(sat1_0),
	.sat0_1(sat0_1),
	.sat1_1(sat1_1),
	.sw0_0(se0_0),
	.sw1_0(se1_0),
	.sw0_1(se0_1),
	.sw1_1(se1_1)
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
	.ais(1'b0),
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

pe pe0_1 (
	.clk(clk),
	.rst_n(rst_n),

	.a_in(a_in1),
	.b_in(b_out0_0),
	.start(start),
	.awe(awe1),
	.bwe(fout0_0),
	.ais(aff1_1),
	.bis(1'b0),
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
	.ais(1'b0),
	.bis(1'b0),

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

endmodule
