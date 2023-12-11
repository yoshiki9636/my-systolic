/*
 * My RISC-V RV32I CPU
 *   sbuf for iobuf
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2021 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

module sbuf (
	input clk,
	input rst_n,

	// ram interface
	input [8:0] sbus_radr,
	output [15:0] sbus_rdata,

	// systolice array inbuffer interface
	input [7:0] run_cntr,
	input start,
	output s_running,
	output finish,
	// systolice array outbuffer interface
	input [15:0] s_out,
	input sat,
	input sw

	);

// running counter
reg [7:0] run_s_cntr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_s_cntr <= 8'd0;
    else if (start)
        run_s_cntr <= run_cntr;
    else if ((run_s_cntr > 8'd0) & sw)
        run_s_cntr <= run_s_cntr - 8'd1;
end


assign s_running = |run_s_cntr;
reg s_running_d1;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        s_running_d1 <= 1'b0;
	else
        s_running_d1 <= s_running;
end

assign finish = ~s_running & s_running_d1;

// outbuffer controls
// read part
wire [15:0] sbuf_s_rdata;
wire [15:0] sbuf_sa_rdata;

reg sbus_rsel;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sbus_rsel <= 1'b0;
	else
        sbus_rsel <=  sbus_radr[8];
end


wire [7:0] obus_radr = sbus_radr[7:0];
assign sbus_rdata = sbus_rsel ? sbuf_sa_rdata : sbuf_s_rdata;

// write part

reg [7:0] sbuf_s_wadr;
// s0 buffer's address
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sbuf_s_wadr <= 8'd0;
    else if (start)
        sbuf_s_wadr <= 8'd0;
	else if (s_running & sw)
        sbuf_s_wadr <= sbuf_s_wadr + 8'd1;
end

// satuation bits buffer
reg [3:0] sat_cntr;
reg [15:0] sat_agg;
reg [9:0] sbuf_sa_wadr;

// satuation bit counter
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sat_cntr <= 4'd0;
    else if (start)
        sat_cntr <= 4'd0;
	else if (s_running & sw)
        sat_cntr <= sat_cntr + 4'd1;
end

wire sat_wen = ((sat_cntr == 4'hf) & sat) | finish;

// bit aggrigator
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sat_agg <= 16'd0;
    else if (start)
        sat_agg <= 16'd0;
	else if (s_running & sw & (sat_cntr == 4'hf))
        sat_agg <= { 15'd0, sat };
	else if (s_running & sw)
        sat_agg <= { sat_agg[15:0], sat };
end

// address counter
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        sbuf_sa_wadr <= 10'd0;
    else if (start)
        sbuf_sa_wadr <= 10'd0;
	else if (sat_wen)
        sbuf_sa_wadr <= sbuf_sa_wadr + 10'd1;
end

// output buffers
sbuf_1r1w buf_s (
	.clk(clk),
	.ram_radr(obus_radr),
	.ram_rdata(sbuf_s_rdata),
	.ram_wadr(sbuf_s_wadr),
	.ram_wdata(s_out),
	.ram_wen(sw)
	);

sbuf_1r1w buf_sa (
	.clk(clk),
	.ram_radr(obus_radr),
	.ram_rdata(sbuf_sa_rdata),
	.ram_wadr(sbuf_sa_wadr),
	.ram_wdata(sat_agg),
	.ram_wen(sat_wen)
	);

endmodule
