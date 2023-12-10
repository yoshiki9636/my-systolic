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
	input signed [15:0] a_in,
	input signed [15:0] b_in,
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
	output signed [15:0] s_out,
	output reg signed [15:0] a_out,
	output reg signed [15:0] b_out,
	output reg start_next,
	input [7:0] max_cntr
	);

wire signed [15:0] a_value;
wire signed [15:0] b_value;
wire aen;
wire ben;
wire men;
wire sen;
wire sreset_pre;
reg sreset;

// dsp block
reg aen_int;
reg ben_int;

dsp dsp (
	.clk(clk),
	.rst_n(rst_n),
	.a_value(a_value),
	.b_value(b_value),
	.aen(aen_int),
	.ben(ben_int),
	.men(men),
	.sen(sen),
	.sreset(sreset),
	.sat(sat),
	.s_out(s_out)
	);

// afifo module
wire arv;

fifo afifo (
	.clk(clk),
	.rst_n(rst_n),
	.we(awe),
	.re(ben),
	.is(ais),
	.rv(arv),
	.ff(aff),
	.din(a_in),
	.dout(a_value)
	);

// bfifo module
wire brv;

fifo bfifo (
	.clk(clk),
	.rst_n(rst_n),
	.we(bwe),
	.re(aen),
	.is(bis),
	.rv(brv),
	.ff(bff),
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
reg aen_post;
reg ben_post;

//assign men_pre = aen_post & ben_post;
//assign men = men_pre & ~ais & ~bis;
assign men = aen_post & ben_post & ~ais & ~bis;
assign sreset_pre = men & ~(|aoffset_cntr) ;

assign aen = arv & ~ais & ~bis;
assign ben = brv & ~ais & ~bis;

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
        //men_post <= men_pre;
        men_post <= men;
end

assign sen = men_post & ~ais & ~bis;

reg sen_post;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        sen_post <= 1'b0;
	else if (~ais & ~bis)
        sen_post <= sen;
        //sen_post <= men_post;
end

assign fout = sen_post & ~ais & ~bis;


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
reg signed [15:0] a_aen;
reg signed [15:0] b_ben;
reg signed [15:0] a_men;
reg signed [15:0] b_men;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        a_aen <= $signed(16'd0);
	else if (aen)
        a_aen <= a_value;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        a_men <= $signed(16'd0);
	else if (men)
        a_men <= a_aen;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        a_out <= $signed(16'd0);
	else if (sen)
        a_out <= a_men;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        b_ben <= $signed(16'd0);
	else if (ben)
        b_ben <= b_value;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        b_men <= $signed(16'd0);
	else if (men)
        b_men <= b_ben;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        b_out <= $signed(16'd0);
	else if (sen)
        b_out <= b_men;
end

endmodule