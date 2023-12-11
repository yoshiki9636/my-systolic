/*
 * My RISC-V RV32I CPU
 *   ab buffer for iobuf
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2021 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

module abbuf(
	input clk,
	input rst_n,

	// ram interface
	input ren,
	input [9:0] abbus_radr,
	input wen,
	input [9:0] ibus_wadr,
	input [15:0] ibus_wdata,

	// systolice array inbuffer interface
	input start,
	input sys_running,
	input ff,
	output [15:0] ab_in,
	output reg we

	);

// input buffer controls
reg [9:0] ibuf_ab_radri;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        ibuf_ab_radri <= 10'd0;
    else if (start)
        ibuf_ab_radri <= 10'd0;
	else if (sys_running & ~ff)
        ibuf_ab_radri <= ibuf_ab_radri + 10'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        we <= 1'b0;
	else if (sys_running & ~ff)
        we <= 1'b1;
	else
        we <= 1'b0;
end

// address selector
wire [9:0] buf_ab_radr = ren ? abbus_radr : ibuf_ab_radri;

// input buffers

buf_1r1w buf_ab (
	.clk(clk),
	.ram_radr(buf_ab_radr),
	.ram_rdata(ab_in),
	.ram_wadr(ibus_wadr),
	.ram_wdata(ibus_wdata),
	.ram_wen(wen)
	);

endmodule
