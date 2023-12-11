#!/usr/bin/perl

$n = $ARGV[0];
$n2 = $n * $n;

print "/*
 * My RISC-V RV32I CPU
";
print " *   Systolic Top Module for $n2 PE version
 *    Verilog code
 * @auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>
 * @copylight	2021 Yoshiki Kurokawa
 * @license		https://opensource.org/licenses/MIT     MIT license
 * @version		0.1
 */

module systolic${n2}(
	input clk,
	input rst_n,

	// ram interface
	input ren,
	input [15:0] ibus_radr,
	output [15:0] ibus_rdata,
	input wen,
	input [15:0] ibus_wadr,
	input [15:0] ibus_wdata

	);
";

for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print"wire aff${i}_${j}; // output\n";
		print"wire bff${i}_${j}; // output\n";
	}
}

for ($j = 0; $j < $n; $j++) {
	print  "wire [15:0] a_in$j; // output\n";
	print  "wire [15:0] b_in$j; // output\n";
}

print "
wire [7:0] max_cntr; // output
wire start; // output
";
for ($j = 0; $j < $n; $j++) {
	print "wire awe$j; // output\n";
	print "wire bwe$j; // output\n";
}
for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print "wire fout${i}_${j}; // output\n";
		print "wire start_next${i}_${j}; // output\n";
		print "wire [15:0] a_out${i}_${j}; // output\n";
		print "wire [15:0] b_out${i}_${j}; // output\n";
		print "wire [15:0] s_out${i}_${j}; // output\n";
		print "wire sat${i}_${j}; // output\n";
		print "wire se${i}_${j}; // output\n";
	}
}

print "

// io buffers and controller

iobuf iobuf (
	.clk(clk),
	.rst_n(rst_n),
	.ren(ren),
	.ibus_radr(ibus_radr),
	.ibus_rdata(ibus_rdata),
	.wen(wen),
	.ibus_wadr(ibus_wadr),
	.ibus_wdata(ibus_wdata),
";


for ($j = 0; $j < $n; $j++) {
	print  "	.aff$j(aff0_$j),\n";
}
for ($j = 0; $j < $n; $j++) {
	print  "	.bff$j(bff${j}_0),\n";
}
for ($j = 0; $j < $n; $j++) {
	print  "	.a_in$j(a_in$j),\n";
	print  "	.b_in$j(b_in$j),\n";
}
print "
	.max_cntr(max_cntr),
	.start(start),
";
for ($j = 0; $j < $n; $j++) {
	print  "	.awe$j(awe$j),\n";
	print  "	.bwe$j(bwe$j),\n";
}
for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		print  "	.s_out${i}_${j}(s_out${i}_${j}),\n";
		print  "	.sat${i}_${j}(sat${i}_${j}),\n";
		if (($i == $n-1)&($j == $n-1)) {
			print  "	.sw${i}_${j}(se${i}_${j})\n";
		} else {
			print  "	.sw${i}_${j}(se${i}_${j}),\n";
		}
	}
}
print "
	);

// processor elements
";

for ($j = 0; $j < $n; $j++) {
	for ($i = 0; $i < $n; $i++) {
		$im1 = $i-1;
		$ip1 = $i+1;
		$jm1 = $j-1;
		$jp1 = $j+1;
		print "
pe pe${i}_${j} (
	.clk(clk),
	.rst_n(rst_n),
";
		if ($i == 0) {
			print "	.a_in(a_in$j),\n";
		} else {
			print "	.a_in(a_out${im1}_${j}),\n";
		}
		if ($j == 0) {
			print "	.b_in(b_in$i),\n";
		} else {
			print "	.b_in(b_out${i}_${jm1}),\n";
		}
		print "	.start(start),\n";
		if ($i == 0) {
			print "	.awe(awe$j),\n";
		} else {
			print "	.awe(fout${im1}_${j}),\n";
		}
		if ($j == 0) {
			print "	.bwe(bwe$i),\n";
		} else {
			print "	.bwe(fout${i}_${jm1}),\n";
		}
		if ($i == $n-1) {
			print "	.ais(1'b0),\n";
		} else {
			print "	.ais(aff${ip1}_${j}),\n";
		}
		if ($j == $n-1) {
			print "	.bis(1'b0),\n";
		} else {
			print "	.bis(bff${i}_${jp1}),\n";
		}
		print "	.aff(aff${i}_${j}),\n";
		print "	.bff(bff${i}_${j}),\n";
		print "	.se(se${i}_${j}),\n";
		print "	.fout(fout${i}_${j}),\n";
		print "	.sat(sat${i}_${j}),\n";
		print "	.s_out(s_out${i}_${j}),\n";
		print "	.a_out(a_out${i}_${j}),\n";
		print "	.b_out(b_out${i}_${j}),\n";
		print "	.start_next(start_next${i}_${j}),\n";
		print "	.max_cntr(max_cntr)
	);
";
	}
}
print "endmodule\n";
