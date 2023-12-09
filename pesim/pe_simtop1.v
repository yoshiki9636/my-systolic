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
reg [7:0] max_cntr; // input

pe pe (
	.clk(clk),
	.rst_n(rst_n),
	.a_in(a_in),
	.b_in(b_in),
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
	.max_cntr(max_cntr)
	);

initial clkin = 0;

always #5 clkin <= ~clkin;


initial begin
	force fpga_top.cpu_start = 1'b0;
	rst_n = 1'b1;
	interrupt_0 = 1'b0;
#10
	rst_n = 1'b0;
#20
	rst_n = 1'b1;
#10
	max_cntr = ('d4;
	ais = 1'b0; // input
	bis = 1'b0; // input

	awe = 1'b0; // input
	bwe = 1'b0; // input
	a_in = $singed(16'd0); // input
	b_in = $singed(16'd0); // input
#10
	awe = 1'b1; // input
	bwe = 1'b1; // input
	a_in = $singed(16'd1); // input
	b_in = $singed(16'd5); // input
#10
	a_in = $singed(16'd2); // input
	b_in = $singed(16'd6); // input
#10
	a_in = $singed(16'd3); // input
	b_in = $singed(16'd7); // input
#10
	a_in = $singed(16'd4); // input
	b_in = $singed(16'd8); // input
#10
	a_in = $singed(16'd0); // input
	b_in = $singed(16'd0); // input
#50
	awe = 1'b0; // input
	bwe = 1'b0; // input
#100
	$stop;
end



endmodule
