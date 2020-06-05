set_property PACKAGE_PIN N8 [get_ports gth_cpll_refclk_p_in]

create_clock -period 6.734 -name gth_cpll_refclk_p_in -waveform {0.000 3.367} [get_ports gth_cpll_refclk_p_in]
set_false_path -from [get_clocks {gtwiz_userclk_tx_srcclk_out[0]}] -to [get_clocks clk_pl_0]
set_false_path -from [get_clocks {rxoutclk_out[0]}] -to [get_clocks clk_pl_0]

set_clock_groups -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks {gtwiz_userclk_tx_srcclk_out[0]}]
set_clock_groups -asynchronous -group [get_clocks clk_pl_0] -group [get_clocks {rxoutclk_out[0]}]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
