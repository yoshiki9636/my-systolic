/*
 * My RISC-V RV32I CPU
 *   Verilog PE Simulation Top Module
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2023 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

module simtop;

reg clkin;
reg rst_n;

reg signed [15:0] a_in; // input
reg signed [15:0] b_in; // input
reg start; // input
reg awe; // input
reg bwe; // input
reg ais; // input
reg bis; // input
wire aff; // output
wire bff; // output
wire se; // output
wire fout; // output
wire sat; // output
wire signed [15:0] s_out; // output
wire signed [15:0] a_out; // output
wire signed [15:0] b_out; // output
wire start_next; // input
reg [7:0] max_cntr; // input

pe pe (
	.clk(clkin),
	.rst_n(rst_n),
	.a_in(a_in),
	.b_in(b_in),
	.start(start),
	.awe(awe),
	.bwe(bwe),
	.ais(ais),
	.bis(bis),
	.aff(aff),
	.bff(bff),
	.se(se),
	.fout(fout),
	.sat(sat),
	.s_out(s_out),
	.a_out(a_out),
	.b_out(b_out),
	.start_next(start_next),
	.max_cntr(max_cntr)
	);

initial clkin = 0;

always #5 clkin <= ~clkin;


initial begin
	max_cntr = $signed('d4);
	start = 1'b0; // input
	ais = 1'b0; // input
	bis = 1'b0; // input

	awe = 1'b0; // input
	bwe = 1'b0; // input
	a_in = 16'd0; // input
	b_in = 16'd0; // input
	rst_n = 1'b1;
#10
	rst_n = 1'b0;
#20
	rst_n = 1'b1;
#20
	start = 1'b1; // input
#10
	start = 1'b0; // input
	awe = 1'b1; // input
	bwe = 1'b1; // input
	a_in = -1; // input
	b_in = -2; // input
#10
	a_in = -2; // input
	b_in = 3; // input
#10
	a_in = 2; // input
	b_in = -5; // input
#10
	a_in = -2; // input
	b_in = -5; // input
#10
	a_in = 0; // input
	b_in = 0; // input
#50
	awe = 1'b0; // input
	bwe = 1'b0; // input
#100
	$stop;
end



endmodule
