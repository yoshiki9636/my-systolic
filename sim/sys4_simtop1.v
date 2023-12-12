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

`define IBUFA0_HEAD 6'h00
`define IBUFA1_HEAD 6'h01
`define IBUFB0_HEAD 6'h02
`define IBUFB1_HEAD 6'h03
`define OBUFS0_0_HEAD 7'h40
`define OBUFS1_0_HEAD 7'h41
`define OBUFS0_1_HEAD 7'h42
`define OBUFS1_1_HEAD 7'h43
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
	ren = 1'b1;
#20
	ibus_radr = `SYS_START_ADR;
#2000
	ibus_radr = `SYS_START_ADR;
#10
	ibus_radr = { `OBUFS0_0_HEAD, 9'h000 };
#10
	ibus_radr = { `OBUFS0_0_HEAD, 9'h001 };
#10
	ibus_radr = { `OBUFS0_0_HEAD, 9'h002 };
#10
	ibus_radr = { `OBUFS0_0_HEAD, 9'h003 };
#10
	ibus_radr = { `OBUFS0_0_HEAD, 9'h004 };
#10
	ibus_radr = { `OBUFS0_0_HEAD, 9'h005 };
#10
	ibus_radr = { `OBUFS0_0_HEAD, 9'h006 };
#10
	ibus_radr = { `OBUFS0_0_HEAD, 9'h007 };
#10

	ibus_radr = { `OBUFS1_0_HEAD, 9'h000 };
#10
	ibus_radr = { `OBUFS1_0_HEAD, 9'h001 };
#10
	ibus_radr = { `OBUFS1_0_HEAD, 9'h002 };
#10
	ibus_radr = { `OBUFS1_0_HEAD, 9'h003 };
#10
	ibus_radr = { `OBUFS1_0_HEAD, 9'h004 };
#10
	ibus_radr = { `OBUFS1_0_HEAD, 9'h005 };
#10
	ibus_radr = { `OBUFS1_0_HEAD, 9'h006 };
#10
	ibus_radr = { `OBUFS1_0_HEAD, 9'h007 };
#10

	ibus_radr = { `OBUFS0_1_HEAD, 9'h000 };
#10
	ibus_radr = { `OBUFS0_1_HEAD, 9'h001 };
#10
	ibus_radr = { `OBUFS0_1_HEAD, 9'h002 };
#10
	ibus_radr = { `OBUFS0_1_HEAD, 9'h003 };
#10
	ibus_radr = { `OBUFS0_1_HEAD, 9'h004 };
#10
	ibus_radr = { `OBUFS0_1_HEAD, 9'h005 };
#10
	ibus_radr = { `OBUFS0_1_HEAD, 9'h006 };
#10
	ibus_radr = { `OBUFS0_1_HEAD, 9'h007 };
#10

	ibus_radr = { `OBUFS1_1_HEAD, 9'h000 };
#10
	ibus_radr = { `OBUFS1_1_HEAD, 9'h001 };
#10
	ibus_radr = { `OBUFS1_1_HEAD, 9'h002 };
#10
	ibus_radr = { `OBUFS1_1_HEAD, 9'h003 };
#10
	ibus_radr = { `OBUFS1_1_HEAD, 9'h004 };
#10
	ibus_radr = { `OBUFS1_1_HEAD, 9'h005 };
#10
	ibus_radr = { `OBUFS1_1_HEAD, 9'h006 };
#10
	ibus_radr = { `OBUFS1_1_HEAD, 9'h007 };
#10

	ibus_radr = { `OBUFS0_0_HEAD, 9'h100 };
#10
	ibus_radr = { `OBUFS1_0_HEAD, 9'h100 };
#10
	ibus_radr = { `OBUFS0_1_HEAD, 9'h100 };
#10
	ibus_radr = { `OBUFS1_1_HEAD, 9'h100 };
#100
	ren = 1'b0;
	ibus_wadr = { `IBUFA0_HEAD, 8'h00 };
	ibus_wdata = 16'h0000;
#10
	ibus_wadr = { `IBUFA0_HEAD, 8'h01 };
	ibus_wdata = 16'h1111;
#10
	ibus_wadr = { `IBUFA0_HEAD, 8'h02 };
	ibus_wdata = 16'h2222;
#10
	ibus_wadr = { `IBUFA0_HEAD, 8'h03 };
	ibus_wdata = 16'h3333;
#10

	ibus_wadr = { `IBUFA1_HEAD, 8'h04 };
	ibus_wdata = 16'h4444;
#10
	ibus_wadr = { `IBUFA1_HEAD, 8'h05 };
	ibus_wdata = 16'h5555;
#10
	ibus_wadr = { `IBUFA1_HEAD, 8'h06 };
	ibus_wdata = 16'h6666;
#10
	ibus_wadr = { `IBUFA1_HEAD, 8'h07 };
	ibus_wdata = 16'h7777;
#10

	ibus_wadr = { `IBUFB0_HEAD, 8'h00 };
	ibus_wdata = 16'h8888;
#10
	ibus_wadr = { `IBUFB0_HEAD, 8'h01 };
	ibus_wdata = 16'h9999;
#10
	ibus_wadr = { `IBUFB0_HEAD, 8'h02 };
	ibus_wdata = 16'haaaa;
#10
	ibus_wadr = { `IBUFB0_HEAD, 8'h03 };
	ibus_wdata = 16'hbbbb;

#10
	ibus_wadr = { `IBUFB1_HEAD, 8'h04 };
	ibus_wdata = 16'hcccc;
#10
	ibus_wadr = { `IBUFB1_HEAD, 8'h05 };
	ibus_wdata = 16'hdddd;
#10
	ibus_wadr = { `IBUFB1_HEAD, 8'h06 };
	ibus_wdata = 16'heeee;
#10
	ibus_wadr = { `IBUFB1_HEAD, 8'h07 };
	ibus_wdata = 16'hffff;

#100
	ren = 1'b1;
	ibus_radr = { `IBUFA0_HEAD, 8'h00 };
#10
	ibus_radr = { `IBUFA0_HEAD, 8'h01 };
#10
	ibus_radr = { `IBUFA0_HEAD, 8'h02 };
#10
	ibus_radr = { `IBUFA0_HEAD, 8'h03 };
#10
	ibus_radr = { `IBUFA1_HEAD, 8'h04 };
#10
	ibus_radr = { `IBUFA1_HEAD, 8'h05 };
#10
	ibus_radr = { `IBUFA1_HEAD, 8'h06 };
#10
	ibus_radr = { `IBUFA1_HEAD, 8'h07 };
#10

	ibus_radr = { `IBUFB0_HEAD, 8'h00 };
#10
	ibus_radr = { `IBUFB0_HEAD, 8'h01 };
#10
	ibus_radr = { `IBUFB0_HEAD, 8'h02 };
#10
	ibus_radr = { `IBUFB0_HEAD, 8'h03 };
#10
	ibus_radr = { `IBUFB1_HEAD, 8'h04 };
#10
	ibus_radr = { `IBUFB1_HEAD, 8'h05 };
#10
	ibus_radr = { `IBUFB1_HEAD, 8'h06 };
#10
	ibus_radr = { `IBUFB1_HEAD, 8'h07 };
#1000

	$stop;
end

endmodule
