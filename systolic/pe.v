/*
 * My Systolic array 
 *   PE block
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2023 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

module pe(
	input clk,
	input rst_n,
	input [15:0] a_in,
	input [15:0] b_in,
	input start,
	input awe,
	input bwe,
	input ais,
	input bis,
	output aff,
	output bff,
	output se,
	output fout,
	output sat,
	output [15:0] s_out,
	output reg [15:0] a_out,
	output reg [15:0] b_out,
	output reg start_next,
	input [7:0] max_cntr
	);

wire [15:0] a_value;
wire [15:0] b_value;
wire aen;
wire ben;
wire men;
wire sen;
wire sreset_pre;
reg sreset;

// dsp block
reg aen_int;
reg ben_int;
reg aben_int;

//(*keep_hierarchy="yes"*)dsp dsp (
dsp dsp (
	.clk(clk),
	.rst_n(rst_n),
	.a_value(a_value),
	.b_value(b_value),
	//.aen(aen_int),
	//.ben(ben_int),
	.aen(aben_int),
	.ben(aben_int),
	.men(men),
	.sen(sen),
	.start(start),
	.sreset(sreset),
	.sat(sat),
	.s_out(s_out)
	);

// afifo module
wire arv;
wire aben;

fifo afifo (
	.clk(clk),
	.rst_n(rst_n),
	.we(awe),
	.re(aben),
	.is(ais),
	.rv(arv),
	.ff(aff),
	.start(start),
	.din(a_in),
	.dout(a_value)
	);

// bfifo module
wire brv;

fifo bfifo (
	.clk(clk),
	.rst_n(rst_n),
	.we(bwe),
	.re(aben),
	.is(bis),
	.rv(brv),
	.ff(bff),
	.start(start),
	.din(b_in),
	.dout(b_value)
	);

// aoffset counter
reg [7:0] aoffset_cntr;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        aoffset_cntr <= 8'd0;
	else if (start | sreset_pre)
		aoffset_cntr <= max_cntr;
	else if (men & (|aoffset_cntr))
		aoffset_cntr <= aoffset_cntr - 8'd1;
end

// control singals
reg aben_post;
reg aen_post;
reg ben_post;

assign aben = aen & ben;
//assign men = aen_post & ben_post & ~ais & ~bis;
//assign men = aben_post & ~ais & ~bis;
assign men = aben_post;
assign fout = men;
assign sreset_pre = men & ~(|aoffset_cntr) ;

//assign aen = arv & ~ais & ~bis;
//assign ben = brv & ~ais & ~bis;
assign aen = arv;
assign ben = brv;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        aben_int <= 1'b0;
	else if (~ais & ~bis)
        aben_int <= aben;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        aben_post <= 1'b0;
	//else if (~ais & ~bis)
        //aben_post <= aben_int;
	else
        aben_post <= aben_int &  (~ais & ~bis);
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        aen_int <= 1'b0;
	else if (~ais & ~bis)
        aen_int <= aen;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        ben_int <= 1'b0;
	else if (~ais & ~bis)
        ben_int <= ben;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        ben_post <= 1'b0;
	else if (~ais & ~bis)
        ben_post <= ben_int;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        aen_post <= 1'b0;
	else if (~ais & ~bis)
        aen_post <= aen_int;
end

reg men_post;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        men_post <= 1'b0;
	else if (~ais & ~bis)
        men_post <= men;
end

assign sen = men_post & ~ais & ~bis;

//reg sen_post;

//always @ (posedge clk or negedge rst_n) begin
	//if (~rst_n)
        //sen_post <= 1'b0;
	//else if (~ais & ~bis)
        //sen_post <= sen;
//end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        sreset <= 1'b0;
	else if (~ais & ~bis)
        sreset <= sreset_pre;
end

reg se_pre;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        se_pre <= 1'b0;
	else if (~ais & ~bis)
        se_pre <= sreset;
end

assign se = se_pre & ~ais & ~bis;

// start FF
always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        start_next <= 1'b0;
	else
        start_next <= start;
end

// pipeline FF for bypassing A,B data

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        a_out <= $signed(16'd0);
	else if (aben)
        a_out <= a_value;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        b_out <= $signed(16'd0);
	else if (aben)
        b_out <= b_value;
end

endmodule
