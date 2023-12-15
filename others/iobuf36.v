/*
 * My RISC-V RV32I CPU
 *   iobuf Module for 36 PE version
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
	input [15:0] dma_io_wdata,
	input [15:2] dma_io_radr,
	input [15:0] dma_io_rdata_in,
	output [15:0] dma_io_rdata,
	// ram interface
	input ibus_ren,
	input [15:2] ibus_radr,
	output [15:0] ibus_rdata,
	input ibus_wen,
	input [15:2] ibus_wadr,
	input [15:0] ibus_wdata,

	// systolice array inbuffer interface
	input aff0,
	input aff1,
	input aff2,
	input aff3,
	input aff4,
	input aff5,
	input bff0,
	input bff1,
	input bff2,
	input bff3,
	input bff4,
	input bff5,
	output [15:0] a_in0,
	output [15:0] b_in0,
	output [15:0] a_in1,
	output [15:0] b_in1,
	output [15:0] a_in2,
	output [15:0] b_in2,
	output [15:0] a_in3,
	output [15:0] b_in3,
	output [15:0] a_in4,
	output [15:0] b_in4,
	output [15:0] a_in5,
	output [15:0] b_in5,
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
	output awe4,
	output bwe4,
	output awe5,
	output bwe5,
	// systolice array outbuffer interface
	input [15:0] s_out0_0,
	input [15:0] s_out1_0,
	input [15:0] s_out2_0,
	input [15:0] s_out3_0,
	input [15:0] s_out4_0,
	input [15:0] s_out5_0,
	input [15:0] s_out0_1,
	input [15:0] s_out1_1,
	input [15:0] s_out2_1,
	input [15:0] s_out3_1,
	input [15:0] s_out4_1,
	input [15:0] s_out5_1,
	input [15:0] s_out0_2,
	input [15:0] s_out1_2,
	input [15:0] s_out2_2,
	input [15:0] s_out3_2,
	input [15:0] s_out4_2,
	input [15:0] s_out5_2,
	input [15:0] s_out0_3,
	input [15:0] s_out1_3,
	input [15:0] s_out2_3,
	input [15:0] s_out3_3,
	input [15:0] s_out4_3,
	input [15:0] s_out5_3,
	input [15:0] s_out0_4,
	input [15:0] s_out1_4,
	input [15:0] s_out2_4,
	input [15:0] s_out3_4,
	input [15:0] s_out4_4,
	input [15:0] s_out5_4,
	input [15:0] s_out0_5,
	input [15:0] s_out1_5,
	input [15:0] s_out2_5,
	input [15:0] s_out3_5,
	input [15:0] s_out4_5,
	input [15:0] s_out5_5,
	input sat0_0,
	input sat1_0,
	input sat2_0,
	input sat3_0,
	input sat4_0,
	input sat5_0,
	input sat0_1,
	input sat1_1,
	input sat2_1,
	input sat3_1,
	input sat4_1,
	input sat5_1,
	input sat0_2,
	input sat1_2,
	input sat2_2,
	input sat3_2,
	input sat4_2,
	input sat5_2,
	input sat0_3,
	input sat1_3,
	input sat2_3,
	input sat3_3,
	input sat4_3,
	input sat5_3,
	input sat0_4,
	input sat1_4,
	input sat2_4,
	input sat3_4,
	input sat4_4,
	input sat5_4,
	input sat0_5,
	input sat1_5,
	input sat2_5,
	input sat3_5,
	input sat4_5,
	input sat5_5,
	input sw0_0,
	input sw1_0,
	input sw2_0,
	input sw3_0,
	input sw4_0,
	input sw5_0,
	input sw0_1,
	input sw1_1,
	input sw2_1,
	input sw3_1,
	input sw4_1,
	input sw5_1,
	input sw0_2,
	input sw1_2,
	input sw2_2,
	input sw3_2,
	input sw4_2,
	input sw5_2,
	input sw0_3,
	input sw1_3,
	input sw2_3,
	input sw3_3,
	input sw4_3,
	input sw5_3,
	input sw0_4,
	input sw1_4,
	input sw2_4,
	input sw3_4,
	input sw4_4,
	input sw5_4,
	input sw0_5,
	input sw1_5,
	input sw2_5,
	input sw3_5,
	input sw4_5,
	input sw5_5
	);
`define IBUFA0_HEAD 4'h0
`define IBUFA1_HEAD 4'h1
`define IBUFA2_HEAD 4'h2
`define IBUFA3_HEAD 4'h3
`define IBUFA4_HEAD 4'h4
`define IBUFA5_HEAD 4'h5
`define IBUFB0_HEAD 4'h6
`define IBUFB1_HEAD 4'h7
`define IBUFB2_HEAD 4'h8
`define IBUFB3_HEAD 4'h9
`define IBUFB4_HEAD 4'h10
`define IBUFB5_HEAD 4'h11
`define OBUFS0_0_HEAD 5'h10
`define OBUFS1_0_HEAD 5'h11
`define OBUFS2_0_HEAD 5'h12
`define OBUFS3_0_HEAD 5'h13
`define OBUFS4_0_HEAD 5'h14
`define OBUFS5_0_HEAD 5'h15
`define OBUFS0_1_HEAD 5'h16
`define OBUFS1_1_HEAD 5'h17
`define OBUFS2_1_HEAD 5'h18
`define OBUFS3_1_HEAD 5'h19
`define OBUFS4_1_HEAD 5'h110
`define OBUFS5_1_HEAD 5'h111
`define OBUFS0_2_HEAD 5'h112
`define OBUFS1_2_HEAD 5'h113
`define OBUFS2_2_HEAD 5'h114
`define OBUFS3_2_HEAD 5'h115
`define OBUFS4_2_HEAD 5'h116
`define OBUFS5_2_HEAD 5'h117
`define OBUFS0_3_HEAD 5'h118
`define OBUFS1_3_HEAD 5'h119
`define OBUFS2_3_HEAD 5'h120
`define OBUFS3_3_HEAD 5'h121
`define OBUFS4_3_HEAD 5'h122
`define OBUFS5_3_HEAD 5'h123
`define OBUFS0_4_HEAD 5'h124
`define OBUFS1_4_HEAD 5'h125
`define OBUFS2_4_HEAD 5'h126
`define OBUFS3_4_HEAD 5'h127
`define OBUFS4_4_HEAD 5'h128
`define OBUFS5_4_HEAD 5'h129
`define OBUFS0_5_HEAD 5'h130
`define OBUFS1_5_HEAD 5'h131
`define OBUFS2_5_HEAD 5'h132
`define OBUFS3_5_HEAD 5'h133
`define OBUFS4_5_HEAD 5'h134
`define OBUFS5_5_HEAD 5'h135
`define SYS_START_ADR 14'h3FF8
`define SYS_MAX_CNTR 14'h3FF9
`define SYS_RUN_CNTR 14'h3FFa

// 1shot start bit
wire write_start = dma_io_we & (dma_io_wadr == `SYS_START_ADR);
reg run_status;
wire finish5_5;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_status <= 1'b0;
	else if (finish5_5)
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

assign dma_io_rdata = re_run_status ? { 15'd0, run_status } :
					  re_run_maxcntr ? { 8'd0, max_cntr } :
					  re_run_runcntr ? { 8'd0, run_cntr } : dma_io_rdata_in;

// input buffer controls
// write part
wire [9:0] abbus_wadr = ibus_wadr[11:2];
wire ibuf_a0_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFA0_HEAD);
wire ibuf_a1_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFA1_HEAD);
wire ibuf_a2_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFA2_HEAD);
wire ibuf_a3_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFA3_HEAD);
wire ibuf_a4_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFA4_HEAD);
wire ibuf_a5_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFA5_HEAD);
wire ibuf_b0_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFB0_HEAD);
wire ibuf_b1_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFB1_HEAD);
wire ibuf_b2_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFB2_HEAD);
wire ibuf_b3_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFB3_HEAD);
wire ibuf_b4_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFB4_HEAD);
wire ibuf_b5_wen = ibus_wen & (ibus_wadr[15:12] == `IBUFB5_HEAD);

wire [9:0] abbus_radr = ibus_radr[11:2];
wire ibuf_a0_dec = (ibus_radr[15:12] == `IBUFA0_HEAD);
wire ibuf_a1_dec = (ibus_radr[15:12] == `IBUFA1_HEAD);
wire ibuf_a2_dec = (ibus_radr[15:12] == `IBUFA2_HEAD);
wire ibuf_a3_dec = (ibus_radr[15:12] == `IBUFA3_HEAD);
wire ibuf_a4_dec = (ibus_radr[15:12] == `IBUFA4_HEAD);
wire ibuf_a5_dec = (ibus_radr[15:12] == `IBUFA5_HEAD);
wire ibuf_b0_dec = (ibus_radr[15:12] == `IBUFB0_HEAD);
wire ibuf_b1_dec = (ibus_radr[15:12] == `IBUFB1_HEAD);
wire ibuf_b2_dec = (ibus_radr[15:12] == `IBUFB2_HEAD);
wire ibuf_b3_dec = (ibus_radr[15:12] == `IBUFB3_HEAD);
wire ibuf_b4_dec = (ibus_radr[15:12] == `IBUFB4_HEAD);
wire ibuf_b5_dec = (ibus_radr[15:12] == `IBUFB5_HEAD);
wire ibuf_a0_ren = ibus_ren & ibuf_a0_dec;
wire ibuf_a1_ren = ibus_ren & ibuf_a1_dec;
wire ibuf_a2_ren = ibus_ren & ibuf_a2_dec;
wire ibuf_a3_ren = ibus_ren & ibuf_a3_dec;
wire ibuf_a4_ren = ibus_ren & ibuf_a4_dec;
wire ibuf_a5_ren = ibus_ren & ibuf_a5_dec;
wire ibuf_b0_ren = ibus_ren & ibuf_b0_dec;
wire ibuf_b1_ren = ibus_ren & ibuf_b1_dec;
wire ibuf_b2_ren = ibus_ren & ibuf_b2_dec;
wire ibuf_b3_ren = ibus_ren & ibuf_b3_dec;
wire ibuf_b4_ren = ibus_ren & ibuf_b4_dec;
wire ibuf_b5_ren = ibus_ren & ibuf_b5_dec;

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

reg ibuf_a2_ren_l1;
reg ibuf_a2_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_a2_ren_l1 <= 1'b0;
         ibuf_a2_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_a2_ren_l1 <= ibuf_a2_ren;
         ibuf_a2_ren_l2 <= ibuf_a2_ren_l1;
    end
end

reg ibuf_a3_ren_l1;
reg ibuf_a3_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_a3_ren_l1 <= 1'b0;
         ibuf_a3_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_a3_ren_l1 <= ibuf_a3_ren;
         ibuf_a3_ren_l2 <= ibuf_a3_ren_l1;
    end
end

reg ibuf_a4_ren_l1;
reg ibuf_a4_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_a4_ren_l1 <= 1'b0;
         ibuf_a4_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_a4_ren_l1 <= ibuf_a4_ren;
         ibuf_a4_ren_l2 <= ibuf_a4_ren_l1;
    end
end

reg ibuf_a5_ren_l1;
reg ibuf_a5_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_a5_ren_l1 <= 1'b0;
         ibuf_a5_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_a5_ren_l1 <= ibuf_a5_ren;
         ibuf_a5_ren_l2 <= ibuf_a5_ren_l1;
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

reg ibuf_b2_ren_l1;
reg ibuf_b2_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_b2_ren_l1 <= 1'b0;
         ibuf_b2_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_b2_ren_l1 <= ibuf_b2_ren;
         ibuf_b2_ren_l2 <= ibuf_b2_ren_l1;
    end
end

reg ibuf_b3_ren_l1;
reg ibuf_b3_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_b3_ren_l1 <= 1'b0;
         ibuf_b3_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_b3_ren_l1 <= ibuf_b3_ren;
         ibuf_b3_ren_l2 <= ibuf_b3_ren_l1;
    end
end

reg ibuf_b4_ren_l1;
reg ibuf_b4_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_b4_ren_l1 <= 1'b0;
         ibuf_b4_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_b4_ren_l1 <= ibuf_b4_ren;
         ibuf_b4_ren_l2 <= ibuf_b4_ren_l1;
    end
end

reg ibuf_b5_ren_l1;
reg ibuf_b5_ren_l2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
         ibuf_b5_ren_l1 <= 1'b0;
         ibuf_b5_ren_l2 <= 1'b0;
    end
    else begin
         ibuf_b5_ren_l1 <= ibuf_b5_ren;
         ibuf_b5_ren_l2 <= ibuf_b5_ren_l1;
    end
end
wire s_running0_0;
wire s_running1_0;
wire s_running2_0;
wire s_running3_0;
wire s_running4_0;
wire s_running5_0;
wire s_running0_1;
wire s_running1_1;
wire s_running2_1;
wire s_running3_1;
wire s_running4_1;
wire s_running5_1;
wire s_running0_2;
wire s_running1_2;
wire s_running2_2;
wire s_running3_2;
wire s_running4_2;
wire s_running5_2;
wire s_running0_3;
wire s_running1_3;
wire s_running2_3;
wire s_running3_3;
wire s_running4_3;
wire s_running5_3;
wire s_running0_4;
wire s_running1_4;
wire s_running2_4;
wire s_running3_4;
wire s_running4_4;
wire s_running5_4;
wire s_running0_5;
wire s_running1_5;
wire s_running2_5;
wire s_running3_5;
wire s_running4_5;
wire s_running5_5;

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

abbuf a4buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_a4_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_a4_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running4_0),
	.ff(aff4),
	.ab_in(a_in4),
	.we(awe4)
	);

abbuf a5buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_a5_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_a5_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running5_0),
	.ff(aff5),
	.ab_in(a_in5),
	.we(awe5)
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

abbuf b4buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_b4_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_b4_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running0_4),
	.ff(bff4),
	.ab_in(b_in4),
	.we(bwe4)
	);

abbuf b5buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_b5_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_b5_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running0_5),
	.ff(bff5),
	.ab_in(b_in5),
	.we(bwe5)
	);

// outbuffer controls
// read part
wire [8:0] sbus_radr = ibus_radr[10:2];

wire sbuf_s0_0_dec = (ibus_radr[15:11] == `OBUFS0_0_HEAD);
wire sbuf_s1_0_dec = (ibus_radr[15:11] == `OBUFS1_0_HEAD);
wire sbuf_s2_0_dec = (ibus_radr[15:11] == `OBUFS2_0_HEAD);
wire sbuf_s3_0_dec = (ibus_radr[15:11] == `OBUFS3_0_HEAD);
wire sbuf_s4_0_dec = (ibus_radr[15:11] == `OBUFS4_0_HEAD);
wire sbuf_s5_0_dec = (ibus_radr[15:11] == `OBUFS5_0_HEAD);
wire sbuf_s0_1_dec = (ibus_radr[15:11] == `OBUFS0_1_HEAD);
wire sbuf_s1_1_dec = (ibus_radr[15:11] == `OBUFS1_1_HEAD);
wire sbuf_s2_1_dec = (ibus_radr[15:11] == `OBUFS2_1_HEAD);
wire sbuf_s3_1_dec = (ibus_radr[15:11] == `OBUFS3_1_HEAD);
wire sbuf_s4_1_dec = (ibus_radr[15:11] == `OBUFS4_1_HEAD);
wire sbuf_s5_1_dec = (ibus_radr[15:11] == `OBUFS5_1_HEAD);
wire sbuf_s0_2_dec = (ibus_radr[15:11] == `OBUFS0_2_HEAD);
wire sbuf_s1_2_dec = (ibus_radr[15:11] == `OBUFS1_2_HEAD);
wire sbuf_s2_2_dec = (ibus_radr[15:11] == `OBUFS2_2_HEAD);
wire sbuf_s3_2_dec = (ibus_radr[15:11] == `OBUFS3_2_HEAD);
wire sbuf_s4_2_dec = (ibus_radr[15:11] == `OBUFS4_2_HEAD);
wire sbuf_s5_2_dec = (ibus_radr[15:11] == `OBUFS5_2_HEAD);
wire sbuf_s0_3_dec = (ibus_radr[15:11] == `OBUFS0_3_HEAD);
wire sbuf_s1_3_dec = (ibus_radr[15:11] == `OBUFS1_3_HEAD);
wire sbuf_s2_3_dec = (ibus_radr[15:11] == `OBUFS2_3_HEAD);
wire sbuf_s3_3_dec = (ibus_radr[15:11] == `OBUFS3_3_HEAD);
wire sbuf_s4_3_dec = (ibus_radr[15:11] == `OBUFS4_3_HEAD);
wire sbuf_s5_3_dec = (ibus_radr[15:11] == `OBUFS5_3_HEAD);
wire sbuf_s0_4_dec = (ibus_radr[15:11] == `OBUFS0_4_HEAD);
wire sbuf_s1_4_dec = (ibus_radr[15:11] == `OBUFS1_4_HEAD);
wire sbuf_s2_4_dec = (ibus_radr[15:11] == `OBUFS2_4_HEAD);
wire sbuf_s3_4_dec = (ibus_radr[15:11] == `OBUFS3_4_HEAD);
wire sbuf_s4_4_dec = (ibus_radr[15:11] == `OBUFS4_4_HEAD);
wire sbuf_s5_4_dec = (ibus_radr[15:11] == `OBUFS5_4_HEAD);
wire sbuf_s0_5_dec = (ibus_radr[15:11] == `OBUFS0_5_HEAD);
wire sbuf_s1_5_dec = (ibus_radr[15:11] == `OBUFS1_5_HEAD);
wire sbuf_s2_5_dec = (ibus_radr[15:11] == `OBUFS2_5_HEAD);
wire sbuf_s3_5_dec = (ibus_radr[15:11] == `OBUFS3_5_HEAD);
wire sbuf_s4_5_dec = (ibus_radr[15:11] == `OBUFS4_5_HEAD);
wire sbuf_s5_5_dec = (ibus_radr[15:11] == `OBUFS5_5_HEAD);
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

reg sbuf_s4_0_dec_l1;
reg sbuf_s4_0_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s4_0_dec_l1 <= 1'b0;
		 sbuf_s4_0_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s4_0_dec_l1 <= sbuf_s4_0_dec;
		 sbuf_s4_0_dec_l2 <= sbuf_s4_0_dec_l1;
	end
end

reg sbuf_s5_0_dec_l1;
reg sbuf_s5_0_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s5_0_dec_l1 <= 1'b0;
		 sbuf_s5_0_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s5_0_dec_l1 <= sbuf_s5_0_dec;
		 sbuf_s5_0_dec_l2 <= sbuf_s5_0_dec_l1;
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

reg sbuf_s4_1_dec_l1;
reg sbuf_s4_1_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s4_1_dec_l1 <= 1'b0;
		 sbuf_s4_1_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s4_1_dec_l1 <= sbuf_s4_1_dec;
		 sbuf_s4_1_dec_l2 <= sbuf_s4_1_dec_l1;
	end
end

reg sbuf_s5_1_dec_l1;
reg sbuf_s5_1_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s5_1_dec_l1 <= 1'b0;
		 sbuf_s5_1_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s5_1_dec_l1 <= sbuf_s5_1_dec;
		 sbuf_s5_1_dec_l2 <= sbuf_s5_1_dec_l1;
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

reg sbuf_s4_2_dec_l1;
reg sbuf_s4_2_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s4_2_dec_l1 <= 1'b0;
		 sbuf_s4_2_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s4_2_dec_l1 <= sbuf_s4_2_dec;
		 sbuf_s4_2_dec_l2 <= sbuf_s4_2_dec_l1;
	end
end

reg sbuf_s5_2_dec_l1;
reg sbuf_s5_2_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s5_2_dec_l1 <= 1'b0;
		 sbuf_s5_2_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s5_2_dec_l1 <= sbuf_s5_2_dec;
		 sbuf_s5_2_dec_l2 <= sbuf_s5_2_dec_l1;
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

reg sbuf_s4_3_dec_l1;
reg sbuf_s4_3_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s4_3_dec_l1 <= 1'b0;
		 sbuf_s4_3_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s4_3_dec_l1 <= sbuf_s4_3_dec;
		 sbuf_s4_3_dec_l2 <= sbuf_s4_3_dec_l1;
	end
end

reg sbuf_s5_3_dec_l1;
reg sbuf_s5_3_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s5_3_dec_l1 <= 1'b0;
		 sbuf_s5_3_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s5_3_dec_l1 <= sbuf_s5_3_dec;
		 sbuf_s5_3_dec_l2 <= sbuf_s5_3_dec_l1;
	end
end

reg sbuf_s0_4_dec_l1;
reg sbuf_s0_4_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s0_4_dec_l1 <= 1'b0;
		 sbuf_s0_4_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s0_4_dec_l1 <= sbuf_s0_4_dec;
		 sbuf_s0_4_dec_l2 <= sbuf_s0_4_dec_l1;
	end
end

reg sbuf_s1_4_dec_l1;
reg sbuf_s1_4_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s1_4_dec_l1 <= 1'b0;
		 sbuf_s1_4_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s1_4_dec_l1 <= sbuf_s1_4_dec;
		 sbuf_s1_4_dec_l2 <= sbuf_s1_4_dec_l1;
	end
end

reg sbuf_s2_4_dec_l1;
reg sbuf_s2_4_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s2_4_dec_l1 <= 1'b0;
		 sbuf_s2_4_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s2_4_dec_l1 <= sbuf_s2_4_dec;
		 sbuf_s2_4_dec_l2 <= sbuf_s2_4_dec_l1;
	end
end

reg sbuf_s3_4_dec_l1;
reg sbuf_s3_4_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s3_4_dec_l1 <= 1'b0;
		 sbuf_s3_4_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s3_4_dec_l1 <= sbuf_s3_4_dec;
		 sbuf_s3_4_dec_l2 <= sbuf_s3_4_dec_l1;
	end
end

reg sbuf_s4_4_dec_l1;
reg sbuf_s4_4_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s4_4_dec_l1 <= 1'b0;
		 sbuf_s4_4_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s4_4_dec_l1 <= sbuf_s4_4_dec;
		 sbuf_s4_4_dec_l2 <= sbuf_s4_4_dec_l1;
	end
end

reg sbuf_s5_4_dec_l1;
reg sbuf_s5_4_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s5_4_dec_l1 <= 1'b0;
		 sbuf_s5_4_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s5_4_dec_l1 <= sbuf_s5_4_dec;
		 sbuf_s5_4_dec_l2 <= sbuf_s5_4_dec_l1;
	end
end

reg sbuf_s0_5_dec_l1;
reg sbuf_s0_5_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s0_5_dec_l1 <= 1'b0;
		 sbuf_s0_5_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s0_5_dec_l1 <= sbuf_s0_5_dec;
		 sbuf_s0_5_dec_l2 <= sbuf_s0_5_dec_l1;
	end
end

reg sbuf_s1_5_dec_l1;
reg sbuf_s1_5_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s1_5_dec_l1 <= 1'b0;
		 sbuf_s1_5_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s1_5_dec_l1 <= sbuf_s1_5_dec;
		 sbuf_s1_5_dec_l2 <= sbuf_s1_5_dec_l1;
	end
end

reg sbuf_s2_5_dec_l1;
reg sbuf_s2_5_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s2_5_dec_l1 <= 1'b0;
		 sbuf_s2_5_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s2_5_dec_l1 <= sbuf_s2_5_dec;
		 sbuf_s2_5_dec_l2 <= sbuf_s2_5_dec_l1;
	end
end

reg sbuf_s3_5_dec_l1;
reg sbuf_s3_5_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s3_5_dec_l1 <= 1'b0;
		 sbuf_s3_5_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s3_5_dec_l1 <= sbuf_s3_5_dec;
		 sbuf_s3_5_dec_l2 <= sbuf_s3_5_dec_l1;
	end
end

reg sbuf_s4_5_dec_l1;
reg sbuf_s4_5_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s4_5_dec_l1 <= 1'b0;
		 sbuf_s4_5_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s4_5_dec_l1 <= sbuf_s4_5_dec;
		 sbuf_s4_5_dec_l2 <= sbuf_s4_5_dec_l1;
	end
end

reg sbuf_s5_5_dec_l1;
reg sbuf_s5_5_dec_l2;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		 sbuf_s5_5_dec_l1 <= 1'b0;
		 sbuf_s5_5_dec_l2 <= 1'b0;
	end
	else begin
		 sbuf_s5_5_dec_l1 <= sbuf_s5_5_dec;
		 sbuf_s5_5_dec_l2 <= sbuf_s5_5_dec_l1;
	end
end

wire [15:0] sbus_rdata0_0;
wire [15:0] sbus_rdata1_0;
wire [15:0] sbus_rdata2_0;
wire [15:0] sbus_rdata3_0;
wire [15:0] sbus_rdata4_0;
wire [15:0] sbus_rdata5_0;
wire [15:0] sbus_rdata0_1;
wire [15:0] sbus_rdata1_1;
wire [15:0] sbus_rdata2_1;
wire [15:0] sbus_rdata3_1;
wire [15:0] sbus_rdata4_1;
wire [15:0] sbus_rdata5_1;
wire [15:0] sbus_rdata0_2;
wire [15:0] sbus_rdata1_2;
wire [15:0] sbus_rdata2_2;
wire [15:0] sbus_rdata3_2;
wire [15:0] sbus_rdata4_2;
wire [15:0] sbus_rdata5_2;
wire [15:0] sbus_rdata0_3;
wire [15:0] sbus_rdata1_3;
wire [15:0] sbus_rdata2_3;
wire [15:0] sbus_rdata3_3;
wire [15:0] sbus_rdata4_3;
wire [15:0] sbus_rdata5_3;
wire [15:0] sbus_rdata0_4;
wire [15:0] sbus_rdata1_4;
wire [15:0] sbus_rdata2_4;
wire [15:0] sbus_rdata3_4;
wire [15:0] sbus_rdata4_4;
wire [15:0] sbus_rdata5_4;
wire [15:0] sbus_rdata0_5;
wire [15:0] sbus_rdata1_5;
wire [15:0] sbus_rdata2_5;
wire [15:0] sbus_rdata3_5;
wire [15:0] sbus_rdata4_5;
wire [15:0] sbus_rdata5_5;
reg [15:0] sbus_rdata0_0_lat;
reg [15:0] sbus_rdata1_0_lat;
reg [15:0] sbus_rdata2_0_lat;
reg [15:0] sbus_rdata3_0_lat;
reg [15:0] sbus_rdata4_0_lat;
reg [15:0] sbus_rdata5_0_lat;
reg [15:0] sbus_rdata0_1_lat;
reg [15:0] sbus_rdata1_1_lat;
reg [15:0] sbus_rdata2_1_lat;
reg [15:0] sbus_rdata3_1_lat;
reg [15:0] sbus_rdata4_1_lat;
reg [15:0] sbus_rdata5_1_lat;
reg [15:0] sbus_rdata0_2_lat;
reg [15:0] sbus_rdata1_2_lat;
reg [15:0] sbus_rdata2_2_lat;
reg [15:0] sbus_rdata3_2_lat;
reg [15:0] sbus_rdata4_2_lat;
reg [15:0] sbus_rdata5_2_lat;
reg [15:0] sbus_rdata0_3_lat;
reg [15:0] sbus_rdata1_3_lat;
reg [15:0] sbus_rdata2_3_lat;
reg [15:0] sbus_rdata3_3_lat;
reg [15:0] sbus_rdata4_3_lat;
reg [15:0] sbus_rdata5_3_lat;
reg [15:0] sbus_rdata0_4_lat;
reg [15:0] sbus_rdata1_4_lat;
reg [15:0] sbus_rdata2_4_lat;
reg [15:0] sbus_rdata3_4_lat;
reg [15:0] sbus_rdata4_4_lat;
reg [15:0] sbus_rdata5_4_lat;
reg [15:0] sbus_rdata0_5_lat;
reg [15:0] sbus_rdata1_5_lat;
reg [15:0] sbus_rdata2_5_lat;
reg [15:0] sbus_rdata3_5_lat;
reg [15:0] sbus_rdata4_5_lat;
reg [15:0] sbus_rdata5_5_lat;

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
		sbus_rdata4_0_lat <= 16'd0;
	else
		sbus_rdata4_0_lat <= sbus_rdata4_0;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata5_0_lat <= 16'd0;
	else
		sbus_rdata5_0_lat <= sbus_rdata5_0;
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
		sbus_rdata4_1_lat <= 16'd0;
	else
		sbus_rdata4_1_lat <= sbus_rdata4_1;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata5_1_lat <= 16'd0;
	else
		sbus_rdata5_1_lat <= sbus_rdata5_1;
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
		sbus_rdata4_2_lat <= 16'd0;
	else
		sbus_rdata4_2_lat <= sbus_rdata4_2;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata5_2_lat <= 16'd0;
	else
		sbus_rdata5_2_lat <= sbus_rdata5_2;
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

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata4_3_lat <= 16'd0;
	else
		sbus_rdata4_3_lat <= sbus_rdata4_3;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata5_3_lat <= 16'd0;
	else
		sbus_rdata5_3_lat <= sbus_rdata5_3;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata0_4_lat <= 16'd0;
	else
		sbus_rdata0_4_lat <= sbus_rdata0_4;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata1_4_lat <= 16'd0;
	else
		sbus_rdata1_4_lat <= sbus_rdata1_4;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata2_4_lat <= 16'd0;
	else
		sbus_rdata2_4_lat <= sbus_rdata2_4;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata3_4_lat <= 16'd0;
	else
		sbus_rdata3_4_lat <= sbus_rdata3_4;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata4_4_lat <= 16'd0;
	else
		sbus_rdata4_4_lat <= sbus_rdata4_4;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata5_4_lat <= 16'd0;
	else
		sbus_rdata5_4_lat <= sbus_rdata5_4;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata0_5_lat <= 16'd0;
	else
		sbus_rdata0_5_lat <= sbus_rdata0_5;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata1_5_lat <= 16'd0;
	else
		sbus_rdata1_5_lat <= sbus_rdata1_5;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata2_5_lat <= 16'd0;
	else
		sbus_rdata2_5_lat <= sbus_rdata2_5;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata3_5_lat <= 16'd0;
	else
		sbus_rdata3_5_lat <= sbus_rdata3_5;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata4_5_lat <= 16'd0;
	else
		sbus_rdata4_5_lat <= sbus_rdata4_5;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		sbus_rdata5_5_lat <= 16'd0;
	else
		sbus_rdata5_5_lat <= sbus_rdata5_5;
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
reg [15:0] a_in2_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in2_lat <= 16'd0;
	else
		a_in2_lat <= a_in2;
end
reg [15:0] a_in3_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in3_lat <= 16'd0;
	else
		a_in3_lat <= a_in3;
end
reg [15:0] a_in4_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in4_lat <= 16'd0;
	else
		a_in4_lat <= a_in4;
end
reg [15:0] a_in5_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		a_in5_lat <= 16'd0;
	else
		a_in5_lat <= a_in5;
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
reg [15:0] b_in2_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in2_lat <= 16'd0;
	else
		b_in2_lat <= b_in2;
end
reg [15:0] b_in3_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in3_lat <= 16'd0;
	else
		b_in3_lat <= b_in3;
end
reg [15:0] b_in4_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in4_lat <= 16'd0;
	else
		b_in4_lat <= b_in4;
end
reg [15:0] b_in5_lat;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
		b_in5_lat <= 16'd0;
	else
		b_in5_lat <= b_in5;
end

// read bus selector
assign ibus_rdata = sbuf_s0_0_dec_l2 ? sbus_rdata0_0_lat :
					sbuf_s1_0_dec_l2 ? sbus_rdata1_0_lat :
					sbuf_s2_0_dec_l2 ? sbus_rdata2_0_lat :
					sbuf_s3_0_dec_l2 ? sbus_rdata3_0_lat :
					sbuf_s4_0_dec_l2 ? sbus_rdata4_0_lat :
					sbuf_s5_0_dec_l2 ? sbus_rdata5_0_lat :
					sbuf_s0_1_dec_l2 ? sbus_rdata0_1_lat :
					sbuf_s1_1_dec_l2 ? sbus_rdata1_1_lat :
					sbuf_s2_1_dec_l2 ? sbus_rdata2_1_lat :
					sbuf_s3_1_dec_l2 ? sbus_rdata3_1_lat :
					sbuf_s4_1_dec_l2 ? sbus_rdata4_1_lat :
					sbuf_s5_1_dec_l2 ? sbus_rdata5_1_lat :
					sbuf_s0_2_dec_l2 ? sbus_rdata0_2_lat :
					sbuf_s1_2_dec_l2 ? sbus_rdata1_2_lat :
					sbuf_s2_2_dec_l2 ? sbus_rdata2_2_lat :
					sbuf_s3_2_dec_l2 ? sbus_rdata3_2_lat :
					sbuf_s4_2_dec_l2 ? sbus_rdata4_2_lat :
					sbuf_s5_2_dec_l2 ? sbus_rdata5_2_lat :
					sbuf_s0_3_dec_l2 ? sbus_rdata0_3_lat :
					sbuf_s1_3_dec_l2 ? sbus_rdata1_3_lat :
					sbuf_s2_3_dec_l2 ? sbus_rdata2_3_lat :
					sbuf_s3_3_dec_l2 ? sbus_rdata3_3_lat :
					sbuf_s4_3_dec_l2 ? sbus_rdata4_3_lat :
					sbuf_s5_3_dec_l2 ? sbus_rdata5_3_lat :
					sbuf_s0_4_dec_l2 ? sbus_rdata0_4_lat :
					sbuf_s1_4_dec_l2 ? sbus_rdata1_4_lat :
					sbuf_s2_4_dec_l2 ? sbus_rdata2_4_lat :
					sbuf_s3_4_dec_l2 ? sbus_rdata3_4_lat :
					sbuf_s4_4_dec_l2 ? sbus_rdata4_4_lat :
					sbuf_s5_4_dec_l2 ? sbus_rdata5_4_lat :
					sbuf_s0_5_dec_l2 ? sbus_rdata0_5_lat :
					sbuf_s1_5_dec_l2 ? sbus_rdata1_5_lat :
					sbuf_s2_5_dec_l2 ? sbus_rdata2_5_lat :
					sbuf_s3_5_dec_l2 ? sbus_rdata3_5_lat :
					sbuf_s4_5_dec_l2 ? sbus_rdata4_5_lat :
					sbuf_s5_5_dec_l2 ? sbus_rdata5_5_lat :
					ibuf_a0_ren_l2 ? a_in0_lat :
					ibuf_a1_ren_l2 ? a_in1_lat :
					ibuf_a2_ren_l2 ? a_in2_lat :
					ibuf_a3_ren_l2 ? a_in3_lat :
					ibuf_a4_ren_l2 ? a_in4_lat :
					ibuf_a5_ren_l2 ? a_in5_lat :
					ibuf_b0_ren_l2 ? b_in0_lat :
					ibuf_b1_ren_l2 ? b_in1_lat :
					ibuf_b2_ren_l2 ? b_in2_lat :
					ibuf_b3_ren_l2 ? b_in3_lat :
					ibuf_b4_ren_l2 ? b_in4_lat :
					ibuf_b5_ren_l2 ? b_in5_lat :
					16'd0;
wire finish0_0;
wire finish1_0;
wire finish2_0;
wire finish3_0;
wire finish4_0;
wire finish5_0;
wire finish0_1;
wire finish1_1;
wire finish2_1;
wire finish3_1;
wire finish4_1;
wire finish5_1;
wire finish0_2;
wire finish1_2;
wire finish2_2;
wire finish3_2;
wire finish4_2;
wire finish5_2;
wire finish0_3;
wire finish1_3;
wire finish2_3;
wire finish3_3;
wire finish4_3;
wire finish5_3;
wire finish0_4;
wire finish1_4;
wire finish2_4;
wire finish3_4;
wire finish4_4;
wire finish5_4;
wire finish0_5;
wire finish1_5;
wire finish2_5;
wire finish3_5;
wire finish4_5;

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

sbuf sbuf4_0 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata4_0),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running4_0),
	.finish(finish4_0),
	.s_out(s_out4_0),
	.sat(sat4_0),
	.sw(sw4_0)
	);

sbuf sbuf5_0 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata5_0),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running5_0),
	.finish(finish5_0),
	.s_out(s_out5_0),
	.sat(sat5_0),
	.sw(sw5_0)
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

sbuf sbuf4_1 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata4_1),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running4_1),
	.finish(finish4_1),
	.s_out(s_out4_1),
	.sat(sat4_1),
	.sw(sw4_1)
	);

sbuf sbuf5_1 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata5_1),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running5_1),
	.finish(finish5_1),
	.s_out(s_out5_1),
	.sat(sat5_1),
	.sw(sw5_1)
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

sbuf sbuf4_2 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata4_2),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running4_2),
	.finish(finish4_2),
	.s_out(s_out4_2),
	.sat(sat4_2),
	.sw(sw4_2)
	);

sbuf sbuf5_2 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata5_2),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running5_2),
	.finish(finish5_2),
	.s_out(s_out5_2),
	.sat(sat5_2),
	.sw(sw5_2)
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

sbuf sbuf4_3 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata4_3),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running4_3),
	.finish(finish4_3),
	.s_out(s_out4_3),
	.sat(sat4_3),
	.sw(sw4_3)
	);

sbuf sbuf5_3 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata5_3),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running5_3),
	.finish(finish5_3),
	.s_out(s_out5_3),
	.sat(sat5_3),
	.sw(sw5_3)
	);

sbuf sbuf0_4 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata0_4),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running0_4),
	.finish(finish0_4),
	.s_out(s_out0_4),
	.sat(sat0_4),
	.sw(sw0_4)
	);

sbuf sbuf1_4 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata1_4),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running1_4),
	.finish(finish1_4),
	.s_out(s_out1_4),
	.sat(sat1_4),
	.sw(sw1_4)
	);

sbuf sbuf2_4 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata2_4),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running2_4),
	.finish(finish2_4),
	.s_out(s_out2_4),
	.sat(sat2_4),
	.sw(sw2_4)
	);

sbuf sbuf3_4 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata3_4),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running3_4),
	.finish(finish3_4),
	.s_out(s_out3_4),
	.sat(sat3_4),
	.sw(sw3_4)
	);

sbuf sbuf4_4 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata4_4),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running4_4),
	.finish(finish4_4),
	.s_out(s_out4_4),
	.sat(sat4_4),
	.sw(sw4_4)
	);

sbuf sbuf5_4 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata5_4),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running5_4),
	.finish(finish5_4),
	.s_out(s_out5_4),
	.sat(sat5_4),
	.sw(sw5_4)
	);

sbuf sbuf0_5 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata0_5),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running0_5),
	.finish(finish0_5),
	.s_out(s_out0_5),
	.sat(sat0_5),
	.sw(sw0_5)
	);

sbuf sbuf1_5 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata1_5),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running1_5),
	.finish(finish1_5),
	.s_out(s_out1_5),
	.sat(sat1_5),
	.sw(sw1_5)
	);

sbuf sbuf2_5 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata2_5),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running2_5),
	.finish(finish2_5),
	.s_out(s_out2_5),
	.sat(sat2_5),
	.sw(sw2_5)
	);

sbuf sbuf3_5 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata3_5),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running3_5),
	.finish(finish3_5),
	.s_out(s_out3_5),
	.sat(sat3_5),
	.sw(sw3_5)
	);

sbuf sbuf4_5 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata4_5),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running4_5),
	.finish(finish4_5),
	.s_out(s_out4_5),
	.sat(sat4_5),
	.sw(sw4_5)
	);

sbuf sbuf5_5 (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata5_5),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running5_5),
	.finish(finish5_5),
	.s_out(s_out5_5),
	.sat(sat5_5),
	.sw(sw5_5)
	);

endmodule
