/*
 * My RISC-V RV32I CPU
 *   Systolic wrapper for system module
 *    Verilog code
 * 		Yoshiki Kurokawa <yoshiki.k963.com>
 * 	2021 Yoshiki Kurokawa
 * 		https://opensource.org/licenses/MIT     MIT license
 * 		0.1
 */

module systolic_wrap(
	input clk,
	input rst_n,

	// ram interface
	input ren,
	input [15:0] ibus_radr,
	output [15:0] ibus32_rdata,
	input wen,
	input [15:0] ibus_wadr,
	input [15:0] ibus32_wdata

	);

wire [15:0] ibus_wdata = ibus32_wdata[15:0];
wire [15:0] ibus_rdata; // output

assign ibus32_rdata = { {16{ibus_rdata}}, ibus_rdata };

systolic4 systolic (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ren),
	.ibus_radr(ibus_radr),
	.ibus_rdata(ibus_rdata),
	.wen(wen),
	.ibus_wadr(ibus_wadr),
	.ibus_wdata(ibus_wdata)
	);

endmodule
