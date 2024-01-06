/*
 * My Systolic array
 *   ram for buffers
 *    Verilog code
 * @auther      Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight   2023 Yoshiki Kurokawa
 * @license     https://opensource.org/licenses/MIT     MIT license
 * @version     0.1
 */

module buf_1r1w(
	input clk,
	input [8:0] ram_radr,
	output [15:0] ram_rdata,
	input [8:0] ram_wadr,
	input [15:0] ram_wdata,
	input ram_wen
	);

// 16x1024 1r1w RAM
reg[15:0] ram[0:512];
reg[8:0] radr;

always @ (posedge clk) begin
	if (ram_wen)
		ram[ram_wadr] <= ram_wdata;
	radr <= ram_radr;
end

assign ram_rdata = ram[radr];

endmodule
