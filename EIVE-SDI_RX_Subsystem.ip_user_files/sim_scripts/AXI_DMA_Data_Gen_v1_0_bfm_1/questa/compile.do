vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/smartconnect_v1_0
vlib questa_lib/msim/axi_protocol_checker_v2_0_1
vlib questa_lib/msim/axi_vip_v1_1_1

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap smartconnect_v1_0 questa_lib/msim/smartconnect_v1_0
vmap axi_protocol_checker_v2_0_1 questa_lib/msim/axi_protocol_checker_v2_0_1
vmap axi_vip_v1_1_1 questa_lib/msim/axi_vip_v1_1_1

vlog -work xil_defaultlib -64 -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L zynq_ultra_ps_e_vip_v1_0_1 -L xil_defaultlib -L xilinx_vip "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/1b5a/hdl/AXI_DMA_Data_Gen_v1_0_S00_AXI.vhd" \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/1b5a/hdl/AXI_DMA_Data_Gen_v1_0.vhd" \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_AXI_DMA_Data_Gen_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_AXI_DMA_Data_Gen_0_0.vhd" \

vlog -work axi_infrastructure_v1_1_0 -64 "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work smartconnect_v1_0 -64 -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L zynq_ultra_ps_e_vip_v1_0_1 -L xil_defaultlib -L xilinx_vip "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/sc_util_v1_0_vl_rfs.sv" \

vlog -work axi_protocol_checker_v2_0_1 -64 -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L zynq_ultra_ps_e_vip_v1_0_1 -L xil_defaultlib -L xilinx_vip "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/3b24/hdl/axi_protocol_checker_v2_0_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L zynq_ultra_ps_e_vip_v1_0_1 -L xil_defaultlib -L xilinx_vip "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0_pkg.sv" \

vlog -work axi_vip_v1_1_1 -64 -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L zynq_ultra_ps_e_vip_v1_0_1 -L xil_defaultlib -L xilinx_vip "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/a16a/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work xil_defaultlib -64 -sv -L smartconnect_v1_0 -L axi_protocol_checker_v2_0_1 -L axi_vip_v1_1_1 -L zynq_ultra_ps_e_vip_v1_0_1 -L xil_defaultlib -L xilinx_vip "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/ec67/hdl" "+incdir+../../../../EIVE-SDI_RX_Subsystem.srcs/sources_1/bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ipshared/02c8/hdl/verilog" "+incdir+D:/Programme/Xilinx/Vivado_2017.4/Vivado/2017.4/data/xilinx_vip/include" \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/ip/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0/sim/AXI_DMA_Data_Gen_v1_0_bfm_1_master_0_0.sv" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/AXI_DMA_Data_Gen_v1_0_bfm_1/sim/AXI_DMA_Data_Gen_v1_0_bfm_1.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

