/*
 * My RISC-V RV32I CPU
 *   FPGA Top Module for Tang Premier
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2021 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

//`define TANG_PRIMER
`define ARTY_A7

module dummy_fpga_top(
	input clkin,
	input rst_n,
	input rx,
	output tx,
	input interrupt_0,
	output [2:0] rgb_led

	);

wire [13:2] d_ram_radr;
wire [13:2] d_ram_wadr;
wire [31:0] d_ram_rdata;
wire [31:0] d_ram_wdata;
wire d_ram_wen;
wire d_read_sel;

wire [13:2] i_ram_radr;
wire [13:2] i_ram_wadr;
wire [31:0] i_ram_rdata;
wire [31:0] i_ram_wdata;
wire i_ram_wen;
wire i_read_sel;

wire [11:2] st_adr_io;
wire [3:0] st_we_io;
wire [31:0] st_data_io;

wire [31:2] start_adr;
wire cpu_start;
wire quit_cmd;
wire [31:0] pc_data;

wire clk;
wire stdby = 1'b0 ;
// for debug
wire tx_fifo_full;
wire tx_fifo_overrun;
wire tx_fifo_underrun;


`ifdef ARTY_A7
wire locked;
 // Instantiation of the clocking network
 //--------------------------------------
  clk_wiz_0 clknetwork
   (
    // Clock out ports
    .clk_out1           (clk),
    // Status and control signals
    .reset              (~rst_n),
    .locked             (locked),
   // Clock in ports
    .clk_in1            (clkin)
);
`endif

`ifdef TANG_PRIMER
wire clklock;
pll pll (
	.refclk(clkin),
	.reset(~rst_n),
	//.stdby(stdby),
	.extlock(clklock),
	.clk0_out(clk)
	);
`endif

reg [15:0] a_in0; // input
reg [15:0] b_in0; // input
reg [15:0] a_in1; // input
reg [15:0] b_in1; // input
reg [7:0] max_cntr; // input
reg start; // input
reg awe0; // input
reg bwe0; // input
reg awe1; // input
reg bwe1; // input

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		a_in0 <= 16'd0;
		b_in0 <= 16'd0;
		a_in1 <= 16'd0;
		b_in1 <= 16'd0;
		max_cntr <= 8'd0;
		start <= 1'b0;
		awe0 <= 1'b0;
		bwe0 <= 1'b0;
		awe1 <= 1'b0;
		bwe1 <= 1'b0;

	end
	else begin
		a_in0 <= { a_in0[14:0], rx };
		b_in0 <= { b_in0[14:0], a_in0[15] };
		a_in1 <= { a_in1[14:0], b_in0[15] };
		b_in1 <= { b_in1[14:0], a_in1[15] };
		max_cntr <= { max_cntr[6:0], b_in1[15] };
		start <= max_cntr[7];
		awe0 <= start;
		bwe0 <= awe0;
		awe1 <= bwe0;
		bwe1 <= awe1;

	end
end

wire aff0_0; // output
wire aff1_0; // output
wire aff0_1; // output
wire aff1_1; // output
wire bff0_0; // output
wire bff1_0; // output
wire bff0_1; // output
wire bff1_1; // output
wire se0_0; // output
wire se1_0; // output
wire se0_1; // output
wire se1_1; // output
wire fout0_0; // output
wire fout1_0; // output
wire fout0_1; // output
wire fout1_1; // output
wire sat0_0; // output
wire sat1_0; // output
wire sat0_1; // output
wire sat1_1; // output
wire start_next0_0; // output
wire start_next1_0; // output
wire start_next0_1; // output
wire start_next1_1; // output
wire [15:0] s_out0_0; // output
wire [15:0] s_out1_0; // output
wire [15:0] s_out0_1; // output
wire [15:0] s_out1_1; // output
wire [15:0] a_out0_0; // output
wire [15:0] a_out1_0; // output
wire [15:0] a_out0_1; // output
wire [15:0] a_out1_1; // output
wire [15:0] b_out0_0; // output
wire [15:0] b_out1_0; // output
wire [15:0] b_out0_1; // output
wire [15:0] b_out1_1; // output


assign tx = ^{
				aff0_0, aff0_1,
				bff0_0, bff1_0,
				fout1_0, fout0_1, fout1_1,
				se0_0,  sat0_0, start_next0_0, s_out0_0,
				se1_0,  sat1_0, start_next1_0, s_out1_0,
				se0_1,  sat0_1, start_next0_1, s_out0_1,
				se1_1,  sat1_1, start_next1_1, s_out1_1,
				a_out1_0, a_out1_1,
				b_out0_1, b_out1_1
				};


pe pe0_0 (
	.clk(clk),
	.rst_n(rst_n),

	.a_in(a_in0),
	.b_in(b_in0),
	.start(start),
	.awe(awe0),
	.bwe(bwe0),
	.ais(aff1_0),
	.bis(bff0_1),

	.aff(aff0_0),
	.bff(bff0_0),
	.se(se0_0),
	.fout(fout0_0),
	.sat(sat0_0),
	.s_out(s_out0_0),
	.a_out(a_out0_0),
	.b_out(b_out0_0),
	.start_next(start_next0_0),

	.max_cntr(max_cntr)
	);

pe pe1_0 (
	.clk(clk),
	.rst_n(rst_n),

	.a_in(a_out0_0),
	.b_in(b_in1),
	.start(start),
	.awe(fout0_0),
	.bwe(bwe1),
	.ais(1'b0),
	.bis(bff1_1),

	.aff(aff1_0),
	.bff(bff1_0),
	.se(se1_0),
	.fout(fout1_0),
	.sat(sat1_0),
	.s_out(s_out1_0),
	.a_out(a_out1_0),
	.b_out(b_out1_0),
	.start_next(start_next1_0),

	.max_cntr(max_cntr)
	);

pe pe0_1 (
	.clk(clk),
	.rst_n(rst_n),

	.a_in(a_in1),
	.b_in(b_out0_0),
	.start(start),
	.awe(awe1),
	.bwe(fout0_0),
	.ais(bff1_1),
	.bis(1'b0),
	.aff(aff0_1),
	.bff(bff0_1),
	.se(se0_1),
	.fout(fout0_1),
	.sat(sat0_1),
	.s_out(s_out0_1),
	.a_out(a_out0_1),
	.b_out(b_out0_1),
	.start_next(start_next0_1),

	.max_cntr(max_cntr)
	);

pe pe1_1 (
	.clk(clk),
	.rst_n(rst_n),

	.a_in(a_out0_1),
	.b_in(b_out1_0),
	.start(start),
	.awe(fout0_1),
	.bwe(fout1_0),
	.ais(1'b0),
	.bis(1'b0),

	.aff(aff1_1),
	.bff(bff1_1),
	.se(se1_1),
	.fout(fout1_1),
	.sat(sat1_1),
	.s_out(s_out1_1),
	.a_out(a_out1_1),
	.b_out(b_out1_1),
	.start_next(start_next1_1),

	.max_cntr(max_cntr)
	);


endmodule
