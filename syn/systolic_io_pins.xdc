#set_property direction IN [get_ports {clkin}]
#set_property direction OUT [get_ports {rgb_led[0]}]
#set_property direction OUT [get_ports {rgb_led[1]}]
#set_property direction OUT [get_ports {rgb_led[2]}]
#set_property direction IN [get_ports {rx}]
#set_property direction OUT [get_ports {tx}]
#set_property direction IN [get_ports {rst_n}]
set_property OFFCHIP_TERM NONE [get_ports rgb_led[2]]
set_property OFFCHIP_TERM NONE [get_ports rgb_led[1]]
set_property OFFCHIP_TERM NONE [get_ports rgb_led[0]]
set_property OFFCHIP_TERM NONE [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgb_led[0]}]
set_property DRIVE 12 [get_ports {rgb_led[2]}]
set_property DRIVE 12 [get_ports {rgb_led[1]}]
set_property DRIVE 12 [get_ports {rgb_led[0]}]
set_property SLEW SLOW [get_ports {rgb_led[2]}]
set_property SLEW SLOW [get_ports {rgb_led[1]}]
set_property SLEW SLOW [get_ports {rgb_led[0]}]
set_property PACKAGE_PIN E1 [get_ports {rgb_led[2]}]
set_property PACKAGE_PIN F6 [get_ports {rgb_led[1]}]
set_property PACKAGE_PIN G6 [get_ports {rgb_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports clkin]
set_property PACKAGE_PIN E3 [get_ports clkin]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN A9 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports interrupt_0]
set_property PACKAGE_PIN D9 [get_ports interrupt_0]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
set_property DRIVE 12 [get_ports tx]
set_property SLEW SLOW [get_ports tx]
set_property PACKAGE_PIN D10 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN C2 [get_ports rst_n]
#revert back to original instance
#current_instance -quiet

set_property OFFCHIP_TERM NONE [get_ports tx]
set_property OFFCHIP_TERM NONE [get_ports rgb_led[2]]
set_property OFFCHIP_TERM NONE [get_ports rgb_led[1]]
set_property OFFCHIP_TERM NONE [get_ports rgb_led[0]]
create_clock -period 10.000 -name clkin -waveform {0.000 5.000} [get_ports clkin]

#create_generated_clock -name clk get_clocks -of_objects  [get_pins clknetwork/clk_out1]
set_input_delay -clock [get_clocks  clk_out1_clk_wiz_0] -min -add_delay 1.000 [get_ports rst_n]
set_input_delay -clock [get_clocks  clk_out1_clk_wiz_0] -max -add_delay 1.000 [get_ports rst_n]
set_input_delay -clock [get_clocks  clk_out1_clk_wiz_0] -min -add_delay 1.000 [get_ports rx]
set_input_delay -clock [get_clocks  clk_out1_clk_wiz_0] -max -add_delay 1.000 [get_ports rx]
set_input_delay -clock [get_clocks  clk_out1_clk_wiz_0] -min -add_delay 1.000 [get_ports interrupt_0]
set_input_delay -clock [get_clocks  clk_out1_clk_wiz_0] -max -add_delay 1.000 [get_ports interrupt_0]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -min -add_delay -3.000 [get_ports {rgb_led[*]}]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -max -add_delay -3.000 [get_ports {rgb_led[*]}]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -min -add_delay -3.000 [get_ports tx]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -max -add_delay -3.000 [get_ports tx]