#!/usr/bin/perl

$n = $ARGV[0];
$n2 = $n * $n;

print "/*
 * My RISC-V RV32I CPU
 *   iobuf Module for $n2 PE version
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
";

for ($j = 0; $j < $n; $j++) {
	print  "	input aff${j},\n";
}
for ($j = 0; $j < $n; $j++) {
	print  "	input bff${j},\n";
}
for ($j = 0; $j < $n; $j++) {
	print  "	output [15:0] a_in${j},\n";
	print  "	output [15:0] b_in${j},\n";
}
print "	output reg [7:0] max_cntr,
	output start,
";
for ($j = 0; $j < $n; $j++) {
	print  "	output awe${j},\n";
	print  "	output bwe${j},\n";
}
print "	// systolice array outbuffer interface\n";

for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print"	input [15:0] s_out${i}_${j},\n";
	}
}
for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print"	input sat${i}_${j},\n";
	}
}
for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		if (($j == $n-1)&($i == $n-1)) {
			print"	input sw${i}_${j}\n";
		} else {
			print"	input sw${i}_${j},\n";
		}
	}
}

print "	);\n";

for ($j = 0; $j < $n; $j++) {
	print "`define IBUFA${j}_HEAD 6'h0$j\n";
}
for ($j = 0; $j < $n; $j++) {
	$j2 = $n + $j;
	print "`define IBUFB${j}_HEAD 6'h0$j2\n";
}
$ij = 0;
for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print "`define OBUFS${i}_${j}_HEAD 7'h4${ij}\n";
		$ij++;
	}
}

$nm1 = $n - 1;

print "`define SYS_START_ADR 16'hFFF0
`define SYS_MAX_CNTR 16'hFFF1
`define SYS_RUN_CNTR 16'hFFF2

// 1shot start bit
wire write_start = wen & (ibus_wadr == `SYS_START_ADR);
reg run_status;
wire finish${nm1}_${nm1};

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        run_status <= 1'b0;
	else if (finish${nm1}_${nm1})
        run_status <= 1'b0;
	else if (write_start)
        run_status <= 1'b1;
end

assign start = write_start & ~run_status;

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
";


for ($j = 0; $j < $n; $j++) {
	print "wire ibuf_a${j}_wen = wen & (ibus_wadr[15:10] == `IBUFA${j}_HEAD);\n";
}
for ($j = 0; $j < $n; $j++) {
	print "wire ibuf_b${j}_wen = wen & (ibus_wadr[15:10] == `IBUFB${j}_HEAD);\n";
}

print "
reg [6:0] ibus_decaddr;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n)
        ibus_decaddr <= 8'd0;
    else if (write_max_cntr)
        ibus_decaddr <= ibus_radr[15:9];
end

wire [9:0] abbus_radr = ibus_wadr[9:0];
";

for ($j = 0; $j < $n; $j++) {
	print "wire ibuf_a${j}_dec = (ibus_decaddr[6:1] == `IBUFA${j}_HEAD);\n";
}
for ($j = 0; $j < $n; $j++) {
	print "wire ibuf_b${j}_dec = (ibus_decaddr[6:1] == `IBUFB${j}_HEAD);\n";
}
for ($j = 0; $j < $n; $j++) {
	print "wire ibuf_a${j}_ren = ren & ibuf_a${j}_dec;\n";
}
for ($j = 0; $j < $n; $j++) {
	print "wire ibuf_b${j}_ren = ren & ibuf_b${j}_dec;\n";
}

for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print "wire s_running${i}_${j};\n";
	}
}

print "\n// a/b buffers\n";

for ($j = 0; $j < $n; $j++) {
	print "
abbuf a${j}buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_a${j}_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_a${j}_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running${j}_0),
	.ff(aff${j}),
	.ab_in(a_in${j}),
	.we(awe${j})
	);
";
}

for ($j = 0; $j < $n; $j++) {
	print "
abbuf b${j}buf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ibuf_b${j}_ren),
	.abbus_radr(abbus_radr),
	.wen(ibuf_b${j}_wen),
	.ibus_wadr(abbus_wadr),
	.ibus_wdata(ibus_wdata),
	.start(start),
	.sys_running(s_running0_${j}),
	.ff(bff${j}),
	.ab_in(b_in${j}),
	.we(bwe${j})
	);
";
}

print "
// outbuffer controls
// read part
wire [8:0] sbus_radr = ibus_radr[8:0];

";

for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print "wire sbuf_s${i}_${j}_dec = (ibus_decaddr == `OBUFS${i}_${j}_HEAD);\n";
	}
}
for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print "wire [15:0] sbus_rdata${i}_${j};\n";
	}
}

print "\n// read bus selector\n";

for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		if (($j == 0)&($i == 0)) {
			print "assign ibus_rdata = sbuf_s0_0_dec ? sbus_rdata0_0 :\n";
		} else {
			print"					sbuf_s${i}_${j}_dec ? sbus_rdata${i}_${j} :\n";
		}
	}
}
for ($j = 0; $j < $n; $j++) {
	print"					ibuf_a${j}_dec ? a_in${j} :\n";
}
for ($j = 0; $j < $n; $j++) {
	if ($j == $n-1) {
		print "					ibuf_b${j}_dec ? b_in${j} : 16'd0;\n";
	} else {
		print"					ibuf_b${j}_dec ? b_in${j} :\n";
	}
}



for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		if (($j == $n-1)&($i == $n-1)) {
		} else {
			print "wire finish${i}_${j};\n";
		}
	}
}

print "\n// s buffers\n";

for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print "
sbuf sbuf${i}_${j} (
	.clk(clk),
	.rst_n(rst_n),
	.sbus_radr(sbus_radr),
	.sbus_rdata(sbus_rdata${i}_${j}),
	.run_cntr(run_cntr),
	.start(start),
	.s_running(s_running${i}_${j}),
	.finish(finish${i}_${j}),
	.s_out(s_out${i}_${j}),
	.sat(sat${i}_${j}),
	.sw(sw${i}_${j})
	);
";
	}
}

print "\nendmodule\n";

