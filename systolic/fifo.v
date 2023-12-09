/*
 * My Systolic array
 *   ram for FIFO
 *    Verilog code
 * @auther      Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight   2023 Yoshiki Kurokawa
 * @license     https://opensource.org/licenses/MIT     MIT license
 * @version     0.1
 */

module fifo(
	input clk,
	input rst_n,
	input we,
	input re,
	input is,
	//output reg rv,
	output rv,
	output ff,
	input [15:0] din,
	output [15:0] dout
	);

// push/pull counter for afifo
wire rv;
reg [2:0] en_cntr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        en_cntr <= 3'd0;
    else if (~is & we & rv & re)
        en_cntr <= en_cntr;
    else if (~is & rv & re)
        en_cntr <= en_cntr - 3'd1;
    else if (we & ~is & (en_cntr < 3'd4))
        en_cntr <= en_cntr + 3'd1;
end

assign rv = |en_cntr;
assign ff = en_cntr[2];

// write counter 
reg [1:0] wadr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        wadr <= 2'd0;
    else if (we & ~is & ~ff)
        wadr <= wadr + 2'd1;
end

// read counter 
reg [1:0] radr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        radr <= 2'd0;
    else if (~is & rv & re)
        radr <= radr + 2'd1;
end

// ram

fifo_1r1w fifo_1r1w (
	.clk(clk),
	.ram_radr(radr),
	.ram_rdata(dout),
	.ram_wadr(wadr),
	.ram_wdata(din),
	.ram_wen(we)
	);

endmodule
