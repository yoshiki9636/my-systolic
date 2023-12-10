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
	output reg tx,
	input interrupt_0,
	output [2:0] rgb_led
	);

wire clk;

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

// output
wire [15:0] ibus_rdata; // output

wire tx_pre = ^ibus_rdata; 

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		tx <= 1'b0;
	else
		tx <= tx_pre;
end

// input
reg [15:0] ibus_radr; // input
reg [15:0] ibus_wadr; // input
reg [15:0] ibus_wdata; // input
reg ren; // input
reg wen; // input


always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		ibus_radr <= 16'd0;
		ibus_wadr <= 16'd0;
		ibus_wdata <= 16'd0;
		ren <= 1'b0;
		wen <= 1'b0;
	end
	else begin
		ibus_radr <= { ibus_radr[14:0], rx };
		ibus_wadr <= { ibus_wadr[14:0], ibus_radr[15] };
		ibus_wdata <= { ibus_wdata[14:0], ibus_wadr[15] };
		ren <= ibus_wdata[15];
		wen <= ren;
	end
end

systolic4 systolic4 (
	.clk(clkin),
	.rst_n(rst_n),
	.ren(ren),
	.ibus_radr(ibus_radr),
	.ibus_rdata(ibus_rdata),
	.wen(wen),
	.ibus_wadr(ibus_wadr),
	.ibus_wdata(ibus_wdata)
	);

endmodule
