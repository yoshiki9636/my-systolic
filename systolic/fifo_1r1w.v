/*
 * My Systolic array
 *   ram for FIFO
 *    Verilog code
 * @auther      Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight   2023 Yoshiki Kurokawa
 * @license     https://opensource.org/licenses/MIT     MIT license
 * @version     0.1
 */

module fifo_1r1w(
	input clk,
	input [1:0] ram_radr,
	output [15:0] ram_rdata,
	input [1:0] ram_wadr,
	input [15:0] ram_wdata,
	input ram_wen
	);

// 16x4 1r1w RAM

reg[15:0] ram[0:3];
reg[1:0] radr;

always @ (posedge clk) begin
	if (ram_wen)
		ram[ram_wadr] <= ram_wdata;
	radr <= ram_radr;
end

assign ram_rdata = ram[radr];

endmodule
