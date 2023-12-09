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

reg [15:0] a_in; // input
reg [15:0] b_in; // input
reg [7:0] max_cntr; // input
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
wire start_next; // output
wire [15:0] s_out; // output
wire [15:0] a_out; // output
wire [15:0] b_out; // output

reg affl; // output
reg bffl; // output
reg sel; // output
reg foutl; // output
reg satl; // output
reg start_nextl; // output
reg [15:0] s_outl; // output
reg [15:0] a_outl; // output
reg [15:0] b_outl; // output

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		a_in <= 16'd0;
		b_in <= 16'd0;
		max_cntr <= 8'd0;
		start <= 1'b0;
		awe <= 1'b0;
		bwe <= 1'b0;
		ais <= 1'b0;
		bis <= 1'b0;

		affl <= 1'b0;
		bffl <= 1'b0;
		sel <= 1'b0;
		foutl <= 1'b0;
		satl <= 1'b0;
		start_nextl <= 1'b0;
		s_outl <= 16'd0;
		a_outl <= 16'd0;
		b_outl <= 16'd0;
	end
	else begin
		a_in <= { a_in[14:0], rx };
		b_in <= { b_in[14:0], a_in[15] };
		max_cntr <= { max_cntr[6:0], b_in[15] };
		start <= max_cntr[7];
		awe <= start;
		bwe <= awe;
		ais <= bwe;
		bis <= ais;

		affl <= aff;
		bffl <= bff;
		sel <= sel;
		foutl <= fout;
		satl <= sat;
		start_nextl <= start_next;
		s_outl <= s_out;
		a_outl <= a_out;
		b_outl <= b_out;
	end
end

assign tx = ^{ affl, bffl, sel, foutl, satl, start_nextl, s_outl, a_outl, b_outl};


pe pe (
	.clk(clk),
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


endmodule
