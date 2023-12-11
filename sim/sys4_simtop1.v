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

reg ren; // input
reg [15:0] ibus_radr; // input
wire [15:0] ibus_rdata; // output
reg wen; // input
reg [15:0] ibus_wadr; // input
reg [15:0] ibus_wdata; // input

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

initial clkin = 0;

always #5 clkin <= ~clkin;

initial $readmemh("./testa0.txt", systolic4.iobuf.a0buf.buf_ab.ram);
initial $readmemh("./testa1.txt", systolic4.iobuf.a1buf.buf_ab.ram);
initial $readmemh("./testb0.txt", systolic4.iobuf.b0buf.buf_ab.ram);
initial $readmemh("./testb1.txt", systolic4.iobuf.b1buf.buf_ab.ram);

`define SYS_START_ADR 16'hFFF0
`define SYS_MAX_CNTR 16'hFFF1
`define SYS_RUN_CNTR 16'hFFF2

initial begin
	ren = 1'b0;
	ibus_radr = 16'd0;
	wen = 1'b0;
	ibus_wadr = 16'd0;
	ibus_wdata = 16'd0;
	rst_n = 1'b1;
#10
	rst_n = 1'b0;
#20
	rst_n = 1'b1;
#10
	ibus_wadr = `SYS_MAX_CNTR;
	ibus_wdata = 16'd3;
	wen = 1'b1;
#10
	ibus_wadr = `SYS_RUN_CNTR;
	ibus_wdata = 16'd3;
#10
	wen = 1'b0;
#10
	ibus_wadr = `SYS_START_ADR;
	ibus_wdata = 16'hffff;
	wen = 1'b1;
#10
	wen = 1'b0;
#10000
	$stop;
end

endmodule
