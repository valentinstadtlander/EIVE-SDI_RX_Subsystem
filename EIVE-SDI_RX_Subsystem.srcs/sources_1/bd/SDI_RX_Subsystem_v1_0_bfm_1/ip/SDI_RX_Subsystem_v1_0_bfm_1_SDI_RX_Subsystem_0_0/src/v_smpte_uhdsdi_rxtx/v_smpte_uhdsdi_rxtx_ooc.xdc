# This constraints file contains default clock frequencies to be used during out-of-context flows such as
# OOC Synthesis and Hierarchical Designs. For best results the frequencies should be modified
# to match the target frequencies.
# This constraints file is not used in normal top-down synthesis.

create_clock -name rx_clk -period 6.74 [get_ports rx_clk]

create_clock -name tx_clk -period 6.74 [get_ports tx_clk]


