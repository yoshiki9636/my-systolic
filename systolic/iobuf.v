/*
 * My RISC-V RV32I CPU
 *   FPGA Top Module for Tang Premier
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2021 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

module iobuf(
	input clk,
	input rst_n,

	// ram interface
	input ren,
	input [15:0] ibus_radr,
	output [15:0] ibus_rdata,
	input wen,
	input [15:0] ibus_wadr,
	input [15:0] ibus_wdata,

	// systolice array inbuffer interface
	input aff0,
	input aff1,
	input bff0,
	input bff1,
	output [15:0] a_in0,
	output [15:0] b_in0,
	output [15:0] a_in1,
	output [15:0] b_in1,
	output reg [7:0] max_cntr,
	output reg start,
	output reg awe0,
	output reg bwe0,
	output reg awe1,
	output reg bwe1,
	// systolice array outbuffer interface
	input [15:0] s_out0,
	input [15:0] s_out1,
	input sat0,
	input sat1,
	input sw0,
	input sw1

	);

`define IBUFA0_HEAD 6'h00
`define IBUFA1_HEAD 6'h01
`define IBUFB0_HEAD 6'h02
`define IBUFB1_HEAD 6'h03
`define OBUFS0_HEAD 6'h20
`define OBUFS1_HEAD 6'h21
`define OBUFSA0_HEAD 6'h22
`define OBUFSA1_HEAD 6'h23
`define SYS_START_ADR 16'hFFF0
`define SYS_MAX_CNTR 16'hFFF1
`define SYS_RUN_CNTR 16'hFFF2

// 1shot start bit
wire write_start = wen & (ibus_wadr == `SYS_START_ADR);

//wire write_end = wen & (ibus_wadr == `SYS_END_ADR);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        start <= 1'b0;
	else if (write_start)
        start <= 1'b1;
	else
        start <= 1'b0;
end

// running counter
wire write_run_cntr = wen & (ibus_wadr == `SYS_RUN_CNTR);
reg [7:0] run_cntr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_cntr <= 16'd0;
    else if (write_run_cntr)
        run_cntr <= ibus_wdata[7:0];
end

reg [7:0] run_s0_cntr;
reg [7:0] run_s1_cntr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_s0_cntr <= 8'd0;
    else if (start)
        run_s0_cntr <= run_cntr;
    else if ((run_s0_cntr > 8'd0) & sw0)
        run_s0_cntr <= run_s0_cntr - 8'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_s1_cntr <= 8'd0;
    else if (start)
        run_s1_cntr <= run_cntr;
    else if ((run_s1_cntr > 8'd0) & sw1)
        run_s1_cntr <= run_s1_cntr - 8'd1;
end

wire run_s0 = |run_s0_cntr;
wire run_s1 = |run_s1_cntr;
wire sys_running = run_s0 | run_s1;
reg sys_running_d1;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sys_running_d1 <= 1'b0;
	else
        sys_running_d1 <= sys_running;
end

wire sys_end = ~sys_running & sys_running_d1;

// max counter
wire write_max_cntr = wen & (ibus_wadr == `SYS_MAX_CNTR);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        max_cntr <= 8'd0;
    else if (write_max_cntr)
        max_cntr <= ibus_wdata[7:0];
end

// input buffer controls
// write part
wire [9:0] ibuf_wadr = ibus_wadr[9:0];
wire ibuf_a0_wen = wen & (ibus_wadr[15:10] == `IBUFA0_HEAD);
wire ibuf_a1_wen = wen & (ibus_wadr[15:10] == `IBUFA1_HEAD);
wire ibuf_b0_wen = wen & (ibus_wadr[15:10] == `IBUFB0_HEAD);
wire ibuf_b1_wen = wen & (ibus_wadr[15:10] == `IBUFB1_HEAD);

wire ibuf_a0_dec = (ibus_radr[15:10] == `IBUFA0_HEAD);
wire ibuf_a1_dec = (ibus_radr[15:10] == `IBUFA1_HEAD);
wire ibuf_b0_dec = (ibus_radr[15:10] == `IBUFB0_HEAD);
wire ibuf_b1_dec = (ibus_radr[15:10] == `IBUFB1_HEAD);
wire ibuf_a0_ren = ren & ibuf_a0_dec;
wire ibuf_a1_ren = ren & ibuf_a1_dec;
wire ibuf_b0_ren = ren & ibuf_b0_dec;
wire ibuf_b1_ren = ren & ibuf_b1_dec;

// read part
reg [9:0] ibuf_a0_radri;
reg [9:0] ibuf_a1_radri;
reg [9:0] ibuf_b0_radri;
reg [9:0] ibuf_b1_radri;
wire [9:0] ibuf_a0_radr;
wire [9:0] ibuf_a1_radr;
wire [9:0] ibuf_b0_radr;
wire [9:0] ibuf_b1_radr;

// a0 buffer's address
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        ibuf_a0_radri <= 10'd0;
    else if (start)
        ibuf_a0_radri <= 10'd0;
	else if (sys_running & ~aff0)
        ibuf_a0_radri <= ibuf_a0_radri + 10'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        awe0 <= 1'b0;
	else if (sys_running & ~aff0)
        awe0 <= 1'b1;
	else
        awe0 <= 1'b0;
end

// a1 buffer's address
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        ibuf_a1_radri <= 10'd0;
    else if (start)
        ibuf_a1_radri <= 10'd0;
	else if (sys_running & ~aff1)
        ibuf_a1_radri <= ibuf_a1_radri + 10'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        awe1 <= 1'b0;
	else if (sys_running & ~aff1)
        awe1 <= 1'b1;
	else
        awe1 <= 1'b0;
end

// b0 buffer's address
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        ibuf_b0_radri <= 10'd0;
    else if (start)
        ibuf_b0_radri <= 10'd0;
	else if (sys_running & ~bff0)
        ibuf_b0_radri <= ibuf_b0_radri + 10'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        bwe0 <= 1'b0;
	else if (sys_running & ~bff0)
        bwe0 <= 1'b1;
	else
        bwe0 <= 1'b0;
end

// a1 buffer's address
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        ibuf_b1_radri <= 10'd0;
    else if (start)
        ibuf_b1_radri <= 10'd0;
	else if (sys_running & ~bff1)
        ibuf_b1_radri <= ibuf_b1_radri + 10'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        bwe1 <= 1'b0;
	else if (sys_running & ~bff1)
        bwe1 <= 1'b1;
	else
        bwe1 <= 1'b0;
end

// address selector
assign ibuf_a0_radr = ibuf_a0_ren ? ibus_radr[9:0] : ibuf_a0_radri;
assign ibuf_a1_radr = ibuf_a1_ren ? ibus_radr[9:0] : ibuf_a1_radri;
assign ibuf_b0_radr = ibuf_b0_ren ? ibus_radr[9:0] : ibuf_b0_radri;
assign ibuf_b1_radr = ibuf_b1_ren ? ibus_radr[9:0] : ibuf_b1_radri;

// input buffers

buf_1r1w buf_a0 (
	.clk(clk),
	.ram_radr(ibuf_a0_radr),
	.ram_rdata(a_in0),
	.ram_wadr(ibuf_wadr),
	.ram_wdata(ibus_wdata),
	.ram_wen(ibuf_a0_wen)
	);

buf_1r1w buf_a1 (
	.clk(clk),
	.ram_radr(ibuf_a1_radr),
	.ram_rdata(a_in1),
	.ram_wadr(ibuf_wadr),
	.ram_wdata(ibus_wdata),
	.ram_wen(ibuf_a1_wen)
	);

buf_1r1w buf_b0 (
	.clk(clk),
	.ram_radr(ibuf_b0_radr),
	.ram_rdata(b_in0),
	.ram_wadr(ibuf_wadr),
	.ram_wdata(ibus_wdata),
	.ram_wen(ibuf_b0_wen)
	);

buf_1r1w buf_b1 (
	.clk(clk),
	.ram_radr(ibuf_b1_radr),
	.ram_rdata(b_in1),
	.ram_wadr(ibuf_wadr),
	.ram_wdata(ibus_wdata),
	.ram_wen(ibuf_b1_wen)
	);


// outbuffer controls
// read part
wire [9:0] obuf_radr = ibus_radr[9:0];
wire obuf_s0_dec = (ibus_radr[15:10] == `OBUFS0_HEAD);
wire obuf_s1_dec = (ibus_radr[15:10] == `OBUFS1_HEAD);
wire obuf_sa0_dec = (ibus_radr[15:10] == `OBUFSA0_HEAD);
wire obuf_sa1_dec = (ibus_radr[15:10] == `OBUFSA1_HEAD);
wire [15:0] obuf_s0_rdata;
wire [15:0] obuf_s1_rdata;
wire [15:0] obuf_sa0_rdata;
wire [15:0] obuf_sa1_rdata;

// read bus selector
assign ibus_rdata = obuf_s0_dec ? obuf_s0_rdata :
					obuf_s1_dec ? obuf_s1_rdata :
					obuf_sa0_dec ? obuf_sa0_rdata :
					obuf_sa1_dec ? obuf_sa1_rdata :
					ibuf_a0_dec ? a_in0 :
					ibuf_a1_dec ? a_in1 :
					ibuf_b0_dec ? b_in0 :
					ibuf_b1_dec ? b_in1 : 16'd0;

// write part
reg [9:0] obuf_s0_wadr;
reg [9:0] obuf_s1_wadr;
// s0 buffer's address
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        obuf_s0_wadr <= 10'd0;
    else if (start)
        obuf_s0_wadr <= 10'd0;
	else if (sys_running & sw0)
        obuf_s0_wadr <= obuf_s0_wadr + 10'd1;
end

// s1 buffer's address
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        obuf_s1_wadr <= 10'd0;
    else if (start)
        obuf_s1_wadr <= 10'd0;
	else if (sys_running & sw1)
        obuf_s1_wadr <= obuf_s1_wadr + 10'd1;
end

// satuation bits buffer
reg [3:0] sat0_cntr;
reg [3:0] sat1_cntr;
reg [15:0] sat0_agg;
reg [15:0] sat1_agg;
reg [9:0] obuf_sa0_wadr;
reg [9:0] obuf_sa1_wadr;

// satuation bit counter
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sat0_cntr <= 4'd0;
    else if (start)
        sat0_cntr <= 4'd0;
	else if (sys_running & sw0)
        sat0_cntr <= sat0_cntr + 4'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sat1_cntr <= 4'd0;
    else if (start)
        sat1_cntr <= 4'd0;
	else if (sys_running & sw1)
        sat1_cntr <= sat1_cntr + 4'd1;
end

wire sat0_wen = ((sat0_cntr == 4'hf) & sat0) | sys_end;
wire sat1_wen = ((sat1_cntr == 4'hf) & sat1) | sys_end;

// bit aggrigator
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sat0_agg <= 16'd0;
    else if (start)
        sat0_agg <= 16'd0;
	else if (sys_running & sw0 & (sat0_cntr == 4'hf))
        sat0_agg <= { 15'd0, sat0 };
	else if (sys_running & sw0)
        sat0_agg <= { sat0_agg[15:0], sat0 };
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sat1_agg <= 16'd0;
    else if (start)
        sat1_agg <= 16'd0;
	else if (sys_running & sw1 & (sat1_cntr == 4'hf))
        sat1_agg <= { 15'd0, sat1 };
	else if (sys_running & sw1)
        sat1_agg <= { sat1_agg[15:0], sat1 };
end

// address counter
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        obuf_sa0_wadr <= 10'd0;
    else if (start)
        obuf_sa0_wadr <= 10'd0;
	else if (sys_running & sat0_wen)
        obuf_sa0_wadr <= obuf_sa0_wadr + 10'd1;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        obuf_sa1_wadr <= 10'd0;
    else if (start)
        obuf_sa1_wadr <= 10'd0;
	else if (sys_running & sat1_wen)
        obuf_sa1_wadr <= obuf_sa1_wadr + 10'd1;
end

// output buffers
buf_1r1w buf_s0 (
	.clk(clk),
	.ram_radr(obuf_radr),
	.ram_rdata(obuf_s0_rdata),
	.ram_wadr(obuf_s0_wadr),
	.ram_wdata(s_out0),
	.ram_wen(sw0)
	);

buf_1r1w buf_s1 (
	.clk(clk),
	.ram_radr(obuf_radr),
	.ram_rdata(obuf_s1_rdata),
	.ram_wadr(obuf_s1_wadr),
	.ram_wdata(s_out1),
	.ram_wen(sw1)
	);

buf_1r1w buf_sa0 (
	.clk(clk),
	.ram_radr(obuf_radr),
	.ram_rdata(obuf_sa0_rdata),
	.ram_wadr(obuf_sa0_wadr),
	.ram_wdata(sat0_agg),
	.ram_wen(sat0_wen)
	);

buf_1r1w buf_sa1 (
	.clk(clk),
	.ram_radr(obuf_radr),
	.ram_rdata(obuf_sa1_rdata),
	.ram_wadr(obuf_sa1_wadr),
	.ram_wdata(sat1_agg),
	.ram_wen(sat1_wen)
	);


endmodule
