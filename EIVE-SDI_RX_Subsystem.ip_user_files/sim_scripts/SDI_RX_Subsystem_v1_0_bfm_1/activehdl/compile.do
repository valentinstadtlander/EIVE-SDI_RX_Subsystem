vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm
vlib activehdl/gtwizard_ultrascale_v1_7_2
vlib activehdl/v_smpte_uhdsdi_v1_0_5
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/smartconnect_v1_0
vlib activehdl/axi_protocol_checker_v2_0_1
vlib activehdl/axi_vip_v1_1_1

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm
vmap gtwizard_ultrascale_v1_7_2 activehdl/gtwizard_ultrascale_v1_7_2
vmap v_smpte_uhdsdi_v1_0_5 activehdl/v_smpte_uhdsdi_v1_0_5
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap smartconnect_v1_0 activehdl/smartconnect_v1_0
vmap axi_protocol_checker_v2_0_1 activehdl/axi_protocol_checker_v2_0_1
vmap axi_vip_v1_1_1 activehdl/axi_vip_v1_1_1

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/tx_vio_i/sim/tx_vio_i.vhd" \

vlog -work gtwizard_ultrascale_v1_7_2  -v2k5 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_bit_sync.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gte4_drp_arb.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gthe4_delay_powergood.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtye4_delay_powergood.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gthe3_cpll_cal.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gthe3_cal_freqcnt.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_rx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gthe4_cpll_cal_tx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gthe4_cal_freqcnt.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_rx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtye4_cpll_cal_tx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtye4_cal_freqcnt.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_rx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtwiz_buffbypass_tx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtwiz_reset.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_rx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtwiz_userclk_tx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_rx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_gtwiz_userdata_tx.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_reset_sync.v" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/hdl/gtwizard_ultrascale_v1_7_reset_inv_sync.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/sim/gtwizard_ultrascale_v1_7_gthe4_channel.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/sim/v_smpte_uhdsdi_gtwiz_gthe4_channel_wrapper.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/sim/v_smpte_uhdsdi_gtwiz_gtwizard_gthe4.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/sim/v_smpte_uhdsdi_gtwiz_gtwizard_top.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_gtwiz/sim/v_smpte_uhdsdi_gtwiz.v" \

vlog -work v_smpte_uhdsdi_v1_0_5  -v2k5 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_rxtx/hdl/v_smpte_uhdsdi_v1_0_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/src/v_smpte_uhdsdi_rxtx/sim/v_smpte_uhdsdi_rxtx.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/kugth_uhdsdi_3g_wrapper.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/kugth_uhdsdi_3g_wrapper_support.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/kugth_uhdsdi_control.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/kugth_uhdsdi_drp_control.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/kugth_uhdsdi_drp_control_fsm.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/kugth_uhdsdi_rx_control.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/kugth_uhdsdi_tx_control.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/multigenHD.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/multigenHD_horz.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/multigenHD_output.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/multigenHD_vert.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/sync_block.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/uhdsdi_rate_detect.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/uhdsdi_vidgen.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/vidgen_ntsc.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/vidgen_pal.v" \

vcom -work xil_defaultlib -93 \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/hdl/SDI_RX_Subsystem_v1_0_S00_AXI.vhd" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/bs_flex_v_2.vhd" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/nidru_20_v_7.vhd" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/src/nidru_20_wrapper.vhd" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/33d1/hdl/SDI_RX_Subsystem_v1_0.vhd" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0/sim/SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/sc_util_v1_0_vl_rfs.sv" \

vlog -work axi_protocol_checker_v2_0_1  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/3b24/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_master_0_0/sim/SDI_RX_Subsystem_v1_0_bfm_1_master_0_0_pkg.sv" \

vlog -work axi_vip_v1_1_1  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/a16a/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_master_0_0/sim/SDI_RX_Subsystem_v1_0_bfm_1_master_0_0.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ipshared/68f7/hdl/sim_clk_gen.v" \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/ip/SDI_RX_Subsystem_v1_0_bfm_1_sim_clk_gen_0_1/sim/SDI_RX_Subsystem_v1_0_bfm_1_sim_clk_gen_0_1.v" \

vcom -work xil_defaultlib -93 \
"../../../bd/SDI_RX_Subsystem_v1_0_bfm_1/sim/SDI_RX_Subsystem_v1_0_bfm_1.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

