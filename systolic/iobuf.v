/*
 * My RISC-V RV32I CPU
 *   iobuf Module for 4 PE version
 *    Verilog code
 * 		Yoshiki Kurokawa <yoshiki.k963.com>
 * 	2021 Yoshiki Kurokawa
 * 		https://opensource.org/licenses/MIT     MIT license
 * 		0.1
 */

module iobuf(
	input clk,
	input rst_n,

	input dma_io_we,
	input [15:2] dma_io_wadr,
	input [31:0] dma_io_wdata,
	input [15:2] dma_io_radr,
	input [31:0] dma_io_rdata_in,
	output [31:0] dma_io_rdata,
	// ram interface
	input ibus_ren,
	input [19:2] ibus_radr,
	output [15:0] ibus_rdata,
	input ibus_wen,
	input [19:2] ibus_wadr,
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
	output start,
	output awe0,
	output bwe0,
	output awe1,
	output bwe1,
	// systolice array outbuffer interface
	input [15:0] s_out0_0,
	input [15:0] s_out1_0,
	input [15:0] s_out0_1,
	input [15:0] s_out1_1,
	input sat0_0,
	input sat1_0,
	input sat0_1,
	input sat1_1,
	input sw0_0,
	input sw1_0,
	input sw0_1,
	input sw1_1
	);
`define IBUFA00_HEAD 8'h00
`define IBUFA01_HEAD 8'h01
`define IBUFB00_HEAD 8'h02
`define IBUFB01_HEAD 8'h03
`define OBUFS00_00_HEAD 8'h00
`define OBUFS01_00_HEAD 8'h01
`define OBUFS00_01_HEAD 8'h02
`define OBUFS01_01_HEAD 8'h03
`define SYS_START_ADR 14'h3FF8
`define SYS_MAX_CNTR 14'h3FF9
`define SYS_RUN_CNTR 14'h3FFa

// 1shot start bit
wire write_start = dma_io_we & (dma_io_wadr == `SYS_START_ADR);
reg run_status;
wire finish1_1;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_status <= 1'b0;
	else if (finish1_1)
        run_status <= 1'b0;
	else if (write_start)
        run_status <= 1'b1;
end

assign start = write_start & ~run_status;

// running counter
wire write_run_cntr = dma_io_we & (dma_io_wadr == `SYS_RUN_CNTR);
reg [7:0] run_cntr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_cntr <= 16'd0;
    else if (write_run_cntr)
        run_cntr <= dma_io_wdata[7:0];
end

// max counter
wire write_max_cntr = dma_io_we & (dma_io_wadr == `SYS_MAX_CNTR);

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        max_cntr <= 8'd0;
    else if (write_max_cntr)
        max_cntr <= dma_io_wdata[7:0];
end

wire re_run_status = (dma_io_radr == `SYS_START_ADR);
wire re_run_maxcntr = (dma_io_radr == `SYS_MAX_CNTR);
wire re_run_runcntr = (dma_io_radr == `SYS_RUN_CNTR);

assign dma_io_rdata = re_run_status ? { 16'd0, 15'd0, run_status } :
					  re_run_maxcntr ? { 16'd0, 8'd0, max_cntr } :
					  re_run_runcntr ? { 16'd0, 8'd0, run_cntr } : dma_io_rdata_in;

// input buffer controls
// write part
wire [9:0] abbus_wadr = ibus_wadr[11:2];
wire ibuf_a0_wen = ibus_wen & (ibus_wadr[19:12] == `IBUFA00_HEAD);
wire ibuf_a1_wen = ibus_wen & (ibus_wadr[19:12] == `IBUFA01_HEAD);
wire ibuf_b0_wen = ibus_wen & (ibus_wadr[19:12] == `IBUFB00_HEAD);
wire ibuf_b1_wen = ibus_wen & (ibus_wadr[19:12] == `IBUFB01_HEAD);

wire [9:0] abbus_radr = ibus_radr[11:2];
wire ibuf_a0_dec = (ibus_radr[19:12] == `IBUFA00_HEAD);
wire ibuf_a1_dec = (ibus_radr[19:12] == `IBUFA01_HEAD);
wire ibuf_b0_dec = (ibus_radr[19:12] == `IBUFB00_HEAD);
wire ibuf_b1_dec = (ibus_radr[19:12] == `IBUFB01_HEAD);
wire ibuf_a0_ren = ibus_ren & ibuf_a0_dec;
wire ibuf_a1_ren = ibus_ren & ibuf_a1_dec;
wire ibuf_b0_ren = ibus_ren & ibuf_b0_dec;
wire ibuf_b1_ren = ibus_ren & ibuf_b1_dec;

reg ibuf_a0_ren_l1;
reg ibuf_a0_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_a0_ren_l1 <= 1'b0;
         ibuf_a0_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_a0_ren_l1 <= ibuf_a0_ren;
         ibuf_a0_ren_l2 <= ibuf_a0_ren_l1;
    end
end

reg ibuf_a1_ren_l1;
reg ibuf_a1_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_a1_ren_l1 <= 1'b0;
         ibuf_a1_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_a1_ren_l1 <= ibuf_a1_ren;
         ibuf_a1_ren_l2 <= ibuf_a1_ren_l1;
    end
end

reg ibuf_b0_ren_l1;
reg ibuf_b0_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_b0_ren_l1 <= 1'b0;
         ibuf_b0_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_b0_ren_l1 <= ibuf_b0_ren;
         ibuf_b0_ren_l2 <= ibuf_b0_ren_l1;
    end
end

reg ibuf_b1_ren_l1;
reg ibuf_b1_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_b1_ren_l1 <= 1'b0;
         ibuf_b1_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_b1_ren_l1 <= ibuf_b1_ren;
         ibuf_b1_ren_l2 <= ibuf_b1_ren_l1;
    end
end
wire s_running0_0;
wire s_running1_0;
wire s_running0_1;
wire s_running1_1;

// a/b buffers

abbuf a0buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_a0_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_a0_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running0_0),
	.ff(aff0),
	.ab_in(a_in0),
	.we(awe0)
	);

abbuf a1buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_a1_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_a1_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running1_0),
	.ff(aff1),
	.ab_in(a_in1),
	.we(awe1)
	);

abbuf b0buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_b0_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_b0_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running0_0),
	.ff(bff0),
	.ab_in(b_in0),
	.we(bwe0)
	);

abbuf b1buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_b1_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_b1_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running0_1),
	.ff(bff1),
	.ab_in(b_in1),
	.we(bwe1)
	);

// outbuffer controls
// read part
wire [8:0] sbus_radr = ibus_radr[10:2];

wire sbuf_s0_0_dec = (ibus_radr[19:11] == { 1'b1, `OBUFS00_00_HEAD });
wire sbuf_s1_0_dec = (ibus_radr[19:11] == { 1'b1, `OBUFS01_00_HEAD });
wire sbuf_s0_1_dec = (ibus_radr[19:11] == { 1'b1, `OBUFS00_01_HEAD });
wire sbuf_s1_1_dec = (ibus_radr[19:11] == { 1'b1, `OBUFS01_01_HEAD });
reg sbuf_s0_0_dec_l1;
reg sbuf_s0_0_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s0_0_dec_l1 <= 1'b0;
		 sbuf_s0_0_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s0_0_dec_l1 <= sbuf_s0_0_dec;
		 sbuf_s0_0_dec_l2 <= sbuf_s0_0_dec_l1;
	end
end

reg sbuf_s1_0_dec_l1;
reg sbuf_s1_0_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s1_0_dec_l1 <= 1'b0;
		 sbuf_s1_0_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s1_0_dec_l1 <= sbuf_s1_0_dec;
		 sbuf_s1_0_dec_l2 <= sbuf_s1_0_dec_l1;
	end
end

reg sbuf_s0_1_dec_l1;
reg sbuf_s0_1_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s0_1_dec_l1 <= 1'b0;
		 sbuf_s0_1_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s0_1_dec_l1 <= sbuf_s0_1_dec;
		 sbuf_s0_1_dec_l2 <= sbuf_s0_1_dec_l1;
	end
end

reg sbuf_s1_1_dec_l1;
reg sbuf_s1_1_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s1_1_dec_l1 <= 1'b0;
		 sbuf_s1_1_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s1_1_dec_l1 <= sbuf_s1_1_dec;
		 sbuf_s1_1_dec_l2 <= sbuf_s1_1_dec_l1;
	end
end

wire [15:0] sbus_rdata0_0;
wire [15:0] sbus_rdata1_0;
wire [15:0] sbus_rdata0_1;
wire [15:0] sbus_rdata1_1;
reg [15:0] sbus_rdata0_0_lat;
reg [15:0] sbus_rdata1_0_lat;
reg [15:0] sbus_rdata0_1_lat;
reg [15:0] sbus_rdata1_1_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata0_0_lat <= 16'd0;
	else
		sbus_rdata0_0_lat <= sbus_rdata0_0;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata1_0_lat <= 16'd0;
	else
		sbus_rdata1_0_lat <= sbus_rdata1_0;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata0_1_lat <= 16'd0;
	else
		sbus_rdata0_1_lat <= sbus_rdata0_1;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata1_1_lat <= 16'd0;
	else
		sbus_rdata1_1_lat <= sbus_rdata1_1;
end
reg [15:0] a_in0_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in0_lat <= 16'd0;
	else
		a_in0_lat <= a_in0;
end
reg [15:0] a_in1_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in1_lat <= 16'd0;
	else
		a_in1_lat <= a_in1;
end
reg [15:0] b_in0_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in0_lat <= 16'd0;
	else
		b_in0_lat <= b_in0;
end
reg [15:0] b_in1_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in1_lat <= 16'd0;
	else
		b_in1_lat <= b_in1;
end

// read bus selector
assign ibus_rdata = sbuf_s0_0_dec_l2 ? sbus_rdata0_0_lat :
					sbuf_s1_0_dec_l2 ? sbus_rdata1_0_lat :
					sbuf_s0_1_dec_l2 ? sbus_rdata0_1_lat :
					sbuf_s1_1_dec_l2 ? sbus_rdata1_1_lat :
					ibuf_a0_ren_l2 ? a_in0_lat :
					ibuf_a1_ren_l2 ? a_in1_lat :
					ibuf_b0_ren_l2 ? b_in0_lat :
					ibuf_b1_ren_l2 ? b_in1_lat :
					16'd0;
wire finish0_0;
wire finish1_0;
wire finish0_1;

// s buffers

sbuf sbuf0_0 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata0_0),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running0_0),
	.finish(finish0_0),
	.s_out(s_out0_0),
	.sat(sat0_0),
	.sw(sw0_0)
	);

sbuf sbuf1_0 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata1_0),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running1_0),
	.finish(finish1_0),
	.s_out(s_out1_0),
	.sat(sat1_0),
	.sw(sw1_0)
	);

sbuf sbuf0_1 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata0_1),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running0_1),
	.finish(finish0_1),
	.s_out(s_out0_1),
	.sat(sat0_1),
	.sw(sw0_1)
	);

sbuf sbuf1_1 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata1_1),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running1_1),
	.finish(finish1_1),
	.s_out(s_out1_1),
	.sat(sat1_1),
	.sw(sw1_1)
	);

endmodule
