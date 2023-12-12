/*
 * My RISC-V RV32I CPU
 *   iobuf Module for 16 PE version
 *    Verilog code
 * 		Yoshiki Kurokawa <yoshiki.k963.com>
 * 	2021 Yoshiki Kurokawa
 * 		https://opensource.org/licenses/MIT     MIT license
 * 		0.1
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
	input aff2,
	input aff3,
	input bff0,
	input bff1,
	input bff2,
	input bff3,
	output [15:0] a_in0,
	output [15:0] b_in0,
	output [15:0] a_in1,
	output [15:0] b_in1,
	output [15:0] a_in2,
	output [15:0] b_in2,
	output [15:0] a_in3,
	output [15:0] b_in3,
	output reg [7:0] max_cntr,
	output start,
	output awe0,
	output bwe0,
	output awe1,
	output bwe1,
	output awe2,
	output bwe2,
	output awe3,
	output bwe3,
	// systolice array outbuffer interface
	input [15:0] s_out0_0,
	input [15:0] s_out1_0,
	input [15:0] s_out2_0,
	input [15:0] s_out3_0,
	input [15:0] s_out0_1,
	input [15:0] s_out1_1,
	input [15:0] s_out2_1,
	input [15:0] s_out3_1,
	input [15:0] s_out0_2,
	input [15:0] s_out1_2,
	input [15:0] s_out2_2,
	input [15:0] s_out3_2,
	input [15:0] s_out0_3,
	input [15:0] s_out1_3,
	input [15:0] s_out2_3,
	input [15:0] s_out3_3,
	input sat0_0,
	input sat1_0,
	input sat2_0,
	input sat3_0,
	input sat0_1,
	input sat1_1,
	input sat2_1,
	input sat3_1,
	input sat0_2,
	input sat1_2,
	input sat2_2,
	input sat3_2,
	input sat0_3,
	input sat1_3,
	input sat2_3,
	input sat3_3,
	input sw0_0,
	input sw1_0,
	input sw2_0,
	input sw3_0,
	input sw0_1,
	input sw1_1,
	input sw2_1,
	input sw3_1,
	input sw0_2,
	input sw1_2,
	input sw2_2,
	input sw3_2,
	input sw0_3,
	input sw1_3,
	input sw2_3,
	input sw3_3
	);
`define IBUFA0_HEAD 6'h00
`define IBUFA1_HEAD 6'h01
`define IBUFA2_HEAD 6'h02
`define IBUFA3_HEAD 6'h03
`define IBUFB0_HEAD 6'h04
`define IBUFB1_HEAD 6'h05
`define IBUFB2_HEAD 6'h06
`define IBUFB3_HEAD 6'h07
`define OBUFS0_0_HEAD 7'h40
`define OBUFS1_0_HEAD 7'h41
`define OBUFS2_0_HEAD 7'h42
`define OBUFS3_0_HEAD 7'h43
`define OBUFS0_1_HEAD 7'h44
`define OBUFS1_1_HEAD 7'h45
`define OBUFS2_1_HEAD 7'h46
`define OBUFS3_1_HEAD 7'h47
`define OBUFS0_2_HEAD 7'h48
`define OBUFS1_2_HEAD 7'h49
`define OBUFS2_2_HEAD 7'h410
`define OBUFS3_2_HEAD 7'h411
`define OBUFS0_3_HEAD 7'h412
`define OBUFS1_3_HEAD 7'h413
`define OBUFS2_3_HEAD 7'h414
`define OBUFS3_3_HEAD 7'h415
`define SYS_START_ADR 16'hFFF0
`define SYS_MAX_CNTR 16'hFFF1
`define SYS_RUN_CNTR 16'hFFF2

// 1shot start bit
wire write_start = wen & (ibus_wadr == `SYS_START_ADR);
reg run_status;
wire finish3_3;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_status <= 1'b0;
	else if (finish3_3)
        run_status <= 1'b0;
	else if (write_start)
        run_status <= 1'b1;
end

assign start = write_start & ~run_status;

reg status_read_en;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		status_read_en <= 1'b0;
	else
		status_read_en <= ren & (ibus_radr == `SYS_START_ADR);
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
wire [9:0] abbus_wadr = ibus_wadr[9:0];
wire ibuf_a0_wen = wen & (ibus_wadr[15:10] == `IBUFA0_HEAD);
wire ibuf_a1_wen = wen & (ibus_wadr[15:10] == `IBUFA1_HEAD);
wire ibuf_a2_wen = wen & (ibus_wadr[15:10] == `IBUFA2_HEAD);
wire ibuf_a3_wen = wen & (ibus_wadr[15:10] == `IBUFA3_HEAD);
wire ibuf_b0_wen = wen & (ibus_wadr[15:10] == `IBUFB0_HEAD);
wire ibuf_b1_wen = wen & (ibus_wadr[15:10] == `IBUFB1_HEAD);
wire ibuf_b2_wen = wen & (ibus_wadr[15:10] == `IBUFB2_HEAD);
wire ibuf_b3_wen = wen & (ibus_wadr[15:10] == `IBUFB3_HEAD);

wire [9:0] abbus_radr = ibus_radr[9:0];
wire ibuf_a0_dec = (ibus_radr[15:10] == `IBUFA0_HEAD);
wire ibuf_a1_dec = (ibus_radr[15:10] == `IBUFA1_HEAD);
wire ibuf_a2_dec = (ibus_radr[15:10] == `IBUFA2_HEAD);
wire ibuf_a3_dec = (ibus_radr[15:10] == `IBUFA3_HEAD);
wire ibuf_b0_dec = (ibus_radr[15:10] == `IBUFB0_HEAD);
wire ibuf_b1_dec = (ibus_radr[15:10] == `IBUFB1_HEAD);
wire ibuf_b2_dec = (ibus_radr[15:10] == `IBUFB2_HEAD);
wire ibuf_b3_dec = (ibus_radr[15:10] == `IBUFB3_HEAD);
wire ibuf_a0_ren = ren & ibuf_a0_dec;
wire ibuf_a1_ren = ren & ibuf_a1_dec;
wire ibuf_a2_ren = ren & ibuf_a2_dec;
wire ibuf_a3_ren = ren & ibuf_a3_dec;
wire ibuf_b0_ren = ren & ibuf_b0_dec;
wire ibuf_b1_ren = ren & ibuf_b1_dec;
wire ibuf_b2_ren = ren & ibuf_b2_dec;
wire ibuf_b3_ren = ren & ibuf_b3_dec;
wire s_running0_0;
wire s_running1_0;
wire s_running2_0;
wire s_running3_0;
wire s_running0_1;
wire s_running1_1;
wire s_running2_1;
wire s_running3_1;
wire s_running0_2;
wire s_running1_2;
wire s_running2_2;
wire s_running3_2;
wire s_running0_3;
wire s_running1_3;
wire s_running2_3;
wire s_running3_3;

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

abbuf a2buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_a2_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_a2_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running2_0),
	.ff(aff2),
	.ab_in(a_in2),
	.we(awe2)
	);

abbuf a3buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_a3_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_a3_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running3_0),
	.ff(aff3),
	.ab_in(a_in3),
	.we(awe3)
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

abbuf b2buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_b2_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_b2_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running0_2),
	.ff(bff2),
	.ab_in(b_in2),
	.we(bwe2)
	);

abbuf b3buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_b3_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_b3_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running0_3),
	.ff(bff3),
	.ab_in(b_in3),
	.we(bwe3)
	);

// outbuffer controls
// read part
wire [8:0] sbus_radr = ibus_radr[8:0];

wire sbuf_s0_0_dec = (ibus_radr[15:9] == `OBUFS0_0_HEAD);
wire sbuf_s1_0_dec = (ibus_radr[15:9] == `OBUFS1_0_HEAD);
wire sbuf_s2_0_dec = (ibus_radr[15:9] == `OBUFS2_0_HEAD);
wire sbuf_s3_0_dec = (ibus_radr[15:9] == `OBUFS3_0_HEAD);
wire sbuf_s0_1_dec = (ibus_radr[15:9] == `OBUFS0_1_HEAD);
wire sbuf_s1_1_dec = (ibus_radr[15:9] == `OBUFS1_1_HEAD);
wire sbuf_s2_1_dec = (ibus_radr[15:9] == `OBUFS2_1_HEAD);
wire sbuf_s3_1_dec = (ibus_radr[15:9] == `OBUFS3_1_HEAD);
wire sbuf_s0_2_dec = (ibus_radr[15:9] == `OBUFS0_2_HEAD);
wire sbuf_s1_2_dec = (ibus_radr[15:9] == `OBUFS1_2_HEAD);
wire sbuf_s2_2_dec = (ibus_radr[15:9] == `OBUFS2_2_HEAD);
wire sbuf_s3_2_dec = (ibus_radr[15:9] == `OBUFS3_2_HEAD);
wire sbuf_s0_3_dec = (ibus_radr[15:9] == `OBUFS0_3_HEAD);
wire sbuf_s1_3_dec = (ibus_radr[15:9] == `OBUFS1_3_HEAD);
wire sbuf_s2_3_dec = (ibus_radr[15:9] == `OBUFS2_3_HEAD);
wire sbuf_s3_3_dec = (ibus_radr[15:9] == `OBUFS3_3_HEAD);
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

reg sbuf_s2_0_dec_l1;
reg sbuf_s2_0_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s2_0_dec_l1 <= 1'b0;
		 sbuf_s2_0_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s2_0_dec_l1 <= sbuf_s2_0_dec;
		 sbuf_s2_0_dec_l2 <= sbuf_s2_0_dec_l1;
	end
end

reg sbuf_s3_0_dec_l1;
reg sbuf_s3_0_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s3_0_dec_l1 <= 1'b0;
		 sbuf_s3_0_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s3_0_dec_l1 <= sbuf_s3_0_dec;
		 sbuf_s3_0_dec_l2 <= sbuf_s3_0_dec_l1;
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

reg sbuf_s2_1_dec_l1;
reg sbuf_s2_1_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s2_1_dec_l1 <= 1'b0;
		 sbuf_s2_1_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s2_1_dec_l1 <= sbuf_s2_1_dec;
		 sbuf_s2_1_dec_l2 <= sbuf_s2_1_dec_l1;
	end
end

reg sbuf_s3_1_dec_l1;
reg sbuf_s3_1_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s3_1_dec_l1 <= 1'b0;
		 sbuf_s3_1_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s3_1_dec_l1 <= sbuf_s3_1_dec;
		 sbuf_s3_1_dec_l2 <= sbuf_s3_1_dec_l1;
	end
end

reg sbuf_s0_2_dec_l1;
reg sbuf_s0_2_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s0_2_dec_l1 <= 1'b0;
		 sbuf_s0_2_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s0_2_dec_l1 <= sbuf_s0_2_dec;
		 sbuf_s0_2_dec_l2 <= sbuf_s0_2_dec_l1;
	end
end

reg sbuf_s1_2_dec_l1;
reg sbuf_s1_2_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s1_2_dec_l1 <= 1'b0;
		 sbuf_s1_2_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s1_2_dec_l1 <= sbuf_s1_2_dec;
		 sbuf_s1_2_dec_l2 <= sbuf_s1_2_dec_l1;
	end
end

reg sbuf_s2_2_dec_l1;
reg sbuf_s2_2_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s2_2_dec_l1 <= 1'b0;
		 sbuf_s2_2_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s2_2_dec_l1 <= sbuf_s2_2_dec;
		 sbuf_s2_2_dec_l2 <= sbuf_s2_2_dec_l1;
	end
end

reg sbuf_s3_2_dec_l1;
reg sbuf_s3_2_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s3_2_dec_l1 <= 1'b0;
		 sbuf_s3_2_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s3_2_dec_l1 <= sbuf_s3_2_dec;
		 sbuf_s3_2_dec_l2 <= sbuf_s3_2_dec_l1;
	end
end

reg sbuf_s0_3_dec_l1;
reg sbuf_s0_3_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s0_3_dec_l1 <= 1'b0;
		 sbuf_s0_3_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s0_3_dec_l1 <= sbuf_s0_3_dec;
		 sbuf_s0_3_dec_l2 <= sbuf_s0_3_dec_l1;
	end
end

reg sbuf_s1_3_dec_l1;
reg sbuf_s1_3_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s1_3_dec_l1 <= 1'b0;
		 sbuf_s1_3_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s1_3_dec_l1 <= sbuf_s1_3_dec;
		 sbuf_s1_3_dec_l2 <= sbuf_s1_3_dec_l1;
	end
end

reg sbuf_s2_3_dec_l1;
reg sbuf_s2_3_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s2_3_dec_l1 <= 1'b0;
		 sbuf_s2_3_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s2_3_dec_l1 <= sbuf_s2_3_dec;
		 sbuf_s2_3_dec_l2 <= sbuf_s2_3_dec_l1;
	end
end

reg sbuf_s3_3_dec_l1;
reg sbuf_s3_3_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s3_3_dec_l1 <= 1'b0;
		 sbuf_s3_3_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s3_3_dec_l1 <= sbuf_s3_3_dec;
		 sbuf_s3_3_dec_l2 <= sbuf_s3_3_dec_l1;
	end
end

wire [15:0] sbus_rdata0_0;
wire [15:0] sbus_rdata1_0;
wire [15:0] sbus_rdata2_0;
wire [15:0] sbus_rdata3_0;
wire [15:0] sbus_rdata0_1;
wire [15:0] sbus_rdata1_1;
wire [15:0] sbus_rdata2_1;
wire [15:0] sbus_rdata3_1;
wire [15:0] sbus_rdata0_2;
wire [15:0] sbus_rdata1_2;
wire [15:0] sbus_rdata2_2;
wire [15:0] sbus_rdata3_2;
wire [15:0] sbus_rdata0_3;
wire [15:0] sbus_rdata1_3;
wire [15:0] sbus_rdata2_3;
wire [15:0] sbus_rdata3_3;
reg [15:0] sbus_rdata0_0_lat;
reg [15:0] sbus_rdata1_0_lat;
reg [15:0] sbus_rdata2_0_lat;
reg [15:0] sbus_rdata3_0_lat;
reg [15:0] sbus_rdata0_1_lat;
reg [15:0] sbus_rdata1_1_lat;
reg [15:0] sbus_rdata2_1_lat;
reg [15:0] sbus_rdata3_1_lat;
reg [15:0] sbus_rdata0_2_lat;
reg [15:0] sbus_rdata1_2_lat;
reg [15:0] sbus_rdata2_2_lat;
reg [15:0] sbus_rdata3_2_lat;
reg [15:0] sbus_rdata0_3_lat;
reg [15:0] sbus_rdata1_3_lat;
reg [15:0] sbus_rdata2_3_lat;
reg [15:0] sbus_rdata3_3_lat;

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
		sbus_rdata2_0_lat <= 16'd0;
	else
		sbus_rdata2_0_lat <= sbus_rdata2_0;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata3_0_lat <= 16'd0;
	else
		sbus_rdata3_0_lat <= sbus_rdata3_0;
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

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata2_1_lat <= 16'd0;
	else
		sbus_rdata2_1_lat <= sbus_rdata2_1;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata3_1_lat <= 16'd0;
	else
		sbus_rdata3_1_lat <= sbus_rdata3_1;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata0_2_lat <= 16'd0;
	else
		sbus_rdata0_2_lat <= sbus_rdata0_2;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata1_2_lat <= 16'd0;
	else
		sbus_rdata1_2_lat <= sbus_rdata1_2;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata2_2_lat <= 16'd0;
	else
		sbus_rdata2_2_lat <= sbus_rdata2_2;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata3_2_lat <= 16'd0;
	else
		sbus_rdata3_2_lat <= sbus_rdata3_2;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata0_3_lat <= 16'd0;
	else
		sbus_rdata0_3_lat <= sbus_rdata0_3;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata1_3_lat <= 16'd0;
	else
		sbus_rdata1_3_lat <= sbus_rdata1_3;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata2_3_lat <= 16'd0;
	else
		sbus_rdata2_3_lat <= sbus_rdata2_3;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata3_3_lat <= 16'd0;
	else
		sbus_rdata3_3_lat <= sbus_rdata3_3;
end
reg a_in0_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in0_lat <= 16'd0;
	else
		a_in0_lat <= a_in0;
end
reg a_in1_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in1_lat <= 16'd0;
	else
		a_in1_lat <= a_in1;
end
reg a_in2_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in2_lat <= 16'd0;
	else
		a_in2_lat <= a_in2;
end
reg a_in3_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in3_lat <= 16'd0;
	else
		a_in3_lat <= a_in3;
end
reg b_in0_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in0_lat <= 16'd0;
	else
		b_in0_lat <= b_in0;
end
reg b_in1_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in1_lat <= 16'd0;
	else
		b_in1_lat <= b_in1;
end
reg b_in2_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in2_lat <= 16'd0;
	else
		b_in2_lat <= b_in2;
end
reg b_in3_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in3_lat <= 16'd0;
	else
		b_in3_lat <= b_in3;
end

// read bus selector
assign ibus_rdata = sbuf_s0_0_dec_l2 ? sbus_rdata0_0_lat :
					sbuf_s1_0_dec_l2 ? sbus_rdata1_0_lat :
					sbuf_s2_0_dec_l2 ? sbus_rdata2_0_lat :
					sbuf_s3_0_dec_l2 ? sbus_rdata3_0_lat :
					sbuf_s0_1_dec_l2 ? sbus_rdata0_1_lat :
					sbuf_s1_1_dec_l2 ? sbus_rdata1_1_lat :
					sbuf_s2_1_dec_l2 ? sbus_rdata2_1_lat :
					sbuf_s3_1_dec_l2 ? sbus_rdata3_1_lat :
					sbuf_s0_2_dec_l2 ? sbus_rdata0_2_lat :
					sbuf_s1_2_dec_l2 ? sbus_rdata1_2_lat :
					sbuf_s2_2_dec_l2 ? sbus_rdata2_2_lat :
					sbuf_s3_2_dec_l2 ? sbus_rdata3_2_lat :
					sbuf_s0_3_dec_l2 ? sbus_rdata0_3_lat :
					sbuf_s1_3_dec_l2 ? sbus_rdata1_3_lat :
					sbuf_s2_3_dec_l2 ? sbus_rdata2_3_lat :
					sbuf_s3_3_dec_l2 ? sbus_rdata3_3_lat :
					ibuf_a0_dec ? a_in0_lat :
					ibuf_a1_dec ? a_in1_lat :
					ibuf_a2_dec ? a_in2_lat :
					ibuf_a3_dec ? a_in3_lat :
					ibuf_b0_dec ? b_in0_lat :
					ibuf_b1_dec ? b_in1_lat :
					ibuf_b2_dec ? b_in2_lat :
					ibuf_b3_dec ? b_in3_lat :
					status_read_en ? { 15'd0, run_status} : 16'd0;
wire finish0_0;
wire finish1_0;
wire finish2_0;
wire finish3_0;
wire finish0_1;
wire finish1_1;
wire finish2_1;
wire finish3_1;
wire finish0_2;
wire finish1_2;
wire finish2_2;
wire finish3_2;
wire finish0_3;
wire finish1_3;
wire finish2_3;

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

sbuf sbuf2_0 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata2_0),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running2_0),
	.finish(finish2_0),
	.s_out(s_out2_0),
	.sat(sat2_0),
	.sw(sw2_0)
	);

sbuf sbuf3_0 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata3_0),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running3_0),
	.finish(finish3_0),
	.s_out(s_out3_0),
	.sat(sat3_0),
	.sw(sw3_0)
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

sbuf sbuf2_1 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata2_1),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running2_1),
	.finish(finish2_1),
	.s_out(s_out2_1),
	.sat(sat2_1),
	.sw(sw2_1)
	);

sbuf sbuf3_1 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata3_1),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running3_1),
	.finish(finish3_1),
	.s_out(s_out3_1),
	.sat(sat3_1),
	.sw(sw3_1)
	);

sbuf sbuf0_2 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata0_2),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running0_2),
	.finish(finish0_2),
	.s_out(s_out0_2),
	.sat(sat0_2),
	.sw(sw0_2)
	);

sbuf sbuf1_2 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata1_2),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running1_2),
	.finish(finish1_2),
	.s_out(s_out1_2),
	.sat(sat1_2),
	.sw(sw1_2)
	);

sbuf sbuf2_2 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata2_2),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running2_2),
	.finish(finish2_2),
	.s_out(s_out2_2),
	.sat(sat2_2),
	.sw(sw2_2)
	);

sbuf sbuf3_2 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata3_2),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running3_2),
	.finish(finish3_2),
	.s_out(s_out3_2),
	.sat(sat3_2),
	.sw(sw3_2)
	);

sbuf sbuf0_3 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata0_3),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running0_3),
	.finish(finish0_3),
	.s_out(s_out0_3),
	.sat(sat0_3),
	.sw(sw0_3)
	);

sbuf sbuf1_3 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata1_3),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running1_3),
	.finish(finish1_3),
	.s_out(s_out1_3),
	.sat(sat1_3),
	.sw(sw1_3)
	);

sbuf sbuf2_3 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata2_3),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running2_3),
	.finish(finish2_3),
	.s_out(s_out2_3),
	.sat(sat2_3),
	.sw(sw2_3)
	);

sbuf sbuf3_3 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata3_3),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running3_3),
	.finish(finish3_3),
	.s_out(s_out3_3),
	.sat(sat3_3),
	.sw(sw3_3)
	);

endmodule
