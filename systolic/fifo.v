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
reg [2:0] en_cntr;
wire rv_pre;
reg rv_post;
wire rnext;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        en_cntr <= 2'd0;
    else if (~is & we & rv_pre & re)
        en_cntr <= en_cntr;
    else if (~is & rv_pre & re)
        en_cntr <= en_cntr - 2'd1;
    else if (we & ~is & (en_cntr < 2'd3))
        en_cntr <= en_cntr + 2'd1;
end

assign rv_pre = (|en_cntr) | we ;
assign ff = (en_cntr > 2'd1);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        rv_post <= 1'b0;
	else
        rv_post <= rv_pre;
end

//assign rv = rv_pre | rv_post;
assign rv = rv_post;

// get 1 more request when ~ff
reg is_post;
reg ff_post;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        is_post <= 1'b0;
        ff_post <= 1'b0;
	end
	else begin
        is_post <= is;
        ff_post <= ff;
	end
end

wire is_1shot = is & ~is_post;
wire ff_1shot = ff & ~ff_post;

// write counter 
reg [1:0] wadr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        wadr <= 2'd0;
    else if (we & ((~is & ~ff) | is_1shot | ff_1shot))
        wadr <= wadr + 2'd1;
end

// read counter 
reg [1:0] radr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        radr <= 2'd0;
    else if (~is & rv_pre & re)
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
