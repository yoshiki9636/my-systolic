/*
 * My Systolic array 
 *   DSP block
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2023 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

module dsp(
	input clk,
	input rst_n,
	input [15:0] a_value,
	input [15:0] b_value,
	input aen,
	input ben,
	input men,
	input sen,
	input start,
	input sreset,
	output reg sat,
	output reg [15:0] s_out
	);

// DSP block
// This block should be replaced to DSP48E1 in xilinx Arty A7 FPGA except saturation part.

// MAC part 
// input port

reg signed [15:0] a_post;
reg signed [15:0] b_post;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        a_post <= $signed(16'd0);
	else if (aen)
		a_post <= a_value;
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        b_post <= $signed(16'd0);
	else if (ben)
		b_post <= b_value;
end

// multiplier

wire signed [31:0] m_pre = a_post * b_post;

// intermidiate FF

reg signed [31:0] m_int;

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n)
        m_int <= $signed(32'd0);
	else if (men)
		m_int <= m_pre;
end

// adder
reg signed [31:0] s_int;

wire signed [32:0] s_pre = $signed({ m_int[31], m_int }) + $signed({ s_int[31], s_int });

// saturation part

wire overflow32  = ~m_int[31] & ~s_int[31] &  s_pre[32];
wire underflow32 =  m_int[31] &  s_int[31] & ~s_pre[32];

wire overflow16  = ~m_int[31] & ~s_int[31] &  (|s_pre[32:16]);
wire underflow16 =  m_int[31] &  s_int[31] & ~(&s_pre[32:16]);

wire sat_int = overflow16 | underflow16; 

wire signed [15:0] s_out_int = $signed( overflow16  ? 16'h7fff :
                                        underflow16 ? 16'h8000 : s_pre[15:0] );

wire signed [31:0] s_p2 = $signed( overflow32  ? 32'h7fff_ffff :
                                    underflow16 ? 32'h8000_0000 : s_pre[31:0] );

// last FF
always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
        s_int <= $signed(32'd0);
	end
	else if (sreset|start) begin
        s_int <= $signed(32'd0);
	end
	else if (sen) begin
		s_int <= s_p2;
	end
end

always @ (posedge clk or negedge rst_n) begin
	if (~rst_n) begin
        sat <= 1'b0;
        s_out <= $signed(16'd0);
	end
	else if (sreset) begin
        sat <= sat_int;
        s_out <= s_out_int;
	end
end

endmodule
